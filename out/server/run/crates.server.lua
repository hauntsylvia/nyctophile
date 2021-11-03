-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local InteractableHelper = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "interactable-helper").InteractableHelper
local Interactable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "interactable").Interactable
local InteractableConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "interactable-config").InteractableConfig
local h = InteractableHelper.new()
local allCrates = game:GetService("Workspace"):WaitForChild("Crates"):GetChildren()
do
	local i = 0
	local _shouldIncrement = false
	while true do
		if _shouldIncrement then
			i += 1
		else
			_shouldIncrement = true
		end
		if not (i < #allCrates) then
			break
		end
		local bp = (allCrates[i + 1]).PrimaryPart
		if bp ~= nil then
			local thisInteractable = Interactable.new(bp, 0, InteractableConfig.new("Crate", "A generic crate containing misc. items.", 24))
			h:RegisterInteractable(thisInteractable)
		else
			print("no primary part for this interactable crate")
		end
	end
end
