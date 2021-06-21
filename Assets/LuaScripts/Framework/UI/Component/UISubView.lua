

local UISubView = BaseClass("UISubView", UIBaseComponent)
local base = UIBaseComponent
local typeof = typeof
local ViewType = EnumConfig.ViewType
local GameObject = CS.UnityEngine.GameObject
local assert = assert
-- 创建
function UISubView:OnCreate(content,binder,property_name,view_class,parent)
	base.OnCreate(self)
	--parent view
	self.parent = parent
	-- content
	self.content = content
	--view
	self.view = binder:GetView()
	--binder
	self.binder = binder
	--view model
	self.view_model = self.view:GetViewModel()
	--sub view model data
	self.sub_view_model_data = self.view_model[property_name]
    --property_name in view model
	self.property_name = property_name
    assert(view_class ~= nil, "view class cannot be nil")
	self.view_class = view_class
    -- sub view
	self.sub_view = self.view_class.New(self.parent.holder, "sub view", self.sub_view_model_data,ViewType.SubView)
    self.sub_view:LoadOver(self.content)
end

-- 打开
function UISubView:OnEnable()
	self.sub_view:OnEnable()
end

-- 关闭
function UISubView:OnDisable()
	self.sub_view:OnDisable()
end

-- 销毁
function UISubView:OnDestroy()
	self.sub_view:Delete()
end

return UISubView