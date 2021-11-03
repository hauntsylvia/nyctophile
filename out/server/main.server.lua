-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local PlayerCard = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "playerCard").PlayerCard
local PlayerState = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "playerState").PlayerState
local Database = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "database").Database
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "apiResult").APIResult
local APIArgs = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "apiArgs").APIArgs
local apiDirectory = Instance.new("Folder", game:GetService("ReplicatedStorage"))
apiDirectory.Name = "api"
local apiHandler = Instance.new("RemoteFunction", apiDirectory)
apiHandler.Name = "func"
local databaseStructure = Database.new()
local plrs = {}
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
	local upperServiceName = _upperServiceName
	local lowerServiceName = _lowerServiceName
	local apiLowerServices = apiDirectory:FindFirstChild(upperServiceName)
	local currentTarget = GetEquatingBindableFunction(upperServiceName, lowerServiceName)
	if currentTarget ~= nil then
		local database = databaseStructure.database
		local player
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #plrs) then
					break
				end
				if plrs[i + 1].userId == user.UserId then
					player = plrs[i + 1]
					break
				end
			end
		end
		if player == nil then
			local _condition = player
			if _condition == nil then
				_condition = database:GetAsync(tostring(user.UserId))
			end
			player = _condition
			local _arg0 = #plrs
			local _player = player
			table.insert(plrs, _arg0 + 1, _player)
		end
		local _condition = player
		if _condition == nil then
			_condition = PlayerState.new(user.UserId, 500, PlayerCard.new(0, "new"))
		end
		player = _condition
		local apiArgs = APIArgs.new(player, clientsArgs)
		local result = currentTarget:Invoke(apiArgs)
		database:SetAsync(tostring(user.UserId), player)
		return result
	else
		return APIResult.new(nil, "Service not found.")
	end
end
