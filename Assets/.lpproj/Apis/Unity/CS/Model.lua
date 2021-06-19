---@class CS.Model : CS.System.Object
CS.Model = {}

---@property readwrite CS.Model.A : CS.System.Boolean
CS.Model.A = nil

---@return CS.Model
function CS.Model()
end

---@param value : CS.System.Action
function CS.Model:add_temp(value)
end

---@param value : CS.System.Action
function CS.Model:remove_temp(value)
end

---@param a : CS.System.Action
function CS.Model:Add(a)
end