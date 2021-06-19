--[[
-- added by wsh @ 2017-12-08
-- UI容器基类：当一个UI组件持有其它UI组件时，它就是一个容器类，它要负责调度其它UI组件的相关函数
-- 注意：
-- 1、window.view是窗口最上层的容器类
-- 2、AddComponent用来添加组件，一般在window.view的OnCreate中使用，RemoveComponent相反
-- 3、GetComponent用来获取组件，GetComponents用来获取一个类别的组件
-- 4、很重要：子组件必须保证名字互斥，即一个不同的名字要保证对应于Unity中一个不同的Transform
--]]

local UIBaseContainer = BaseClass("UIBaseContainer", Updatable)

function UIBaseContainer:__init(holder, var_arg)
	-- 一个容器包含了多少组件
	self.components = {}
	self.length = 0
end

function UIBaseContainer:OnCreate()

end

-- 打开
function UIBaseContainer:OnEnable()
	self:Walk(function(component)
		if component.OnEnable then
			component:OnEnable()
		end
	end)
end

-- 遍历：注意，这里是无序的
function UIBaseContainer:Walk(callback)
	for _,component in pairs(self.components) do
		callback(component)
	end
end

-- 记录Component
function UIBaseContainer:RecordComponent(name, component)
	-- 同一个Transform不能挂两个同类型的组件
	assert(self.components[name] == nil, "Aready exist component_class : ", name)
	self.components[name] = component
end

-- 子组件销毁,数量减一
function UIBaseContainer:OnComponentDestroy(component)
	self.length = self.length - 1
end

-- 添加组件
function UIBaseContainer:AddComponent(item,component_target, component_name, binder, ...)
	assert(component_target.__ctype == ClassType.class)
	local component_inst = nil
	local component_class = nil
	component_inst = component_target.New(self)
	component_class = component_target
	component_inst:OnCreate(item,binder,...)
	
	local name = component_name
	self:RecordComponent(name, component_inst)
	self.length = self.length + 1
	return component_inst
end

-- 获取组件
function UIBaseContainer:GetComponent(name)
	local component = self.components[name]
	if component == nil then
		return nil
	end
	return component
end

-- 获取组件个数
function UIBaseContainer:GetComponentsCount()
	return self.length
end

-- 移除组件
function UIBaseContainer:RemoveComponent(name)
	local component = self:GetComponent(name)
	if component ~= nil then
		component:Delete()
		self.components[name] = nil
	end
end

-- 关闭
function UIBaseContainer:OnDisable()
	self:Walk(function(component)
		component:OnDisable()
	end)
end

-- 销毁
function UIBaseContainer:Destroy()
	self:Walk(function(component)
		-- 说明：现在一个组件可以被多个容器持有，但是holder只有一个，所以由holder去释放
		if component.holder == self then
			component:Delete()
		end
	end)
	self.components = nil
end

function UIBaseContainer:__delete()
	self:OnDestroy()
	self:Destroy()
end

return UIBaseContainer