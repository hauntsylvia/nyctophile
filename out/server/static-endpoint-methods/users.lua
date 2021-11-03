-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Database = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "database").Database
local function GetUserById(userId)
	local databaseNow = Database.new()
	return databaseNow.database:GetAsync(tostring(userId))
end
return nil
