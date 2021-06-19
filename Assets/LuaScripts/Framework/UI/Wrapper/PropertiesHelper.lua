
local PropertiesHelper = {}


--property_name
local _IsVisible = "_IsVisible"
local default_properties =
{
    visible = function(self,property_name)
        if self:IsBinded(_IsVisible) then
            error(("%s has bind"):format(_IsVisible))
            return
        end
        self.binder:Add(property_name, function (oldValue, newValue)
            if oldValue ~= newValue then
                local game_object = self._origin.gameObject
                game_object:SetActive(newValue)
            end
        end)
        self:RecordProperty(_IsVisible)
    end
}

function PropertiesHelper:Extends(clazz)
 
    for k,v in pairs(default_properties) do
        clazz[k] = v
    end

    return clazz
end

return PropertiesHelper