-- Compiled with roblox-ts v1.2.7
local Node
do
	Node = setmetatable({}, {
		__tostring = function()
			return "Node"
		end,
	})
	Node.__index = Node
	function Node.new(...)
		local self = setmetatable({}, Node)
		return self:constructor(...) or self
	end
	function Node:constructor(owner, position, config)
		self.owner = owner
		self.position = position
		self.config = config
		self.activePlaceables = {}
	end
end
return {
	Node = Node,
}
