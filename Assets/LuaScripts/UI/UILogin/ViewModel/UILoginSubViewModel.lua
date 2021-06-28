
local UILoginViewModel = BaseClass("UILoginViewModel",UIBaseViewModel)
local base = UIBaseViewModel


function UILoginViewModel:OnCreate()
    
    self.app_version_text = BindableProperty.New("1.0.1")
    self.hp_image = BindableProperty.New("login2_05" )
    self.input = BindableProperty.New("login2_05")
    self.on_value_change = function(value)
       -- print(("on_value_change_%s"):format(value))
    end

    self.hp_btn = function()
        --     local count = self.list.Count
        --     if count >= 6 then
        --       --  self.list:Remove(0)
        --     end
        --     self.list:Add(
        --        {
        --             my_txt = BindableProperty.New(("%03d"):format(count)),
        --             my_img = BindableProperty.New("login2_05" ),
        --        }
        --    )
            print("you press me")    
    end

end

function UILoginViewModel:OnEnable(txt)
    print(("my sub view text = %s"):format(txt))
end

return UILoginViewModel