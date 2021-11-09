-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Node = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node").Node
local NodeConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node-config").NodeConfig
local Placeable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable").Placeable
local PlaceableConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable-config").PlaceableConfig
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local coffee = _colors.coffee
local textCoffee = _colors.textCoffee
local textVanilla = _colors.textVanilla
local vanilla = _colors.vanilla
local BellaEnum = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "enums", "bella-enum").BellaEnum
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
local ti = TweenInfo.new(0.075, Enum.EasingStyle.Quint)
local canInteractableHeartbeatRun = true
local DrawBuildUIItems
local function DrawBuildUICategories()
	local fr = buildUI:WaitForChild("Screen"):WaitForChild("Categorization"):WaitForChild("InternalFrame")
	if fr ~= nil and fr:IsA("Frame") then
		local chldrn = fr:GetChildren()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #chldrn) then
					break
				end
				if string.lower(chldrn[i + 1].Name) ~= "a" and chldrn[i + 1]:IsA("Frame") then
					chldrn[i + 1]:Destroy()
				end
			end
		end
		local placeableEnums = BellaEnum.placeableCategories:GetEnums()
		local lastSel
		local lastFr
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
				if not (i < #placeableEnums) then
					break
				end
				local base = (fr:WaitForChild("A")):Clone()
				base.BackgroundColor3 = coffee
				base.Name = "B"
				base.Parent = fr
				base.Visible = true
				local baseTextBtn = (base:WaitForChild("B"))
				local baseImageBtn = (base:WaitForChild("I"))
				baseTextBtn.Font = Enum.Font.SourceSansItalic
				baseTextBtn.TextSize = 18
				baseTextBtn.TextColor3 = textVanilla
				baseTextBtn.Text = placeableEnums[i + 1].name
				local function Press()
					if (lastSel ~= nil and lastFr ~= nil) or (lastSel == baseTextBtn and lastFr == base) then
						tweenService:Create(lastSel, ti, {
							TextColor3 = textVanilla,
						}):Play()
						tweenService:Create(lastFr, ti, {
							BackgroundColor3 = coffee,
						}):Play()
					end
					tweenService:Create(baseTextBtn, ti, {
						TextColor3 = textCoffee,
					}):Play()
					tweenService:Create(base, ti, {
						BackgroundColor3 = vanilla,
					}):Play()
					lastSel = baseTextBtn
					lastFr = base
					DrawBuildUIItems(placeableEnums[i + 1])
				end
				baseTextBtn.MouseButton1Up:Connect(Press)
				baseImageBtn.MouseButton1Up:Connect(Press)
				_i = i
			end
		end
	end
end
local lastColorPicker, lastMatPicker
function DrawBuildUIItems(category)
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
				local thisChild = children[i + 1]
				if string.lower(thisChild.Name) ~= "a" and thisChild:IsA("Frame") then
					local _exp = thisChild:GetDescendants()
					local _arg0 = function(desc)
						if desc:IsA("GuiButton") then
							local t = desc:IsA("TextButton") and tweenService:Create(desc, ti, {
								TextTransparency = 1,
								BackgroundTransparency = 1,
							}) or tweenService:Create(desc, ti, {
								Transparency = 1,
								BackgroundTransparency = 1,
							})
							t:Play()
						end
					end
					-- ▼ ReadonlyArray.forEach ▼
					for _k, _v in ipairs(_exp) do
						_arg0(_v, _k - 1, _exp)
					end
					-- ▲ ReadonlyArray.forEach ▲
					tweenService:Create(thisChild, ti, {
						Transparency = 1,
						BackgroundTransparency = 1,
					}):Play()
					coroutine.resume(coroutine.create(function()
						wait(ti.Time)
						thisChild:Destroy()
					end))
				end
			end
		end
	end
	wait(ti.Time)
	local larry = lib:GetAllPossiblePlaceables()
	if larry ~= nil and node ~= nil then
		local lastButtonSel
		local lastFrameSel
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
				if larry[i + 1].config.placeableCategory == category or (larry[i + 1].config.placeableCategory == nil and category == BellaEnum.placeableCategories:TryParse("misc")) then
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
					placementUIFrame.BackgroundColor3 = coffee
					tweenService:Create(placementUIFrame, ti, {
						BackgroundTransparency = 0,
					}):Play()
					local b = placementUIFrame:FindFirstChild("B")
					b.Text = larry[i + 1].config.name
					b.TextColor3 = textVanilla
					b.MouseButton1Up:Connect(function()
						if larry ~= nil and #larry > 0 then
							if lastButtonSel ~= nil and lastFrameSel ~= nil then
								tweenService:Create(lastFrameSel, ti, {
									BackgroundColor3 = coffee,
								}):Play()
								tweenService:Create(lastButtonSel, ti, {
									TextColor3 = textVanilla,
								}):Play()
							end
							lastFrameSel = placementUIFrame
							lastButtonSel = b
							buildSystem:Disable()
							buildSystem:Enable(larry[i + 1], nil, nil, node)
							tweenService:Create(placementUIFrame, ti, {
								BackgroundColor3 = vanilla,
							}):Play()
							tweenService:Create(b, ti, {
								TextColor3 = textCoffee,
							}):Play()
							local _condition = lastColorPicker
							if _condition == nil then
								_condition = ColorPicker.new(customizeableFrame:FindFirstChild("ColorPicker"))
							end
							lastColorPicker = _condition
							local _condition_1 = lastMatPicker
							if _condition_1 == nil then
								_condition_1 = MaterialPicker.new(customizeableFrame:FindFirstChild("MaterialPicker"))
							end
							lastMatPicker = _condition_1
							canInteractableHeartbeatRun = false
							local uisEv
							uisEv = userInputService.InputEnded:Connect(function(inputObj, isProcessed)
								if not isProcessed and (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and (larry ~= nil and (lastColorPicker ~= nil and (lastMatPicker ~= nil and buildSystem.isEnabled)))) then
									local placeable = lib:PlacePlaceable(larry[i + 1], buildSystem.actualResult, lastColorPicker.selectedColor, lastMatPicker.selectedMat)
									if placeable ~= nil then
										tweenService:Create(placementUIFrame, ti, {
											BackgroundColor3 = coffee,
										}):Play()
										tweenService:Create(b, ti, {
											TextColor3 = textVanilla,
										}):Play()
										canInteractableHeartbeatRun = true
										buildSystem:Disable()
										uisEv:Disconnect()
									end
								end
							end)
						else
							print("No placeables.")
						end
					end)
				end
				_i = i
			end
		end
	end
end
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
	if #draws > 0 and canInteractableHeartbeatRun then
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
	else
		if closestDraw ~= nil then
			closestDraw:Disable()
		end
	end
end)
userInputService.InputEnded:Connect(function(inputObject, isProcessed)
	if not isProcessed and me ~= nil then
		local keySettings = me.playerSettings.playerKeys
		if inputObject.KeyCode.Name == keySettings.interactKey and (closestDraw ~= nil and (closestDraw:IsInRange(plr) and canInteractableHeartbeatRun)) then
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
					buildUI.Enabled = not buildUI.Enabled
					if buildUI.Enabled then
						DrawBuildUICategories()
					end
				else
					local acceptInpType = Enum.UserInputType.MouseButton1
					buildSystem:Enable(Placeable.new(Node.new(me.userId, Vector3.new(0, 0, 0), NodeConfig.new(0, {})), buildSystem:MakeNodeRepresentation(), PlaceableConfig.new(1, "", "", 0, nil), 0), acceptInpType)
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
