-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local PlayerCard = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player-card").PlayerCard
local PlayerState = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player-state").PlayerState
local Database = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "database").Database
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local APIArgs = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-args").APIArgs
local PlayerSettings = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player-settings").PlayerSettings
local PlayerKeySettings = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player-key-settings").PlayerKeySettings
local playerDirectory = Instance.new("Folder", game:GetService("ReplicatedStorage"))
playerDirectory.Name = "player"
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
	local _exitType, _returns = TS.try(function()
		local upperServiceName = _upperServiceName
		local lowerServiceName = _lowerServiceName
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
				local _player = player
				-- ▼ Array.push ▼
				plrs[#plrs + 1] = _player
				-- ▲ Array.push ▲
			end
			local _condition = player
			if _condition == nil then
				_condition = PlayerState.new(user.UserId, 500, PlayerCard.new(0, "new"), PlayerSettings.new(PlayerKeySettings.new(Enum.KeyCode.E, Enum.KeyCode.G)))
			end
			player = _condition
			local apiArgs = APIArgs.new(player, clientsArgs)
			local result = currentTarget:Invoke(apiArgs)
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
					if plrs[i + 1].userId == player.userId then
						plrs[i + 1] = player
						break
					end
				end
			end
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
	local database = databaseStructure.database
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
				database:SetAsync(tostring(user.UserId), plrs[i + 1])
				break
			end
		end
	end
end)
