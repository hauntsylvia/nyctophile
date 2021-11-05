-- Compiled with roblox-ts v1.2.7
local NodeConfig
do
	NodeConfig = setmetatable({}, {
		__tostring = function()
			return "NodeConfig"
		end,
	})
	NodeConfig.__index = NodeConfig
	function NodeConfig.new(...)
		local self = setmetatable({}, NodeConfig)
		return self:constructor(...) or self
	end
	function NodeConfig:constructor(radius, trustedUsers)
		self.radius = radius
		self.trustedUsers = trustedUsers
	end
end
return {
	NodeConfig = NodeConfig,
}
