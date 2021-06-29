#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import sys
import itertools
import re

from io import StringIO

from google.protobuf.compiler import plugin_pb2 as plugin
from google.protobuf.descriptor_pb2 import DescriptorProto,EnumDescriptorProto

root_logger = logging.getLogger()
root_logger.setLevel(logging.INFO)
handler = logging.FileHandler('gen.log', 'w', 'utf-8')
formatter = logging.Formatter('%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s')
handler.setFormatter(formatter)
root_logger.addHandler(handler)

class Writer(object):
    def __init__(self):
        self.io = StringIO()
        self.__indent = ''

    def getvalue(self):
        return self.io.getvalue()

    def __call__(self, _str):
        self.io.write(self.__indent)
        self.io.write(_str)

    def __enter__(self):
        self.__indent += '    '
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.__indent = self.__indent[:-4]


_PROTO_ENUM_START = dict(S2C='SPT_', C2S='CPT_')


class Protocol(object):
    def __init__(self, package, msg_descriptor):
        self.name = msg_descriptor.name
        if package:
            self.full_name = package + '.' + msg_descriptor.name
        else:
            self.full_name = msg_descriptor.name
        self.id_field = None
        for f in msg_descriptor.field:
            if f.name == 'type' or f.name == 'protoType':
                self.id_field = f
                break
        self.id_value = None
        logging.info('find protocol %s', self.name)
        logging.info("has idfield %s", self.id_field is not None)

    def find_id_value(self, proto_def):
        # if not self.id_field:
        #     return

        code = proto_def.get_protocol_meta(self.full_name, "proto_code")
        if not code:
            return

        self.id_value = int(code)

    def get_lua_name_to_id(self):
        return "{0:<30}=\t\t\t{1},\n".format(self.name, self.id_value)

    def get_lua_id_to_name(self):
        return '{0:<30}=\t\t\t"{1}",\n'.format('['+str(self.id_value)+']', self.full_name)

    def get_csharp_id_to_name(self):
        return f"\t[{self.id_value}] = typeof({self.name}),\n"
        
    def get_csharp_name_to_id(self):
        return f"public const int {self.name} = {self.id_value};\n"


class Enumeration(object):
    def __init__(self, package, enum_descriptor):
        self.name = enum_descriptor.name
        if package:
            self.full_name = package + '.' + enum_descriptor.name
        else:
            self.full_name = enum_descriptor.name
        self.values = {}
        for v in enum_descriptor.value:
            self.values[v.name] = v.number
        logging.info('find enum %s', self.name)

    def write(self,writer):
        writer("{0} = {{\n".format(self.name))
        with writer:
            for field,val in self.values.items():
                writer(f"{field} = {val},\n")
        writer("},\n\n")


class ProtoDef(object):
    def __init__(self, _options):
        self.options = _options
        self.enums = {}
        self.protocols = {}
        self.protocol_meta = {}

    def add_protocol(self, package, msg_descriptor, source_location):
        protocol = Protocol(package, msg_descriptor)
        self.protocols[protocol.full_name] = protocol
        if source_location:
            meta = self._parse_meta(source_location.leading_comments)
            self.protocol_meta[protocol.full_name] = meta

    def _parse_meta(self, comment):
        meta = {}
        for line in comment.splitlines():
            m = re.match(r"^\s*@(\w+)\s+(.+)$", line)
            if m:
                key = m.group(1)
                value = m.group(2)
                meta[key] = value
        return meta

    def get_protocol_meta(self, protocol_full_name, meta_key, default_value=None):
        meta = self.protocol_meta.get(protocol_full_name)
        if not meta:
            return None
        
        return meta.get(meta_key, default_value)

    def add_enum(self, package, enum_descriptor):
        enumeration = Enumeration(package,enum_descriptor)
        self.enums[enumeration.full_name] = enumeration

    def get_enum_value(self, enum_type_name, enum_value_name):
        enumeration = self.enums.get(enum_type_name)
        if enumeration:
            return enumeration.values.get(enum_value_name)

    def gen_protocol_id(self):
        for protocol in self.protocols.values():
            protocol.find_id_value(self)

    def get_sorted_protocols(self):
        ids = {}
        for k, v in self.protocols.items():
            if v.id_value is None:
                continue
            ids[v.id_value] = v
        return sorted(ids.values(), key=lambda pro: pro.id_value)

    #生成协议的名字与id的映射文本
    def gen_proto_map(self, file):
        gen_type = self.options.get('gen_type')
        if gen_type == 'csharp':
            file.name = "ProtocolMapping.cs"
            file.content = self.gen_proto_map_csharp()
        elif gen_type == 'lua':
            file.name = "ProtocolMapping.lua"
            file.content = self.gen_proto_map_lua()
        else:
            raise Exception(f"invalid gen_type: {gen_type}")

    def gen_proto_map_csharp(self):
        writer = Writer()
        writer('''//---
//---Generated By proto-gen. Do not Edit.
//---

using System;
using System.Collections.Generic;

namespace PB {
public static class ProtocolMapping
{
    public static IReadOnlyDictionary<int, Type> TypeMapping => Mapping;
	public static IReadOnlyDictionary<Type, int> CodeMapping => ReverseMapping;

    private static readonly Dictionary<int, Type> Mapping = new Dictionary<int, Type>()
    {
''')
        pts = self.get_sorted_protocols()
        with writer:
            for protocol in pts:
                writer(protocol.get_csharp_id_to_name())
        writer('''
    };

    private static readonly Dictionary<Type, int> ReverseMapping = new Dictionary<Type, int>();

    static ProtocolMapping()
    {
	    ReverseMapping.Clear();
	    foreach (var pair in Mapping)
	    {
		    ReverseMapping.Add(pair.Value, pair.Key);
	    }
    }

    public static Type Get(int protoCode)
    {
	    return Mapping.TryGetValue(protoCode, out var type) ? type : null;
    }

    public static int Get(Type protoType)
    {
	    return ReverseMapping.TryGetValue(protoType, out var code) ? code : 0;
    }

    public static int Get<T>()
    {
	    return Get(typeof(T));
    }

''')
        with writer:
            for protocol in pts:
                writer(protocol.get_csharp_name_to_id())
        writer('''
}
}
''')
        return writer.getvalue()

    def gen_proto_map_lua(self):
        writer = Writer()
        writer('''---
---Generated By proto-gen. Do not Edit.
---
''')
        pts = self.get_sorted_protocols()
        writer('ProtocolIds = {\n')
        with writer:
            for protocol in pts:
                writer(protocol.get_lua_name_to_id())
        writer('}\n')
        writer('ProtocolNames = {\n')
        with writer:
            for protocol in pts:
                writer(protocol.get_lua_id_to_name())
        writer('}\n')
        return writer.getvalue()

class ProtoSourceCodeInfo(object):
    def __init__(self, source_code_info):
        self.mapping = {}
        for location in source_code_info.location:
            path = []
            for p in location.path:
                path.append(str(p))
            key = ",".join(path)
            self.mapping[key] = location
    def get(self, path):
        return self.mapping.get(path)

def traverse(proto_file):
    logging.info("parse file : %s",proto_file.name)
    source_info = ProtoSourceCodeInfo(proto_file.source_code_info)

    def _traverse(package, items, depth = 0):
        for index, item in enumerate(items):
            source_location = None
            if depth == 0 and isinstance(item, DescriptorProto):
                # see https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/descriptor.proto
                # The magic number 4 is because FileDescriptorProto.message_type has field number 4:
                #       repeated DescriptorProto message_type = 4;
                source_location = source_info.get(f"4,{index}")
            yield item, package, source_location

            if isinstance(item, DescriptorProto):
                for enum in item.enum_type:
                    yield enum, package, None

                for nested in item.nested_type:
                    nested_package = package + item.name

                    for nested_item in _traverse(nested, nested_package, depth + 1):
                        yield nested_item, nested_package, None

    return itertools.chain(
        _traverse(proto_file.package, proto_file.enum_type),
        _traverse(proto_file.package, proto_file.message_type),
    )

def parse_parameter(params):
    if not params:
        return {}
    pairs = re.split(r',\s*', params)
    result = {}
    for pair in pairs:
        
        kv = pair.split('=', 2)
        if len(kv) >= 2:
            result[kv[0]] = kv[1]
    return result

def generate_code(request, response):
    # request.parameter为--custom_opt后的参数，可以定义多个，如--custom_opt=gen_type=lua --custom_opt=gen_typp=lusa，传入两个参数
    options = parse_parameter(request.parameter)
    # print("kv[0]=---------------------------------- " ,request.proto_file)
    # print(request.proto_file)
    proto_def = ProtoDef(options)
    for proto_file in request.proto_file:
        # Parse request
        for item, package, source_location in traverse(proto_file):
            if isinstance(item, DescriptorProto):
                proto_def.add_protocol(package, item, source_location)
            elif isinstance(item, EnumDescriptorProto):
                proto_def.add_enum(package, item)

    proto_def.gen_protocol_id()
    #gen proto mapping
    f = response.file.add()
    proto_def.gen_proto_map(f)

if __name__ == "__main__":
    # Read request message from stdin
    data = sys.stdin.buffer.read()
    # Parse request
    request = plugin.CodeGeneratorRequest()
    request.ParseFromString(data)
    # Create response
    response = plugin.CodeGeneratorResponse()
    # Generate code
    generate_code(request, response)
    # Serialise response message
    output = response.SerializeToString()
    # Write to stdout
    sys.stdout.buffer.write(output)

