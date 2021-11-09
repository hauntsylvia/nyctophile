import { coffee, vanilla, vanillaHalf } from "shared/modules/colors/colors"
import { uiFillTween } from "shared/modules/tweens/tweens"

const tweenService = game.GetService("TweenService")

class UIHover
{
    constructor(hoverOver: GuiButton | GuiLabel, text: string)
    {
        let screenUI = new Instance("ScreenGui")
        screenUI.Name = "hover"
        screenUI.Parent = game.GetService("Players").LocalPlayer.WaitForChild("PlayerGui")
        screenUI.Enabled = true
        let hoverFrame = new Instance("Frame")
        hoverFrame.Parent = screenUI
        hoverFrame.BackgroundTransparency = 0
        hoverFrame.BorderSizePixel = 0
        hoverFrame.BackgroundColor3 = coffee
        hoverFrame.Name = "hover frame"
        let label = new Instance("TextLabel")
        label.Name = "version"
        label.Parent = screenUI
        label.Visible = true
        label.RichText = true
        label.Text = 
        `
        <font size="18" color="rgb(${vanilla.R}, ${vanilla.G}, ${vanilla.B})">
            ${text}
        </font>
        `
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        let isHover = false
        function Hover()
        {
            isHover = !isHover
            let endTransparency = (isHover ? 0 : 1)
            tweenService.Create(hoverFrame, uiFillTween, {BackgroundTransparency: endTransparency}).Play()
            tweenService.Create(label, uiFillTween, {TextTransparency: endTransparency}).Play()
        }
        hoverOver.MouseEnter.Connect(Hover)
        hoverOver.MouseLeave.Connect(Hover)
    }
}

export { UIHover }