using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Framework;
using UnityEngine;

namespace Game
{
    public static class LuaUtility
    {
        public static byte[] LoadProtoBufFileBinary(string filepath)
        {
#if UNITY_EDITOR
            var scriptDir = Path.Combine(Application.dataPath, XLuaManager.luaScriptsFolder);
            var luaPath = Path.Combine(scriptDir, filepath);
            // Logger.Log("Load lua script : " + luaPath);
            return GameUtility.SafeReadAllBytes(luaPath);
#else
            //assetbundle
#endif
            return null;
        }
    }
}

