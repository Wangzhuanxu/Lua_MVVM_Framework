--[[
-- added by wsh @ 2017-12-01
-- UILogin视图层
-- 注意：
-- 1、成员变量最好预先在__init函数声明，提高代码可读性
-- 2、OnEnable函数每次在窗口打开时调用，直接刷新
-- 3、组件命名参考代码规范
--]]

local UILoginViewModel = BaseClass("UILoginViewModel",UIBaseViewModel)
local base = UIBaseViewModel


function UILoginViewModel:OnCreate()
    self.app_version_text = BindableProperty.New("1.0.1")
    self.hp_image = BindableProperty.New("login2_05" )
    self.input = BindableProperty.New("login2_05")

    self.on_value_change = function(value)
        print(("on_value_change_%s"):format(value))
    end

    self.on_editor_end = function(value)
        print(("%s__%s"):format(value,value))
    end

    self.toggle = BindableProperty.New(true)
    self.slider = BindableProperty.New(0.2)

    self.my_dd = {
        {sprite = "login2_05",txt = "123"},
        {sprite = "login2_05",txt = "456"},
        {sprite = "login2_05",txt = "789"},
    }

    local list = {}
    for i = 1,100 do 
        list[#list + 1] = {
            my_txt = BindableProperty.New(("%03d"):format(i)),
            my_img = BindableProperty.New("login2_05" ),
        }
    end
    self.list = ObservableList.New(list)
    self.hp_btn = function()
        local count = self.list.Count
        if count >= 6 then
          --  self.list:Remove(0)
        end
        self.list:Add(
           {
                my_txt = BindableProperty.New(("%03d"):format(count)),
                my_img = BindableProperty.New("login2_05" ),
           }
       )
    end

-- 打开
    base.OnEnable(self)
end

function UILoginViewModel:OnEnable(txt)
    self.timer = TimerManager:GetInstance():GetTimer(5, function(obj)
        -- local list = {}
        -- for i = 1,13 do 
        --     list[#list + 1] = {
        --         my_txt = BindableProperty.New(("%3d"):format(i)),
        --         my_img = BindableProperty.New("login2_05" ),
        --     }
        -- end
        -- self.list.Value = list
        self.toggle.Value = false
    end, self,true,false)
	self.timer:Start()
    
end

return UILoginViewModel