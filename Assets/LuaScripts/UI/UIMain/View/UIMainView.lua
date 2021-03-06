
--[[
-- 视图层
-- 注意：
-- 1、成员变量最好预先在OnCreate函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新，可以注册好事件，在OnDisable的时候去除
-- 3、组件命名参考代码规范
--]]

local UIMainView = BaseClass("UIMainView", UIBaseView)
local base = UIBaseView

-- 首次创建调用
function UIMainView:OnCreate()
	--self:Bind("my_dd.value","drop_value")
	--self:ListBind("my_content","list",UITestItemView)
	--self:DataBind({"drop_value","toggle"},function(drop_value,my_tog)
	--    print("-------------------------------------------------",drop_value,my_tog)
	--end)
	--self:HBind("my_btn.visible",{"drop_value","toggle"},function(my_dd,toggle)
	--return my_dd == 1 and toggle
	--end)
	--self:ViewBind("sub_model","sub_view_model",UILoginSubView)
end

-- 每次open 调用
function UIMainView:OnEnable()
	
end

-- 每次close调用
function UIMainView:OnDisable()
	base.OnAddListener(self)
	-- UI消息注册
	
end

-- destroy时调用
function UIMainView:OnDestroy()

end

-- 整个ui prefab加载完成后调用，在OnCreate之前
function UIMainView:OnLoaded()

end

return UIMainView
