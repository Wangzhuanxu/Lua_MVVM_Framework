
local UITestItemView = BaseClass("UITestItemView", UIBaseView)
local base = UIBaseView

function UITestItemView:OnCreate()
	base.OnCreate(self)
	-- 初始化各个组件
	self:Bind("my_txt.text", "my_txt")
	self:Bind("my_img.sprite", "my_img")
	self:Bind("selected.visible", "selected")
	self:Bind("my_btn", "my_btn")
end



function UITestItemView:OnDestroy()
	self.app_version_text = nil
	self.res_version_text = nil
	self.server_text = nil
	self.account_input = nil
	self.password_input = nil
	self.server_select_btn = nil
	self.login_btn = nil

	base.OnDestroy(self)
end

return UITestItemView