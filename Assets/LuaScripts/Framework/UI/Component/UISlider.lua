--[[
-- added by wsh @ 2017-12-18
-- Lua侧UISlider
-- 使用方式：
-- self.xxx_text = self:AddComponent(UISlider, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UISlider = BaseClass("UISlider", UIBaseComponent)
local base = UIBaseComponent
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
-- 创建
function UISlider:OnCreate(item,binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_uislider = item
	self.view = binder:GetView()
	self.binder = binder
	self.view_model = self.view:GetViewModel()
	assert(not IsNull(self.unity_uislider), "Err : unity_toggle nil!")

end

---------------------property-------------------
local _value = "value"
function UISlider:value(property_name)
	if self:IsBinded(_value) then
		error(("UISlider %s has bind"):format(_value))
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
	self.unity_uislider.onValueChanged:AddListener(func)
	self:RecordProperty(_value)
end

local _onValueChanged = "onValueChanged"
function UISlider:onValueChanged(property_name)
	if self:IsBinded(_onValueChanged) then
		error(("UISlider %s has bind"):format(_onValueChanged))
		return
	end
	self.binder:RegisterEvent(function(viewModel, property)
		self.unity_uislider.onValueChanged:AddListener(property)
	end,nil, property_name)
	self:RecordProperty(_onValueChanged)
end

-- 获取进度
function UISlider:GetValue()
	if not IsNull(self.unity_uislider) then
		return self.unity_uislider.value
	end
end

-- 设置进度
function UISlider:SetValue(value)
	if not IsNull(self.unity_uislider) then
		self.unity_uislider.value = value
	end
end

-- 销毁
function UISlider:OnDestroy()
	self.unity_uislider.onValueChanged:RemoveAllListeners()
	self.unity_uislider = nil
	base.OnDestroy(self)
end


return PropertiesHelper:Extends(UISlider)