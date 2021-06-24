--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIToggle
-- 使用方式：
--]]

local UIToggle = BaseClass("UIToggle", UIBaseComponent)
local base = UIBaseComponent
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
-- 创建
function UIToggle:OnCreate(item,binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_toggle = item
	self.view = binder:GetView()
	self.binder = binder
	self.view_model = self.view:GetViewModel()
	assert(not IsNull(self.unity_toggle), "Err : unity_toggle nil!")
end

local _isOn = "isOn"
function UIToggle:isOn(property_name)
	if self:IsBinded(_isOn) then
		error(("UIToggle %s has bind"):format(_isOn))
		return
	end
	self.binder:Add(property_name, function (oldValue, newValue)
		if oldValue ~= newValue then
			self:SetValue(newValue)
		end
	end)
	local func = function(value)
		self.view_model[property_name].Value = value
	end
	self.unity_toggle.onValueChanged:AddListener(func)
	self:RecordProperty(_isOn)
end

local _onValueChanged = "onValueChanged"
function UIToggle:onValueChanged(property_name)
	if self:IsBinded(_onValueChanged) then
		error(("UIToggle %s has bind"):format(_onValueChanged))
		return
	end
	self.binder:RegisterEvent(function(viewModel, property)
		self.unity_toggle.onValueChanged:AddListener(property)
	end,nil, property_name)
	self:RecordProperty(_onValueChanged)
end


-- 获取文本
function UIToggle:GetValue()
	if not IsNull(self.unity_toggle) then
		return self.unity_toggle.isOn
	end
end

-- 设置文本
function UIToggle:SetValue(isOn)
	if not IsNull(self.unity_toggle) then
		self.unity_toggle.isOn = isOn
	end
end

-- 销毁
function UIToggle:OnDestroy()
	if self.unity_toggle then
		self.unity_toggle.onValueChanged:RemoveAllListeners()
		self.unity_toggle.onValueChanged = nil
		self.unity_toggle = nil
	end
	base.OnDestroy(self)
end

return PropertiesHelper:Extends(UIToggle)