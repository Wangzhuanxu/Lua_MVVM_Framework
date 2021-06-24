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
--local OptionList = CS.System.Collections.Generic.List(typeof(OptionData))
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

--参考自 table 和list,dictionary可以互转https://github.com/Tencent/xLua/issues/495
-- 直接local array = { 2, 3, 3}
-- 不用特意的去“转”，你要传给C#时直接传这个table，会自动转到 List、Array、Dictionary 等 C# 类型
-- 总之，结构上一致就自动转。
-- 不建议在lua那转成 Array、List 然后去调用C#方法，性能比较低。
-- 尽量在lua操作table，然后一次赋值过去。
local _options = "options"
function UIDropdown:options(property_name)
	if self:IsBinded(_options) then
		error(("UIDropdown %s has bind"):format(_options))
		return
    end
    self.binder:RegisterEvent(function(viewModel, property)
        assert(type(property) == "table","dropdown need table as optionData!")
        self._length = #property
        --local List = OptionList(self._length)
		local list = {}
        for index,option in ipairs(property) do 
            local sprite 
            if option.sprite and option.sprite ~= "" then
                local path = ("sprite path is %s"):format(option.sprite)
                print(path)
                sprite = Resources.Load(option.sprite,typeof(CS.UnityEngine.Sprite))
            end
            local txt = option.txt or tostring(index)
            local p = OptionData(txt,sprite)
           -- List:Add(p)
			list[#list + 1] = p
        end
		self.unity_uidropdown.options = list
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
	if self.unity_uidropdown then
		self.unity_uidropdown.onValueChanged:RemoveAllListeners()
		self.unity_uidropdown.onValueChanged = nil
		self.unity_uidropdown = nil
	end

	base.OnDestroy(self)
end

return PropertiesHelper:Extends(UIDropdown)