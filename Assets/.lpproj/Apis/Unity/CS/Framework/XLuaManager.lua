---@class CS.Framework.XLuaManager : CS.Framework.MonoSingleton
CS.Framework.XLuaManager = {}

---@field public CS.Framework.XLuaManager.luaAssetbundleAssetName : CS.System.String
CS.Framework.XLuaManager.luaAssetbundleAssetName = nil

---@field public CS.Framework.XLuaManager.luaScriptsFolder : CS.System.String
CS.Framework.XLuaManager.luaScriptsFolder = nil

---@property readwrite CS.Framework.XLuaManager.HasGameStart : CS.System.Boolean
CS.Framework.XLuaManager.HasGameStart = nil

---@return CS.Framework.XLuaManager
function CS.Framework.XLuaManager()
end

---@return CS.XLua.LuaEnv
function CS.Framework.XLuaManager:GetLuaEnv()
end

function CS.Framework.XLuaManager:OnInit()
end

function CS.Framework.XLuaManager:Restart()
end

---@param scriptContent : CS.System.String
function CS.Framework.XLuaManager:SafeDoString(scriptContent)
end

---@param restart : CS.System.Boolean
function CS.Framework.XLuaManager:StartHotfix(restart)
end

function CS.Framework.XLuaManager:StopHotfix()
end

function CS.Framework.XLuaManager:StartGame()
end

---@param scriptName : CS.System.String
function CS.Framework.XLuaManager:ReloadScript(scriptName)
end

---@param filepath : CS.System.String
---@return CS.System.Byte[]
function CS.Framework.XLuaManager.CustomLoader(filepath)
end

function CS.Framework.XLuaManager:Dispose()
end