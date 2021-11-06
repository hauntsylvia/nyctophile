-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local APIRegister = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "api-register").APIRegister
local APIResult = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "api", "api-result").APIResult
local Node = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node").Node
local NodeConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node-config").NodeConfig
local NodeHelper = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "helpers", "node-helper").NodeHelper
local SetPlayerState = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "lib", "player-state-consistency").SetPlayerState
local helper
local dir = game:GetService("ReplicatedStorage"):FindFirstChild("Placeables")
if dir == nil then
	local dir = Instance.new("Folder", game:GetService("ReplicatedStorage"))
	dir.Name = "Placeables"
	helper = NodeHelper.new(dir)
else
	helper = NodeHelper.new(dir)
end
local globalConfig = NodeConfig.new(100, {})
local thisService = APIRegister.new("nodes")
local nodes = {}
local tweenService = game:GetService("TweenService")
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
local function Internal_CustomizePlaceable(placeable, color, mat, tween)
	local _condition = tween
	if _condition == nil then
		_condition = true
	end
	tween = _condition
	local custParts = placeable:GetCustomizeableParts()
	local _custParts = custParts
	local _arg0 = function(part)
		if color ~= nil then
			if tween then
				tweenService:Create(part, TweenInfo.new(0.4), {
					Color = color,
				}):Play()
			else
				part.Color = color
			end
		end
		if mat ~= nil then
			part.Material = mat
		end
	end
	-- ▼ ReadonlyArray.forEach ▼
	for _k, _v in ipairs(_custParts) do
		_arg0(_v, _k - 1, _custParts)
	end
	-- ▲ ReadonlyArray.forEach ▲
end
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
				if (_position - _askingPosition).Magnitude <= nodes[i + 1].config.radius * 2 then
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
local function CreatePlaceable(args)
	local reqPlayersNode = GetSelfNode(args)
	if reqPlayersNode.success then
		local usersArgs = args.clientArgs
		local playersNode = reqPlayersNode.result
		local requestedPlaceable = (args.clientArgs)[1]
		local requestedPosition = (args.clientArgs)[2]
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
					local nodeCanUse
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
							local r = nodes[i + 1].config.radius
							local _position = requestedPosition.Position
							local _position_1 = nodes[i + 1].position
							local isInNode = (_position - _position_1).Magnitude < r
							local _trustedUsers = nodes[i + 1].config.trustedUsers
							local _arg0_1 = function(x)
								return x == args.caller.userId
							end
							-- ▼ ReadonlyArray.filter ▼
							local _newValue_1 = {}
							local _length_1 = 0
							for _k, _v in ipairs(_trustedUsers) do
								if _arg0_1(_v, _k - 1, _trustedUsers) == true then
									_length_1 += 1
									_newValue_1[_length_1] = _v
								end
							end
							-- ▲ ReadonlyArray.filter ▲
							local _condition = #_newValue_1 > 0
							if not _condition then
								_condition = nodes[i + 1].owner == args.caller.userId
							end
							local canUseNode = _condition
							-- if node isnt players node and doesnt trust the player
							if nodes[i + 1].owner ~= args.caller.userId and (canUseNode and isInNode) then
								return APIResult.new(nil, "Invalid location: must be placed within a trusted node.", false)
							elseif canUseNode and isInNode then
								nodeCanUse = nodes[i + 1]
								break
							end
						end
					end
					if nodeCanUse ~= nil then
						print(args.caller.ashlin)
						args.caller.ashlin -= realPlaceable.config.cost
						print(args.caller.ashlin)
						local _arg0_1 = usersArgs[3]
						local color = typeof(_arg0_1) ~= nil and usersArgs[3] or nil
						local _arg0_2 = usersArgs[4]
						local material = typeof(_arg0_2) ~= nil and usersArgs[4] or nil
						Internal_CustomizePlaceable(realPlaceable, color, material, false)
						realPlaceable.attachedModel.Parent = game:GetService("Workspace")
						realPlaceable.attachedModel:SetPrimaryPartCFrame(requestedPosition)
						local _activePlaceables_1 = playersNode.activePlaceables
						local _realPlaceable = realPlaceable
						-- ▼ Array.push ▼
						_activePlaceables_1[#_activePlaceables_1 + 1] = _realPlaceable
						-- ▲ Array.push ▲
						SetPlayerState(args.caller)
						return APIResult.new(realPlaceable, "Successfully placed.", true)
					else
						return APIResult.new(nil, "Invalid location: no node present.", false)
					end
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
		local all = helper:GetAllPossiblePlaceables(reqPlayersNode.result)
		return APIResult.new(all, "Successfully fetched all possible placeables.", true)
	end
	return reqPlayersNode
end
local function CustomizeExistingPlaceable(args)
	local reqPlayersNode = GetSelfNode(args)
	local usersArgs = args.clientArgs
	local requestedPlaceableId = usersArgs[1]
	local _arg0 = usersArgs[2]
	local color = typeof(_arg0) ~= nil and usersArgs[2] or nil
	local _arg0_1 = usersArgs[3]
	local material = typeof(_arg0_1) ~= nil and usersArgs[3] or nil
	local thisPlaceable
	local playersNode = reqPlayersNode.result
	if playersNode ~= nil then
		local p = playersNode
		local _activePlaceables = p.activePlaceables
		local _arg0_2 = function(x)
			return x.id == requestedPlaceableId
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_activePlaceables) do
			if _arg0_2(_v, _k - 1, _activePlaceables) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local placeableCustomizing = _newValue
		thisPlaceable = #placeableCustomizing > 0 and placeableCustomizing[1] or nil
	end
	if thisPlaceable == nil then
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
				local _trustedUsers = nodes[i + 1].config.trustedUsers
				local _arg0_2 = function(x)
					return x == args.caller.userId
				end
				-- ▼ ReadonlyArray.filter ▼
				local _newValue = {}
				local _length = 0
				for _k, _v in ipairs(_trustedUsers) do
					if _arg0_2(_v, _k - 1, _trustedUsers) == true then
						_length += 1
						_newValue[_length] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				if #_newValue > 0 then
					local _activePlaceables = nodes[i + 1].activePlaceables
					local _arg0_3 = function(x)
						return x.id == requestedPlaceableId
					end
					-- ▼ ReadonlyArray.filter ▼
					local _newValue_1 = {}
					local _length_1 = 0
					for _k, _v in ipairs(_activePlaceables) do
						if _arg0_3(_v, _k - 1, _activePlaceables) == true then
							_length_1 += 1
							_newValue_1[_length_1] = _v
						end
					end
					-- ▲ ReadonlyArray.filter ▲
					local a = _newValue_1
					if #a > 0 then
						thisPlaceable = a[1]
					end
				end
			end
		end
	end
	if thisPlaceable ~= nil then
		Internal_CustomizePlaceable(thisPlaceable, color, material)
		return APIResult.new(thisPlaceable, "Successfully customized placeable.", true)
	else
		return APIResult.new(nil, "No matching placeable found.", false)
	end
end
thisService:RegisterNewLowerService("create").OnInvoke = PlaceNode
thisService:RegisterNewLowerService("all").OnInvoke = GetAllNodes
thisService:RegisterNewLowerService("me").OnInvoke = GetSelfNode
thisService:RegisterNewLowerService("placeables.create").OnInvoke = CreatePlaceable
thisService:RegisterNewLowerService("placeables.all").OnInvoke = GetAllPlaceables
thisService:RegisterNewLowerService("placeables.customize").OnInvoke = CustomizeExistingPlaceable
