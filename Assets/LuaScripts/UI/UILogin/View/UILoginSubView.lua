local UILoginSubView = BaseClass("UILoginSubView", UIBaseView)
local base = UIBaseView
local function OnCreate(self)
	-- 初始化各个组件
	self:Bind("my_txt.text", "app_version_text")
	self:Bind("my_img.sprite", "hp_image")
	self:Bind("my_btn", "hp_btn")
	self:Bind("my_input.onValueChanged","on_value_change")
	self:Bind("my_input","input")
end



local function OnDestroy(self)
	self.app_version_text = nil
	self.res_version_text = nil
	self.server_text = nil
	self.account_input = nil
	self.password_input = nil
	self.server_select_btn = nil
	self.login_btn = nil
end

UILoginSubView.OnCreate = OnCreate
UILoginSubView.OnDestroy = OnDestroy

return UILoginSubView