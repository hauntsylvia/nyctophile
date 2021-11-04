-- Compiled with roblox-ts v1.2.7
local allInteractablesRegistered = {}
local InteractableHelper
do
	InteractableHelper = setmetatable({}, {
		__tostring = function()
			return "InteractableHelper"
		end,
	})
	InteractableHelper.__index = InteractableHelper
	function InteractableHelper.new(...)
		local self = setmetatable({}, InteractableHelper)
		return self:constructor(...) or self
	end
	function InteractableHelper:constructor()
	end
	function InteractableHelper:GetInteractablesOfPlayerByUserId(userId)
		local arrayRes = {}
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #allInteractablesRegistered) then
					break
				end
				if allInteractablesRegistered[i + 1].attachedPlayerUserId == userId or allInteractablesRegistered[i + 1].attachedPlayerUserId <= 0 then
					local _arrayRes = arrayRes
					local _arg0 = allInteractablesRegistered[i + 1]
					-- ▼ Array.push ▼
					_arrayRes[#_arrayRes + 1] = _arg0
					-- ▲ Array.push ▲
				end
			end
		end
		return arrayRes
	end
	function InteractableHelper:GetInteractablesOfPlayerByState(player)
		return self:GetInteractablesOfPlayerByUserId(player.userId)
	end
	function InteractableHelper:RegisterInteractable(interactable)
		-- ▼ Array.push ▼
		allInteractablesRegistered[#allInteractablesRegistered + 1] = interactable
		-- ▲ Array.push ▲
	end
end
return {
	InteractableHelper = InteractableHelper,
}
