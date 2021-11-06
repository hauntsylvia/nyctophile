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
local PlaceableCategories
do
	local _inverse = {}
	PlaceableCategories = setmetatable({}, {
		__index = _inverse,
	})
	PlaceableCategories.Furniture = 0
	_inverse[0] = "Furniture"
	PlaceableCategories.Production = 1
	_inverse[1] = "Production"
	PlaceableCategories.Defense = 2
	_inverse[2] = "Defense"
	PlaceableCategories.Lighting = 3
	_inverse[3] = "Lighting"
	PlaceableCategories.Misc = 4
	_inverse[4] = "Misc"
end
return {
	PlaceableConfig = PlaceableConfig,
	PlaceableCategories = PlaceableCategories,
}
