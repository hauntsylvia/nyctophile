-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Database = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "database").Database
local APIRegister = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "api-register").APIRegister
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local NyctoVersion = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "nycto-version").NyctoVersion
local thisService = APIRegister.new("version")
local versionDatabase = Database.new("version_11-10-2021.A.1")
local thisVersion
local preV = versionDatabase:GetObject("v")
if preV ~= nil then
	local v = preV
	v.build += 1
	thisVersion = v
else
	thisVersion = NyctoVersion.new(0, 1, 0, (DateTime.now().UnixTimestamp - os.time({
		year = 2020,
		month = 4,
		day = 15,
	})) / 2)
end
versionDatabase:SaveObject("v", thisVersion)
thisService:RegisterNewLowerService("v").OnInvoke = function(args)
	return APIResult.new(thisVersion, "", true)
end
