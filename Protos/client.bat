    @echo off

    ::协议文件路径, 最后不要跟“\”符号
    set SOURCE_FOLDER=.\protos

    ::protoc编译器路径
    set PROTOC_COMPILER_PATH=.\protoc-3.17.3-win64\protoc\protoc.exe
	::proto2luamaping编译器路径
	set PROTO_GEN_PATH=.\ProtoGen\proto_gen.bat

    ::pb文件生成路径, 最后不要跟“\”符号
    set PB_TARGET_PATH= ..\Assets\LuaScripts\Net\PB\
	::ProtoLuaMapping生成路径
    set LUA_MAPPING_PATH_PATH=..\Assets\LuaScripts\Net\PB\

    ::删除之前创建的文件
    rd /s /q %PB_TARGET_PATH%

    md %PB_TARGET_PATH%
	
	echo NetPBStart
	%PROTOC_COMPILER_PATH% -o %PB_TARGET_PATH%\net.pb --proto_path=%SOURCE_FOLDER% --include_imports net.proto
    echo NetPBStartOver
	
	echo NetProto2LuaEnumStart
	%PROTOC_COMPILER_PATH% --plugin=protoc-gen-custom=%PROTO_GEN_PATH% --proto_path=%SOURCE_FOLDER% --custom_opt=gen_type=lua --custom_out=%LUA_MAPPING_PATH_PATH% net.proto   
	echo NetProto2LuaEnumOver
	
    pause
