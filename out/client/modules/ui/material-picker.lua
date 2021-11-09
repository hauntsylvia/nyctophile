-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local coffee = _colors.coffee
local textVanilla = _colors.textVanilla
local vanillaHalf = _colors.vanillaHalf
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
		box.BackgroundColor3 = coffee
		box.PlaceholderText = "Default Material"
		box.PlaceholderColor3 = vanillaHalf
		box.Text = ""
		box.TextSize = 18
		box.TextScaled = false
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Center
		box.TextColor3 = textVanilla
		box.Size = UDim2.fromScale(1, 1)
		box.Visible = true
		local boxCorner = Instance.new("UICorner")
		boxCorner.Parent = box
		boxCorner.Name = "corner"
		boxCorner.CornerRadius = UDim.new(1, 0)
		local corner = Instance.new("UICorner")
		corner.Parent = box
		corner.Name = "corner"
		corner.CornerRadius = UDim.new(0, 18)
		self.mats = Enum.Material:GetEnumItems()
		local fakeThis = self
		self.u = game:GetService("UserInputService").InputEnded:Connect(function(inputObject, isProcessed)
			if not isProcessed then
				if inputObject.KeyCode == Enum.KeyCode.Return then
					local foundMat
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
								foundMat = fakeThis.mats[i + 1]
							end
						end
					end
					if foundMat == nil then
						fakeThis.selectedMat = nil
					else
						fakeThis.selectedMat = foundMat
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
