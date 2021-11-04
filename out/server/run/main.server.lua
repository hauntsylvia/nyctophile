-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Database = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "database").Database
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local APIArgs = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-args").APIArgs
local playerDirectory = Instance.new("Folder", game:GetService("ReplicatedStorage"))
playerDirectory.Name = "player"
local apiDirectory = Instance.new("Folder", game:GetService("ReplicatedStorage"))
apiDirectory.Name = "api"
local apiHandler = Instance.new("RemoteFunction", apiDirectory)
apiHandler.Name = "func"
local database = Database.new()
local internalAPIDirectory = Instance.new("Folder", game:GetService("ServerStorage"))
internalAPIDirectory.Name = "api"
local function GetEquatingBindableFunction(upper, lower)
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #internalAPIDirectory:GetChildren()) then
				break
			end
			local folderS = internalAPIDirectory:GetChildren()[i + 1]
			if folderS:IsA("Folder") and string.lower(folderS.Name) == string.lower(upper) then
				do
					local x = 0
					local _shouldIncrement_1 = false
					while true do
						if _shouldIncrement_1 then
							x += 1
						else
							_shouldIncrement_1 = true
						end
						if not (x < #folderS:GetChildren()) then
							break
						end
						local f = folderS:GetChildren()[x + 1]
						if f:IsA("BindableFunction") and string.lower(f.Name) == string.lower(lower) then
							return f
						end
					end
				end
			end
		end
	end
end
apiHandler.OnServerInvoke = function(user, _upperServiceName, _lowerServiceName, clientsArgs)
	local _exitType, _returns = TS.try(function()
		local upperServiceName = _upperServiceName
		local lowerServiceName = _lowerServiceName
		local currentTarget = GetEquatingBindableFunction(upperServiceName, lowerServiceName)
		if currentTarget ~= nil then
			local apiArgs = APIArgs.new(database:GetPlayerState(user), clientsArgs)
			local result = currentTarget:Invoke(apiArgs)
			return TS.TRY_RETURN, { result }
		else
			return TS.TRY_RETURN, { APIResult.new(nil, "Service not found.") }
		end
	end, function()
		return TS.TRY_RETURN, { APIResult.new(nil, "Malformed client data or internal server failure.") }
	end)
	if _exitType then
		return unpack(_returns)
	end
end
game:GetService("Players").PlayerRemoving:Connect(function(user)
	database:SavePlayerState(database:GetPlayerState(user))
end)
