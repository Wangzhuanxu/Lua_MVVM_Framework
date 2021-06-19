--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIImage
-- 使用方式：
-- self.xxx_img = self:AddComponent(UIImage, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIImage = BaseClass("UIImage", UIBaseComponent)
local base = UIBaseComponent
local PropertiesHelper = require "Framework.UI.Wrapper.PropertiesHelper"
-- 创建
function UIImage:OnCreate(item, binder)
	base.OnCreate(self)
	self._origin = item
	-- Unity侧原生组件
	self.unity_uiimage = item
	self.binder = binder
	assert(not IsNull(self.unity_uiimage), "Err : unity_uiimage nil!")
end



----------bind property ----------
local _sprite = "sprite"
function UIImage:sprite(property_name)
	if self:IsBinded(_sprite) then
		error(("UIImage %s has bind"):format(_sprite))
		return
	end
	self.binder:Add(property_name, function (oldValue, newValue)
		if oldValue ~= newValue then
			if(newValue ~= nil) then
				self:SetSpriteName(newValue)
			end
		end
	end)
	self:RecordProperty(_sprite)
end

----------------------------------

-- 获取Sprite名称
function UIImage:GetSpriteName()
	return self.sprite_name
end

-- 设置Sprite名称
function UIImage:SetSpriteName(sprite_name)
	self.sprite_name = sprite_name
	if IsNull(self.unity_uiimage) then
		return
	end

	local Resources = CS.UnityEngine.Resources
	-- local path = ("sprite path is %s"):format(sprite_name)
	-- print(path)
	local sprite = Resources.Load(sprite_name,typeof(CS.UnityEngine.Sprite))
	if IsNull(self.unity_uiimage) then
		return
	end
			
	-- 被加载的Sprite不是当前想要的Sprite：可能预设被复用，之前的加载操作就要作废
	if sprite_name ~= self.sprite_name then
		return
	end
			
	if not IsNull(sprite) then
		self.unity_uiimage.sprite = sprite
	end
	-- AtlasManager:GetInstance():LoadImageAsync(self.atlas_config, sprite_name, function(sprite, sprite_name)
	-- 	-- 预设已经被销毁
	-- 	if IsNull(self.unity_uiimage) then
	-- 		return
	-- 	end
		
	-- 	-- 被加载的Sprite不是当前想要的Sprite：可能预设被复用，之前的加载操作就要作废
	-- 	if sprite_name ~= self.sprite_name then
	-- 		return
	-- 	end
		
	-- 	if not IsNull(sprite) then
	-- 		self.unity_uiimage.sprite = sprite
	-- 	end
	-- end, self.sprite_name)
end

-- 销毁
function UIImage:OnDestroy()
	self.unity_uiimage = nil
	base.OnDestroy(self)
end

return PropertiesHelper:Extends(UIImage)