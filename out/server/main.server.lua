-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local PlayerCard = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "playerCard").PlayerCard
local PlayerState = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "playerState").PlayerState
local Database = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "database").Database
local apiDirectory = Instance.new("Folder", game:GetService("ReplicatedStorage"))
apiDirectory.Name = "api"
local apiHandler = Instance.new("RemoteFunction", apiDirectory)
apiHandler.Name = "event"
local databaseStructure = Database.new()
local plrs = {}
apiHandler.OnServerInvoke = function(user, upperServiceName, lowerServiceName, clientsArgs)
	local _exitType, _returns = TS.try(function()
		local serviceDirectory = "./static-endpoint-methods"
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
		player.ashlin -= 5
		database:SetAsync(tostring(user.UserId), player)
		return TS.TRY_RETURN, { player }
	end, function(e)
		print(e)
	end)
	if _exitType then
		return unpack(_returns)
	end
end
