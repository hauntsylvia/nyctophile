-- Compiled with roblox-ts v1.2.7
local PlayerKeySettings
do
	PlayerKeySettings = setmetatable({}, {
		__tostring = function()
			return "PlayerKeySettings"
		end,
	})
	PlayerKeySettings.__index = PlayerKeySettings
	function PlayerKeySettings.new(...)
		local self = setmetatable({}, PlayerKeySettings)
		return self:constructor(...) or self
	end
	function PlayerKeySettings:constructor(interactKey, inventoryKey, buildSystemKey)
		self.interactKey = interactKey
		self.inventoryKey = inventoryKey
		self.buildSystemKey = buildSystemKey
	end
end
return {
	PlayerKeySettings = PlayerKeySettings,
}
