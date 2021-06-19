--[[
-- added by wsh @ 2017-12-18
-- 更新管理，负责Unity侧Update、LateUpdate、FixedUpdate对Lua脚本的调用
-- 注意：
-- 1、别直接用tolua的UpdateBeat、LateUpdateBeat、FixedUpdateBeat，所有需要以上三个更新函数的脚本，都从这里注册。
-- 2、tolua的event没有使用weak表，直接使用tolua的更新系统会导致脚本被event持有引用而无法释放---除非每次都记得手动去释放
--]]
local xpcall, traceback = xpcall, debug.traceback
local UpdateManager = BaseClass("UpdateManager", Singleton)
local UpdateMsgName = "Update"
local LateUpdateMsgName = "LateUpdateMsgName"
local FixedUpdateMsgName = "FixedUpdateMsgName"

-- 构造函数
local function __init(self)
	-- Update
	self.__update_handle = nil
	-- LateUpdate
	self.__lateupdate_handle = nil
	-- FixedUpdate
	self.__fixedupdate_handle = nil

	self.__update_tick = nil

	self.__lateupdate_tick = nil

	self._fixedupdate_tick = nil
end

local function is_callable(obj)
    if not obj then return false end
    return type(obj) == 'function'
end

-- Update回调
local function UpdateHandle(self)
	for obj, tick in pairs(self.__update_tick) do
        local success, err = xpcall(tick, traceback, obj)
        if not success then
            log_error(err)
        end
    end
end

-- LateUpdate回调
local function LateUpdateHandle(self)
	for obj, tick in pairs(self.__lateupdate_tick) do
        local success, err = xpcall(tick, traceback, obj)
        if not success then
            log_error(err)
        end
    end
end

-- FixedUpdate回调
local function FixedUpdateHandle(self)
	for obj, tick in pairs(self._fixedupdate_tick) do
        local success, err = xpcall(tick, traceback, obj)
        if not success then
            log_error(err)
        end
    end
end

-- 启动
local function Startup(self)
	self:Dispose()
	local obj = UpdateManager:GetInstance()
	self.__update_handle = UpdateBeat:RegisterListener(UpdateHandle, obj)
	self.__lateupdate_handle = LateUpdateBeat:RegisterListener(LateUpdateHandle, obj)
	self.__fixedupdate_handle = FixedUpdateBeat:RegisterListener(FixedUpdateHandle, obj)

	self.__update_tick = setmetatable({}, { __mode = "k"})
	self.__lateupdate_tick = setmetatable({}, { __mode = "k"})
	self._fixedupdate_tick = setmetatable({}, { __mode = "k"})
end

-- 释放
local function Dispose(self)
	if self.__update_handle ~= nil then
		UpdateBeat:RemoveListener(self.__update_handle)
		self.__update_handle = nil
	end
	if self.__lateupdate_handle ~= nil then
		LateUpdateBeat:RemoveListener(self.__lateupdate_handle)
		self.__lateupdate_handle = nil
	end
	if self.__fixedupdate_handle ~= nil then
		FixedUpdateBeat:RemoveListener(self.__fixedupdate_handle)
		self.__fixedupdate_handle = nil
	end

	self.__update_tick = nil
	self.__lateupdate_tick = nil
	self._fixedupdate_tick = nil
end

-- 清理：消息系统不需要强行清理
local function Cleanup(self)
end

-- 添加Update更新
local function AddUpdate(self, obj, Update)
	tick = Update or obj.Update
    if not is_callable(tick) then 
        log_error(("%s.tick is not callable"):format(tostring(obj)))
        return 
    end

    self.__update_tick[obj] = tick
end

-- 添加LateUpdate更新
local function AddLateUpdate(self, obj, LateUpdate)
	tick = LateUpdate or obj.LateUpdate
    if not is_callable(tick) then 
        log_error(("%s.tick is not callable"):format(tostring(obj)))
        return 
    end

    self.__lateupdate_tick[obj] = tick
end

-- 添加FixedUpdate更新
local function AddFixedUpdate(self, obj, FixedUpdate)
	tick = FixedUpdate or obj.FixedUpdate
    if not is_callable(tick) then 
        log_error(("%s.tick is not callable"):format(tostring(obj)))
        return 
    end

    self._fixedupdate_tick[obj] = tick
end

-- 移除Update更新
local function RemoveUpdate(self, obj)
	if not self.__update_tick then return end
	self.__update_tick[obj] = nil
end

-- 移除LateUpdate更新
local function RemoveLateUpdate(self, obj)
	if not self.__lateupdate_tick then return end
	self.__lateupdate_tick[obj] = nil
end

-- 移除FixedUpdate更新
local function RemoveFixedUpdate(self, obj)
	if not self._fixedupdate_tick then return end
	self._fixedupdate_tick[obj] = nil
end

-- 析构函数
local function __delete(self)
	self:Cleanup()
	self:Dispose()
end

UpdateManager.__init = __init
UpdateManager.Startup = Startup
UpdateManager.Dispose = Dispose
UpdateManager.Cleanup = Cleanup
UpdateManager.AddUpdate = AddUpdate
UpdateManager.AddLateUpdate = AddLateUpdate
UpdateManager.AddFixedUpdate = AddFixedUpdate
UpdateManager.RemoveUpdate = RemoveUpdate
UpdateManager.RemoveLateUpdate = RemoveLateUpdate
UpdateManager.RemoveFixedUpdate = RemoveFixedUpdate
UpdateManager.__delete = __delete
return UpdateManager;