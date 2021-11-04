-- Compiled with roblox-ts v1.2.7
local PlayerState
do
	PlayerState = setmetatable({}, {
		__tostring = function()
			return "PlayerState"
		end,
	})
	PlayerState.__index = PlayerState
	function PlayerState.new(...)
		local self = setmetatable({}, PlayerState)
		return self:constructor(...) or self
	end
	function PlayerState:constructor(userId, ashlin, playerCard, playerSettings, playerInventory)
		self.userId = userId
		self.ashlin = ashlin
		self.playerCard = playerCard
		self.playerSettings = playerSettings
		self.playerInventory = playerInventory
	end
	function PlayerState:GetAttachedPlayer()
		return game:GetService("Players"):GetPlayerByUserId(self.userId)
	end
end
return {
	PlayerState = PlayerState,
}
