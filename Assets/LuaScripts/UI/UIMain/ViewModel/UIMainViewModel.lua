
--[[
-- 模型层
-- 注意：
-- 1、成员变量预先在OnCreate、OnEnable函数声明，提高代码可读性
-- 2、OnCreate内放窗口生命周期内保持的成员变量，窗口销毁时才会清理
-- 3、OnEnable内放窗口打开时才需要的成员变量，窗口关闭后及时清理
--]]

local UIMainViewModel = BaseClass("UIMainViewModel", UIBaseViewModel)
local base = UIBaseViewModel

-- 创建
function UIMainViewModel:OnCreate()
    --self.toggle = BindableProperty.New(true)
    --self.slider = BindableProperty.New(0.2)
end

-- 打开,可以传递一些需要的参数
function UIMainViewModel:OnEnable(...)

end

-- 关闭
function UIMainViewModel:OnDisable()

end

-- 销毁
function UIMainViewModel:OnDestroy()

end

return UIMainViewModel