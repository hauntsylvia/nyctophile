-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Node = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node").Node
local NodeConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "node-config").NodeConfig
local Placeable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable").Placeable
local PlaceableConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "node", "placeable-config").PlaceableConfig
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local blackCoffee = _colors.blackCoffee
local coffee = _colors.coffee
local textCoffee = _colors.textCoffee
local textVanilla = _colors.textVanilla
local vanilla = _colors.vanilla
local BellaEnum = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "enums", "bella-enum").BellaEnum
local uiFillTween = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "tweens", "tween").uiFillTween
local BuildSystem = TS.import(script, script.Parent, "modules", "helpers", "build-system").BuildSystem
local Draw = TS.import(script, script.Parent, "modules", "helpers", "interactable-draw").Draw
local Client = TS.import(script, script.Parent, "modules", "net", "lib").Client
local ColorPicker = TS.import(script, script.Parent, "modules", "ui", "color-picker").ColorPicker
local MaterialPicker = TS.import(script, script.Parent, "modules", "ui", "material-picker").MaterialPicker
local UIHover = TS.import(script, script.Parent, "modules", "ui", "ui-hover").UIHover
local VersionDisplayLabel = TS.import(script, script.Parent, "modules", "ui", "version-display").VersionDisplayLabel
local lib = Client.new()
local plr = game:GetService("Players").LocalPlayer
local draws = {}
local me = lib:GetMe()
local node
local buildUIEnabled = false
local lastColorPicker
local lastMatPicker
local buildSystem = BuildSystem.new(lib)
local buildUI = plr:WaitForChild("PlayerGui"):WaitForChild("BuildingsGUI")
local buildUIScreen = (buildUI:WaitForChild("Screen"))
buildUIScreen.Position = UDim2.fromScale(1, 0)
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local function VersionDisplay()
	local versDisplay = VersionDisplayLabel.new(lib.gameVersion)
end
VersionDisplay()
local lastUIS, DrawBuildUIItems
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
						tweenService:Create(lastSel, uiFillTween, {
							TextColor3 = textVanilla,
						}):Play()
						tweenService:Create(lastFr, uiFillTween, {
							BackgroundColor3 = coffee,
						}):Play()
					end
					if buildSystem.isEnabled then
						if lastUIS ~= nil then
							lastUIS:Disconnect()
						end
						buildSystem:Disable()
					end
					DrawBuildUIItems(placeableEnums[i + 1])
					tweenService:Create(baseTextBtn, uiFillTween, {
						TextColor3 = textCoffee,
					}):Play()
					tweenService:Create(base, uiFillTween, {
						BackgroundColor3 = vanilla,
					}):Play()
					lastSel = baseTextBtn
					lastFr = base
				end
				baseTextBtn.MouseButton1Up:Connect(Press)
				baseImageBtn.MouseButton1Up:Connect(Press)
				_i = i
			end
		end
	end
end
local allUIHovers = {}
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
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #allUIHovers) then
				break
			end
			allUIHovers[i + 1]:Dispose()
		end
	end
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
							local t = desc:IsA("TextButton") and tweenService:Create(desc, uiFillTween, {
								TextTransparency = 1,
								BackgroundTransparency = 1,
							}) or tweenService:Create(desc, uiFillTween, {
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
					tweenService:Create(thisChild, uiFillTween, {
						Transparency = 1,
						BackgroundTransparency = 1,
					}):Play()
					coroutine.resume(coroutine.create(function()
						wait(uiFillTween.Time)
						thisChild:Destroy()
					end))
				end
			end
		end
	end
	wait(uiFillTween.Time)
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
				local _condition = larry[i + 1].config.placeableCategory ~= nil
				if _condition then
					local _exp = category.name
					local _result_2 = larry[i + 1].config.placeableCategory
					if _result_2 ~= nil then
						_result_2 = _result_2.name
					end
					_condition = _exp == _result_2
				end
				local _condition_1 = _condition
				if not _condition_1 then
					_condition_1 = (larry[i + 1].config.placeableCategory == nil and category == BellaEnum.placeableCategories:TryParse("misc"))
				end
				if _condition_1 then
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
					placementUIFrame.BackgroundColor3 = blackCoffee
					local uiHvr = UIHover.new(placementUIFrame, larry[i + 1].config.name, "[$" .. (tostring(larry[i + 1].config.cost) .. ("]\n" .. larry[i + 1].config.description)))
					local _allUIHovers = allUIHovers
					local _uiHvr = uiHvr
					-- ▼ Array.push ▼
					_allUIHovers[#_allUIHovers + 1] = _uiHvr
					-- ▲ Array.push ▲
					local b = placementUIFrame:FindFirstChild("B")
					b.Font = Enum.Font.SourceSansItalic
					b.Text = larry[i + 1].config.name
					b.TextTransparency = 1
					b.TextColor3 = textVanilla
					tweenService:Create(placementUIFrame, uiFillTween, {
						BackgroundTransparency = 0,
						Transparency = 0,
					}):Play()
					tweenService:Create(b, uiFillTween, {
						TextTransparency = 0,
					}):Play()
					b.MouseButton1Up:Connect(function()
						if larry ~= nil and #larry > 0 then
							if lastButtonSel ~= nil and lastFrameSel ~= nil then
								tweenService:Create(lastFrameSel, uiFillTween, {
									BackgroundColor3 = blackCoffee,
								}):Play()
								tweenService:Create(lastButtonSel, uiFillTween, {
									TextColor3 = textVanilla,
								}):Play()
							end
							if lastUIS ~= nil then
								lastUIS:Disconnect()
							end
							lastFrameSel = placementUIFrame
							lastButtonSel = b
							buildSystem:Disable()
							buildSystem:Enable(larry[i + 1], nil, nil, node)
							tweenService:Create(placementUIFrame, uiFillTween, {
								BackgroundColor3 = vanilla,
							}):Play()
							tweenService:Create(b, uiFillTween, {
								TextColor3 = textCoffee,
							}):Play()
							local _condition_2 = lastColorPicker
							if _condition_2 == nil then
								_condition_2 = ColorPicker.new(customizeableFrame:FindFirstChild("ColorPicker"))
							end
							lastColorPicker = _condition_2
							local _condition_3 = lastMatPicker
							if _condition_3 == nil then
								_condition_3 = MaterialPicker.new(customizeableFrame:FindFirstChild("MaterialPicker"))
							end
							lastMatPicker = _condition_3
							lastUIS = userInputService.InputEnded:Connect(function(inputObj, isProcessed)
								local _condition_4 = not isProcessed and (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and (larry ~= nil and (lastColorPicker ~= nil and (lastMatPicker ~= nil and buildSystem.isEnabled))))
								if _condition_4 then
									local _result_3 = lastUIS
									if _result_3 ~= nil then
										_result_3 = _result_3.Connected
									end
									_condition_4 = _result_3
								end
								if _condition_4 then
									local placeable = lib:PlacePlaceable(larry[i + 1], buildSystem.actualResult, lastColorPicker.selectedColor, lastMatPicker.selectedMat)
									if placeable ~= nil then
										tweenService:Create(placementUIFrame, uiFillTween, {
											BackgroundColor3 = blackCoffee,
										}):Play()
										tweenService:Create(b, uiFillTween, {
											TextColor3 = textVanilla,
										}):Play()
										buildSystem:Disable()
										if lastUIS ~= nil then
											lastUIS:Disconnect()
										end
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
	if #draws > 0 and not buildSystem.isEnabled then
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
	elseif buildSystem.isEnabled then
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
				local int = draws[i + 1]
				if int ~= nil then
					int:Disable()
				end
			end
		end
	end
end)
userInputService.InputEnded:Connect(function(inputObject, isProcessed)
	if not isProcessed and me ~= nil then
		local keySettings = me.playerSettings.playerKeys
		if inputObject.KeyCode.Name == keySettings.interactKey and (closestDraw ~= nil and (closestDraw:IsInRange(plr) and not buildSystem.isEnabled)) then
			closestDraw:Interact()
		elseif inputObject.KeyCode.Name == keySettings.buildSystemKey then
			local _condition = node
			if _condition == nil then
				_condition = lib:GetNode()
			end
			node = _condition
			if not buildSystem.isEnabled then
				if node ~= nil then
					if buildUIEnabled then
						tweenService:Create((buildUI:WaitForChild("Screen")), TweenInfo.new(uiFillTween.Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
							Position = UDim2.fromScale(1, 0),
						}):Play()
					else
						tweenService:Create((buildUI:WaitForChild("Screen")), TweenInfo.new(uiFillTween.Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
							Position = UDim2.fromScale(0, 0),
						}):Play()
					end
					buildUIEnabled = not buildUIEnabled
				else
					local acceptInpType = Enum.UserInputType.MouseButton1
					buildSystem:Enable(Placeable.new(Node.new(me.userId, Vector3.new(0, 0, 0), NodeConfig.new(0, {})), buildSystem:MakeNodeRepresentation(), PlaceableConfig.new(1, "", "", 0, nil), 0), acceptInpType)
				end
			else
				if lastUIS ~= nil then
					lastUIS:Disconnect()
				end
				buildSystem:Disable()
			end
		end
	end
end)
DrawBuildUICategories()
EvaluateInteractables()
while { wait(120) } do
	EvaluateInteractables()
end
