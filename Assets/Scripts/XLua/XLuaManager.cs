﻿using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using XLua;
/// <summary>
/// 说明：xLua管理类
/// 注意：
/// 1、整个Lua虚拟机执行的脚本分成3个模块：热修复、公共模块、逻辑模块
/// 2、公共模块：提供Lua语言级别的工具类支持，和游戏逻辑无关，最先被启动
/// 3、热修复模块：脚本全部放Lua/XLua目录下，随着游戏的启动而启动
/// 4、逻辑模块：资源热更完毕后启动
/// 5、资源热更以后，理论上所有被加载的Lua脚本都要重新执行加载，如果热更某个模块被删除，则可能导致Lua加载异常，这里的方案是释放掉旧的虚拟器另起一个
/// @by wsh 2017-12-28
/// </summary>

namespace Framework
{
    public class XLuaManager : MonoSingleton<XLuaManager>
    {
        public static HashSet<string> classLibrary = new HashSet<string>()
        {
            "protoc"
        };

        public const string classLibraryName = "Common/Library";
        public const string luaAssetbundleAssetName = "Lua";
        public const string luaScriptsFolder = "LuaScripts";
        const string commonMainScriptName = "Common.Main";
        const string gameMainScriptName = "GameMain";
        const string hotfixMainScriptName = "XLua.HotfixMain";
        LuaEnv luaEnv = null;
        LuaUpdater luaUpdater = null;
    
        protected override void Init()
        {
            InitLuaEnv();
        }
    
        public bool HasGameStart
        {
            get;
            protected set;
        }
    
        public LuaEnv GetLuaEnv()
        {
            return luaEnv;
        }
    
        void InitLuaEnv()
        {
            luaEnv = new LuaEnv();
            HasGameStart = false;
            if (luaEnv != null)
            {
                luaEnv.AddLoader(CustomLoader);
                luaEnv.AddBuildin("pb", XLua.LuaDLL.Lua.LoadLuaProfobuf);
                // luaEnv.AddBuildin("cjson", XLua.LuaDLL.Lua.LoadRapidJson);
            }
            else
            {
                Debug.LogError("InitLuaEnv null!!!");
            }
        }
    
        // 这里必须要等待资源管理模块加载Lua AB包以后才能初始化
        public void OnInit()
        {
            if (luaEnv != null)
            {
                LoadScript(commonMainScriptName);
                luaUpdater = gameObject.GetComponent<LuaUpdater>();
                if (luaUpdater == null)
                {
                    luaUpdater = gameObject.AddComponent<LuaUpdater>();
                }
                luaUpdater.OnInit(luaEnv);
    // #if UNITY_EDITOR
    //             UnityEditor.EditorApplication.playModeStateChanged -= OnEditorPalyModeChanged;
    //             UnityEditor.EditorApplication.playModeStateChanged += OnEditorPalyModeChanged;
    // #endif
            }
        }


        // 重启虚拟机：热更资源以后被加载的lua脚本可能已经过时，需要重新加载
        // 最简单和安全的方式是另外创建一个虚拟器，所有东西一概重启
        public void Restart()
        {
            //StopHotfix();
            Dispose();
            InitLuaEnv();
            OnInit();
        }
        
// #if UNITY_EDITOR
//         private void OnEditorPalyModeChanged(UnityEditor.PlayModeStateChange state)
//         {
//             //点击编辑器停止的时候调用
//             if(state == UnityEditor.PlayModeStateChange.ExitingPlayMode)
//             {
//                 UnityEditor.EditorApplication.playModeStateChanged -= OnEditorPalyModeChanged;
//                 Exit();
//             }
//         }
// #endif
        public void SafeDoString(string scriptContent)
        {
            if (luaEnv != null)
            {
                try
                {
                    luaEnv.DoString(scriptContent);
                }
                catch (System.Exception ex)
                {
                    string msg = string.Format("xLua exception : {0}\n {1}", ex.Message, ex.StackTrace);
                    Debug.LogError(msg, null);
                }
            }
        }
    
        public void StartHotfix(bool restart = false)
        {
            if (luaEnv == null)
            {
                return;
            }
    
            if (restart)
            {
                StopHotfix();
                ReloadScript(hotfixMainScriptName);
            }
            else
            {
                LoadScript(hotfixMainScriptName);
            }
            SafeDoString("HotfixMain.Start()");
        }
    
        public void StopHotfix()
        {
            SafeDoString("HotfixMain.Stop()");
        }
    
        public void StartGame()
        {
            if (luaEnv != null)
            {
                LoadScript(gameMainScriptName);
                SafeDoString("GameMain.Start()");
                HasGameStart = true;
            }
        }
        
        public void ReloadScript(string scriptName)
        {
            SafeDoString(string.Format("package.loaded['{0}'] = nil", scriptName));
            LoadScript(scriptName);
        }
    
        void LoadScript(string scriptName)
        {
            SafeDoString(string.Format("require('{0}')", scriptName));
        }
    
        public static byte[] CustomLoader(ref string filepath)
        {
            StringBuilder scriptPath = new StringBuilder();
            if (classLibrary.Contains(filepath))
            {
                scriptPath.Append(classLibraryName).Append("/");
            }
            scriptPath.Append(filepath.Replace(".", "/")).Append(".lua");
    
#if UNITY_EDITOR
            var scriptDir = Path.Combine(Application.dataPath, luaScriptsFolder);
            var luaPath = Path.Combine(scriptDir, scriptPath.ToString());
            // Logger.Log("Load lua script : " + luaPath);
            return GameUtility.SafeReadAllBytes(luaPath);
#else

            var luaAddress = scriptPath.Append(".bytes").ToString();
    
            var asset = AddressablesManager.Instance.GetLuaCache(luaAddress) ;
            if (asset != null)
            {
                Logger.Log("Load lua script : " + scriptPath);
                return asset.bytes;
            }
            Logger.LogError("Load lua script failed : " + scriptPath + ", You should preload lua assetbundle first!!!");
            return null;
#endif
        }

        private void Update()
        {
            if (luaEnv != null)
            {
                luaEnv.Tick();
    
                if (Time.frameCount % 5000 == 0)
                {
                    luaEnv.FullGc();
                }
            }
        }
    
    
        private void OnApplicationQuit()
        {
            Exit();
        }
        private void Exit()
        {
            if (luaEnv != null && HasGameStart)
            {
               // StopHotfix();
                SafeDoString("GameMain.OnApplicationQuit()");
                Dispose();
                Debug.Log("lua env has been disposed");
                HasGameStart = false;
            }
        }
    
        public override void Dispose()
        {
            if (luaUpdater != null)
            {
                luaUpdater.OnDispose();
            }
            if (luaEnv != null)
            {
                try
                {
                    luaEnv.Dispose();
                    luaEnv = null;
                }
                catch (System.Exception ex)
                {
                    string msg = string.Format("xLua exception : {0}\n {1}", ex.Message, ex.StackTrace);
                    Debug.LogError(msg, null);
                }
            }
        }
        
    }

}
