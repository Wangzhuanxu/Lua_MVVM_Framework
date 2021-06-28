using System;
using System.Collections;
using System.Collections.Generic;
using Game;
using UnityEngine;
using XLua;
using XLua.LuaDLL;

namespace Framework
{
     public class GameLaunch : MonoBehaviour
     {
 
          const string launchPrefabPath = "UI/Prefabs/View/UILaunch.prefab";
          const string noticeTipPrefabPath = "UI/Prefabs/Common/UINoticeTip.prefab";
          GameObject launchPrefab;
          GameObject noticeTipPrefab;

          IEnumerator Start ()
          {

               var start = DateTime.Now;

               // 启动资源管理模块
               start = DateTime.Now;
               Debug.Log(string.Format("AssetBundleManager Initialize use {0}ms", (DateTime.Now - start).Milliseconds));

               // 启动xlua热修复模块
               start = DateTime.Now;
               TestHotfix();
               XLuaManager.Instance.Startup();
               XLuaManager.Instance.OnInit();
             //  XLuaManager.Instance.StartHotfix();
               Debug.Log(string.Format("XLuaManager StartHotfix use {0}ms", (DateTime.Now - start).Milliseconds));
        
               yield return StartGame();
          }
    
          IEnumerator StartGame()
          {
               XLuaManager.Instance.StartGame();
               TestHotfix();
               yield break;
          }

          void TestHotfix()
          {
               // HotFixTest h = new HotFixTest();
               // h.Add(1,3);
               // h.Func();
          }

     }
}

