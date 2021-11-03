-- Compiled with roblox-ts v1.2.7
local InteractableConfig
do
	InteractableConfig = setmetatable({}, {
		__tostring = function()
			return "InteractableConfig"
		end,
	})
	InteractableConfig.__index = InteractableConfig
	function InteractableConfig.new(...)
		local self = setmetatable({}, InteractableConfig)
		return self:constructor(...) or self
	end
	function InteractableConfig:constructor(name, description, range)
		self.name = name
		self.description = description
		self.range = range
	end
end
return {
	InteractableConfig = InteractableConfig,
}
