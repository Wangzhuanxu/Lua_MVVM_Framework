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
local function OnCreate(self)
	base.OnCreate(self)
	-- 初始化各个组件
	-- self:Bind("my_txt.text", "app_version_text")
	-- self:Bind("my_img.sprite", "hp_image")
	-- self:Bind("my_btn", "hp_btn")
	-- self:Bind("my_input.onValueChanged","on_value_change")
	-- self:Bind("my_input","input")
	self:Bind("my_tog","toggle")
	-- self:Bind("my_slider","slider")
	self:Bind("my_dd","my_dd")
	self:Bind("my_dd.value","drop_value")
	-- self:ListBind("my_content","list",UITestItemView)
	self:DataBind({"drop_value","toggle"},function(drop_value,my_tog)
		print("-------------------------------------------------",drop_value,my_tog)
	end)
	self:HBind("my_btn.visible",{"drop_value","toggle"},function(my_dd,toggle)
		return my_dd == 1 and toggle
	end)
	-- self.input = self:AddComponent(UIInput,input, self.Binder, "input","on_value_change")
	-- self.toggle = self:AddComponent(UIToggle,toggle, self.Binder, "toggle")
	-- self.slider = self:AddComponent(UISlider,slider, self.Binder, "slider")
	-- 调用父类Bind所有属性
end



local function OnDestroy(self)
	self.app_version_text = nil
	self.res_version_text = nil
	self.server_text = nil
	self.account_input = nil
	self.password_input = nil
	self.server_select_btn = nil
	self.login_btn = nil

	base.OnDestroy(self)
end

UILoginView.OnCreate = OnCreate
UILoginView.OnDestroy = OnDestroy

return UILoginView