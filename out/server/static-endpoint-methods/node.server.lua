-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local APIRegister = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "api-register").APIRegister
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local Node = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node").Node
local NodeConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node-config").NodeConfig
local NodeHelper = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "node-helper").NodeHelper
local thisService = APIRegister.new("nodes")
local nodes = {}
local dir = Instance.new("Folder", game:GetService("ReplicatedStorage"))
dir.Name = "Placeables"
local helper = NodeHelper.new(dir)
local globalConfig = NodeConfig.new(100, {})
game:GetService("Players").PlayerRemoving:Connect(function(user)
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #nodes) then
				break
			end
			if user.UserId == nodes[i + 1].owner then
				local _i = i
				local nodeRemoving = table.remove(nodes, _i + 1)
				if nodeRemoving ~= nil then
					print("node at " .. (tostring(nodeRemoving.position) .. " removed from global array"))
				end
				break
			end
		end
	end
end)
local function PlaceNode(args)
	local askingPosition = args.clientArgs
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #nodes) then
				break
			end
			if nodes[i + 1].owner == args.caller.userId then
				return APIResult.new(nil, "Your node has already been placed.", false)
			else
				local _position = nodes[i + 1].position
				local _askingPosition = askingPosition
				if (_position - _askingPosition).Magnitude <= nodes[i + 1].config.radius then
					return APIResult.new(nil, "Can not place a node inside another player's node.", false)
				end
			end
		end
	end
	local newNode = Node.new(args.caller.userId, askingPosition, globalConfig)
	local _newNode = newNode
	-- ▼ Array.push ▼
	nodes[#nodes + 1] = _newNode
	-- ▲ Array.push ▲
	return APIResult.new(newNode, "Node successfully created and placed.", true)
end
local function GetAllNodes(args)
	return APIResult.new(nodes, "Successfully grabbed all other nodes in game.", true)
end
local function GetSelfNode(args)
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #nodes) then
				break
			end
			if nodes[i + 1].owner == args.caller.userId then
				return APIResult.new(nodes[i + 1], "Successfully fetched your node.", true)
			end
		end
	end
	return APIResult.new(nil, "Node not found.", false)
end
local function CreateStructure(args)
	local reqPlayersNode = GetSelfNode(args)
	if reqPlayersNode.success then
		local playersNode = reqPlayersNode.result
		local requestedPlaceable = args.clientArgs
		local realPlaceable = helper:GetRealFromUntrustedPlaceable(requestedPlaceable)
		if realPlaceable ~= nil then
			if args.caller.ashlin >= realPlaceable.config.cost then
				local numberOfThisAlreadyPlaced = 0
				local _activePlaceables = playersNode.activePlaceables
				local _arg0 = function(x)
					local _exp = x.config.name
					local _result = realPlaceable
					if _result ~= nil then
						_result = _result.config.name
					end
					return _exp == _result
				end
				-- ▼ ReadonlyArray.filter ▼
				local _newValue = {}
				local _length = 0
				for _k, _v in ipairs(_activePlaceables) do
					if _arg0(_v, _k - 1, _activePlaceables) == true then
						_length += 1
						_newValue[_length] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				numberOfThisAlreadyPlaced = #_newValue
				if numberOfThisAlreadyPlaced < realPlaceable.config.maxOfThisAllowed then
					args.caller.ashlin -= realPlaceable.config.cost
					return APIResult.new(realPlaceable, "Successfully placed.", true)
				else
					return APIResult.new(nil, "Maximum number of this placeable reached.", false)
				end
			else
				return APIResult.new(nil, "You do not have enough ashlin to build this.", false)
			end
		else
			return APIResult.new(nil, "No real placeable equivalent found.", false)
		end
	else
		return reqPlayersNode
	end
end
local function GetAllPlaceables(args)
	local reqPlayersNode = GetSelfNode(args)
	if reqPlayersNode.success then
		return APIResult.new(helper:GetAllPossiblePlaceables(reqPlayersNode.result), "Successfully fetched all possible placeables.", true)
	end
	return reqPlayersNode
end
thisService:RegisterNewLowerService("create").OnInvoke = PlaceNode
thisService:RegisterNewLowerService("all").OnInvoke = GetAllNodes
thisService:RegisterNewLowerService("me").OnInvoke = GetSelfNode
thisService:RegisterNewLowerService("placeables.create").OnInvoke = CreateStructure
thisService:RegisterNewLowerService("placeables.all").OnInvoke = GetAllPlaceables
