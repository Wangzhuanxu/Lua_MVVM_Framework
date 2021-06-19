---@class CS.UnityEngine.Rendering.BatchCullingContext : CS.System.ValueType
CS.UnityEngine.Rendering.BatchCullingContext = {}

---@field public CS.UnityEngine.Rendering.BatchCullingContext.cullingPlanes : CS.Unity.Collections.NativeArray
CS.UnityEngine.Rendering.BatchCullingContext.cullingPlanes = nil

---@field public CS.UnityEngine.Rendering.BatchCullingContext.batchVisibility : CS.Unity.Collections.NativeArray
CS.UnityEngine.Rendering.BatchCullingContext.batchVisibility = nil

---@field public CS.UnityEngine.Rendering.BatchCullingContext.visibleIndices : CS.Unity.Collections.NativeArray
CS.UnityEngine.Rendering.BatchCullingContext.visibleIndices = nil

---@field public CS.UnityEngine.Rendering.BatchCullingContext.lodParameters : CS.UnityEngine.Rendering.LODParameters
CS.UnityEngine.Rendering.BatchCullingContext.lodParameters = nil

---@param inCullingPlanes : CS.Unity.Collections.NativeArray
---@param inOutBatchVisibility : CS.Unity.Collections.NativeArray
---@param outVisibleIndices : CS.Unity.Collections.NativeArray
---@param inLodParameters : CS.UnityEngine.Rendering.LODParameters
---@return CS.UnityEngine.Rendering.BatchCullingContext
function CS.UnityEngine.Rendering.BatchCullingContext(inCullingPlanes, inOutBatchVisibility, outVisibleIndices, inLodParameters)
end