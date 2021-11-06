-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Node = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node").Node
local NodeConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node-config").NodeConfig
local Placeable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable").Placeable
local _placeable_config = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable-config")
local PlaceableCategories = _placeable_config.PlaceableCategories
local PlaceableConfig = _placeable_config.PlaceableConfig
local BuildSystem = TS.import(script, script.Parent, "modules", "helpers", "build-system").BuildSystem
local Draw = TS.import(script, script.Parent, "modules", "helpers", "interactable-draw").Draw
local Client = TS.import(script, script.Parent, "modules", "net", "lib").Client
local ColorPicker = TS.import(script, script.Parent, "modules", "ui", "color-picker").ColorPicker
local MaterialPicker = TS.import(script, script.Parent, "modules", "ui", "material-picker").MaterialPicker
local lib = Client.new()
local draws = {}
local plr = game:GetService("Players").LocalPlayer
local me = lib:GetMe()
local node
local buildSystem = BuildSystem.new(lib)
local buildUI = plr:WaitForChild("PlayerGui"):WaitForChild("BuildingsGUI")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
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
local lastColorPicker
local lastMatPicker
userInputService.InputEnded:Connect(function(inputObject, isProcessed)
	if not isProcessed and me ~= nil then
		local keySettings = me.playerSettings.playerKeys
		if inputObject.KeyCode.Name == keySettings.interactKey and (closestDraw ~= nil and closestDraw:IsInRange(plr)) then
			closestDraw:Interact()
		elseif inputObject.KeyCode.Name == keySettings.buildSystemKey then
			local _condition = node
			if _condition == nil then
				_condition = lib:GetNode()
			end
			local selfNode = _condition
			node = selfNode
			if not buildSystem.isEnabled then
				if selfNode ~= nil then
					local _result = buildUI:FindFirstChild("Screen")
					if _result ~= nil then
						_result = _result:FindFirstChild("Customization")
					end
					local customizeableFrame = _result
					local _result_1 = buildUI:FindFirstChild("Screen")
					if _result_1 ~= nil then
						_result_1 = _result_1:FindFirstChild("Placeables")
						if _result_1 ~= nil then
							_result_1 = _result_1:FindFirstChild("Placeables")
						end
					end
					local scrollFrame = _result_1
					local _children = scrollFrame
					if _children ~= nil then
						_children = _children:GetChildren()
					end
					local children = _children
					if children ~= nil then
						do
							local i = 0
							local _shouldIncrement = false
							while true do
								if _shouldIncrement then
									i += 1
								else
									_shouldIncrement = true
								end
								if not (i < #children) then
									break
								end
								if string.lower(children[i + 1].Name) ~= "a" and children[i + 1]:IsA("Frame") then
									children[i + 1]:Destroy()
								end
							end
						end
					end
					local larry = lib:GetAllPossiblePlaceables()
					if larry ~= nil then
						do
							local _i = 0
							local _shouldIncrement = false
							while true do
								local i = _i
								if _shouldIncrement then
									i += 1
								else
									_shouldIncrement = true
								end
								if not (i < #larry) then
									break
								end
								local _result_2 = scrollFrame
								if _result_2 ~= nil then
									_result_2 = _result_2:FindFirstChild("A")
									if _result_2 ~= nil then
										_result_2 = _result_2:Clone()
									end
								end
								local placementUIFrame = _result_2
								placementUIFrame.Parent = scrollFrame
								placementUIFrame.Visible = true
								placementUIFrame.Name = "_"
								placementUIFrame.BackgroundTransparency = 1
								tweenService:Create(placementUIFrame, TweenInfo.new(0.2), {
									BackgroundTransparency = 0,
								}):Play()
								local b = placementUIFrame:FindFirstChild("B")
								print(larry[i + 1].config.name)
								b.Text = larry[i + 1].config.name
								b.MouseButton1Up:Connect(function()
									if larry ~= nil and #larry > 0 then
										buildSystem:Disable()
										buildSystem:Enable(larry[i + 1], nil, nil, selfNode)
										local _condition_1 = lastColorPicker
										if _condition_1 == nil then
											_condition_1 = ColorPicker.new(customizeableFrame:FindFirstChild("ColorPicker"))
										end
										lastColorPicker = _condition_1
										local _condition_2 = lastMatPicker
										if _condition_2 == nil then
											_condition_2 = MaterialPicker.new(customizeableFrame:FindFirstChild("MaterialPicker"))
										end
										lastMatPicker = _condition_2
										local uisEv
										uisEv = userInputService.InputBegan:Connect(function(inputObj, isProcessed)
											if not isProcessed and (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and (larry ~= nil and (lastColorPicker ~= nil and lastMatPicker ~= nil))) then
												local ar = {}
												local _ar = ar
												local _arg0 = larry[i + 1]
												local _actualResult = buildSystem.actualResult
												-- ▼ Array.push ▼
												local _length = #_ar
												_ar[_length + 1] = _arg0
												_ar[_length + 2] = _actualResult
												-- ▲ Array.push ▲
												local placeable = lib:PlacePlaceable(ar)
												if placeable ~= nil then
													buildSystem:Disable()
													lib:CustomizePlaceable(placeable.id, lastColorPicker.selectedColor, lastMatPicker.selectedMat)
													uisEv:Disconnect()
												end
											end
										end)
									else
										print("No placeables.")
									end
								end)
								_i = i
							end
						end
					end
				else
					local acceptInpType = Enum.UserInputType.MouseButton1
					buildSystem:Enable(Placeable.new(Node.new(me.userId, Vector3.new(0, 0, 0), NodeConfig.new(0, {})), buildSystem:MakeNodeRepresentation(), PlaceableConfig.new(1, "", "", 0, PlaceableCategories.Misc), 0), acceptInpType)
				end
			else
				buildSystem:Disable()
			end
		end
	end
end)
EvaluateInteractables()
while { wait(120) } do
	EvaluateInteractables()
end
