---@class CS.UnityEngine.Events.PersistentCall : CS.System.Object
CS.UnityEngine.Events.PersistentCall = {}

---@property readonly CS.UnityEngine.Events.PersistentCall.target : CS.UnityEngine.Object
CS.UnityEngine.Events.PersistentCall.target = nil

---@property readonly CS.UnityEngine.Events.PersistentCall.methodName : CS.System.String
CS.UnityEngine.Events.PersistentCall.methodName = nil

---@property readwrite CS.UnityEngine.Events.PersistentCall.mode : CS.UnityEngine.Events.PersistentListenerMode
CS.UnityEngine.Events.PersistentCall.mode = nil

---@property readonly CS.UnityEngine.Events.PersistentCall.arguments : CS.UnityEngine.Events.ArgumentCache
CS.UnityEngine.Events.PersistentCall.arguments = nil

---@property readwrite CS.UnityEngine.Events.PersistentCall.callState : CS.UnityEngine.Events.UnityEventCallState
CS.UnityEngine.Events.PersistentCall.callState = nil

---@return CS.UnityEngine.Events.PersistentCall
function CS.UnityEngine.Events.PersistentCall()
end

---@return CS.System.Boolean
function CS.UnityEngine.Events.PersistentCall:IsValid()
end

---@param theEvent : CS.UnityEngine.Events.UnityEventBase
---@return CS.UnityEngine.Events.BaseInvokableCall
function CS.UnityEngine.Events.PersistentCall:GetRuntimeCall(theEvent)
end

---@param ttarget : CS.UnityEngine.Object
---@param mmethodName : CS.System.String
function CS.UnityEngine.Events.PersistentCall:RegisterPersistentListener(ttarget, mmethodName)
end

function CS.UnityEngine.Events.PersistentCall:UnregisterPersistentListener()
end