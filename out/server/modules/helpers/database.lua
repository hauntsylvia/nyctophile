-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local PlayerCard = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player", "player-card").PlayerCard
local PlayerInventory = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player", "player-inventory").PlayerInventory
local PlayerKeySettings = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player", "player-key-settings").PlayerKeySettings
local PlayerSettings = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player", "player-settings").PlayerSettings
local PlayerState = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "player", "player-state").PlayerState
local players = {}
local Database
do
	Database = setmetatable({}, {
		__tostring = function()
			return "Database"
		end,
	})
	Database.__index = Database
	function Database.new(...)
		local self = setmetatable({}, Database)
		return self:constructor(...) or self
	end
	function Database:constructor(newName)
		local _condition = newName
		if _condition == nil then
			_condition = "11-02-2021.A.1"
		end
		local name = _condition
		self.database = game:GetService("DataStoreService"):GetDataStore(name)
		self.cache = {}
	end
	function Database:GetObject(key, cache)
		local _condition = cache
		if _condition == nil then
			_condition = true
		end
		cache = _condition
		if cache and self.cache[key] ~= nil then
			return self.cache[key]
		end
		return self.database:GetAsync(key)
	end
	function Database:SaveObject(key, value)
		self.cache[key] = value
		self.database:SetAsync(key, value)
	end
	function Database:SetPlayerState(plr)
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #players) then
					break
				end
				if players[i + 1].userId == plr.userId then
					local _i = i
					table.remove(players, _i + 1)
				end
			end
		end
		-- ▼ Array.push ▼
		players[#players + 1] = plr
		-- ▲ Array.push ▲
	end
	function Database:GetPlayerState(user)
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
				if not (i < #players) then
					break
				end
				if players[i + 1].userId == user.UserId then
					player = players[i + 1]
					break
				end
			end
		end
		if player == nil then
			local _condition = player
			if _condition == nil then
				_condition = self.database:GetAsync(tostring(user.UserId))
			end
			player = _condition
			if player == nil then
				player = PlayerState.new(user.UserId, 25000, PlayerCard.new(0, "new"), PlayerSettings.new(PlayerKeySettings.new("E", "G", "U")), PlayerInventory.new(5))
			end
			local _player = player
			-- ▼ Array.push ▼
			players[#players + 1] = _player
			-- ▲ Array.push ▲
		end
		return player
	end
	function Database:SavePlayerState(player)
		local d = self.database
		d:SetAsync(tostring(player.userId), player)
	end
end
return {
	Database = Database,
}
