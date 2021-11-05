-- Compiled with roblox-ts v1.2.7
local Placeable
do
	Placeable = setmetatable({}, {
		__tostring = function()
			return "Placeable"
		end,
	})
	Placeable.__index = Placeable
	function Placeable.new(...)
		local self = setmetatable({}, Placeable)
		return self:constructor(...) or self
	end
	function Placeable:constructor(ownerNode, attachedModel, config)
		self.ownerNode = ownerNode
		self.attachedModel = attachedModel
		self.config = config
	end
end
return {
	Placeable = Placeable,
}
