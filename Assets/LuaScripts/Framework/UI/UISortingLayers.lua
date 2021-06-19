local SortingLayer = CS.UnityEngine.SortingLayer
local pairs,ipairs = pairs,ipairs
local UISortingLayers = {}
UISortingLayers.name_mapping = {}
UISortingLayers.id_mapping = {}
UISortingLayers.list = {}

local function _init_sorting_layers()
    local name_mapping = UISortingLayers.name_mapping
    local id_mapping = UISortingLayers.id_mapping
    local list = UISortingLayers.list

    local layers = SortingLayer.layers                
    for i = 0, layers.Length - 1 do
        local v = layers[i]
        local layer = {
            id = v.id,
            index = i,
            name = v.name,
            value = v.value,
        }
        name_mapping[v.name] = layer
        id_mapping[v.id] = layer
        list[#list + 1] = layer
    end
end
_init_sorting_layers()

function UISortingLayers:get_layer(id_or_name)
    if type(id_or_name) == "number" then
        return self.id_mapping[id_or_name]
    end
    
    return self.name_mapping[id_or_name]
end

function UISortingLayers:pairs()
    return pairs(self.name_mapping)
end

function UISortingLayers:ipairs()
    return ipairs(self.list)
end

return UISortingLayers