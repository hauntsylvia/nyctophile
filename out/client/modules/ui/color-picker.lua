-- Compiled with roblox-ts v1.2.7
local function RadToDegree(x)
	return ((x + math.pi) / (2 * math.pi)) * 360
end
local function ToPolar(v)
	return math.atan2(v.Y, v.X)
end
local ColorPicker
do
	ColorPicker = setmetatable({}, {
		__tostring = function()
			return "ColorPicker"
		end,
	})
	ColorPicker.__index = ColorPicker
	function ColorPicker.new(...)
		local self = setmetatable({}, ColorPicker)
		return self:constructor(...) or self
	end
	function ColorPicker:constructor(parentTo)
		self.thisFrame = Instance.new("Frame")
		self.thisFrame.Parent = parentTo
		self.thisFrame.Name = "color-picker"
		self.thisFrame.BackgroundTransparency = 1
		self.thisFrame.BorderSizePixel = 0
		self.thisFrame.Size = UDim2.new(0.95, 0, 0.95, 0)
		self.thisFrame.Position = UDim2.new(0.025, 0, 0.025, 0)
		self.thisFrame.Visible = true
		self.thisFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		self.thisFrame.Position = UDim2.fromScale(0.5, 0.5)
		local colorFrame = Instance.new("Frame")
		colorFrame.Parent = self.thisFrame
		colorFrame.Name = "color frame"
		colorFrame.BackgroundTransparency = 0
		colorFrame.BorderSizePixel = 0
		colorFrame.Size = UDim2.fromScale(0.9, 0.9)
		colorFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
		colorFrame.Visible = true
		colorFrame.ClipsDescendants = true
		colorFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		colorFrame.Position = UDim2.fromScale(0.5, 0.5)
		local corner = Instance.new("UICorner")
		corner.Parent = colorFrame
		corner.Name = "corner"
		corner.CornerRadius = UDim.new(1, 0)
		local aspectRatio = Instance.new("UIAspectRatioConstraint")
		aspectRatio.Parent = colorFrame
		aspectRatio.AspectRatio = 1
		aspectRatio.Name = "a"
		local picker = Instance.new("Frame")
		picker.Parent = colorFrame
		picker.Name = "picker"
		picker.BackgroundTransparency = 0
		picker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		picker.BorderSizePixel = 0
		picker.Size = UDim2.fromScale(0.15, 0.15)
		picker.Position = UDim2.new(0, 0, 0, 0)
		picker.Visible = true
		picker.ZIndex = 100
		local pickerAspectRatio = Instance.new("UIAspectRatioConstraint")
		pickerAspectRatio.Parent = picker
		pickerAspectRatio.AspectRatio = 1
		pickerAspectRatio.Name = "a"
		local pickerCorner = Instance.new("UICorner")
		pickerCorner.Parent = picker
		pickerCorner.Name = "corner"
		pickerCorner.CornerRadius = UDim.new(1, 0)
		local decal = Instance.new("ImageButton")
		decal.Image = "rbxassetid://3678860818"
		decal.BackgroundTransparency = 1
		decal.Parent = colorFrame
		decal.Name = "wheel"
		decal.Size = UDim2.fromScale(1, 1)
		decal.Rotation = 180
		self.selectedColor = Color3.fromRGB(255, 255, 255)
		local rainbow = {}
		local _rainbow = rainbow
		local _arg0 = Color3.fromRGB(255, 0, 0)
		local _arg1 = Color3.fromRGB(255, 127, 0)
		local _arg2 = Color3.fromRGB(255, 255, 0)
		local _arg3 = Color3.fromRGB(0, 255, 0)
		local _arg4 = Color3.fromRGB(0, 0, 255)
		local _arg5 = Color3.fromRGB(75, 0, 130)
		local _arg6 = Color3.fromRGB(148, 0, 211)
		-- ▼ Array.push ▼
		local _length = #_rainbow
		_rainbow[_length + 1] = _arg0
		_rainbow[_length + 2] = _arg1
		_rainbow[_length + 3] = _arg2
		_rainbow[_length + 4] = _arg3
		_rainbow[_length + 5] = _arg4
		_rainbow[_length + 6] = _arg5
		_rainbow[_length + 7] = _arg6
		-- ▲ Array.push ▲
		local fakeThis = self
		decal.MouseButton1Up:Connect(function()
			local mouseLoc = game:GetService("Players").LocalPlayer:GetMouse()
			local pos = UDim2.fromOffset(mouseLoc.X, mouseLoc.Y)
			local _myS = picker.AbsoluteSize
			local p = (picker.Parent).AbsolutePosition
			local _pos = pos
			local _arg0_1 = UDim2.fromOffset(p.X, p.Y)
			local res = _pos - _arg0_1
			local myS = UDim2.fromOffset(_myS.X / 2, _myS.Y / 2)
			local _res = res
			local _myS_1 = myS
			picker.Position = _res - _myS_1
			local r = decal.AbsoluteSize.X / 2
			local _vector2 = Vector2.new(mouseLoc.X, mouseLoc.Y)
			local _absolutePosition = decal.AbsolutePosition
			local _arg0_2 = decal.AbsoluteSize / 2
			local d = _vector2 - _absolutePosition - _arg0_2
			if d:Dot(d) > r * r then
				local _unit = d.Unit
				local _r = r
				d = _unit * _r
			end
			local _d = d
			local _vector2_1 = Vector2.new(1, -1)
			local phi = ToPolar(_d * _vector2_1)
			local _d_1 = d
			local _vector2_2 = Vector2.new(1, -1)
			local len = (_d_1 * _vector2_2).Magnitude
			local hue = RadToDegree(phi) / 360
			local saturation = len / r
			fakeThis.selectedColor = Color3.fromHSV(hue, saturation, 1)
		end)
		colorFrame.MouseLeave:Connect(function()
			if fakeThis.uisC ~= nil then
				fakeThis.uisC:Disconnect()
			end
		end)
	end
	function ColorPicker:Disable()
		if self.uisC ~= nil then
			self.uisC:Disconnect()
		end
		self.thisFrame:Destroy()
	end
end
return {
	ColorPicker = ColorPicker,
}
