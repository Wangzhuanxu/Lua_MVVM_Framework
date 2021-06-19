--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIToggle
-- 使用方式：
--]]

local UIDropdown = BaseClass("UIDropdown", UIBaseComponent)
local base = UIBaseComponent
local error = error
local assert = assert
local OptionData = CS.UnityEngine.UI.Dropdown.OptionData
local OptionList = CS.System.Collections.Generic.List(typeof(OptionData))
local Resources = CS.UnityEngine.Resources
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
local BindLevel = EnumConfig.BindLevel
-- 创建
function UIDropdown:OnCreate(item,binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_uidropdown = item
	self.view = binder:GetView()
	self.binder = binder
	self.view_model = self.view:GetViewModel()
	assert(not IsNull(self.unity_uidropdown), "Err : unity_uidropdown nil!")
end

local _options = "options"
function UIDropdown:options(property_name)
	if self:IsBinded(_options) then
		error(("UIDropdown %s has bind"):format(_options))
		return
    end
    self.binder:RegisterEvent(function(viewModel, property)
        assert(type(property) == "table","dropdown need table as optionData!")
        self._length = #property
        local List = OptionList(self._length)
        for index,option in ipairs(property) do 
            local sprite 
            if option.sprite and option.sprite ~= "" then
                local path = ("sprite path is %s"):format(option.sprite)
                print(path)
                sprite = Resources.Load(option.sprite,typeof(CS.UnityEngine.Sprite))
            end
            local txt = option.txt or tostring(index)
            local p = OptionData(txt,sprite)
            List:Add(p)
        end
		self.unity_uidropdown.options = List
	end,nil, property_name,BindLevel.High)
	self:RecordProperty(_options)
end

local _onValueChanged = "onValueChanged"
function UIDropdown:onValueChanged(property_name)
	if self:IsBinded(_onValueChanged) then
		error(("UIDropdown %s has bind"):format(_onValueChanged))
		return
	end
	self.binder:RegisterEvent(function(viewModel, property)
		self.unity_uidropdown.onValueChanged:AddListener(property)
	end,nil, property_name)
	self:RecordProperty(_onValueChanged)
end

local _value = "value"
function UIDropdown:value(property_name)
	if self:IsBinded(_value) then
		error(("UIDropdown %s has bind"):format(_value))
		return
	end
    self.binder:Add(property_name, function (oldValue, newValue)
        assert(self._length > 0,"you should set dropdown optionData first")
        assert(newValue < self._length, ("the index must < optionData Length"))
		if oldValue ~= newValue then
			self:SetValue(newValue)
		end
	end)
	local func = function(value)
		self.view_model[property_name].Value = value
	end
	self.unity_uidropdown.onValueChanged:AddListener(func)
	self:RecordProperty(_value)
end


-- 获取文本
function UIDropdown:GetValue()
	if not IsNull(self.unity_uidropdown) then
		return self.unity_uidropdown.value
	end
end

-- 设置文本
function UIDropdown:SetValue(value)
	if not IsNull(self.unity_uidropdown) then
		self.unity_uidropdown.value = value
	end
end

-- 销毁
function UIDropdown:OnDestroy()
	self.unity_uidropdown.onValueChanged:RemoveAllListeners()
	self.unity_uidropdown = nil
	base.OnDestroy(self)
end

return PropertiesHelper:Extends(UIDropdown)