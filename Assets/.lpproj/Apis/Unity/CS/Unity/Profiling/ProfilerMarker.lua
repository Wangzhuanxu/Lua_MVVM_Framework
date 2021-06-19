---@module CS.Unity.Profiling
CS.Unity.Profiling = {}

---@class CS.Unity.Profiling.ProfilerMarker : CS.System.ValueType
CS.Unity.Profiling.ProfilerMarker = {}

---@param name : CS.System.String
---@return CS.Unity.Profiling.ProfilerMarker
function CS.Unity.Profiling.ProfilerMarker(name)
end

function CS.Unity.Profiling.ProfilerMarker:Begin()
end

---@param contextUnityObject : CS.UnityEngine.Object
function CS.Unity.Profiling.ProfilerMarker:Begin(contextUnityObject)
end

function CS.Unity.Profiling.ProfilerMarker:End()
end

---@return CS.Unity.Profiling.AutoScope
function CS.Unity.Profiling.ProfilerMarker:Auto()
end