local ComponentMapping = {
    C2LuaType = {
        ["UnityEngine.UI.Button"] = UIButton,
        ["UnityEngine.UI.InputField"] = UIInput,
        ["UnityEngine.UI.Slider"] = UISlider,
        ["UnityEngine.UI.Text"] = UIText,
        ["UnityEngine.UI.Image"] = UIImage,
        ["UnityEngine.UI.Toggle"] = UIToggle,
        ["UnityEngine.UI.Dropdown"] = UIDropdown,
    },
    DefualtComponentProperty = 
    {
        ["UnityEngine.UI.Text"] = "text",
        ["UnityEngine.UI.InputField"] = "text",
        ["UnityEngine.UI.Button"] = "onClick",
        ["UnityEngine.UI.Toggle"] = "isOn",
        ["UnityEngine.UI.Slider"] = "value",
        ["UnityEngine.UI.Image"] = "sprite",
        ["UnityEngine.UI.Dropdown"] = "options",
        ["UnityEngine.UI.RawImage"] = "texture",
        ["Framework.UI.UIToggleGroup"] = "value",
        ["Framework.UI.UIToggleValue"] = "value",
        ["Framework.UI.ButtonEx"] = "onClick",
        ["TMPro.TextMeshProUGUI"] = "text",
        ["TMPro.TMP_InputField"] = "text",
        ["Framework.UI.TweenSlider"] = "value",
        ["Framework.UI.UIWidget"] = "url",

    }
    
}


return ComponentMapping