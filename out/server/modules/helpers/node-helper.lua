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
		local configFolder = model:FindFirstChild("config")
		if configFolder ~= nil and configFolder:IsA("Configuration") then
			local placeableConfig = defaultPlaceableConfig
			local module = configFolder:FindFirstChildWhichIsA("ModuleScript")
			if module ~= nil then
				local _condition = (require(module))
				if _condition == nil then
					_condition = defaultPlaceableConfig
				end
				placeableConfig = _condition
				return placeableConfig
			end
		end
		return defaultPlaceableConfig
	end
	function NodeHelper:GetAllPossiblePlaceables(hypotheticalOwner)
		local placeables = {}
		local ch = self.buildablesDirectory:GetChildren()
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
					local _placeables = placeables
					local _placeable = Placeable.new(hypotheticalOwner, thisModel, self:GetRealPlaceableConfigFromPhysicalConfig(thisModel))
					-- ▼ Array.push ▼
					_placeables[#_placeables + 1] = _placeable
					-- ▲ Array.push ▲
				end
			end
		end
		return placeables
	end
	function NodeHelper:GetRealFromUntrustedPlaceable(placeable)
		local allP = self:GetAllPossiblePlaceables(placeable.ownerNode)
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
				if thisP.attachedModel == placeable.attachedModel then
					return thisP
				end
			end
		end
	end
end
return {
	NodeHelper = NodeHelper,
}
