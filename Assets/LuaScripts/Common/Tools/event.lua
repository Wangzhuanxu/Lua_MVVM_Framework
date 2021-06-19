
local insert = table.insert
local ipairs = ipairs

local event = class("event")
local ilist = ilist
local e_nextId = 1

local checkCycle = true
local curCalls = {}
local bugReport

function event:ctor()
	self.list = list.new()
	self.opList = {}
	self.lock = false
	self.id = e_nextId
	e_nextId = e_nextId + 1
end

--创建事件监听
function event:CreateListener(func,obj)
	return {value = func,obj = obj,removed = true}
end
--添加事件监听
function event:AddListener(listener)
	if not listener then
		return
	end
	if self.lock then
		insert(self.opList,function ()
			self.list:pushnode(listener)
		end)
	else
		self.list:pushnode(listener)
	end
end
--删除事件监听
function event:RemoveListener(listener)
	if not listener then
		return
	end
	if self.lock then
		insert(self.opList,function ()
			self.list:remove(listener)
		end)
	else
		self.list:remove(listener)
	end
end
--注册回调作为事件监听
function event:RegisterListener(func,obj)
	local listener = self:GetListener(func,obj)
	if listener then
		print("you have already register the listener")
		printCallStack()
		if bugReport then
			bugReport("you have already register the listener")
		end
		return listener
	end
	listener = self:CreateListener(func,obj)
	self:AddListener(listener)
	return listener
end
--取消回调监听
function event:UnregisterListener(func,obj)
	local listener = self:GetListener(func,obj)
	if not listener then return end
	self:RemoveListener(listener)
end

function event:Clear()
	self.list:clear()
	self.opList = {}
	self.lock = false
end
--获取回调对应的监听
function event:GetListener(func,obj)
	local _list = self.list
	for i,f in ilist(_list) do
		if i.value == func and i.obj == obj then
			return i
		end
	end
end

event.__call = function (self, ... )
	local _list = self.list	
	self.lock = true
	if checkCycle then
		local calls = (curCalls[self.id] or 0) +1
		if calls > 1 then
			--printCallStack()
			if bugReport then
				bugReport("you got cycle call")
			end
		end
		curCalls[self.id] = calls
	end
	for i, f in ilist(_list) do
		if i.obj then f(i.obj,...) else f(...) end
	end

	if checkCycle then
		curCalls[self.id] = curCalls[self.id] - 1
	end

	local opList = self.opList	
	self.lock = false		

	for i, op in ipairs(opList) do									
		op()
		opList[i] = nil
	end
end

function event.setReportFunc(func)
	bugReport = func
end

UpdateBeat 			= event.new()
LateUpdateBeat		= event.new()
FixedUpdateBeat		= event.new()
--只在协同使用
CoUpdateBeat		= event.new()
CoLateUpdateBeat	= event.new()
CoFixedUpdateBeat 	= event.new()

function Update(deltaTime, unscaledDeltaTime)
	Time:SetDeltaTime(deltaTime, unscaledDeltaTime)
	UpdateBeat()
	CoUpdateBeat()
end

function LateUpdate()
	LateUpdateBeat()
	CoLateUpdateBeat()
	Time:SetFrameCount()
end

function FixedUpdate(fixedDeltaTime)
	Time:SetFixedDelta(fixedDeltaTime)
	FixedUpdateBeat()
	CoFixedUpdateBeat()
end