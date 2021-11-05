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
		self.internallyHandleDisabling = true
		self.client = client
	end
	function BuildSystem:Enable(attachedModel, pressedToReturn, pressedToDisable, internallyHandleDisabling, node)
		if self.isEnabled then
			self:_Disable()
		end
		self.internallyHandleDisabling = internallyHandleDisabling
		self.attachedModel = attachedModel
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
						tweenService:Create(thisPart, TweenInfo.new(1), {
							Transparency = 0.8,
						}):Play()
					end
				end
			end
			self.uisConnection = game:GetService("UserInputService").InputEnded:Connect(function(inputObject, isProcessed)
				if not isProcessed and (s.attachedModel ~= nil and s.attachedModel.PrimaryPart ~= nil) then
					if inputObject.UserInputType == pressedToReturn and isValid then
						s:_Disable()
						return actualPosition
					elseif inputObject.KeyCode == pressedToDisable then
						s:_Disable()
						return nil
					end
				end
			end)
			local _condition_1 = self.client:GetAllOtherPlayersNodes()
			if _condition_1 == nil then
				_condition_1 = {}
			end
			local allNodesInGame = _condition_1
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
							if node ~= nil then
								local _position = node.position
								local _position_1 = s.attachedModel.PrimaryPart.Position
								isValid = (_position - _position_1).Magnitude <= node.config.radius
							elseif allNodesInGame ~= nil then
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
										if thisN.config ~= nil and thisN.position ~= nil then
											local _result = thisN.position
											if _result ~= nil then
												local _position = s.attachedModel.PrimaryPart.Position
												_result = (_result - _position).Magnitude
											end
											local _result_1 = thisN.config
											if _result_1 ~= nil then
												_result_1 = _result_1.radius
											end
											if _result <= (_result_1 * 2) then
												isValid = true
												break
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
										tweenService:Create(thisPart, TweenInfo.new(0.4), {
											Color = colorToTweenTo,
										}):Play()
									end
								end
							end
							local _position = raycastResult.Position
							local _arg0 = s.attachedModel:GetExtentsSize()
							actualPosition = (_position + _arg0) / 2
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
	function BuildSystem:_Disable(overrideInternallyHandleDisabling)
		if overrideInternallyHandleDisabling == nil then
			overrideInternallyHandleDisabling = false
		end
		if self.internallyHandleDisabling or overrideInternallyHandleDisabling then
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
		end
	end
	function BuildSystem:Disable()
		self:_Disable(true)
	end
end
return {
	BuildSystem = BuildSystem,
}
