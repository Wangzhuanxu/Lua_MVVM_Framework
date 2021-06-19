--[[
-- added by wsh @ 2017-12-08
-- Lua侧UILayer
--]]

local UILayer = BaseClass("UILayer", Updatable)
local base = UIBaseComponent

local function __init(self, holder, info)
	assert(not IsNull(holder), "Err : holder nil!")
	assert(not IsNull(holder.transform), "Err : holder tansform nil!")
	assert(not IsNull(info), "Err: info nil!")
	-- 持有者
	self.holder = holder
	-- 脚本绑定的transform
	self.transform = nil
	-- transform对应的gameObject
	self.gameObject = nil
	-- trasnform对应的RectTransform
	self.rectTransform = nil
	self.info = info
end

-- 创建
local function OnCreate(self)
	assert(not IsNull(self.holder), "Err : holder nil!")
	assert(not IsNull(self.holder.transform), "Err : holder tansform nil!")
	
	self.gameObject = self.info.gameobject
	self.transform = self.gameObject.transform

	assert(not IsNull(self.gameObject), "Err : layer gameObject nil!")
	assert(not IsNull(self.transform), "Err : layer tansform nil!")
	
	-- window order
	local start_order = self.info.sorting_order_start + self.info.sorting_order_layer_range * self.info.layer_index
	self.top_window_order = start_order
	self.min_window_order = start_order
end

-- pop window order
local function PopWindowOder(self)
	local cur = self.top_window_order
	self.top_window_order = self.top_window_order + UIManager:GetInstance().MaxOderPerWindow
	return cur
end

-- push window order
local function PushWindowOrder(self)
	assert(self.top_window_order > self.min_window_order)
	self.top_window_order = self.top_window_order - UIManager:GetInstance().MaxOderPerWindow
end

-- 销毁
local function OnDestroy(self)
	self.unity_canvas = nil
	self.unity_canvas_scaler = nil
	self.unity_graphic_raycaster = nil
	base.OnDestroy(self)
end

UILayer.__init = __init
UILayer.OnCreate = OnCreate
UILayer.PopWindowOder = PopWindowOder
UILayer.PushWindowOrder = PushWindowOrder
UILayer.OnDestroy = OnDestroy

return UILayer