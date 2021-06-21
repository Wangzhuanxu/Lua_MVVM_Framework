--[[
-- added by wsh @ 2017-11-30
-- UI管理系统：提供UI操作、UI层级、UI消息、UI资源加载、UI调度、UI缓存等管理
-- 注意：
-- 1、Window包括：Model、Ctrl、View、和Active状态等构成的一个整体概念
-- 2、所有带Window接口的都是操作整个窗口，如CloseWindow以后：整个窗口将不再活动
-- 3、所有带View接口的都是操作视图层展示，如CloseView以后：View、Model依然活跃，只是看不见，可看做切入了后台
-- 4、如果只是要监听数据，可以创建不带View、Ctrl的后台窗口，配置为nil，比如多窗口需要共享某控制model（配置为后台窗口）
-- 5、可将UIManager看做一个挂载在UIRoot上的不完全UI组件，但是它是Singleton，不使用多重继承，UI组件特性隐式实现
--]]

local Messenger = require "Framework.Common.Messenger"
local UIManager = BaseClass("UIManager", Singleton)
local GameObject = CS.UnityEngine.GameObject
local UISortingLayers = require ("Framework.UI.UISortingLayers")
-- UIRoot路径
local UIRootPath = "UI/UIRoot"
-- EventSystem路径
local EventSystemPath = "EventSystem"
-- UICamera路径
local UICameraPath = "UI/UICamera"
-- 分辨率
local Resolution = Vector2.New(1920, 1080)
-- 窗口最大可使用的相对order_in_layer
local MaxOderPerWindow = 10
-- cs Tip
local UINoticeTip = CS.UINoticeTip.Instance


--初始化层级
local function _init_layers(self)
    for name, layer in UISortingLayers:pairs() do
		local info  = 
		{
			sorting_layer_id = layer.id,
			sorting_order_start = -32000,
			sorting_order_layer_range = 3000,
			layer_name = layer.name,
			layer_index = layer.index,
			gameobject = self.gameObject,
		}
        self.layers[name] = UILayer.New(self, info)
		self.layers[name]:OnCreate()
    end
end

local function _init_ui_root(self)
	--self.rectTransform = UIUtil.FindComponent(self.transform, typeof(CS.UnityEngine.RectTransform))

	-- Unity侧原生组件
	self.unity_canvas = nil
	self.unity_canvas_scaler = nil
	self.unity_graphic_raycaster = nil
	
	-- ui layer
	self.gameObject.layer = 5
	
	-- canvas
	self.unity_canvas = UIUtil.FindComponent(self.transform, typeof(CS.UnityEngine.Canvas))
	if IsNull(self.unity_canvas) then
		self.unity_canvas = self.gameObject:AddComponent(typeof(CS.UnityEngine.Canvas))
		-- 说明：很坑爹，这里添加UI组件以后transform会Unity被替换掉，必须重新获取
		self.transform = self.unity_canvas.transform
		self.gameObject = self.unity_canvas.gameObject
	end
	self.unity_canvas.renderMode = CS.UnityEngine.RenderMode.ScreenSpaceCamera
	self.unity_canvas.worldCamera = self.UICamera
	
	-- scaler
	self.unity_canvas_scaler = UIUtil.FindComponent(self.transform, typeof(CS.UnityEngine.UI.CanvasScaler))
	if IsNull(self.unity_canvas_scaler) then
		self.unity_canvas_scaler = self.gameObject:AddComponent(typeof(CS.UnityEngine.UI.CanvasScaler))
	end
	self.unity_canvas_scaler.uiScaleMode = CS.UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
	self.unity_canvas_scaler.screenMatchMode = CS.UnityEngine.UI.CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
	self.unity_canvas_scaler.referenceResolution = self.Resolution
	
	-- raycaster
	self.unity_graphic_raycaster = UIUtil.FindComponent(self.transform, typeof(CS.UnityEngine.UI.GraphicRaycaster))
	if IsNull(self.unity_graphic_raycaster) then
		self.unity_graphic_raycaster = self.gameObject:AddComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
	end

end

-- 构造函数
local function __init(self)
	-- 成员变量
	-- 消息中心
	self.ui_message_center = Messenger.New()
	-- 所有存活的窗体
	self.windows = {}
	-- 所有可用的层级
	self.layers = {}
	-- 保持Model
	self.keep_model = {}
	-- 窗口记录队列
	self.__window_stack = {}
	-- 是否启用记录
	self.__enable_record = true
	
	-- 初始化组件
	local ui_obj =  GameObject.Find("UI")
	CS.UnityEngine.Object.DontDestroyOnLoad(ui_obj)
	self.gameObject = GameObject.Find(UIRootPath)
	self.transform = self.gameObject.transform
	self.camera_go = GameObject.Find(UICameraPath)
	self.UICamera = self.camera_go:GetComponent(typeof(CS.UnityEngine.Camera))
	self.Resolution = Resolution
	self.MaxOderPerWindow = MaxOderPerWindow
	local event_system = GameObject.Find(EventSystemPath)
	CS.UnityEngine.Object.DontDestroyOnLoad(event_system)
	assert(not IsNull(self.transform))
	assert(not IsNull(self.UICamera))
	
	-- 初始化层级
	_init_ui_root(self)
	_init_layers(self)
end



-- 注册消息
local function AddListener(self, e_type, e_listener,obj)
	self.ui_message_center:AddListener(e_type, e_listener,obj)
end

-- 发送消息
local function Broadcast(self, e_type, ...)
	self.ui_message_center:Broadcast(e_type, ...)
end

-- 注销消息
local function RemoveListener(self, e_type, e_listener,obj)
	self.ui_message_center:RemoveListener(e_type, e_listener,obj)
end

-- 获取窗口
local function GetWindow(self, ui_name, active, view_active)
	local target = self.windows[ui_name]
	if target == nil then
		return nil
	end
	if active ~= nil and target.Active ~= active then
		return nil
	end
	if view_active ~= nil and target.View:GetActive() ~= view_active then
		return nil
	end
	return target
end

-- 初始化窗口
local function InitWindow(self, ui_name, window)
	local config = UIConfig[ui_name]
	assert(config, "No window named : "..ui_name..".You should add it to UIConfig first!")
	
	local layer = self.layers[config.Layer]
	assert(layer, "No layer named : ".. config.Layer ..".You should create it first!")
	
	window.Name = ui_name
	if self.keep_model[ui_name] then
		window.ViewModel = self.keep_model[ui_name]
	elseif config.ViewModel then
		window.ViewModel = config.ViewModel.New(ui_name)
	end

	if config.View then
		window.View = config.View.New(layer, window.Name, window.ViewModel)
	end

	window.Active = false
	window.Layer = layer
	window.PrefabPath = config.PrefabPath
	
	self:Broadcast(UIMessageNames.UIFRAME_ON_WINDOW_CREATE, window)
	return window
end

-- 激活窗口
local function ActivateWindow(self, target, ...)
	assert(target)
	assert(target.IsLoading == false, "You can only activate window after prefab locaded!")
	target.ViewModel:Activate(...)
	target.View:SetActive(true)
	self:Broadcast(UIMessageNames.UIFRAME_ON_WINDOW_OPEN, target)
end

-- 反激活窗口
local function Deactivate(self, target)
	target.ViewModel:Deactivate()
	target.View:SetActive(false)
	self:Broadcast(UIMessageNames.UIFRAME_ON_WINDOW_CLOSE, target)
end

-- 打开窗口：私有，必要时准备资源
local function InnerOpenWindow(self, target, ...)
	assert(target)
	assert(target.ViewModel)
	assert(target.View)
	assert(target.Active == false, "You should close window before open again!")
	
	target.Active = true
	local has_view = target.View ~= UIBaseView
	local has_prefab_res = target.PrefabPath and #target.PrefabPath > 0
	local has_loaded = not IsNull(target.View.gameObject)
	local need_load = has_view and has_prefab_res and not has_loaded
	if not need_load then
		ActivateWindow(self, target, ...)
	elseif not target.IsLoading then
		target.IsLoading = true
		local params = SafePack(...)

		local Resources = CS.UnityEngine.Resources
		local path = ("path is %s"):format(target.PrefabPath)
		print(path)
		local prefab = Resources.Load(target.PrefabPath,typeof(GameObject))
		if IsNull(prefab) then
			return
		end
		local go = GameObject.Instantiate(prefab)
		local trans = go.transform
		trans:SetParent(target.Layer.transform)
		trans.name = target.Name
		
		target.IsLoading = false
		target.View:LoadOver(go)
		if target.Active then
			ActivateWindow(self, target, SafeUnpack(params))
		end
	end
end

-- 关闭窗口：私有
local function InnerCloseWindow(self, target)
	assert(target)
	assert(target.ViewModel)
	assert(target.View)
	if target.Active then
		Deactivate(self, target)
		target.Active = false
	end
end

-- 打开窗口：公有
local function OpenWindow(self, ui_name, ...)
	local target = self:GetWindow(ui_name)
	if not target then
		local window = UIWindow.New()
		self.windows[ui_name] = window
		target = InitWindow(self, ui_name, window)
	end
	
	-- 先关闭
	InnerCloseWindow(self, target)
	InnerOpenWindow(self, target, ...)
	
	-- 窗口记录
	local layer = UIConfig[ui_name].Layer
	if layer == SortingLayerNames.Background then
		local bg_index = self:GetLastBgWindowIndexInWindowStack()
		if bg_index == -1 or self.__window_stack[bg_index] ~= target.Name then
			self:AddToWindowStack(target.Name)
		else
			self:PopWindowStack()
		end
	elseif layer == SortingLayerNames.Normal then
		self:AddToWindowStack(target.Name)
	end
end

-- 关闭窗口：公有
local function CloseWindow(self, ui_name)
	local target = self:GetWindow(ui_name, true)
	if not target then
		return
	end
	
	InnerCloseWindow(self, target)
	
	-- 窗口记录
	local layer = UIConfig[ui_name].Layer
	if layer == SortingLayerNames.Background then
		if target.Name == self.__window_stack[table.count(self.__window_stack)] then
			self:RemoveFormWindowStack(target.Name, true)
			--self:PopWindowStack()
		else
			self:RemoveFormWindowStack(target.Name, true)
		end
	elseif layer == SortingLayerNames.Normal then
		self:RemoveFormWindowStack(target.Name, true)
	end
end

-- 关闭层级所有窗口
local function CloseWindowByLayer(self, layer)
	for _,v in pairs(self.windows) do
		if v.Layer:GetName() == layer.Name then
			InnerCloseWindow(self, v)
		end
	end
end

-- 关闭其它层级窗口
local function CloseWindowExceptLayer(self, layer)
	for _,v in pairs(self.windows) do
		if v.Layer:GetName() ~= layer.Name then
			InnerCloseWindow(self, v)
		end
	end
end

-- 关闭所有窗口
local function CloseAllWindows(self)
	for _,v in pairs(self.windows) do
		InnerCloseWindow(self, v)
	end
end

-- 展示窗口
local function OpenView(self, ui_name, ...)
	local target = self:GetWindow(ui_name)
	assert(target, "Try to show a window that does not exist: "..ui_name)
	if not target.View:GetActive() then
		target.View:SetActive(true)
	end
end

-- 隐藏窗口
local function CloseView(self, ui_name)
	local target = self:GetWindow(ui_name)
	assert(target, "Try to hide a window that does not exist: "..ui_name)
	if target.View:GetActive() then
		target.View:SetActive(false)
	end
end

local function InnerDelete(plugin)
	if plugin.__ctype == ClassType.instance then
		plugin:Delete()
	end
end

local function InnerDestroyWindow(self, ui_name, target, include_keep_model)
	self:Broadcast(UIMessageNames.UIFRAME_ON_WINDOW_DESTROY, target)
	-- 说明：一律缓存，如果要真的清理，那是清理缓存时需要管理的功能
	GameObjectPool:GetInstance():RecycleGameObject(self.windows[ui_name].PrefabPath, target.View.gameObject)
	if include_keep_model then
		self.keep_model[ui_name] = nil
		InnerDelete(target.ViewModel)
	elseif not self.keep_model[ui_name] then
		InnerDelete(target.ViewModel)
	end
	InnerDelete(target.View)
	self.windows[ui_name] = nil
end

-- 销毁窗口
local function DestroyWindow(self, ui_name, include_keep_model)
	local target = self:GetWindow(ui_name)
	if not target then
		return
	end
	
	InnerCloseWindow(self, target)
	InnerDestroyWindow(self, ui_name, target, include_keep_model)
end

-- 销毁层级所有窗口
local function DestroyWindowByLayer(self, layer, include_keep_model)
	for k,v in pairs(self.windows) do
		if v.Layer:GetName() == layer.Name then
			InnerCloseWindow(self, v)
			InnerDestroyWindow(self, k, v, include_keep_model)
		end
	end
end

-- 销毁其它层级窗口
local function DestroyWindowExceptLayer(self, layer, include_keep_model)
	for k,v in pairs(self.windows) do
		if v.Layer:GetName() ~= layer.Name then
			InnerCloseWindow(self, v)
			InnerDestroyWindow(self, k, v, include_keep_model)
		end
	end
end

-- 销毁所有窗口
local function DestroyAllWindow(self, include_keep_model)
	for k,v in pairs(self.windows) do
		InnerCloseWindow(self, v)
		InnerDestroyWindow(self, k, v, include_keep_model)
	end
end

-- 设置是否保持Model
local function SetKeepModel(self, ui_name, keep)
	local target = self:GetWindow(ui_name)
	assert(target, "Try to keep a model that window does not exist: "..ui_name)

	if keep then
		self.keep_model[target.Name] = target.ViewModel
	else
		self.keep_model[target.Name] = nil
	end
end

-- 获取保持的Model
local function GetKeepModel(self, ui_name)
	return self.keep_model[ui_name]
end

-- 加入窗口记录栈
local function AddToWindowStack(self, ui_name)
	if not self.__enable_record then
		return
	end
	
	table.insert(self.__window_stack, ui_name)
	-- 保持Model
	self:SetKeepModel(ui_name, true)
end

-- 从窗口记录栈中移除
local function RemoveFormWindowStack(self, ui_name, only_check_top)
	if not self.__enable_record then
		return
	end
	
	local index = table.indexof(self.__window_stack, ui_name)
	if not index then
		return
	end
	if only_check_top and index ~= table.count(self.__window_stack) then
		return
	end
	
	local ui_name = table.remove(self.__window_stack, index)
	-- 取消Model保持
	self:SetKeepModel(ui_name, false)
end

-- 获取记录栈
local function GetWindowStack(self)
	return self.__window_stack
end

-- 清空记录栈
local function ClearWindowStack(self)
	self.__window_stack = {}
end

-- 获取最后添加的一个背景窗口索引
local function GetLastBgWindowIndexInWindowStack(self)
	local bg_index = -1
	for i = 1, table.count(self.__window_stack) do
		local ui_name = self.__window_stack[i]
		if UIConfig[ui_name].Layer == SortingLayerNames.Background then
			bg_index = i
		end
	end
	return bg_index
end

-- 弹出栈
-- 注意：从上一个记录的背景UI开始弹出之后所有被记录的窗口
local function PopWindowStack(self)
	local bg_index = self:GetLastBgWindowIndexInWindowStack()
	if bg_index == -1 then
		-- 没找到背景UI
		if table.count(self.__window_stack) > 0 then
			error("There is something wrong!")
		end
		return
	end
	
	self.__enable_record = false
	local end_index = table.count(self.__window_stack)
	for i = bg_index + 1, end_index  do
		local ui_name = self.__window_stack[i]
		UIManager:GetInstance():OpenWindow(ui_name)
	end
	self.__enable_record = true
end

-- 展示Tip：单按钮
local function OpenOneButtonTip(self, title, content, btnText, callback)
	local ui_name = UIWindowNames.UINoticeTip
	local cs_func = UINoticeTip.ShowOneButtonTip
	self:OpenWindow(ui_name, cs_func, title, content, btnText, callback)
end

-- 展示Tip：双按钮
local function OpenTwoButtonTip(self, title, content, btnText1, btnText2, callback1, callback2)
	local ui_name = UIWindowNames.UINoticeTip
	local cs_func = UINoticeTip.ShowTwoButtonTip
	self:OpenWindow(ui_name, cs_func, title, content, btnText1, btnText2, callback1, callback2)
end

-- 展示Tip：三按钮
local function OpenThreeButtonTip(self, title, content, btnText1, btnText2, btnText3, callback1, callback2, callback3)
	local ui_name = UIWindowNames.UINoticeTip
	local cs_func = UINoticeTip.ShowThreeButtonTip
	self:OpenWindow(ui_name, cs_func, title, content, btnText1, btnText2, btnText3, callback1, callback2, callback3)
end

-- 隐藏Tip
local function CloseTip(self)
	local ui_name = UIWindowNames.UINoticeTip
	self:CloseWindow(ui_name)
end

-- 获取层级
local function GetLayer(self,layer)
	return self.layers[layer]
end

local function LeaveSceneSave(self,scene_name)
	if self.scene_window_stack == nil then
		self.scene_window_stack = {}
	end
	self.scene_window_stack[scene_name] = GetLastBgWindowIndexInWindowStack(self)
end

-- 打开最后一个场景对应界面
local function OpenLastLeaveSceneWindow(self,scene_name)
	if self.scene_window_stack ~= nil and self.scene_window_stack[scene_name] ~= nil then
		local index = self.scene_window_stack[scene_name]
		if index > 0 then
			UIManager:GetInstance():OpenWindow(self.__window_stack[index])
			return true
		end
	end
	return false
end


-- 析构函数
local function __delete(self)
	self.ui_message_center = nil
	self.windows = nil
	self.layers = nil
	self.keep_model = nil
end

UIManager.__init = __init
UIManager.AddListener = AddListener
UIManager.Broadcast = Broadcast
UIManager.RemoveListener = RemoveListener
UIManager.GetWindow = GetWindow
UIManager.OpenWindow = OpenWindow
UIManager.CloseWindow = CloseWindow
UIManager.CloseWindowByLayer = CloseWindowByLayer
UIManager.CloseWindowExceptLayer = CloseWindowExceptLayer
UIManager.CloseAllWindows = CloseAllWindows
UIManager.OpenView = OpenView
UIManager.CloseView = CloseView
UIManager.DestroyWindow = DestroyWindow
UIManager.DestroyWindowByLayer = DestroyWindowByLayer
UIManager.DestroyWindowExceptLayer = DestroyWindowExceptLayer
UIManager.DestroyAllWindow = DestroyAllWindow
UIManager.SetKeepModel = SetKeepModel
UIManager.GetKeepModel = GetKeepModel
UIManager.AddToWindowStack = AddToWindowStack
UIManager.RemoveFormWindowStack = RemoveFormWindowStack
UIManager.GetLastBgWindowIndexInWindowStack = GetLastBgWindowIndexInWindowStack
UIManager.GetWindowStack = GetWindowStack
UIManager.ClearWindowStack = ClearWindowStack
UIManager.PopWindowStack = PopWindowStack
UIManager.OpenOneButtonTip = OpenOneButtonTip
UIManager.OpenTwoButtonTip = OpenTwoButtonTip
UIManager.OpenThreeButtonTip = OpenThreeButtonTip
UIManager.CloseTip = CloseTip
UIManager.OpenLastLeaveSceneWindow = OpenLastLeaveSceneWindow
UIManager.GetLayer = GetLayer
UIManager.LeaveSceneSave = LeaveSceneSave
UIManager.__delete = __delete

return UIManager;