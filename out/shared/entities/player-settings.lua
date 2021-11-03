-- Compiled with roblox-ts v1.2.7
local PlayerSettings
do
	PlayerSettings = setmetatable({}, {
		__tostring = function()
			return "PlayerSettings"
		end,
	})
	PlayerSettings.__index = PlayerSettings
	function PlayerSettings.new(...)
		local self = setmetatable({}, PlayerSettings)
		return self:constructor(...) or self
	end
	function PlayerSettings:constructor(playerKeys)
		self.playerKeys = playerKeys
	end
end
return {
	PlayerSettings = PlayerSettings,
}
