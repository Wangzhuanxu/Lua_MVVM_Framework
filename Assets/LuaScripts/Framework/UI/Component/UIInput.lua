--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIInput
-- 使用方式：
-- self.xxx_input = self:AddComponent(UIInput, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIInput = BaseClass("UIInput", UIBaseComponent)
local base = UIBaseComponent
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
-- 创建
function UIInput:OnCreate(item,binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_uiinput = item
	self.view = binder:GetView()
	self.binder = binder
	self.view_model = self.view:GetViewModel()
	assert(not IsNull(self.unity_uiinput), "Err : unity_uiinput nil!")

end

---- property bind 
local _onValueChanged = "onValueChanged"
function UIInput:onValueChanged(property_name)
	if self:IsBinded(_onValueChanged) then
		error(("UIInput %s has bind"):format(_onValueChanged))
		return
	end
	self.binder:RegisterEvent(function(viewModel, property)
		self.unity_uiinput.onValueChanged:AddListener(property)
	end,nil, property_name)
	self:RecordProperty(_onValueChanged)
end

local _onEndEdit = "onEndEdit"
function UIInput:text(property_name)
	if self:IsBinded(_onEndEdit) then
		error(("UIInput %s has bind"):format(_onEndEdit))
		return
	end
	self.binder:RegisterEvent(function(viewModel, property)
		self.unity_uiinput.onEndEdit:AddListener(property)
	end,nil, property_name)
	self:RecordProperty(_onEndEdit)
end

local _text = "text"
function UIInput:text(property_name)
	if self:IsBinded(_text) then
		error(("UIInput %s has bind"):format(_text))
		return
	end
	self.binder:Add(property_name, function (oldValue, newValue)
		if oldValue ~= newValue then
			self:SetText(newValue)
		end
	end)
	local func = function(value)
		self.view_model[property_name].Value = value
	end
	self.unity_uiinput.onEndEdit:AddListener(func)
	self:RecordProperty(_text)
end




-------------------


-- 获取文本
function UIInput:GetText()
	if not IsNull(self.unity_uiinput) then
		return self.unity_uiinput.text
	end
end

-- 设置文本
function UIInput:SetText(text)
	if not IsNull(self.unity_uiinput) then
		self.unity_uiinput.text = text
	end
end

-- 销毁
function UIInput:OnDestroy()
	if self.unity_uiinput then
		self.unity_uiinput.onEndEdit:RemoveAllListeners()
		self.unity_uiinput.onValueChanged:RemoveAllListeners()
		self.unity_uiinput.onEndEdit = nil
		self.unity_uiinput.onValueChanged = nil
		self.unity_uiinput = nil
	end
	base.OnDestroy(self)
end

return PropertiesHelper:Extends(UIInput)