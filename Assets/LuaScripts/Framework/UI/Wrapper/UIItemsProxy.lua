
local error = error

local UIItemsProxy = {
    __index = function(t,k)
        error(("items.%s not exist."):format(k))
    end,
    __newindex = function(t,k,v)
        error(("UIItemsProxy is readonly. attempt to modifying '%s' was ignored."):format(k))
    end
}
    
function UIItemsProxy:New(manifest)
    local o = {}
    local names = manifest.itemNames
    for j = 0, names.Length - 1 do
        local name = names[j]
        o[name] = manifest:GetItem(name)
        assert(not IsNull(o[name]), "Err : obj is nil!")
    end
    setmetatable(o, self)
    return o
end

return UIItemsProxy