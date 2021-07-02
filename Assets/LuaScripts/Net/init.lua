--[[
--  Created Date: 2021-01-11 19:03:23
--  Author: fengbo
--]]
local LuaUtility = CS.Game.LuaUtility
local pb = require("pb")
--local protoc = require("protoc")
pb.option("enum_as_value")

local PB_FILES = {
    "Net/PB/net.pb",
}

local function load_pb(path)
    local pb_data = LuaUtility.LoadProtoBufFileBinary(path)
    assert(pb_data, ("failed to load %s"):format(path))

    local success, err = pb.load(pb_data)
    if success then
        print(("load pb file success: %s"):format(path))
    else
        log_error(("load pb file failed: %s, %s"):format(path, err))
    end
end

for _, v in ipairs(PB_FILES) do
    load_pb(v)
end

function test()
    -- local data = {
    --     name = "name",
    --     phonenumber = "23232",
    -- }
    -- local bytes = assert(pb.encode("Data.PB.Phone", data))
    -- print(pb.tohex(bytes))
    -- -- 再解码回Lua表
    -- local data2 = assert(pb.decode("Data.PB.Phone", bytes))
    -- print(data2)
    -- local pb_data = LuaUtility.LoadProtoBufFileBinary("Net/9.data")
    --     local v1,v2,v3 = pb.unpack(pb_data, "s@")
	--  v1,v2,v3 = pb.unpack(pb_data, "s@")
    -- print("-----",pb.unpack(pb_data, "ss@"))
end

test()

return {}