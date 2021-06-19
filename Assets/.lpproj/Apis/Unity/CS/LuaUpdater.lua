---@class CS.LuaUpdater : CS.UnityEngine.MonoBehaviour
CS.LuaUpdater = {}

---@return CS.LuaUpdater
function CS.LuaUpdater()
end

---@param luaEnv : CS.XLua.LuaEnv
function CS.LuaUpdater:OnInit(luaEnv)
end

---@param luaEnv : CS.XLua.LuaEnv
function CS.LuaUpdater:Restart(luaEnv)
end

function CS.LuaUpdater:OnDispose()
end