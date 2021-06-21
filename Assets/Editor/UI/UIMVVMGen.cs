﻿using UnityEngine;
using System.Collections.Generic;
using XLua;
using System.IO;
using System.Text;
using System.Linq;
using CSObjectWrapEditor;
using UnityEditor;

public class ComItem
{
    public string com_var_name;
    public string com_type_name;
    public string com_path_name;
}

/// <summary>
/// 生成UI 模板
/// 操作方法：  
/// 1， 将 UI界面的prefab 拖入Hierarchy
/// 2,  在Hierarchy中右键点击MVC子菜单下的相关生成项
/// 
/// 要求：
/// 1， prefab 名字中不能带下划线
/// 2， 如果需要生成AddCommponent代码，在相应的GameObjet名字中添加_UIxx
///     比如prefab中button所在gameobject名为：selectServerBtn, 如果要自动
///     生成组件代码，请将按钮改名为： selectServerBtn_UIButton
/// 3,  支持的组件请查看UIMVCGen下的comTypes 数组
/// 
/// </summary>
public class UIMVVMGen
{
    public static string output_dir = Application.dataPath + "/LuaScripts/UI/";

    public static string tpl_viewmodel = "Assets/Editor/UI/Template/UIViewModelGen.tpl.txt";
    public static string tpl_view      = "Assets/Editor/UI/Template/UIViewGen.tpl.txt";
    public static string tpl_component = "Assets/Editor/UI/Template/UICompontGen.tpl.txt";
    public static string tpl_config    = "Assets/Editor/UI/Template/UIConfigGen.tpl.txt";

    public static string default_layer = "NormalLayer";

    public static List<string> comTypes = new List<string> {
        "UIButton","UIButtonGroup","UICanvas","UIImage","UIInput","UILayer",
        "UISlider","UITabGroup","UIText","UIToggleButton","UIWrapComponent"
    };

    #region 工具方法
    public static bool checkComType(string comType)
    {
        return comType.Contains(comType);
    }

    public static string GetTransPath(string rootName, Transform trans)
    {
        if (null == trans) return string.Empty;
        if (trans.parent!=null && trans.parent.name.Equals(rootName)) return trans.name;

        return GetTransPath(rootName, trans.parent) + "/" + trans.name;
    }

    public static void FindChild(string rootName,Transform trans, List<ComItem> list)
    {
        string name = trans.name;
        int lastUnderLine = name.LastIndexOf('_');

        if(lastUnderLine > 0)
        {
            string comName = name.Substring(0, lastUnderLine);
            string comType = name.Substring(lastUnderLine+1);

            if (comType != "" && checkComType(comType))
            {
                ComItem item = new ComItem();
                if (comName .Length >1)
                {
                    string firstLetter = comName[0].ToString();
                    string lastLatters = comName.Substring(1);
                    item.com_var_name = string.Format("{0}{1}", firstLetter.ToLower(), lastLatters); 
                }
                else
                {
                    item.com_var_name = comName.ToLower();
                }
                item.com_type_name = comType;
                item.com_path_name = GetTransPath(rootName,trans);
                list.Add(item);
            }
        }

        for(int i=0; i< trans.childCount; i++)
        {
            FindChild(rootName, trans.GetChild(i), list);
        }
    }
    #endregion

    /// <summary>
    /// 生成UI模板
    /// </summary>
    public static void GenUITemplate(string moduleName,string layerName, string templatePath, string outputPath)
    {
        EditorUtility.DisplayProgressBar("生成中...", "生成模板...", 20);
        TextAsset ta = AssetDatabase.LoadAssetAtPath<TextAsset>(templatePath);

        Generator.GetTasks tasks = null;
        List<ComItem> comList = new List<ComItem>();

        Transform trans = Selection.activeTransform;
        if (trans != null && !trans.name.Contains("_"))
        {
            FindChild(trans.name, trans, comList);

        }
        else
        {
            Debug.LogError("prefab 名字为空或名字中带下划线，请规范命名！");
            //return;
        }

        tasks += (lua_env, user_cfg) =>
        {

            LuaTable data = lua_env.NewTable();
            data.Set("module_name", moduleName);
            data.Set("module_layer", layerName);
            data.Set("viewmodel_class_name", moduleName + "ViewModel");
            data.Set("compontent_class_name", moduleName + "WrapItem");
            data.Set("view_class_name", moduleName + "View");
            data.Set("config_class_name", moduleName + "Config");

            //不再自动生成控件
            data.Set("com_list", comList);


            List<CustomGenTask> list = new List<CustomGenTask>();
            CustomGenTask task = new CustomGenTask
            {
                Data = data,
                Output = new StreamWriter(outputPath,
                false, new UTF8Encoding(false))
            };
            list.Add(task);

            return list;
        };

        Generator.CustomGen(ta.text, tasks);
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }


    [MenuItem("XLua/MVVM/Gen MVVM", priority = 10)]
    public static void GenUIMVVM()
    {
        GenUIViewModel();
        GenUIView();
        GenUIConfig();
    }

   // [MenuItem("GameObject/MVVM/Gen ViewModel", priority = 11)]
    public static void GenUIViewModel()
    {
        Transform trans = Selection.activeTransform;
        if (trans == null) return;

        string pagePath = output_dir + trans.name + "/ViewModel";
        if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

        string modelPath = pagePath + "/" + trans.name + "ViewModel.lua";
        if (File.Exists(modelPath))
        {
            Debug.LogError("lua file in path:{0} is existed." + modelPath);
            return;
        }

        GenUITemplate(trans.name,default_layer,tpl_viewmodel, modelPath);
    }

   // [MenuItem("GameObject/MVVM/Gen View", priority = 12)]
    public static void GenUIView()
    {
        Transform trans = Selection.activeTransform;
        if (trans == null) return;

        string pagePath = output_dir + trans.name + "/View";
        if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

        string viewPath = pagePath + "/" + trans.name + "View.lua";
        if (File.Exists(viewPath))
        {
            Debug.LogError("lua file in path:{0} is existed."+ viewPath);
            return;
        }

        GenUITemplate(trans.name, default_layer, tpl_view, viewPath);
    }

   // [MenuItem("GameObject/MVVM/Gen Component", priority = 13)]
    public static void GenUIComponent()
    {
        Transform trans = Selection.activeTransform;
        if (trans == null) return;

        string pagePath = output_dir + trans.name + "/Component";
        if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

        string componentPath = pagePath + "/" + trans.name + "WrapItem.lua";
        if (File.Exists(componentPath))
        {
            Debug.LogError("lua file in path:{0} is existed." + componentPath);
            return;
        }

        GenUITemplate(trans.name, default_layer, tpl_component, componentPath);
    }

  //  [MenuItem("GameObject/MVVM/Gen Config", priority = 14)]
    public static void GenUIConfig()
    {
        Transform trans = Selection.activeTransform;
        if (trans == null) return;

        string pagePath = output_dir + trans.name ;
        if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

        string configPath = pagePath + "/" + trans.name + "Config.lua";
        if (File.Exists(configPath))
        {
            Debug.LogError("lua file in path:{0} is existed." 
            + configPath);
            return;
        }

        GenUITemplate(trans.name, default_layer, tpl_config, configPath);
    }

}
