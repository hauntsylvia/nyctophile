import { coffee, vanilla, vanillaHalf } from "shared/modules/colors/colors"
import { uiFillTween } from "shared/modules/tweens/tween"

const m = math.floor
const tweenService = game.GetService("TweenService")

class UIHover
{
    constructor(hoverOver: GuiButton | GuiLabel, title: string, text: string)
    {
        let screenUI = new Instance("ScreenGui")
        screenUI.Name = "hover"
        screenUI.Parent = game.GetService("Players").LocalPlayer.WaitForChild("PlayerGui")
        screenUI.Enabled = true
        let hoverFrame = new Instance("Frame")
        hoverFrame.Parent = screenUI
        hoverFrame.BackgroundTransparency = 1
        hoverFrame.BorderSizePixel = 0
        hoverFrame.BackgroundColor3 = coffee
        hoverFrame.Name = "hover frame"
        hoverFrame.Size = UDim2.fromScale(0.1, 0.1)
        let uiAspect = new Instance("UIAspectRatioConstraint")
        uiAspect.Parent = hoverFrame
        uiAspect.AspectRatio = 3
        uiAspect.Name = "ui aspect ratio"
        let divider = new Instance("Frame")
        divider.Parent = hoverFrame
        divider.BorderSizePixel = 0
        divider.BackgroundColor3 = vanillaHalf
        divider.Name = "divider"
        divider.AnchorPoint = new Vector2(0.5, 1)
        divider.Position = UDim2.fromScale(0.5, 0.3)
        divider.Size = new UDim2(0.8, 0, 0, 1)        
        divider.BackgroundTransparency = 1
        let titleLabel = new Instance("TextLabel")
        titleLabel.Name = "version"
        titleLabel.Parent = hoverFrame
        titleLabel.Visible = true
        titleLabel.RichText = true
        titleLabel.Text = `<font size="9" color="rgb(${m(vanilla.R*255)}, ${m(vanilla.G*255)}, ${m(vanilla.B*255)})">${title}</font>`
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextTransparency = 1
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Right
        titleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
        titleLabel.Position = UDim2.fromScale(0, 0)
        titleLabel.Size = UDim2.fromScale(1, 0.3)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        titleLabel.TextYAlignment = Enum.TextYAlignment.Center
        let numSequence = new NumberSequence([new NumberSequenceKeypoint(0, 1), new NumberSequenceKeypoint(0.2, 0), new NumberSequenceKeypoint(0.8, 0), new NumberSequenceKeypoint(1, 1)])
        let uiGradient = new Instance("UIGradient")
        uiGradient.Name = "ui gradient"
        uiGradient.Parent = divider
        uiGradient.Enabled = true
        uiGradient.Color = new ColorSequence(divider.BackgroundColor3)
        uiGradient.Transparency = numSequence
        let label = new Instance("TextLabel")
        label.Name = "version"
        label.Parent = hoverFrame
        label.Visible = true
        label.RichText = true
        label.Text = `<font size="7" color="rgb(${m(vanillaHalf.R*255)}, ${m(vanillaHalf.G*255)}, ${m(vanillaHalf.B*255)})">${text}</font>`
        label.BackgroundTransparency = 1
        label.TextTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        label.Position = UDim2.fromScale(0, 0.2)
        label.Size = UDim2.fromScale(1, 0.8)
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        let isHover = false
        let r: RBXScriptConnection | undefined
        function Hover()
        {
            isHover = !isHover
            let endTransparency = (isHover ? 0 : 1)
            tweenService.Create(hoverFrame, uiFillTween, {BackgroundTransparency: endTransparency}).Play()
            tweenService.Create(label, uiFillTween, {TextTransparency: endTransparency}).Play()
            tweenService.Create(divider, uiFillTween, {BackgroundTransparency: endTransparency}).Play()
            tweenService.Create(titleLabel, uiFillTween, {TextTransparency: endTransparency}).Play()
            if(isHover)
            {
                r = game.GetService("RunService").RenderStepped.Connect(function(dt)
                {
                    let _m = game.GetService("UserInputService").GetMouseLocation()
                    let hFSize = hoverFrame.AbsoluteSize
                    let screenResolution = screenUI.AbsoluteSize
                    let isTooFarRight   = (_m.X + hFSize.X) > screenResolution.X
                    let isTooFarDown    = (_m.Y + hFSize.Y) > screenResolution.Y
                    let m = UDim2.fromOffset(_m.X, (isTooFarDown) ? screenResolution.Y - hFSize.Y : _m.Y)
                    hoverFrame.Position = hoverFrame.Position.Lerp(m, 0.3)
                    let actualAnchorPoint = new Vector2(isTooFarRight ? 1 : 0, 0)
                    hoverFrame.AnchorPoint = hoverFrame.AnchorPoint.Lerp(actualAnchorPoint, 0.3)
                })
            }
            else if(r !== undefined && r.Connected)
            {
                r.Disconnect()
            }
        }
        hoverOver.MouseEnter.Connect(Hover)
        hoverOver.MouseLeave.Connect(Hover)
    }
}

export { UIHover }