
local pb = require("pb")

local enum = {
    _enum_defs = {}
}

local mt = {
    __call = function(t, enum_full_name)
        return t:get(enum_full_name)
    end
}
setmetatable(enum, mt)

local enum_def_prototype = {}

function enum:get(enum_full_name)
    local def = self._enum_defs[enum_full_name]
    if def then return def end

    local _, _, pbtype = pb.type(enum_full_name)
    assert(pbtype == "enum", ("%s is not an enum"):format(enum_full_name))

    def = {
        _enum_full_name = enum_full_name,
        _entries = {},
    }
    setmetatable(def, { 
        __index = enum_def_prototype,
        __len = function(t)
            return #t._entries
        end,
    })
    for key, value in pb.fields(enum_full_name) do
        def[key] = value
        def[value] = key
        def._entries[#def._entries + 1] = { key = key, value = value }
    end
    table.sort(def._entries, function(a, b) return a.value < b.value end)
    self._enum_defs[enum_full_name] = def
    return def
end

local function _iter(entries)
    local i = 0
    local n = #entries
    return function ()
        i = i + 1
        if i <= n then 
            local entry = entries[i]
            return entry.key, entry.value
        end
    end
end

function enum_def_prototype:iter()
    return _iter(self._entries)
end

return enum