

local UILIst = BaseClass("UILIst", UIBaseComponent)
local base = UIBaseComponent
local typeof = typeof
local ViewType = EnumConfig.ViewType
local GameObject = CS.UnityEngine.GameObject
local assert = assert
-- 创建
function UILIst:OnCreate(content,binder,property_name,view_class,parent,list_count)
	base.OnCreate(self)
	--parent view
	self.parent = parent
	--max_list_count
	self.max_list_count = list_count or 50
	-- item list
	self.sub_views = {}
	-- view length
	self.length = 0
	-- content
	self.content = content
	-- UICircularScrollView
	self.scroll_view = content:GetComponentInParent(typeof(CS.Framework.UICircularScrollView))
	self.scroll_view:Init(
		--show
		function(index,pos)
			return self:_show_item(index,pos)
		end,
		--hide
		function(index)
			self:_hide_item(index)
		end
	)
	--view
	self.view = binder:GetView()
	--binder
	self.binder = binder
	--view model
	self.view_model = self.view:GetViewModel()
	--data list
	self.data_list = self.view_model[property_name].Value 
	--templates
	self.templates = {}
	self.property_name = property_name
	self.view_class = view_class
	---game_pool
	self.obj_pool = {}
	self:_init_event()
	self:_refresh_list_data()
	self:_init_list()
end

function UILIst:_init_event()
	local child_count = self.content.childCount
	for i = 0, child_count - 1 do 
		local go = self.content:GetChild(i).gameObject
		self.templates[#self.templates + 1] = go 
		go:SetActive(false)
	end
	self.binder:AddEx(self.property_name,
	--add
	function(item)
		self:_add_item()
	end,
	--insert
	function(item,index)
	
	end,
	--remove
	function(index,model)
		self:_remove_item(index,model)
	end)

	self.binder:AddWithNotInit(self.property_name,function()
		self:_clear()
		self.data_list = self.view_model[self.property_name].Value 
		self:_refresh_list_data()
	end)
end

function UILIst:_refresh_list_data()
	for _,value in ipairs(self.data_list) do 
		self.sub_views[self.length + 1] = false
		self.length = self.length + 1
	end
	self.scroll_view:CalContentSize(self.length)
	self.scroll_view:UpdateList()
end

function UILIst:_init_list()
	self.scroll_view:ShowList(self.max_list_count)
end

function UILIst:_add_item()
	self.sub_views[self.length + 1] = false
	self.length = self.length + 1
	self.scroll_view:CalContentSize(self.length)
	self.scroll_view:UpdateList()
end

function UILIst:_get_object_by_type(t)
	local pool = self.obj_pool[t]
	if not pool then return nil end
	if #pool <= 0 then return nil end
	return table.remove(pool)
end

function UILIst:_push_object_by_type(t,obj)
	if not self.obj_pool[t] then 
		self.obj_pool[t] = {}--setmetatable({}, {__mode = "v"})
	end
	table.insert(self.obj_pool[t],obj)
end

function UILIst:_show_item(index,pos)
	if index > self.length - 1 then 
		--print(tostring(true),"Lua--------------")
		return true 
	end
	-- lua 从1 开始
	local model = self.data_list[index + 1]
	local view = self.sub_views[index + 1]
	if not view then
		view = self.view_class.New(self.parent.holder, tostring(index), model,ViewType.ItemView)
	end
	local side = model.side or 0
	side = side + 1
	local go = self:_get_object_by_type(side)
	if not go then
		go = GameObject.Instantiate(self.templates[side])
	end
	assert(not IsNull(go), "Err : ui list template is nil!")
	local trans = go.transform
	trans:SetParent(self.content)
	trans:SetAsLastSibling()
	go:SetActive(true)
	local rect = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
	assert(not IsNull(rect), "Err : rect is nil!")
	rect.anchoredPosition3D = pos
	view:LoadOver(go)
	self.sub_views[index + 1] = view
	--print(tostring(false),"Lua--------------")
	return false
end

function UILIst:_hide_item(index)
	if index > self.length - 1 then return end
	local view = self.sub_views[index + 1]
	if not view then return end
	local model = self.data_list[index + 1]
	local side = model.side or 0
	side = side + 1
	local go = view.gameObject
	go:SetActive(false)
	view:Delete()
	self:_push_object_by_type(side,go)
	self.sub_views[index + 1] = false
	print("Destroy----------------------------------------------------------")
end

function UILIst:_remove_item(index,model)
	local view = self.sub_views[index + 1]
	table.remove(self.sub_views,index + 1)
	self.scroll_view:ClearRange(index, self.length)
	if view then
		local side = model.side or 0
		side = side + 1
		local go = view.gameObject
		go:SetActive(false)
		view:Delete()
		self:_push_object_by_type(side,go)
	end
	self.length = self.length - 1
	self.scroll_view:CalContentSize(self.length)
	self.scroll_view:UpdateList()
end

function UILIst:_clear()
	self.scroll_view:ClearRange(0, self.length)
	self.length = 0
end

-- 销毁
function UILIst:OnDestroy()
	self.scroll_view:DisposeAll()
	for _,view in pairs(self.sub_views) do 
		if type(view) == "table" then
			view:Delete()
		end
	end
	self.sub_views = nil
	for _,pool in pairs(self.obj_pool) do 
		if not pool then
			goto CONTINUE
		end
		for _,obj in pairs(pool) do 
			if obj then
				GameObject.Destroy(obj)
			end
		end
		::CONTINUE::
	end
	self.obj_pool = nil
	base.OnDestroy(self)
end

return UILIst