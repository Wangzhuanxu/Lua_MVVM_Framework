--[[

--]]

local UIBaseViewModel = BaseClass("UIBaseViewModel")

-- 如非必要，别重写构造函数，使用OnCreate初始化
function UIBaseViewModel:__init( ui_name)
    self.__ui_name = ui_name
    self:OnCreate()
end

-- 如非必要，别重写析构函数，使用OnDestroy销毁资源
function UIBaseViewModel:__delete()
    self:OnDestroy()
    self.__ui_name = nil
end

-- 注册游戏数据监听事件，别重写
function UIBaseViewModel:AddDataListener(msg_name, callback,obj)
    DataManager:GetInstance():AddListener(msg_name, callback,obj)
end

-- 注销游戏数据监听事件，别重写
function UIBaseViewModel:RemoveDataListener(msg_name, callback,obj)
    DataManager:GetInstance():RemoveListener(msg_name, callback,obj)
end

-- 激活：给UIManager用，别重写
function UIBaseViewModel:Activate(...)
    self:OnEnable(...)
end

-- 反激活：给UIManager用，别重写
function UIBaseViewModel:Deactivate()
    self:OnDisable()
end

--------------------------------------------生命周期-------------------------------------------------------------
-- 创建：变量定义，初始化，消息注册
-- 注意：窗口生命周期内保持的成员变量放这
function UIBaseViewModel:OnCreate()
end

-- 打开：刷新数据模型
-- 注意：窗口关闭时可以清理的成员变量放这
function UIBaseViewModel:OnEnable( ...)
end

-- 关闭
-- 注意：必须清理OnEnable中声明的变量
function UIBaseViewModel:OnDisable()
end

-- 销毁
-- 注意：必须清理OnCreate中声明的变量
function UIBaseViewModel:OnDestroy()
end

return UIBaseViewModel