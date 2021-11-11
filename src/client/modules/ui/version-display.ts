import { NyctoVersion } from "shared/entities/nycto-version"
import { vanilla, vanillaHalf } from "shared/modules/colors/colors"
import { UIHover } from "./ui-hover"
const m = math.floor
class VersionDisplayLabel
{
    constructor(version: NyctoVersion)
    {
        let screenUI = new Instance("ScreenGui")
        screenUI.Name = "version"
        screenUI.Parent = game.GetService("Players").LocalPlayer.WaitForChild("PlayerGui")
        screenUI.Enabled = true
        let label = new Instance("TextLabel")
        label.RichText = true
        label.Position = UDim2.fromScale(0.9, 0.95)
        label.Size = UDim2.fromScale(0.1, 0.05)
        label.Name = "version"
        label.Parent = screenUI
        label.Visible = true
        label.Text = 
        `<font size="8" color=\"rgb(${m(vanilla.R*255)}, ${m(vanilla.G*255)}, ${m(vanilla.B*255)})\">${version.major}.${version.minor}.${version.build}</font><font size="8" color=\"rgb(${m(vanillaHalf.R*255)}, ${m(vanillaHalf.G*255)}, ${m(vanillaHalf.B*255)})\">.[${version.revision}]</font>`
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        label.ZIndex = 0x7FFFFFFF

        let uiHover = new UIHover(label, "version", `${version.major}.${version.minor}.${version.build}.${version.revision}`)
    }
}

export { VersionDisplayLabel }