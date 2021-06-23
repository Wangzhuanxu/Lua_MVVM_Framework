-- added by wsh @ 2018-01-01
-- xlua热修复测试，主要测试下资源热更以后xlua重启后热修复是否生效
-- 注意：
-- 1、现在的做法热修复模块一定要提供Register、Unregister两个接口，因为现在热修复模块要支持动态加载和卸载
-- 2、注册使用xlua.hotfix或者util.hotfix_ex
-- 3、注销一律使用xlua.hotfix

local util = require "XLua.Common.util"
local HotFixTest = CS.Game.HotFixTest

--xlua.private_accessible(AssetbundleUpdater)
--xlua.private_accessible(AssetBundleManager)

local function Func(self)
	print("**********Lua Func <<<")
end

local function Add(self,a,b)
	print("lua add = ",a + b)
end

local function Register()
	xlua.hotfix(HotFixTest, "Func", Func)
	util.hotfix_ex(HotFixTest, "Add", Add)
end

local function Unregister()
	xlua.hotfix(HotFixTest, "Func", nil)
	xlua.hotfix(HotFixTest, "Add", nil)
end

return {
	Register = Register,
	Unregister = Unregister,
}