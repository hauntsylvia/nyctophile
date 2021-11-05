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
		self.allRenderedNodes = {}
		self.client = client
	end
	function BuildSystem:MakeNodeRepresentation(n)
		local nodeModel = Instance.new("Model", game:GetService("Workspace"))
		nodeModel.Name = "temp-node-model"
		local nodePart = Instance.new("Part", nodeModel)
		nodePart.Name = "temp-node-part"
		nodePart.Size = Vector3.new(7.5, 10, 7.5)
		nodePart.Transparency = 0.7
		nodePart.Material = Enum.Material.Neon
		nodePart.CanCollide = false
		nodePart.Anchored = true
		nodePart.Color = Color3.fromRGB(255, 135, 135)
		nodeModel.PrimaryPart = nodePart
		if n ~= nil then
			local nodeRadius = Instance.new("Part", nodeModel)
			nodeRadius.Name = "temp-node-radius"
			nodeRadius.Size = Vector3.new(n.config.radius, n.config.radius, n.config.radius)
			nodeRadius.Transparency = 0.97
			nodeRadius.Material = Enum.Material.Neon
			nodeRadius.CanCollide = false
			nodeRadius.Anchored = true
			nodeRadius.Color = Color3.fromRGB(255, 135, 135)
			nodeModel:SetPrimaryPartCFrame(CFrame.new(n.position))
		end
		return nodeModel
	end
	function BuildSystem:Enable(placeable, pressedToReturn, pressedToDisable, node)
		if self.isEnabled then
			self:Disable()
		end
		self.attachedModel = placeable.attachedModel
		if self.attachedModel.PrimaryPart ~= nil then
			local actualPosition
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
							s.client:PlacePlaceable(placeable)
							s:Disable()
						end
					elseif pressedToDisable ~= nil and inputObject.KeyCode == pressedToDisable then
						s:Disable()
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
					local thisNodeModel = s:MakeNodeRepresentation(allNodesInGame[n + 1])
					local _allRenderedNodes = s.allRenderedNodes
					local _thisNodeModel = thisNodeModel
					-- ▼ Array.push ▼
					_allRenderedNodes[#_allRenderedNodes + 1] = _thisNodeModel
					-- ▲ Array.push ▲
				end
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
						local _char = char
						-- ▼ Array.push ▼
						local _length = #_ignore
						_ignore[_length + 1] = _attachedModel
						_ignore[_length + 2] = _char
						-- ▲ Array.push ▲
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
											local _position_1 = thisN.position
											local _actualPosition = actualPosition
											if (_position_1 - _actualPosition).Magnitude <= (thisN.config.radius) then
												isValid = false
											end
										end
									end
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
										thisPart.Color = thisPart.Color:Lerp(colorToTweenTo, 0.2)
									end
								end
							end
							local fakePosition = s.attachedModel.PrimaryPart.CFrame:Lerp(CFrame.new(actualPosition), 0.2)
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
			local _result = self.connection
			if _result ~= nil then
				_result:Disconnect()
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
