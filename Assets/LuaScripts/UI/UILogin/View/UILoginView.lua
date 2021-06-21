--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]

local UILoginView = BaseClass("UILoginView", UIBaseView)
local base = UIBaseView
local UITestItemView = require "UI.UILogin.View.UITestItemView"
local UILoginSubView = require "UI.UILogin.View.UILoginSubView"
local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化各个组件
	self:Bind("my_tog","toggle")
	self:Bind("my_slider","slider")
	self:Bind("my_dd","my_dd")
	self:Bind("my_dd.value","drop_value")
	self:ListBind("my_content","list",UITestItemView)
	self:DataBind({"drop_value","toggle"},function(drop_value,my_tog)
		print("-------------------------------------------------",drop_value,my_tog)
	end)
	self:HBind("my_btn.visible",{"drop_value","toggle"},function(my_dd,toggle)
		return my_dd == 1 and toggle
	end)
	self:ViewBind("sub_model","sub_view_model",UILoginSubView)
end



local function OnDestroy(self)

end

UILoginView.OnCreate = OnCreate
UILoginView.OnDestroy = OnDestroy

return UILoginView