-- Compiled with roblox-ts v1.2.7
local PlaceableConfig
do
	PlaceableConfig = setmetatable({}, {
		__tostring = function()
			return "PlaceableConfig"
		end,
	})
	PlaceableConfig.__index = PlaceableConfig
	function PlaceableConfig.new(...)
		local self = setmetatable({}, PlaceableConfig)
		return self:constructor(...) or self
	end
	function PlaceableConfig:constructor(cost, name, description, maxOfThisAllowed)
		self.cost = cost
		self.name = name
		self.description = description
		self.maxOfThisAllowed = maxOfThisAllowed
	end
end
return {
	PlaceableConfig = PlaceableConfig,
}
