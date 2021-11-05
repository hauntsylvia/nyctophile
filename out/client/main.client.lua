-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local BuildSystem = TS.import(script, script.Parent, "modules", "helpers", "build-system").BuildSystem
local Draw = TS.import(script, script.Parent, "modules", "helpers", "interactable-draw").Draw
local Client = TS.import(script, script.Parent, "modules", "net", "lib").Client
local lib = Client.new()
local buildSystem = BuildSystem.new(lib)
local draws = {}
local plr = game:GetService("Players").LocalPlayer
local me = lib:GetMe()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local function EvaluateInteractables()
	local ints = lib:GetInteractables()
	if ints ~= nil then
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #ints) then
					break
				end
				local canPush = true
				do
					local x = 0
					local _shouldIncrement_1 = false
					while true do
						if _shouldIncrement_1 then
							x += 1
						else
							_shouldIncrement_1 = true
						end
						if not (x < #draws) then
							break
						end
						if draws[x + 1].int.attachedPart == ints[i + 1].attachedPart then
							canPush = false
							break
						end
					end
				end
				if canPush then
					local _draws = draws
					local _draw = Draw.new(ints[i + 1])
					-- ▼ Array.push ▼
					_draws[#_draws + 1] = _draw
					-- ▲ Array.push ▲
				end
			end
		end
	else
		print("ints undefined")
	end
end
local closestDraw = nil
runService.Heartbeat:Connect(function(deltaTime)
	if #draws > 0 then
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #draws) then
					break
				end
				if closestDraw ~= nil then
					local int = draws[i + 1]
					local distanceOfCurrentIteration = int:GetDistanceFromPlayer(plr)
					local currentDistance = closestDraw:GetDistanceFromPlayer(plr)
					local inRange = int:IsInRange(plr)
					if (distanceOfCurrentIteration < currentDistance) and inRange then
						closestDraw:Disable()
						closestDraw = draws[i + 1]
					end
				else
					closestDraw = draws[i + 1]
				end
			end
		end
		if closestDraw ~= nil and not closestDraw.isEnabled then
			closestDraw:Enable(true, plr)
		end
	end
end)
userInputService.InputEnded:Connect(function(inputObject, isProcessed)
	if not isProcessed and me ~= nil then
		local keySettings = me.playerSettings.playerKeys
		if inputObject.KeyCode.Name == keySettings.interactKey and (closestDraw ~= nil and closestDraw:IsInRange(plr)) then
			closestDraw:Interact()
		elseif inputObject.KeyCode.Name == keySettings.buildSystemKey then
			local selfNode = lib:GetNode()
			if not buildSystem.isEnabled then
				if selfNode ~= nil then
					local larry = lib:GetAllPossiblePlaceables()
					if larry ~= nil then
						local thisModel = larry[1].attachedModel:Clone()
						thisModel.Parent = game:GetService("Workspace")
						buildSystem:Enable(thisModel, Enum.UserInputType.MouseButton1, inputObject.KeyCode, false, selfNode)
					end
				else
					local nodeModel = Instance.new("Model", game:GetService("Workspace"))
					nodeModel.Name = "temp-node-model"
					local nodePart = Instance.new("Part", nodeModel)
					nodePart.Name = "temp-node-part"
					nodeModel.PrimaryPart = nodePart
					buildSystem:Enable(nodeModel, Enum.UserInputType.MouseButton1, inputObject.KeyCode, false)
				end
			else
				buildSystem:Disable()
			end
		end
	end
end)
EvaluateInteractables()
while { wait(30) } do
	EvaluateInteractables()
end
