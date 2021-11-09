-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Placeable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable").Placeable
local PlaceableConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable-config").PlaceableConfig
local BellaEnum = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "enums", "bella-enum").BellaEnum
local defaultPlaceableConfig = PlaceableConfig.new(10, "Placeable", "A generic placeable.", 5, BellaEnum.placeableCategories:TryParse("misc"))
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
		local fullConfigFolder = model:FindFirstChildWhichIsA("Configuration")
		if fullConfigFolder ~= nil and fullConfigFolder:IsA("Configuration") then
			local configFolder = fullConfigFolder:WaitForChild("Placeable")
			if configFolder ~= nil and configFolder:IsA("Configuration") then
				local placeableConfig = PlaceableConfig.new(defaultPlaceableConfig.cost, defaultPlaceableConfig.name, defaultPlaceableConfig.description, defaultPlaceableConfig.maxOfThisAllowed, defaultPlaceableConfig.placeableCategory)
				local categoryV = configFolder:FindFirstChild("Category")
				local nameV = configFolder:FindFirstChild("Name")
				local descriptionV = configFolder:FindFirstChild("Description")
				local maxAllowedV = configFolder:FindFirstChild("MaxAllowed")
				local costV = configFolder:FindFirstChild("Cost")
				local _result
				if (categoryV ~= nil and categoryV:IsA("StringValue")) then
					_result = BellaEnum.placeableCategories:TryParse(categoryV.Value)
				else
					_result = nil
				end
				placeableConfig.placeableCategory = _result
				placeableConfig.name = (nameV ~= nil and nameV:IsA("StringValue")) and nameV.Value or "unknown"
				placeableConfig.description = (descriptionV ~= nil and descriptionV:IsA("StringValue")) and descriptionV.Value or "unknown"
				placeableConfig.maxOfThisAllowed = (maxAllowedV ~= nil and maxAllowedV:IsA("NumberValue")) and maxAllowedV.Value or 0
				placeableConfig.cost = (costV ~= nil and costV:IsA("NumberValue")) and costV.Value or 0
				return placeableConfig
			end
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
					local thisPlaceable = Placeable.new(hypotheticalOwner, thisModel, parsedConfig, tick())
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
					return thisP
				end
			end
		end
	end
end
return {
	NodeHelper = NodeHelper,
}
