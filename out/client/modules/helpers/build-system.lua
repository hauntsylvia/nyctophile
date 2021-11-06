-- Compiled with roblox-ts v1.2.7
local tweenService = game:GetService("TweenService")
local BuildSystem
do
	BuildSystem = setmetatable({}, {
		__tostring = function()
			return "BuildSystem"
		end,
	})
	BuildSystem.__index = BuildSystem
	function BuildSystem.new(...)
		local self = setmetatable({}, BuildSystem)
		return self:constructor(...) or self
	end
	function BuildSystem:constructor(client)
		self.isEnabled = false
		self.actualResult = CFrame.new(0, 0, 0)
		self.allRenderedNodes = {}
		self.client = client
	end
	function BuildSystem:MakeNodeRepresentation(n, color)
		local nodeModel = Instance.new("Model", game:GetService("Workspace"))
		nodeModel.Name = "temp-node-model"
		local nodePart = Instance.new("Part", nodeModel)
		nodePart.Name = "temp-node-part"
		nodePart.Size = Vector3.new(7.5, 10, 7.5)
		nodePart.Transparency = 0.7
		nodePart.Material = Enum.Material.Neon
		nodePart.CanCollide = false
		nodePart.Anchored = true
		local _condition = color
		if _condition == nil then
			_condition = Color3.fromRGB(255, 135, 135)
		end
		nodePart.Color = _condition
		nodeModel.PrimaryPart = nodePart
		if n ~= nil then
			local nodeRadius = Instance.new("Part", nodeModel)
			nodeRadius.Shape = Enum.PartType.Ball
			nodeRadius.Name = "temp-node-radius"
			nodeRadius.Size = Vector3.new(n.config.radius, n.config.radius, n.config.radius) * 2
			nodeRadius.Transparency = 0.97
			nodeRadius.Material = Enum.Material.Neon
			nodeRadius.CanCollide = false
			nodeRadius.Anchored = true
			local _condition_1 = color
			if _condition_1 == nil then
				_condition_1 = Color3.fromRGB(255, 135, 135)
			end
			nodeRadius.Color = _condition_1
			nodeModel:SetPrimaryPartCFrame(CFrame.new(n.position))
		end
		return nodeModel
	end
	function BuildSystem:Enable(placeable, pressedToReturn, pressedToDisable, node)
		if self.isEnabled then
			self:Disable()
		end
		self.attachedModel = placeable.attachedModel:Clone()
		self.attachedModel.Parent = game:GetService("Workspace")
		self.attachedModel.Name = "temp-build-system-attachment"
		if self.attachedModel.PrimaryPart ~= nil then
			local actualPosition
			local actualRotation = CFrame.fromEulerAnglesXYZ(0, 0, 0)
			self.isEnabled = true
			local plr = game:GetService("Players").LocalPlayer
			local mouse = plr:GetMouse()
			local _condition = plr.Character
			if _condition == nil then
				_condition = { plr.CharacterAdded:Wait() }
			end
			local char = _condition
			local isValid = false
			local s = self
			local modelsDescendants = self.attachedModel:GetDescendants()
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #modelsDescendants) then
						break
					end
					if modelsDescendants[i + 1]:IsA("BasePart") then
						local thisPart = modelsDescendants[i + 1]
						thisPart.Anchored = true
						thisPart.CanCollide = false
						tweenService:Create(thisPart, TweenInfo.new(1), {
							Transparency = 0.6,
						}):Play()
					end
				end
			end
			self.uisConnection = game:GetService("UserInputService").InputEnded:Connect(function(inputObject, isProcessed)
				if not isProcessed and (s.attachedModel ~= nil and s.attachedModel.PrimaryPart ~= nil) then
					if pressedToReturn ~= nil and (inputObject.UserInputType == pressedToReturn and isValid) then
						if node == nil then
							s.client:PlaceNode(actualPosition)
							s:Disable()
						else
							s.client:PlacePlaceable(placeable, s.actualResult)
							s:Disable()
						end
					elseif pressedToDisable ~= nil and inputObject.KeyCode == pressedToDisable then
						s:Disable()
					end
				end
			end)
			self.uisContConnection = game:GetService("UserInputService").InputBegan:Connect(function(inputObject, isProcessed)
				if not isProcessed then
					local condition = true
					if inputObject.KeyCode == Enum.KeyCode.E then
						local e = game:GetService("UserInputService").InputEnded:Connect(function(newInp, isP)
							if not isP and newInp.KeyCode == inputObject.KeyCode then
								condition = false
							end
						end)
						while condition and { wait() } do
							local _actualRotation = actualRotation
							local _arg0 = CFrame.fromEulerAnglesXYZ(0, -0.25, 0)
							actualRotation = _actualRotation * _arg0
						end
						e:Disconnect()
					elseif inputObject.KeyCode == Enum.KeyCode.Q then
						local e = game:GetService("UserInputService").InputEnded:Connect(function(newInp, isP)
							if not isP and newInp.KeyCode == inputObject.KeyCode then
								condition = false
							end
						end)
						while condition and { wait() } do
							local _actualRotation = actualRotation
							local _arg0 = CFrame.fromEulerAnglesXYZ(0, 0.25, 0)
							actualRotation = _actualRotation * _arg0
						end
						e:Disconnect()
					end
				end
			end)
			local _condition_1 = self.client:GetAllOtherPlayersNodes()
			if _condition_1 == nil then
				_condition_1 = {}
			end
			local allNodesInGame = _condition_1
			do
				local n = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						n += 1
					else
						_shouldIncrement = true
					end
					if not (n < #allNodesInGame) then
						break
					end
					if allNodesInGame[n + 1].owner == plr.UserId then
						local thisNodeModel = s:MakeNodeRepresentation(allNodesInGame[n + 1], Color3.fromRGB(180, 255, 180))
						local _allRenderedNodes = s.allRenderedNodes
						local _thisNodeModel = thisNodeModel
						-- ▼ Array.push ▼
						_allRenderedNodes[#_allRenderedNodes + 1] = _thisNodeModel
						-- ▲ Array.push ▲
					else
						local thisNodeModel = s:MakeNodeRepresentation(allNodesInGame[n + 1])
						local _allRenderedNodes = s.allRenderedNodes
						local _thisNodeModel = thisNodeModel
						-- ▼ Array.push ▼
						_allRenderedNodes[#_allRenderedNodes + 1] = _thisNodeModel
						-- ▲ Array.push ▲
					end
				end
			end
			local thisRenderedNode
			if node ~= nil then
				thisRenderedNode = s:MakeNodeRepresentation(nil, Color3.fromRGB(180, 255, 180))
				local _allRenderedNodes = s.allRenderedNodes
				local _thisRenderedNode = thisRenderedNode
				-- ▼ Array.push ▼
				_allRenderedNodes[#_allRenderedNodes + 1] = _thisRenderedNode
				-- ▲ Array.push ▲
			end
			self.connection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
				if s.attachedModel ~= nil then
					local _ray = game:GetService("Workspace").CurrentCamera
					if _ray ~= nil then
						_ray = _ray:ScreenPointToRay(mouse.X, mouse.Y)
					end
					local ray = _ray
					if ray ~= nil and s.attachedModel.PrimaryPart ~= nil then
						local raycastParams = RaycastParams.new()
						local ignore = {}
						local _ignore = ignore
						local _attachedModel = s.attachedModel
						-- ▼ Array.push ▼
						_ignore[#_ignore + 1] = _attachedModel
						-- ▲ Array.push ▲
						do
							local i = 0
							local _shouldIncrement = false
							while true do
								if _shouldIncrement then
									i += 1
								else
									_shouldIncrement = true
								end
								if not (i < #game:GetService("Players"):GetPlayers()) then
									break
								end
								local plrsChar = game:GetService("Players"):GetPlayers()[i + 1].Character
								if plrsChar ~= nil then
									local _ignore_1 = ignore
									local _plrsChar = plrsChar
									-- ▼ Array.push ▼
									_ignore_1[#_ignore_1 + 1] = _plrsChar
									-- ▲ Array.push ▲
								end
							end
						end
						do
							local i = 0
							local _shouldIncrement = false
							while true do
								if _shouldIncrement then
									i += 1
								else
									_shouldIncrement = true
								end
								if not (i < #s.allRenderedNodes) then
									break
								end
								local _ignore_1 = ignore
								local _arg0 = s.allRenderedNodes[i + 1]
								-- ▼ Array.push ▼
								_ignore_1[#_ignore_1 + 1] = _arg0
								-- ▲ Array.push ▲
							end
						end
						raycastParams.FilterDescendantsInstances = ignore
						raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
						local raycastResult = game:GetService("Workspace"):Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
						if raycastResult ~= nil then
							local _position = raycastResult.Position
							local _vector3 = Vector3.new(0, (s.attachedModel:GetExtentsSize() / 2).Y, 0)
							actualPosition = _position + _vector3
							if node ~= nil then
								local _position_1 = node.position
								local _position_2 = s.attachedModel.PrimaryPart.Position
								isValid = (_position_1 - _position_2).Magnitude <= node.config.radius
							elseif allNodesInGame ~= nil then
								if #allNodesInGame <= 0 then
									isValid = true
								else
									local closestNode
									do
										local i = 0
										local _shouldIncrement = false
										while true do
											if _shouldIncrement then
												i += 1
											else
												_shouldIncrement = true
											end
											if not (i < #allNodesInGame) then
												break
											end
											local thisN = allNodesInGame[i + 1]
											local _condition_2 = closestNode == nil
											if not _condition_2 then
												local _actualPosition = actualPosition
												local _position_1 = thisN.position
												local _exp = (_actualPosition - _position_1).Magnitude
												local _actualPosition_1 = actualPosition
												local _position_2 = closestNode.position
												_condition_2 = _exp < (_actualPosition_1 - _position_2).Magnitude
											end
											if _condition_2 then
												closestNode = thisN
											end
										end
									end
									local _condition_2 = closestNode ~= nil
									if _condition_2 then
										local _actualPosition = actualPosition
										local _position_1 = closestNode.position
										_condition_2 = (_actualPosition - _position_1).Magnitude >= closestNode.config.radius * 2
									end
									isValid = _condition_2
								end
							end
							local colorToTweenTo = isValid and Color3.fromRGB(135, 255, 135) or Color3.fromRGB(255, 135, 135)
							local allDesc = s.attachedModel:GetDescendants()
							do
								local i = 0
								local _shouldIncrement = false
								while true do
									if _shouldIncrement then
										i += 1
									else
										_shouldIncrement = true
									end
									if not (i < #allDesc) then
										break
									end
									local thisPart = allDesc[i + 1]
									if thisPart:IsA("BasePart") then
										thisPart.Color = thisPart.Color:Lerp(colorToTweenTo, 0.3)
									end
								end
							end
							local _fn = s.attachedModel.PrimaryPart.CFrame
							local _cFrame = CFrame.new(actualPosition)
							local _actualRotation = actualRotation
							local fakePosition = _fn:Lerp(_cFrame * _actualRotation, 0.3)
							local _cFrame_1 = CFrame.new(actualPosition)
							local _actualRotation_1 = actualRotation
							s.actualResult = (_cFrame_1 * _actualRotation_1)
							s.attachedModel:SetPrimaryPartCFrame(fakePosition)
						end
					elseif s.attachedModel.PrimaryPart == nil then
						error("Primary part removed.")
					end
				end
			end)
		else
			error("No primary part exists on this model.")
		end
	end
	function BuildSystem:Disable()
		self.isEnabled = false
		if self.attachedModel ~= nil then
			self.attachedModel:Destroy()
		end
		if self.connection ~= nil then
			self.connection:Disconnect()
		end
		if self.uisConnection ~= nil then
			self.uisConnection:Disconnect()
		end
		if self.uisContConnection ~= nil then
			self.uisContConnection:Disconnect()
		end
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.allRenderedNodes) then
					break
				end
				self.allRenderedNodes[i + 1]:Destroy()
			end
		end
	end
end
return {
	BuildSystem = BuildSystem,
}
