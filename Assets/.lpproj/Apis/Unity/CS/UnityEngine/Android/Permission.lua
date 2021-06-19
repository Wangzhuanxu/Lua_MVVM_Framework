---@class CS.UnityEngine.Android.Permission : CS.System.ValueType
CS.UnityEngine.Android.Permission = {}

---@field public CS.UnityEngine.Android.Permission.Camera : CS.System.String
CS.UnityEngine.Android.Permission.Camera = nil

---@field public CS.UnityEngine.Android.Permission.Microphone : CS.System.String
CS.UnityEngine.Android.Permission.Microphone = nil

---@field public CS.UnityEngine.Android.Permission.FineLocation : CS.System.String
CS.UnityEngine.Android.Permission.FineLocation = nil

---@field public CS.UnityEngine.Android.Permission.CoarseLocation : CS.System.String
CS.UnityEngine.Android.Permission.CoarseLocation = nil

---@field public CS.UnityEngine.Android.Permission.ExternalStorageRead : CS.System.String
CS.UnityEngine.Android.Permission.ExternalStorageRead = nil

---@field public CS.UnityEngine.Android.Permission.ExternalStorageWrite : CS.System.String
CS.UnityEngine.Android.Permission.ExternalStorageWrite = nil

---@param permission : CS.System.String
---@return CS.System.Boolean
function CS.UnityEngine.Android.Permission.HasUserAuthorizedPermission(permission)
end

---@param permission : CS.System.String
function CS.UnityEngine.Android.Permission.RequestUserPermission(permission)
end