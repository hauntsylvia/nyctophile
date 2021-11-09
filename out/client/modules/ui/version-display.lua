-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _colors = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "colors", "colors")
local vanilla = _colors.vanilla
local vanillaHalf = _colors.vanillaHalf
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
		label.Name = "version"
		label.Parent = screenUI
		label.Visible = true
		label.RichText = true
		label.Text = [[
        <font size="11" color="rgb(]] .. (tostring(vanilla.R) .. (", " .. (tostring(vanilla.G) .. (", " .. (tostring(vanilla.B) .. ([[)">
            ]] .. (tostring(version.major) .. ([[.
            ]] .. (tostring(version.minor) .. ([[.
            ]] .. (tostring(version.build) .. ([[.
        </font>
        <font size="11" color="rgb(]] .. (tostring(vanillaHalf.R) .. (", " .. (tostring(vanillaHalf.G) .. (", " .. (tostring(vanillaHalf.B) .. ([[)">
            ]] .. (tostring(version.revision) .. [[
        </font>
        ]])))))))))))))))))))
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Right
		label.TextYAlignment = Enum.TextYAlignment.Bottom
	end
end
return {
	VersionDisplayLabel = VersionDisplayLabel,
}
