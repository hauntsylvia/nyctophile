-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local vanilla = _colors.vanilla
local vanillaHalf = _colors.vanillaHalf
local UIHover = TS.import(script, script.Parent, "ui-hover").UIHover
local m = math.floor
local VersionDisplayLabel
do
	VersionDisplayLabel = setmetatable({}, {
		__tostring = function()
			return "VersionDisplayLabel"
		end,
	})
	VersionDisplayLabel.__index = VersionDisplayLabel
	function VersionDisplayLabel.new(...)
		local self = setmetatable({}, VersionDisplayLabel)
		return self:constructor(...) or self
	end
	function VersionDisplayLabel:constructor(version)
		local screenUI = Instance.new("ScreenGui")
		screenUI.Name = "version"
		screenUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		screenUI.Enabled = true
		local label = Instance.new("TextLabel")
		label.RichText = true
		label.Position = UDim2.fromScale(0.9, 0.95)
		label.Size = UDim2.fromScale(0.1, 0.05)
		label.Name = "version"
		label.Parent = screenUI
		label.Visible = true
		label.Text = '<font size="8" color=\"rgb(' .. (tostring(m(vanilla.R * 255)) .. (", " .. (tostring(m(vanilla.G * 255)) .. (", " .. (tostring(m(vanilla.B * 255)) .. (')\">' .. (tostring(version.major) .. ("." .. (tostring(version.minor) .. ("." .. (tostring(version.build) .. ('</font><font size="8" color=\"rgb(' .. (tostring(m(vanillaHalf.R * 255)) .. (", " .. (tostring(m(vanillaHalf.G * 255)) .. (", " .. (tostring(m(vanillaHalf.B * 255)) .. (')\">.[' .. (tostring(version.revision) .. "]</font>")))))))))))))))))))
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Right
		label.TextYAlignment = Enum.TextYAlignment.Bottom
		label.ZIndex = 0x7FFFFFFF
		local uiHover = UIHover.new(label, "version", tostring(version.major) .. ("." .. (tostring(version.minor) .. ("." .. (tostring(version.build) .. ("." .. tostring(version.revision)))))))
	end
end
return {
	VersionDisplayLabel = VersionDisplayLabel,
}
