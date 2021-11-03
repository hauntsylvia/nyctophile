-- Compiled with roblox-ts v1.2.7
local PlayerCard
do
	PlayerCard = setmetatable({}, {
		__tostring = function()
			return "PlayerCard"
		end,
	})
	PlayerCard.__index = PlayerCard
	function PlayerCard.new(...)
		local self = setmetatable({}, PlayerCard)
		return self:constructor(...) or self
	end
	function PlayerCard:constructor(assetId, phrase)
		self.assetId = assetId
		self.phrase = phrase
	end
end
return {
	PlayerCard = PlayerCard,
}
