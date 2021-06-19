local PropertyBinder = BaseClass("PropertyBinder")

-- 如非必要，别重写构造函数，使用OnCreate初始化
function PropertyBinder:__init(view)
    self.view = view
    self._binders = {} --function(viewModel)
    self._unbinders = {} --function(viewModel)
end

function PropertyBinder:GetView()
    return self.view
end

--------------------------------------------------Simple Bind Start-----------------------------------------
function PropertyBinder.GetProperty(viewModel, path)
    if not path then return end
    local property = viewModel
    return property[path]
end

function PropertyBinder:Add(name, valueChangedHandler)
    local registerFunc = function(viewModel, bindableProperty)
        table.insert(bindableProperty.OnValueChanged, valueChangedHandler)
        local value = bindableProperty.Value
        valueChangedHandler(nil, value) --初始化数据
    end

    local unregisterFunc = function(viewModel, bindableProperty)
        table.remove_value(bindableProperty.OnValueChanged, valueChangedHandler)
    end

    self:RegisterEvent(registerFunc, unregisterFunc, name)
end

function PropertyBinder:AddWithNotInit(name, valueChangedHandler)
    local registerFunc = function(viewModel, bindableProperty)
        table.insert(bindableProperty.OnValueChanged, valueChangedHandler)
    end

    local unregisterFunc = function(viewModel, bindableProperty)
        table.remove_value(bindableProperty.OnValueChanged, valueChangedHandler)
    end

    self:RegisterEvent(registerFunc, unregisterFunc, name)
end

function PropertyBinder:RegisterEvent(eventRegisterHandler, eventUnregisterHandler, name)
    if eventRegisterHandler then 
        local bind = function(viewModel)
            currentPath = name
            local targetValue = self.GetProperty(viewModel, currentPath)
            eventRegisterHandler(viewModel, targetValue)
        end
        table.insert(self._binders, bind)
    end

    if eventUnregisterHandler then
        local unbind = function(viewModel)
            currentPath = name
            local targetValue = self.GetProperty(viewModel, currentPath)
            eventUnregisterHandler(viewModel, targetValue)
        end
        table.insert(self._unbinders, unbind)
    end
end

--------------------------------------------------Simple Bind End-----------------------------------------

function PropertyBinder:AddEx(name, onAdd, onInsert, onRemove)--给list用绑定
    local registerFunc = function(viewModel, bindableProperty)
        if bindableProperty.AddHandlers then
            table.insert(bindableProperty.AddHandlers, onAdd)
        end
        if bindableProperty.InsertHandlers then
            table.insert(bindableProperty.InsertHandlers, onInsert)
        end
        if bindableProperty.RemoveHandlers then
            table.insert(bindableProperty.RemoveHandlers, onRemove)
        end
    end

    local unregisterFunc = function(viewModel, bindableProperty)
        if bindableProperty.AddHandlers then
            table.remove_value(bindableProperty.AddHandlers, onAdd)
        end
        if bindableProperty.InsertHandlers then
            table.remove_value(bindableProperty.InsertHandlers, onInsert)
        end
        if bindableProperty.RemoveHandlers then
            table.remove_value(bindableProperty.RemoveHandlers, onRemove)
        end
    end

    self:RegisterEvent(registerFunc, unregisterFunc, name)
end



function PropertyBinder:Bind(viewModel)
    if viewModel then
        for _, binder in pairs(self._binders) do
            binder(viewModel)
        end
    end
end

function PropertyBinder:Unbind(viewModel)
    if viewModel then
        for _, unbinder in pairs(self._unbinders) do
            unbinder(viewModel)
        end
    end
end

return PropertyBinder