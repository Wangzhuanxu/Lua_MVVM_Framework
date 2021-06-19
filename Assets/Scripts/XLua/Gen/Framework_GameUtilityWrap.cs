﻿#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class FrameworkGameUtilityWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Framework.GameUtility);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 25, 0, 0);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "FormatToUnityPath", _m_FormatToUnityPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FormatToSysFilePath", _m_FormatToSysFilePath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetPlatform", _m_GetPlatform_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "IsMobile", _m_IsMobile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "FullPathToAssetPath", _m_FullPathToAssetPath_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetFileExtension", _m_GetFileExtension_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetSpecifyFilesInFolder", _m_GetSpecifyFilesInFolder_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAllFilesInFolder", _m_GetAllFilesInFolder_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "GetAllDirsInFolder", _m_GetAllDirsInFolder_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CheckFileAndCreateDirWhenNeeded", _m_CheckFileAndCreateDirWhenNeeded_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "CheckDirAndCreateWhenNeeded", _m_CheckDirAndCreateWhenNeeded_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeWriteAllBytes", _m_SafeWriteAllBytes_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeWriteAllLines", _m_SafeWriteAllLines_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeWriteAllText", _m_SafeWriteAllText_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeReadAllBytes", _m_SafeReadAllBytes_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeReadAllLines", _m_SafeReadAllLines_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeReadAllText", _m_SafeReadAllText_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "DeleteDirectory", _m_DeleteDirectory_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeClearDir", _m_SafeClearDir_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeDeleteDir", _m_SafeDeleteDir_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeDeleteFile", _m_SafeDeleteFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeRenameFile", _m_SafeRenameFile_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SafeCopyFile", _m_SafeCopyFile_xlua_st_);
            
			
            Utils.RegisterObject(L, translator, Utils.CLS_IDX, "AssetsFolderName", Framework.GameUtility.AssetsFolderName);
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new Framework.GameUtility();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Framework.GameUtility constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FormatToUnityPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.FormatToUnityPath( _path );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FormatToSysFilePath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.FormatToSysFilePath( _path );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetPlatform_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = Framework.GameUtility.GetPlatform(  );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_IsMobile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                        var gen_ret = Framework.GameUtility.IsMobile(  );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_FullPathToAssetPath_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _full_path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.FullPathToAssetPath( _full_path );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetFileExtension_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.GetFileExtension( _path );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetSpecifyFilesInFolder_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
			    int gen_param_count = LuaAPI.lua_gettop(L);
            
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& (LuaAPI.lua_isnil(L, 2) || LuaAPI.lua_type(L, 2) == LuaTypes.LUA_TSTRING)) 
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    string _pattern = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = Framework.GameUtility.GetSpecifyFilesInFolder( _path, _pattern );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 3&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<string[]>(L, 2)&& LuaTypes.LUA_TBOOLEAN == LuaAPI.lua_type(L, 3)) 
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    string[] _extensions = (string[])translator.GetObject(L, 2, typeof(string[]));
                    bool _exclude = LuaAPI.lua_toboolean(L, 3);
                    
                        var gen_ret = Framework.GameUtility.GetSpecifyFilesInFolder( _path, _extensions, _exclude );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 2&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)&& translator.Assignable<string[]>(L, 2)) 
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    string[] _extensions = (string[])translator.GetObject(L, 2, typeof(string[]));
                    
                        var gen_ret = Framework.GameUtility.GetSpecifyFilesInFolder( _path, _extensions );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                if(gen_param_count == 1&& (LuaAPI.lua_isnil(L, 1) || LuaAPI.lua_type(L, 1) == LuaTypes.LUA_TSTRING)) 
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.GetSpecifyFilesInFolder( _path );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
            return LuaAPI.luaL_error(L, "invalid arguments to Framework.GameUtility.GetSpecifyFilesInFolder!");
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllFilesInFolder_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.GetAllFilesInFolder( _path );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetAllDirsInFolder_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _path = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.GetAllDirsInFolder( _path );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CheckFileAndCreateDirWhenNeeded_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                    Framework.GameUtility.CheckFileAndCreateDirWhenNeeded( _filePath );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CheckDirAndCreateWhenNeeded_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _folderPath = LuaAPI.lua_tostring(L, 1);
                    
                    Framework.GameUtility.CheckDirAndCreateWhenNeeded( _folderPath );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeWriteAllBytes_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _outFile = LuaAPI.lua_tostring(L, 1);
                    byte[] _outBytes = LuaAPI.lua_tobytes(L, 2);
                    
                        var gen_ret = Framework.GameUtility.SafeWriteAllBytes( _outFile, _outBytes );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeWriteAllLines_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _outFile = LuaAPI.lua_tostring(L, 1);
                    string[] _outLines = (string[])translator.GetObject(L, 2, typeof(string[]));
                    
                        var gen_ret = Framework.GameUtility.SafeWriteAllLines( _outFile, _outLines );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeWriteAllText_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _outFile = LuaAPI.lua_tostring(L, 1);
                    string _text = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = Framework.GameUtility.SafeWriteAllText( _outFile, _text );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeReadAllBytes_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _inFile = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.SafeReadAllBytes( _inFile );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeReadAllLines_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    string _inFile = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.SafeReadAllLines( _inFile );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeReadAllText_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _inFile = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.SafeReadAllText( _inFile );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DeleteDirectory_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _dirPath = LuaAPI.lua_tostring(L, 1);
                    
                    Framework.GameUtility.DeleteDirectory( _dirPath );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeClearDir_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _folderPath = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.SafeClearDir( _folderPath );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeDeleteDir_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _folderPath = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.SafeDeleteDir( _folderPath );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeDeleteFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _filePath = LuaAPI.lua_tostring(L, 1);
                    
                        var gen_ret = Framework.GameUtility.SafeDeleteFile( _filePath );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeRenameFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _sourceFileName = LuaAPI.lua_tostring(L, 1);
                    string _destFileName = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = Framework.GameUtility.SafeRenameFile( _sourceFileName, _destFileName );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SafeCopyFile_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _fromFile = LuaAPI.lua_tostring(L, 1);
                    string _toFile = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = Framework.GameUtility.SafeCopyFile( _fromFile, _toFile );
                        LuaAPI.lua_pushboolean(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        
        
		
		
		
		
    }
}
