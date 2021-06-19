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
    public class FrameworkUICircularScrollViewWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(Framework.UICircularScrollView);
			Utils.BeginObjectRegister(type, L, translator, 0, 14, 7, 7);
			
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnBeginDrag", _m_OnBeginDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnDrag", _m_OnDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnEndDrag", _m_OnEndDrag);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "Init", _m_Init);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateList", _m_UpdateList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ClearRange", _m_ClearRange);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateCell", _m_UpdateCell);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "CalContentSize", _m_CalContentSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "ShowList", _m_ShowList);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "UpdateSize", _m_UpdateSize);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "DisposeAll", _m_DisposeAll);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnClickCell", _m_OnClickCell);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "OnClickExpand", _m_OnClickExpand);
			Utils.RegisterFunc(L, Utils.METHOD_IDX, "SetToPageIndex", _m_SetToPageIndex);
			
			
			Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_CellGameObject", _g_get_m_CellGameObject);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_Direction", _g_get_m_Direction);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_IsShowArrow", _g_get_m_IsShowArrow);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_PointingEndArrow", _g_get_m_PointingEndArrow);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_PointingFirstArrow", _g_get_m_PointingFirstArrow);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_Row", _g_get_m_Row);
            Utils.RegisterFunc(L, Utils.GETTER_IDX, "m_Spacing", _g_get_m_Spacing);
            
			Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_CellGameObject", _s_set_m_CellGameObject);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_Direction", _s_set_m_Direction);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_IsShowArrow", _s_set_m_IsShowArrow);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_PointingEndArrow", _s_set_m_PointingEndArrow);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_PointingFirstArrow", _s_set_m_PointingFirstArrow);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_Row", _s_set_m_Row);
            Utils.RegisterFunc(L, Utils.SETTER_IDX, "m_Spacing", _s_set_m_Spacing);
            
			
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
					
					var gen_ret = new Framework.UICircularScrollView();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to Framework.UICircularScrollView constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnBeginDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnBeginDrag( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnDrag( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnEndDrag(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.EventSystems.PointerEventData _eventData = (UnityEngine.EventSystems.PointerEventData)translator.GetObject(L, 2, typeof(UnityEngine.EventSystems.PointerEventData));
                    
                    gen_to_be_invoked.OnEndDrag( _eventData );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    System.Func<int, UnityEngine.Vector3, bool> _showFunc = translator.GetDelegate<System.Func<int, UnityEngine.Vector3, bool>>(L, 2);
                    System.Action<int> _hideFunc = translator.GetDelegate<System.Action<int>>(L, 3);
                    
                    gen_to_be_invoked.Init( _showFunc, _hideFunc );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UpdateList(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ClearRange(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _start = LuaAPI.xlua_tointeger(L, 2);
                    int _end = LuaAPI.xlua_tointeger(L, 3);
                    
                    gen_to_be_invoked.ClearRange( _start, _end );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateCell(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.UpdateCell( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_CalContentSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _num = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.CalContentSize( _num );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_ShowList(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _num = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.ShowList( _num );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_UpdateSize(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.UpdateSize(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_DisposeAll(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    
                    gen_to_be_invoked.DisposeAll(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnClickCell(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    UnityEngine.GameObject _cell = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
                    
                    gen_to_be_invoked.OnClickCell( _cell );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_OnClickExpand(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.OnClickExpand( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SetToPageIndex(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
            
            
                
                {
                    int _index = LuaAPI.xlua_tointeger(L, 2);
                    
                    gen_to_be_invoked.SetToPageIndex( _index );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_CellGameObject(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_CellGameObject);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_Direction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_Direction);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_IsShowArrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushboolean(L, gen_to_be_invoked.m_IsShowArrow);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_PointingEndArrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_PointingEndArrow);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_PointingFirstArrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                translator.Push(L, gen_to_be_invoked.m_PointingFirstArrow);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_Row(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                LuaAPI.xlua_pushinteger(L, gen_to_be_invoked.m_Row);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_m_Spacing(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                LuaAPI.lua_pushnumber(L, gen_to_be_invoked.m_Spacing);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_CellGameObject(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_CellGameObject = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_Direction(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                Framework.e_Direction gen_value;translator.Get(L, 2, out gen_value);
				gen_to_be_invoked.m_Direction = gen_value;
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_IsShowArrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_IsShowArrow = LuaAPI.lua_toboolean(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_PointingEndArrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_PointingEndArrow = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_PointingFirstArrow(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_PointingFirstArrow = (UnityEngine.GameObject)translator.GetObject(L, 2, typeof(UnityEngine.GameObject));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_Row(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_Row = LuaAPI.xlua_tointeger(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_m_Spacing(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			
                Framework.UICircularScrollView gen_to_be_invoked = (Framework.UICircularScrollView)translator.FastGetCSObj(L, 1);
                gen_to_be_invoked.m_Spacing = (float)LuaAPI.lua_tonumber(L, 2);
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
