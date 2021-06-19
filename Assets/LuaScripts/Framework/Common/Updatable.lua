--[[
-- added by wsh @ 2017-12-18
-- 可更新脚本，等效于带有Unity侧Update、LateUpdate、FixedUpdate函数
-- 注意：
-- 1、虽然支持Update、LateUpdate、FixedUpdate更新，但能不用就不用---不要定义这些函数即可，用太多可能对性能有影响
-- 2、使用Time获取时间相关信息，如：Time.deltaTime，Time.fixedDeltaTime，Time.frameCount等
--]]

local Updatable = BaseClass("Updatable")

-- 添加更新函数
local function AddUpdate(self)
	if self.Update ~= nil then
		UpdateManager:GetInstance():AddUpdate(self, self.Update)
	end
	if self.LateUpdate ~= nil then
		UpdateManager:GetInstance():AddLateUpdate(self, self.LateUpdate)
	end
	if self.FixedUpdate ~= nil then
		UpdateManager:GetInstance():AddFixedUpdate(self, self.FixedUpdate)
	end
end

-- 注销更新函数
local function RemoveUpdate(self)
	UpdateManager:GetInstance():RemoveUpdate(self)
	UpdateManager:GetInstance():RemoveLateUpdate(self)
	UpdateManager:GetInstance():RemoveFixedUpdate(self)
end

-- 构造函数
local function __init(self)

end

-- 析构函数
local function __delete(self)

end

-- 是否启用更新
local function EnableUpdate(self, enable)
	RemoveUpdate(self)
	if enable then
		AddUpdate(self)
	end
end

Updatable.__init = __init
Updatable.__delete = __delete
Updatable.EnableUpdate = EnableUpdate

return Updatable