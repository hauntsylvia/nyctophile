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
	function Placeable:constructor(ownerNode, attachedModel, config, id)
		self.ownerNode = ownerNode
		self.attachedModel = attachedModel
		self.config = config
		self.id = id
	end
	function Placeable:GetCustomizeableParts()
		local toReturn = {}
		local d = self.attachedModel:GetDescendants()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #d) then
					break
				end
				local thisDescendant = d[i + 1]
				if thisDescendant:IsA("Configuration") and thisDescendant.Parent ~= self.attachedModel then
					if thisDescendant.Parent ~= nil then
						local theseChildren = thisDescendant.Parent:GetChildren()
						do
							local childrenOf = 0
							local _shouldIncrement_1 = false
							while true do
								if _shouldIncrement_1 then
									childrenOf += 1
								else
									_shouldIncrement_1 = true
								end
								if not (childrenOf < #theseChildren) then
									break
								end
								local thisChild = theseChildren[childrenOf + 1]
								if thisChild:IsA("BasePart") then
									local _toReturn = toReturn
									local _thisChild = thisChild
									-- ▼ Array.push ▼
									_toReturn[#_toReturn + 1] = _thisChild
									-- ▲ Array.push ▲
								end
							end
						end
					end
				end
			end
		end
		return toReturn
	end
end
return {
	Placeable = Placeable,
}
