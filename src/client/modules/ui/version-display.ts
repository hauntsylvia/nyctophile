import { NyctoVersion } from "shared/entities/nycto-version"
import { vanilla, vanillaHalf } from "shared/modules/colors/colors"

class VersionDisplayLabel
{
    constructor(version: NyctoVersion)
    {
        let screenUI = new Instance("ScreenGui")
        screenUI.Name = "version"
        screenUI.Parent = game.GetService("Players").LocalPlayer.WaitForChild("PlayerGui")
        screenUI.Enabled = true
        let label = new Instance("TextLabel")
        label.Name = "version"
        label.Parent = screenUI
        label.Visible = true
        label.RichText = true
        label.Text = 
        `
        <font size="11" color="rgb(${vanilla.R}, ${vanilla.G}, ${vanilla.B})">
            ${version.major}.
            ${version.minor}.
            ${version.build}.
        </font>
        <font size="11" color="rgb(${vanillaHalf.R}, ${vanillaHalf.G}, ${vanillaHalf.B})">
            ${version.revision}
        </font>
        `
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.TextYAlignment = Enum.TextYAlignment.Bottom
    }
}

export { VersionDisplayLabel }