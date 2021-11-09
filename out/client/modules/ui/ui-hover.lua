-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local coffee = _colors.coffee
local vanilla = _colors.vanilla
local uiFillTween = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "tweens", "tweens").uiFillTween
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
	function UIHover:constructor(hoverOver, text)
		local screenUI = Instance.new("ScreenGui")
		screenUI.Name = "hover"
		screenUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		screenUI.Enabled = true
		local hoverFrame = Instance.new("Frame")
		hoverFrame.Parent = screenUI
		hoverFrame.BackgroundTransparency = 0
		hoverFrame.BorderSizePixel = 0
		hoverFrame.BackgroundColor3 = coffee
		hoverFrame.Name = "hover frame"
		local label = Instance.new("TextLabel")
		label.Name = "version"
		label.Parent = screenUI
		label.Visible = true
		label.RichText = true
		label.Text = [[
        <font size="18" color="rgb(]] .. (tostring(vanilla.R) .. (", " .. (tostring(vanilla.G) .. (", " .. (tostring(vanilla.B) .. ([[)">
            ]] .. (text .. [[
        </font>
        ]])))))))
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Right
		label.TextYAlignment = Enum.TextYAlignment.Bottom
		local isHover = false
		local function Hover()
			isHover = not isHover
			local endTransparency = (isHover and 0 or 1)
			tweenService:Create(hoverFrame, uiFillTween, {
				BackgroundTransparency = endTransparency,
			}):Play()
			tweenService:Create(label, uiFillTween, {
				TextTransparency = endTransparency,
			}):Play()
		end
		hoverOver.MouseEnter:Connect(Hover)
		hoverOver.MouseLeave:Connect(Hover)
	end
end
return {
	UIHover = UIHover,
}
