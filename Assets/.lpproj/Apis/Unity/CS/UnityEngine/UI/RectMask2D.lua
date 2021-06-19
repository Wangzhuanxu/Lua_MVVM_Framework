---@class CS.UnityEngine.UI.RectMask2D : CS.UnityEngine.EventSystems.UIBehaviour
CS.UnityEngine.UI.RectMask2D = {}

---@property readonly CS.UnityEngine.UI.RectMask2D.canvasRect : CS.UnityEngine.Rect
CS.UnityEngine.UI.RectMask2D.canvasRect = nil

---@property readonly CS.UnityEngine.UI.RectMask2D.rectTransform : CS.UnityEngine.RectTransform
CS.UnityEngine.UI.RectMask2D.rectTransform = nil

---@param sp : CS.UnityEngine.Vector2
---@param eventCamera : CS.UnityEngine.Camera
---@return CS.System.Boolean
function CS.UnityEngine.UI.RectMask2D:IsRaycastLocationValid(sp, eventCamera)
end

function CS.UnityEngine.UI.RectMask2D:PerformClipping()
end

---@param clippable : CS.UnityEngine.UI.IClippable
function CS.UnityEngine.UI.RectMask2D:AddClippable(clippable)
end

---@param clippable : CS.UnityEngine.UI.IClippable
function CS.UnityEngine.UI.RectMask2D:RemoveClippable(clippable)
end