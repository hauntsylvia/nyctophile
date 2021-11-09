-- Compiled with roblox-ts v1.2.7
local BellaMainEnum
do
	BellaMainEnum = setmetatable({}, {
		__tostring = function()
			return "BellaMainEnum"
		end,
	})
	BellaMainEnum.__index = BellaMainEnum
	function BellaMainEnum.new(...)
		local self = setmetatable({}, BellaMainEnum)
		return self:constructor(...) or self
	end
	function BellaMainEnum:constructor(enums)
		self.enums = enums
	end
	function BellaMainEnum:GetEnums()
		return self.enums
	end
	function BellaMainEnum:TryParse(name)
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.enums) then
					break
				end
				if string.lower(self.enums[i + 1].name) == string.lower(name) then
					return self.enums[i + 1]
				end
			end
		end
	end
end
local BellaEnumValue
do
	BellaEnumValue = setmetatable({}, {
		__tostring = function()
			return "BellaEnumValue"
		end,
	})
	BellaEnumValue.__index = BellaEnumValue
	function BellaEnumValue.new(...)
		local self = setmetatable({}, BellaEnumValue)
		return self:constructor(...) or self
	end
	function BellaEnumValue:constructor(name)
		self.name = name
	end
end
local BellaEnum
do
	BellaEnum = setmetatable({}, {
		__tostring = function()
			return "BellaEnum"
		end,
	})
	BellaEnum.__index = BellaEnum
	function BellaEnum.new(...)
		local self = setmetatable({}, BellaEnum)
		return self:constructor(...) or self
	end
	function BellaEnum:constructor()
	end
	BellaEnum.placeableCategories = BellaMainEnum.new({ BellaEnumValue.new("Furniture"), BellaEnumValue.new("Production"), BellaEnumValue.new("Defense"), BellaEnumValue.new("Lighting"), BellaEnumValue.new("Misc") })
end
return {
	BellaEnumValue = BellaEnumValue,
	BellaEnum = BellaEnum,
}
