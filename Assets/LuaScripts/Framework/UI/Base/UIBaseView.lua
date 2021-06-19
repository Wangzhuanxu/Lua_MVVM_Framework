--[[
-- added by wsh @ 2017-11-30
-- UI视图层基类：该界面所有UI刷新操作，只和展示相关的数据放在这，只有操作相关数据放Model去
-- 注意：
-- 1、被动刷新：所有界面刷新通过消息驱动---除了打开界面时的刷新
-- 2、对Model层可读，不可写---调试模式下强制
-- 3、所有写数据、游戏控制操作、网络相关操作全部放Ctrl层
-- 4、Ctrl层不依赖View层，但是依赖Model层
-- 5、任何情况下不要在游戏逻辑代码操作界面刷新---除了打开、关闭界面
--]]

local UIBaseView = BaseClass("UIBaseView", UIBaseContainer)
local ComponentMapping = require "Framework.UI.Component.ComponentMapping"
local C2LuaType = ComponentMapping.C2LuaType
local DefualtComponentProperty = ComponentMapping.DefualtComponentProperty
local UIItemsProxy = require "Framework.UI.Wrapper.UIItemsProxy"
local base = UIBaseContainer
local ViewType = EnumConfig.ViewType
local format = string.format

local _gen_keys = 
{
	[1] = function(names)
		return format("_%s",table.unpack(names))
	end,
	[1] = function(names)
		return format("_%s%s",table.unpack(names))
	end,
	[1] = function(names)
		return format("_%s%s%s",table.unpack(names))
	end,
	[1] = function(names)
		return format("_%s%s%s%s",table.unpack(names))
	end,
	[1] = function(names)
		return format("_%s%s%s%s%s",table.unpack(names))
	end,
}

-- 构造函数：必须把基类需要的所有参数列齐---即使在这里不用，提高代码可读性
-- 子类别再写构造函数，初始化工作放OnCreate
function UIBaseView:__init(holder, var_arg, viewModel,view_type)
	assert(viewModel ~= nil)
	------------------------------------------------- ViewModel
	self.Binder = PropertyBinder.New(self)
	self.viewModelProperty = BindableProperty.New()

	if(viewModel~=nil) then
		self.viewModelProperty.Value = viewModel
	end

	------------------------------------------------ 窗口画布
	self.canvas = nil
	-- 窗口基础order，窗口内添加的其它canvas设置的order都以它做偏移
	self.base_order = 0

	------------------------------基础组件------------------------
	-- 窗口view层脚本
	self.view = nil
	-- 持有者,子view holder为nil，否则为layer
	self.holder = holder
	-- 脚本绑定的transform
	self.transform = nil
	-- transform对应的gameObject
	self.gameObject = nil
	-- trasnform对应的RectTransform
	self.rectTransform = nil
	--windowname
	self.windowname = var_arg
	self.view_type = view_type or ViewType.MainView
	
end

local _main_view_canvas = "_main_view_canvas"

function UIBaseView:LoadOver(go)
	self.manifest = go:GetComponent(typeof(CS.Framework.Manifest))
	assert(not IsNull(self.manifest), "Err : manifest nil!")
	self.items = UIItemsProxy:New(self.manifest)

	if self.view_type == ViewType.MainView then
		assert(not IsNull(self.holder), "Err : holder nil!")
		assert(not IsNull(self.holder.transform), "Err : holder tansform nil!")
	end

	-- 初始化view
	self.view = self
	assert(not IsNull(self.view))
	
	self.transform = go.transform
	self.gameObject = go
	assert(not IsNull(self.gameObject), "Err : gameObject nil!")

	self.rectTransform = UIUtil.FindComponent(self.transform, typeof(CS.UnityEngine.RectTransform))
	--初始化RectTransform
	if self.view_type == ViewType.MainView then
		-- 主界面，增加一个canvas，控制界面的绘制顺序
		self.canvas = self:AddComponent(go,UICanvas, _main_view_canvas, nil,3)
		self.rectTransform.offsetMax = Vector2.zero
		self.rectTransform.offsetMin = Vector2.zero
		self.rectTransform.localPosition = Vector3.zero
		self.has_canvas = true
	end
	self.rectTransform.localScale = Vector3.one
	self:OnLoaded()
	table.insert(self.viewModelProperty.OnValueChanged, handlerEx(self.OnBindingContextChanged, self))
	self:OnCreate()
	self:_bind_all()
end

--------------------------------------------------------bind Start,cant override ----------------
function UIBaseView:_get_component_defualt_property(name)
	local item = self.items[name]
	local c_sharp_type = item:GetType():ToString()
	local property = DefualtComponentProperty[c_sharp_type]
	return property
end

function UIBaseView:_unpack_table(property_names)
	local t = {}
	local viewModel = self:GetViewModel()
	for _, name in ipairs(property_names) do
		t[#t + 1] = viewModel[name].Value
	end
	return table.unpack(t)
end

function UIBaseView:_data_bind(property_names,func,changed_property_name)
	if type(property_names) == "table" then
		for _,name in pairs(property_names) do 
			self.Binder:Add(property_names, function (oldValue, newValue)
				if oldValue ~= newValue then
					if changed_property_name then
						local viewModel = self:GetViewModel()
						viewModel[changed_property_name].Value = func(self:_unpack_table(property_names))
					else
						func(self:_unpack_table(property_names))
					end
				end
			end)
		end
	elseif type(property_names) == "string" then
		self.Binder:Add(property_names, function (oldValue, newValue)
			if oldValue ~= newValue then
				if changed_property_name then
					local viewModel = self:GetViewModel()
					viewModel[changed_property_name].Value = func(newValue)
				else
					func(newValue)
				end
			end
		end)
	end
end

function UIBaseView:Bind(component_name,property_name)
	assert(type(property_name) == "string","bind property_name must be string")
	local names = string.split(component_name, ".")
	local component = self:GetComponent(names[1])
	if not component then
		local item = self.items[names[1]]
		local c_sharp_type = item:GetType():ToString()
		local component_class = C2LuaType[c_sharp_type]
		assert(component_class ~= nil, ("%s dont have component_class!"):format(c_sharp_type))
		component = self:AddComponent(item,component_class,component_name, self.Binder)
	end
	local name = names[2] or self:_get_component_defualt_property(names[1])
	local p = component[name]
	assert(p ~= nil, ("%s for %s is nil !"):format(name,property_name))
	p(component,property_name)
end

function UIBaseView:DataBind(property_names,func)
	self:_data_bind(property_names,func)
end

function UIBaseView:ListBind(component_name,property_name,view_class,list_count)
	local item = self.items[component_name]
	assert(not IsNull(item), ("%s is nil !"):format(component_name))
	local trans = item.transform
	self:AddComponent(trans,UILIst,component_name, self.Binder,property_name,view_class,self,list_count)
end

function UIBaseView:HBind(component_name,property_names,func)
	assert(type(property_names) == "table","custom bind property_names must be a table")
	local names = string.split(component_name, ".")
	local component = self:GetComponent(names[1])
	if not component then
		local item = self.items[names[1]]
		local c_sharp_type = item:GetType():ToString()
		local component_class = C2LuaType[c_sharp_type]
		assert(component_class ~= nil, ("%s dont have component_class!"):format(c_sharp_type))
		component = self:AddComponent(item,component_class,component_name, self.Binder)
	end
	-- gen temp property
	local property_name = _gen_keys[#property_names](property_names)
	local view_model = self:GetViewModel()
	if not view_model[property_name] then
		viewModel[property_name] = BindableProperty.New("")
		self:_data_bind(property_names,func,property_name)
	end
	local name = names[2] or self:_get_component_defualt_property(names[1])
	local p = component[name]
	if p then 
		--封装的属性
		p(component,property_name)
	else
		--自己的属性
		self.Binder:Add(property_name, function (oldValue, newValue)
			if oldValue ~= newValue then
				component._origin[name] = newValue
			end
		end)
	end
	
end
------------------------------------------------------bind end ----------------------

-----------------------------------------------------execture order ,can override ------------------
---资源加载完毕---------
function UIBaseView:OnLoaded()
	
end

-- 绑定某些组件
function UIBaseView:OnCreate()

end

-- 打开：窗口显示
function UIBaseView:OnEnable()

end

-- 关闭：窗口隐藏
function UIBaseView:OnDisable()

end


-- 销毁：窗口销毁
function UIBaseView:OnDestroy()

end

-----------------------------------other function,cant overrride -------
function UIBaseView:GetViewModel()
	return self.viewModelProperty.Value
end

function UIBaseView:_bind_all()
	self.Binder:Bind(self.viewModelProperty.Value)
end

-- Binding 上下文改变时触发
function UIBaseView:OnBindingContextChanged(oldValue, newValue)

	if oldValue~= nil then self.Binder:Unbind(oldValue) end
	if newValue~= nil then self.Binder:Bind(newValue) end

end

-- 修改viewModel
function UIBaseView:SetBindingContext(viewModel)
	if viewModel~=nil then
		self.viewModelProperty.Value = viewModel
	end
end

-- 获取viewModel
function UIBaseView:GetBindingContext()
	return self.viewModelProperty.Value
end

-- 激活、反激活
function UIBaseView:SetActive(active)
	if active then
		self.gameObject:SetActive(active)
			-- 启用更新函数
		self:EnableUpdate(true)
		if self.holder and self.has_canvas then
			self.base_order = self.holder:PopWindowOder()
		end
		self:OnEnable()
		base.OnEnable(self)
	else
		base.OnDisable(self)
		-- 禁用更新函数
		self:EnableUpdate(true)
		if self.holder and self.has_canvas then
			self.holder:PushWindowOrder()
		end
		self:OnDisable()
		self.gameObject:SetActive(active)
	end
end

-- 获取激活状态
function UIBaseView:GetActive()
	return self.gameObject.activeSelf
end

-- 注册UI数据监听事件，别重写
function UIBaseView:AddUIListener(msg_name, callback)
	UIManager:GetInstance():AddListener(msg_name, callback,self)
end

-- 注销UI数据监听事件，别重写
function UIBaseView:RemoveUIListener(msg_name, callback)
	UIManager:GetInstance():RemoveListener(msg_name, callback,self)
end

function UIBaseView:Destroy()
	self.Binder:Unbind(self.viewModelProperty.Value)
	self.Binder = nil
	table.remove_value(self.viewModelProperty.OnValueChanged, handlerEx(self.OnBindingContextChanged, self))
	self.viewModelProperty = nil

	self.holder = nil
	self.transform = nil
	self.gameObject = nil
	self.rectTransform = nil
	base.Destroy(self)
end

------------------------------------------------------------
return UIBaseView