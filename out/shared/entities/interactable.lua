-- Compiled with roblox-ts v1.2.7
local Interactable
do
	Interactable = setmetatable({}, {
		__tostring = function()
			return "Interactable"
		end,
	})
	Interactable.__index = Interactable
	function Interactable.new(...)
		local self = setmetatable({}, Interactable)
		return self:constructor(...) or self
	end
	function Interactable:constructor(attachedPart, attachedPlayerUserId, config, remote)
		self.attachedPart = attachedPart
		self.attachedPlayerUserId = attachedPlayerUserId
		self.config = config
		self.remote = remote
	end
end
return {
	Interactable = Interactable,
}
