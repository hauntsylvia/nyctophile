-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Placeable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable").Placeable
local PlaceableConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable-config").PlaceableConfig
local defaultPlaceableConfig = PlaceableConfig.new(10, "Placeable", "A generic placeable.", 5)
local NodeHelper
do
	NodeHelper = setmetatable({}, {
		__tostring = function()
			return "NodeHelper"
		end,
	})
	NodeHelper.__index = NodeHelper
	function NodeHelper.new(...)
		local self = setmetatable({}, NodeHelper)
		return self:constructor(...) or self
	end
	function NodeHelper:constructor(buildablesDirectory)
		self.buildablesDirectory = buildablesDirectory
	end
	function NodeHelper:GetRealPlaceableConfigFromPhysicalConfig(model)
		local configFolder = model:FindFirstChildWhichIsA("Configuration")
		if configFolder ~= nil and configFolder:IsA("Configuration") then
			local placeableConfig = PlaceableConfig.new(0, "", "", 0)
			placeableConfig.cost = (configFolder:FindFirstChild("Cost")).Value
			placeableConfig.maxOfThisAllowed = (configFolder:FindFirstChild("MaxAllowed")).Value
			placeableConfig.description = (configFolder:FindFirstChild("Description")).Value
			placeableConfig.name = (configFolder:FindFirstChild("Name")).Value
			return placeableConfig
		end
		return defaultPlaceableConfig
	end
	function NodeHelper:GetAllPossiblePlaceables(hypotheticalOwner)
		local ch = self.buildablesDirectory:GetChildren()
		local p = {}
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #ch) then
					break
				end
				local thisModel = ch[i + 1]
				if thisModel:IsA("Model") and thisModel.PrimaryPart ~= nil then
					local parsedConfig = self:GetRealPlaceableConfigFromPhysicalConfig(thisModel)
					local thisPlaceable = Placeable.new(hypotheticalOwner, thisModel, parsedConfig)
					local _p = p
					local _thisPlaceable = thisPlaceable
					-- ▼ Array.push ▼
					_p[#_p + 1] = _thisPlaceable
					-- ▲ Array.push ▲
				elseif thisModel:IsA("Model") and thisModel.PrimaryPart == nil then
					print("Placeable " .. (thisModel:GetFullName() .. " does not have PrimaryPart set."))
				end
			end
		end
		return p
	end
	function NodeHelper:GetRealFromUntrustedPlaceable(untrusted)
		local allP = self:GetAllPossiblePlaceables(untrusted.ownerNode)
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #allP) then
					break
				end
				local thisP = allP[i + 1]
				if thisP.config.name == untrusted.config.name then
					thisP.attachedModel = thisP.attachedModel:Clone()
					thisP.attachedModel.Name = "_"
					print(thisP.config.name)
					return thisP
				end
			end
		end
	end
end
return {
	NodeHelper = NodeHelper,
}
