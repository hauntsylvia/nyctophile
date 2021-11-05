-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local APIRegister = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "api-register").APIRegister
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local InteractableHelper = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "interactable-helper").InteractableHelper
local thisService = APIRegister.new("interactables")
local h = InteractableHelper.new()
local function GetCurrent(args)
	local arrayOfInteractables = h:GetInteractablesOfPlayerByUserId(args.caller.userId)
	return APIResult.new(arrayOfInteractables, "Succesfully returned all user's interactables.", true)
end
thisService:RegisterNewLowerService("getcurrent").OnInvoke = GetCurrent
