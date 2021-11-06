-- Compiled with roblox-ts v1.2.7
local MaterialPicker
do
	MaterialPicker = setmetatable({}, {
		__tostring = function()
			return "MaterialPicker"
		end,
	})
	MaterialPicker.__index = MaterialPicker
	function MaterialPicker.new(...)
		local self = setmetatable({}, MaterialPicker)
		return self:constructor(...) or self
	end
	function MaterialPicker:constructor(parent)
		self.thisFrame = Instance.new("Frame")
		self.thisFrame.Parent = parent
		self.thisFrame.Name = "mat-picker"
		self.thisFrame.BackgroundTransparency = 1
		self.thisFrame.BorderSizePixel = 0
		self.thisFrame.Size = UDim2.new(0.95, 0, 0.95, 0)
		self.thisFrame.Position = UDim2.new(0.025, 0, 0.025, 0)
		self.thisFrame.Visible = true
		self.thisFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		self.thisFrame.Position = UDim2.fromScale(0.5, 0.5)
		local aspectRatio = Instance.new("UIAspectRatioConstraint")
		aspectRatio.Parent = self.thisFrame
		aspectRatio.AspectRatio = 1.5
		aspectRatio.Name = "a"
		local box = Instance.new("TextBox")
		box.Parent = self.thisFrame
		box.Name = "box"
		box.BorderSizePixel = 0
		box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		box.PlaceholderText = "Default"
		box.Text = ""
		box.TextSize = 18
		box.TextScaled = false
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Center
		box.TextColor3 = Color3.fromRGB(180, 180, 180)
		box.Size = UDim2.fromScale(0.95, 0.95)
		box.Position = UDim2.new(0.025, 0, 0.025, 0)
		box.Visible = true
		box.AnchorPoint = Vector2.new(0.5, 0.5)
		box.Position = UDim2.fromScale(0.5, 0.5)
		local corner = Instance.new("UICorner")
		corner.Parent = box
		corner.Name = "corner"
		corner.CornerRadius = UDim.new(0, 18)
		self.mats = Enum.Material:GetEnumItems()
		local fakeThis = self
		self.u = game:GetService("UserInputService").InputEnded:Connect(function(inputObject, isProcessed)
			if not isProcessed then
				if inputObject.KeyCode == Enum.KeyCode.Return then
					do
						local i = 0
						local _shouldIncrement = false
						while true do
							if _shouldIncrement then
								i += 1
							else
								_shouldIncrement = true
							end
							if not (i < #fakeThis.mats) then
								break
							end
							if string.lower(fakeThis.mats[i + 1].Name) == string.lower(box.Text) then
								fakeThis.selectedMat = fakeThis.mats[i + 1]
								break
							end
						end
					end
				end
			end
		end)
	end
	function MaterialPicker:Disable()
		if self.u ~= nil then
			self.u:Disconnect()
		end
		self.thisFrame:Destroy()
	end
end
return {
	MaterialPicker = MaterialPicker,
}
