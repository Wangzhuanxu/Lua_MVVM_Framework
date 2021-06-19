---@class CS.UnityEngine.Profiling.CustomSampler : CS.UnityEngine.Profiling.Sampler
CS.UnityEngine.Profiling.CustomSampler = {}

---@param name : CS.System.String
---@return CS.UnityEngine.Profiling.CustomSampler
function CS.UnityEngine.Profiling.CustomSampler.Create(name)
end

function CS.UnityEngine.Profiling.CustomSampler:Begin()
end

---@param targetObject : CS.UnityEngine.Object
function CS.UnityEngine.Profiling.CustomSampler:Begin(targetObject)
end

function CS.UnityEngine.Profiling.CustomSampler:End()
end