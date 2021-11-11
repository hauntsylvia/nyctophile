-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local coffee = _colors.coffee
local vanilla = _colors.vanilla
local vanillaHalf = _colors.vanillaHalf
local uiFillTween = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "tweens", "tween").uiFillTween
local m = math.floor
local tweenService = game:GetService("TweenService")
local UIHover
do
	UIHover = setmetatable({}, {
		__tostring = function()
			return "UIHover"
		end,
	})
	UIHover.__index = UIHover
	function UIHover.new(...)
		local self = setmetatable({}, UIHover)
		return self:constructor(...) or self
	end
	function UIHover:constructor(hoverOver, title, text)
		local screenUI = Instance.new("ScreenGui")
		screenUI.Name = "hover"
		screenUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		screenUI.Enabled = true
		local hoverFrame = Instance.new("Frame")
		hoverFrame.Parent = screenUI
		hoverFrame.BackgroundTransparency = 1
		hoverFrame.BorderSizePixel = 0
		hoverFrame.BackgroundColor3 = coffee
		hoverFrame.Name = "hover frame"
		hoverFrame.Size = UDim2.fromScale(0.1, 0.1)
		local uiAspect = Instance.new("UIAspectRatioConstraint")
		uiAspect.Parent = hoverFrame
		uiAspect.AspectRatio = 3
		uiAspect.Name = "ui aspect ratio"
		local divider = Instance.new("Frame")
		divider.Parent = hoverFrame
		divider.BorderSizePixel = 0
		divider.BackgroundColor3 = vanillaHalf
		divider.Name = "divider"
		divider.AnchorPoint = Vector2.new(0.5, 1)
		divider.Position = UDim2.fromScale(0.5, 0.3)
		divider.Size = UDim2.new(0.8, 0, 0, 1)
		divider.BackgroundTransparency = 1
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "version"
		titleLabel.Parent = hoverFrame
		titleLabel.Visible = true
		titleLabel.RichText = true
		titleLabel.Text = '<font size="9" color="rgb(' .. (tostring(m(vanilla.R * 255)) .. (", " .. (tostring(m(vanilla.G * 255)) .. (", " .. (tostring(m(vanilla.B * 255)) .. (')">' .. (title .. "</font>")))))))
		titleLabel.BackgroundTransparency = 1
		titleLabel.TextTransparency = 1
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextXAlignment = Enum.TextXAlignment.Right
		titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		titleLabel.Position = UDim2.fromScale(0, 0)
		titleLabel.Size = UDim2.fromScale(1, 0.3)
		titleLabel.TextXAlignment = Enum.TextXAlignment.Center
		titleLabel.TextYAlignment = Enum.TextYAlignment.Center
		local numSequence = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 1) })
		local uiGradient = Instance.new("UIGradient")
		uiGradient.Name = "ui gradient"
		uiGradient.Parent = divider
		uiGradient.Enabled = true
		uiGradient.Color = ColorSequence.new(divider.BackgroundColor3)
		uiGradient.Transparency = numSequence
		local label = Instance.new("TextLabel")
		label.Name = "version"
		label.Parent = hoverFrame
		label.Visible = true
		label.RichText = true
		label.Text = '<font size="7" color="rgb(' .. (tostring(m(vanillaHalf.R * 255)) .. (", " .. (tostring(m(vanillaHalf.G * 255)) .. (", " .. (tostring(m(vanillaHalf.B * 255)) .. (')">' .. (text .. "</font>")))))))
		label.BackgroundTransparency = 1
		label.TextTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextXAlignment = Enum.TextXAlignment.Right
		label.TextYAlignment = Enum.TextYAlignment.Bottom
		label.Position = UDim2.fromScale(0, 0.2)
		label.Size = UDim2.fromScale(1, 0.8)
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.TextYAlignment = Enum.TextYAlignment.Center
		local isHover = false
		local r
		local function Hover()
			isHover = not isHover
			local endTransparency = (isHover and 0 or 1)
			tweenService:Create(hoverFrame, uiFillTween, {
				BackgroundTransparency = endTransparency,
			}):Play()
			tweenService:Create(label, uiFillTween, {
				TextTransparency = endTransparency,
			}):Play()
			tweenService:Create(divider, uiFillTween, {
				BackgroundTransparency = endTransparency,
			}):Play()
			tweenService:Create(titleLabel, uiFillTween, {
				TextTransparency = endTransparency,
			}):Play()
			if isHover then
				r = game:GetService("RunService").RenderStepped:Connect(function(dt)
					local _m = game:GetService("UserInputService"):GetMouseLocation()
					local hFSize = hoverFrame.AbsoluteSize
					local screenResolution = screenUI.AbsoluteSize
					local isTooFarRight = (_m.X + hFSize.X) > screenResolution.X
					local isTooFarDown = (_m.Y + hFSize.Y) > screenResolution.Y
					local m = UDim2.fromOffset(_m.X, isTooFarDown and screenResolution.Y - hFSize.Y or _m.Y)
					hoverFrame.Position = hoverFrame.Position:Lerp(m, 0.3)
					local actualAnchorPoint = Vector2.new(isTooFarRight and 1 or 0, 0)
					hoverFrame.AnchorPoint = hoverFrame.AnchorPoint:Lerp(actualAnchorPoint, 0.3)
				end)
			elseif r ~= nil and r.Connected then
				r:Disconnect()
			end
		end
		hoverOver.MouseEnter:Connect(Hover)
		hoverOver.MouseLeave:Connect(Hover)
	end
end
return {
	UIHover = UIHover,
}
