--[[
-- added by wsh @ 2017-12-08
-- UI组件基类：所有UI组件从这里继承
-- 说明：
-- 1、采用基于组件的设计方式，容器类负责管理和调度子组件，实现类似于Unity中挂载脚本的功能
-- 2、组件对应Unity原生的各种Component和Script，容器对应Unity原生的GameObject
-- 3、写逻辑时完全不需要关注脚本调度，在cs中脚本函数怎么调度的，这里就怎么调度，只是要注意接口变动，lua侧没有Get、Set访问器
-- 注意：
-- 1、Lua侧组件的名字并不总是和Unity侧组件名字同步，Lua侧组件名字会作为组件系统中组件的标识
-- 2、Lua侧组件名字会在组件创建时提取Unity侧组件名字，随后二者没有任何关联，Unity侧组件名字可以随便改
-- 3、虽然Unity侧组件名字随后可以随意改，但是不建议（有GC），此外Lua侧组件一旦创建，使用时全部以Lua侧名字为准
-- 4、虽然支持Update、LateUpdate、FixedUpdate更新，但是UI组件最好不要使用---不要定义这些函数即可
-- 5、需要定时刷新的界面，最好启用定时器、协程，界面需要刷新的频率一般较低，倒计时之类的只需要每秒钟更新一次即可
--]]

local UIBaseComponent = BaseClass("UIBaseComponent")

-- 构造函数：除非特殊情况，所有子类不要再写这个函数，初始化工作放OnCreate
-- 多种重载方式：
-- 1、ComponentTypeClass.New(relative_path)
-- 2、ComponentTypeClass.New(child_index)
-- 3、ComponentTypeClass.New(unity_gameObject)
function UIBaseComponent:__init(holder)
	assert(not IsNull(holder), "Err : holder nil!")
	assert(not IsNull(holder.transform), "Err : holder tansform nil!")
	-- 窗口view层脚本
	self.view = nil
	-- 持有者
	self.holder = holder
end

-- 析构函数：所有组件的子类不要再写这个函数，释放工作全部放到OnDestroy
local function __delete(self)
	self:OnDestroy()
end

-- 创建，获取view
function UIBaseComponent:OnCreate()
	assert(not IsNull(self.holder), "Err : holder nil!")
	assert(not IsNull(self.holder.transform), "Err : holder tansform nil!")
	-- 初始化view
	local now_holder = self.holder
	while not IsNull(now_holder) do	
		if now_holder._class_type == UILayer then
			self.view = self
			break
		elseif not IsNull(now_holder.view) then
			self.view = now_holder.view
			break
		end
		now_holder = now_holder.holder
	end
	assert(not IsNull(self.view))

	--- 记录组件那些属性已经绑定了事件
	self._binders = {}
end

function UIBaseComponent:RecordProperty(property_name)
	self._binders[property_name] = true
end

function UIBaseComponent:IsBinded(property_name)
	return self._binders[property_name]
end

-- 打开
function UIBaseComponent:OnEnable()
	
end

-- 关闭
function UIBaseComponent:OnDisable()
	
end

-- 销毁
function UIBaseComponent:OnDestroy()
	if self.holder.OnComponentDestroy ~= nil then
		self.holder:OnComponentDestroy(self)
	end
	self.holder = nil
	self.view = nil
end

-- ----------------ComponentMapping中共有的属性------------------
-- function UIBaseComponent:visible()

-- end

return UIBaseComponent