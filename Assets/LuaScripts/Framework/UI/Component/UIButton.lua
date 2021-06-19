--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIButton,之让其包含点击事件
--]]

local UIButton = BaseClass("UIButton", UIBaseComponent)
local base = UIBaseComponent
local error = error
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
-- 创建
function UIButton:OnCreate(item, binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_uibutton = item
	self.binder = binder
	assert(not IsNull(self.unity_uibutton), "Err : unity_uibutton nil!")
end

--- property bind 
local _interactable = "interactable"
function UIButton:interactable(property_name)
	if self:IsBinded(_interactable) then
		error(("UIButton %s has bind"):format(_interactable))
		return
	end
	self.binder:Add(property_name, function (oldValue, newValue)
		if oldValue ~= newValue then
			self.unity_uibutton.interactable = newValue
		end
	end)
	self:RecordProperty(_interactable)
end

local _onClick = "onClick"
function UIButton:onClick(property_name)
	if self:IsBinded(_onClick) then
		error(("UIButton %s has bind"):format(_onClick))
		return
	end
	self.binder:RegisterEvent(function(viewModel, property)
		self.unity_uibutton.onClick:AddListener(property)
	end,nil, property_name)
	self:RecordProperty(_onClick)
end


-- 资源释放
function UIButton:OnDestroy()
	self.unity_uibutton.onClick:RemoveAllListeners()
	self.unity_uibutton = nil
	self.__onclick = nil
	base.OnDestroy(self)
end


return PropertiesHelper:Extends(UIButton)