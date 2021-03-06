--[[
-- added by wsh @ 2017-11-28
-- 消息系统
-- 使用范例：
-- local Messenger = require "Framework.Common.Messenger";
-- local TestEventCenter = Messenger.New() --创建消息中心
-- TestEventCenter:AddListener(Type, callback) --添加监听
-- TestEventCenter:AddListener(Type, callback, ...) --添加监听
-- TestEventCenter:Broadcast(Type, ...) --发送消息
-- TestEventCenter:RemoveListener(Type, callback, ...) --移除监听
-- TestEventCenter:Cleanup() --清理消息中心
-- 注意：
-- 1、模块实例销毁时，要自动移除消息监听，不移除的话不能自动清理监听
-- 2、使用弱引用，即使监听不手动移除，消息系统也不会持有对象引用，所以对象的销毁是不受消息系统影响的
-- 3、换句话说：广播发出，回调一定会被调用，但回调参数中的实例对象，可能已经被销毁，所以回调函数一定要注意判空
--]]

local Messenger = BaseClass("Messenger");

local function __init(self)
	self.events = {}
end

local function __delete(self)
	self:Cleanup()	
end

local function AddListener(self, e_type, func,obj)
	local e = self.events[e_type]
	if e == nil then
		e = event.new()
	end
	e:RegisterListener(func,obj)
	self.events[e_type] = e
end

local function Broadcast(self, e_type, ...)
	local e = self.events[e_type]
	if e == nil then
		return
	end
	
	e(...)
end

local function RemoveListener(self, e_type, func,obj)
	local e = self.events[e_type]
	if e == nil then
		return
	end
	e:UnregisterListener(func,obj)
end

local function RemoveListenerByType(self, e_type)
	self.events[e_type] = nil
end

local function Cleanup(self)
	self.events = nil
end

Messenger.__init = __init
Messenger.__delete = __delete
Messenger.AddListener = AddListener
Messenger.Broadcast = Broadcast
Messenger.RemoveListener = RemoveListener
Messenger.RemoveListenerByType = RemoveListenerByType
Messenger.Cleanup = Cleanup

return Messenger;