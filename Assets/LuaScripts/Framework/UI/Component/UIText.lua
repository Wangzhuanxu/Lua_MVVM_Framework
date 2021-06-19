--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIText
-- 使用方式：
-- TODO：本地化支持
--]]

local UIText = BaseClass("UIText", UIBaseComponent)
local base = UIBaseComponent
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
-- 创建
function UIText:OnCreate(item, binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_uitext = item
	self.binder = binder
	assert(not IsNull(self.unity_uitext), "Err : unity_uitext nil!")
end

------------------------ Property start
local _text = "text"
function UIText:text(property_name)
	if self:IsBinded(_text) then
		error(("UIText %s has bind"):format(_text))
		return
	end
	self.binder:Add(property_name, function (oldValue, newValue)
		if oldValue ~= newValue then
			self:SetText(newValue)
		end
	end)
	self:RecordProperty(_text)
end

------------------------ property  end 

-- 获取文本
function UIText:GetText()
	if not IsNull(self.unity_uitext) then
		return self.unity_uitext.text
	end
end

-- 设置文本
function UIText:SetText(text)
	if not IsNull(self.unity_uitext) then
		self.unity_uitext.text = text
	end
end

-- 销毁
function UIText:OnDestroy()
	self.unity_uitext = nil
	base.OnDestroy(self)
end

return PropertiesHelper:Extends(UIText)