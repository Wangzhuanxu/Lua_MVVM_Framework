---@module CS.XLua
CS.XLua = {}

---@class CS.XLua.DelegateBridge : CS.XLua.DelegateBridgeBase
CS.XLua.DelegateBridge = {}

---@field public CS.XLua.DelegateBridge.Gen_Flag : CS.System.Boolean
CS.XLua.DelegateBridge.Gen_Flag = nil

---@param reference : CS.System.Int32
---@param luaenv : CS.XLua.LuaEnv
---@return CS.XLua.DelegateBridge
function CS.XLua.DelegateBridge(reference, luaenv)
end

function CS.XLua.DelegateBridge:__Gen_Delegate_Imp0()
end

---@param p0 : CS.System.Single
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp1(p0)
end

---@param p0 : CS.System.Single
---@param p1 : CS.System.Single
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp2(p0, p1)
end

---@param p0 : CS.System.Int32
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp3(p0)
end

---@param p0 : CS.System.Int32
---@param p1 : CS.UnityEngine.Vector3
---@return CS.System.Boolean
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp4(p0, p1)
end

---@param p0 : CS.UnityEngine.Vector2
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp5(p0)
end

---@param p0 : CS.UnityEngine.Playables.PlayableDirector
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp6(p0)
end

---@param p0 : CS.System.String
---@param p1 : CS.System.Int32
---@param p2 : CS.System.Single
---@param p3 : CS.System.String
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp7(p0, p1, p2, p3)
end

---@param p0 : CS.UnityEngine.EventSystems.BaseEventData
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp8(p0)
end

---@param p0 : CS.System.Boolean
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp9(p0)
end

---@param p0 : CS.System.Object
---@param p1 : CS.System.Object
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp10(p0, p1)
end

---@param p0 : CS.System.Object
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp11(p0)
end

---@param p0 : CS.System.Object
---@return CS.System.String
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp12(p0)
end

---@return CS.System.String
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp13()
end

---@return CS.System.Boolean
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp14()
end

---@param p0 : CS.System.Object
---@param p1 : CS.System.Object
---@param p2 : CS.System.Boolean
---@return CS.System.String[]
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp15(p0, p1, p2)
end

---@param p0 : CS.System.Object
---@param p1 : CS.System.Object
---@return CS.System.String[]
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp16(p0, p1)
end

---@param p0 : CS.System.Object
---@return CS.System.String[]
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp17(p0)
end

---@param p0 : CS.System.Object
---@param p1 : CS.System.Object
---@return CS.System.Boolean
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp18(p0, p1)
end

---@param p0 : CS.System.Object
---@return CS.System.Byte[]
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp19(p0)
end

---@param p0 : CS.System.Object
---@return CS.System.Boolean
function CS.XLua.DelegateBridge:__Gen_Delegate_Imp20(p0)
end

---@param type : CS.System.Type
---@return CS.System.Delegate
function CS.XLua.DelegateBridge:GetDelegateByType(type)
end

---@param L : CS.System.IntPtr
---@param nArgs : CS.System.Int32
---@param nResults : CS.System.Int32
---@param errFunc : CS.System.Int32
function CS.XLua.DelegateBridge:PCall(L, nArgs, nResults, errFunc)
end

function CS.XLua.DelegateBridge:Action()
end