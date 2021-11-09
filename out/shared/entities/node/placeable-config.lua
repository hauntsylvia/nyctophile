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
	function PlaceableConfig:constructor(cost, name, description, maxOfThisAllowed, placeableCategory)
		self.cost = cost
		self.name = name
		self.description = description
		self.maxOfThisAllowed = maxOfThisAllowed
		self.placeableCategory = placeableCategory
	end
end
return {
	PlaceableConfig = PlaceableConfig,
}
