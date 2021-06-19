ObservableList = {}

local get = {}
local set = {}

ObservableList.__index = function(t,k)
    local var = rawget(ObservableList, k)

    if var == nil then
        var = rawget(get, k)

        if var ~= nil then
            return var(t)
        end
    end

    return var
end

ObservableList.__tostring = function(self)
    local value = rawget(self, '_value')
    if value then
        return tostring(value)
    else
        return 'nil'
    end
end

ObservableList.__newindex = function(t, k, v)
    local var = rawget(ObservableList, k)

    if var == nil then
        var = rawget(set, k)

        if var ~= nil then
            return var(t, v)
        end
    end
end

function ObservableList.New(value)
    local t = {
        _value = value,
        OnValueChanged = {},
        AddHandlers = {},--delegate void AddHandler(T instance);
        InsertHandlers = {},--delegate void InsertHandler(int index,T instance);
        RemoveHandlers = {},--delegate void RemoveHandler(T instance);
    }
    setmetatable(t, ObservableList)
    return t
end

function ObservableList:Set_Value(value)
    local old = rawget(self, '_value')

    rawset(self, '_value', value)
    self:ValueChanged(old, value)
end

function ObservableList:Get_Value()
    return rawget(self, '_value')
end

function ObservableList:ValueChanged(oldValue, newValue)
    for _, onValueChanged in pairs(self.OnValueChanged) do
        onValueChanged(oldValue, newValue)
    end
end

function ObservableList:Add(item)
    local list = rawget(self, '_value')
    table.insert(list, item)
    for _, onAdd in pairs(self.AddHandlers) do
        onAdd(item)
    end
end

--不要使用
function ObservableList:Insert(item, index)
    -- index = index or 1
    -- local list = rawget(self, '_value')
    -- table.insert(list, index, item)
    -- for _, onInsert in pairs(self.InsertHandlers) do
    --     onInsert(index, item)
    -- end
end

function ObservableList:Remove(index)
    local list = rawget(self, '_value')
    if index >= #list then
        return 
    end
    local item = list[index + 1]
    table.remove(list, index + 1)
    for _, onRemove in pairs(self.RemoveHandlers) do
        onRemove(index,item)
    end
end

function ObservableList:GetCount()
    local list = rawget(self, '_value')
    return #list
end

function ObservableList:GetItem(index)
    local list = rawget(self, '_value')
    return list[index]
end


get.Value = ObservableList.Get_Value
get.Count = ObservableList.GetCount
set.Value = ObservableList.Set_Value