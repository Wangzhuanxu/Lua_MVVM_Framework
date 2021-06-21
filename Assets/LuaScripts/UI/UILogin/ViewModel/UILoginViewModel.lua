

local UILoginViewModel = BaseClass("UILoginViewModel",UIBaseViewModel)
local base = UIBaseViewModel
local UILoginSubViewModel = require "UI.UILogin.ViewModel.UILoginSubViewModel"

function UILoginViewModel:OnCreate()
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
    self.drop_value = BindableProperty.New(1)

    self.list_select_index = 1
    local list = {}
    for i = 1,100 do 
        list[#list + 1] = {
            my_txt = BindableProperty.New(("%03d"):format(i)),
            my_img = BindableProperty.New("login2_05" ),
            selected = BindableProperty.New(self.list_select_index == i),
            my_btn = function()
                local my_list = self.list.Value
                local pre = my_list[self.list_select_index]
                local now = my_list[i]
                print(("list = %d,now = %d"):format(self.list_select_index,i))
                pre.selected.Value = false
                now.selected.Value = true
                self.list_select_index = i
            end
        }
    end
    self.list = ObservableList.New(list)

    self.sub_view_model = self:CreateSubViewModel(UILoginSubViewModel)
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