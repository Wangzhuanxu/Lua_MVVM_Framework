#if USE_UNI_LUA
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
    public class FrameworkManifestWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Framework.Manifest);
			Utils.BeginObjectRegister(type, L, translator, 0, 1, 4, 1);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "GetItem", _m_GetItem);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "map", _g_get_map);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "itemNames", _g_get_itemNames);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "containerNames", _g_get_containerNames);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "Items", _g_get_Items);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "Items", _s_set_Items);
            
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 1, 0, 0);
			
			
            
			
			
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new Framework.Manifest();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Framework.Manifest constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_GetItem(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.Manifest gen_to_be_invoked = (Framework.Manifest)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    string _key = LuaAPI.lua_tostring(L, 2);
                    
                        var gen_ret = gen_to_be_invoked.GetItem( _key );
                        translator.Push(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_map(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.Manifest gen_to_be_invoked = (Framework.Manifest)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.map);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_itemNames(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.Manifest gen_to_be_invoked = (Framework.Manifest)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.itemNames);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_containerNames(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.Manifest gen_to_be_invoked = (Framework.Manifest)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.containerNames);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_Items(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.Manifest gen_to_be_invoked = (Framework.Manifest)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.Items);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_Items(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.Manifest gen_to_be_invoked = (Framework.Manifest)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.Items = (Framework.Manifest.Item[])translator.GetObject(L, 2, typeof(Framework.Manifest.Item[]));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
