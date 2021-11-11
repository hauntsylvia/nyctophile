-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local APIRegister = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "api-register").APIRegister
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local thisService = APIRegister.new("users")
local function GetSelf(args)
	print("get self")
	return APIResult.new(args.caller, "", true)
end
local function GetPlayerRotations(args)
end
local function UpdatePlayerRotations(args)
end
thisService:RegisterNewLowerService("me").OnInvoke = GetSelf
thisService:RegisterNewLowerService("getplayerrotations").OnInvoke = GetSelf
