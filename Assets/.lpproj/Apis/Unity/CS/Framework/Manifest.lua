---@module CS.Framework
CS.Framework = {}

---@class CS.Framework.Manifest : CS.UnityEngine.MonoBehaviour
CS.Framework.Manifest = {}

---@field public CS.Framework.Manifest.Items : CS.Item[]
CS.Framework.Manifest.Items = nil

---@property readonly CS.Framework.Manifest.map : CS.System.Collections.Generic.Dictionary
CS.Framework.Manifest.map = nil

---@property readonly CS.Framework.Manifest.itemNames : CS.System.String[]
CS.Framework.Manifest.itemNames = nil

---@property readonly CS.Framework.Manifest.containerNames : CS.System.String[]
CS.Framework.Manifest.containerNames = nil

---@return CS.Framework.Manifest
function CS.Framework.Manifest()
end

---@param key : CS.System.String
---@return CS.UnityEngine.Object
function CS.Framework.Manifest:GetItem(key)
end