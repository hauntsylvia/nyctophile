import { blackCoffee, textCoffee, textVanilla, vanilla } from "shared/modules/colors/colors";

const ts = game.GetService("TweenService")
function RadToDegree(x: number)
{
    return ((x + math.pi) / (2 * math.pi)) * 360;
}
function ToPolar(v: Vector2)
{
    return math.atan2(v.Y, v.X);
}
class ColorPicker
{
    thisFrame: Frame
    selectedColor: Color3 | undefined
    constructor(parentTo: Frame)
    {
        this.thisFrame = new Instance("Frame")
        this.thisFrame.Parent = parentTo
        this.thisFrame.Name = "color-picker"
        this.thisFrame.BackgroundTransparency = 1
        this.thisFrame.BorderSizePixel = 0
        this.thisFrame.Size =       new UDim2(0.95, 0, 0.95, 0)
        this.thisFrame.Position =   new UDim2(0.025, 0, 0.025, 0)
        this.thisFrame.Visible = true
        
        let list = new Instance("UIListLayout")
        list.Parent = this.thisFrame
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.FillDirection = Enum.FillDirection.Horizontal
        list.Name = "ui list"
        list.VerticalAlignment = Enum.VerticalAlignment.Center
        list.Padding = new UDim(0, 14)

        let defaultSetter = new Instance("TextButton")
        defaultSetter.Parent = this.thisFrame
        defaultSetter.Name = "defaultSetter"
        defaultSetter.BorderSizePixel = 0
        defaultSetter.Text = "Default Color"
        defaultSetter.TextSize = 19
        defaultSetter.TextScaled = false
        defaultSetter.Font = Enum.Font.SourceSansSemibold
        defaultSetter.TextXAlignment = Enum.TextXAlignment.Center
        defaultSetter.Size = UDim2.fromScale(0.55, 0.55)
        defaultSetter.Visible = true
        defaultSetter.AnchorPoint = new Vector2(0.5, 0.5)
        defaultSetter.Position = UDim2.fromScale(0.5, 0.5)
        defaultSetter.AutoButtonColor = false

        let defaultSetterCorner = new Instance("UICorner")
        defaultSetterCorner.Parent = defaultSetter
        defaultSetterCorner.Name = "corner"
        defaultSetterCorner.CornerRadius = new UDim(0.2, 0)

        let defaultSetterAspectRatio = new Instance("UIAspectRatioConstraint")
        defaultSetterAspectRatio.Parent = defaultSetter
        defaultSetterAspectRatio.AspectRatio = 3
        defaultSetterAspectRatio.Name = "a"
        
        let colorFrame = new Instance("Frame")
        colorFrame.Parent = this.thisFrame
        colorFrame.Name = "color frame"
        colorFrame.BackgroundTransparency = 0
        colorFrame.BorderSizePixel = 0
        colorFrame.Size = UDim2.fromScale(0.8, 0.8)
        colorFrame.Position = new UDim2(0.05, 0, 0.05, 0)
        colorFrame.Visible = true
        colorFrame.ClipsDescendants = true
        colorFrame.AnchorPoint = new Vector2(0.5, 0.5)
        colorFrame.Position = UDim2.fromScale(0.5, 0.5)

        let corner = new Instance("UICorner")
        corner.Parent = colorFrame
        corner.Name = "corner"
        corner.CornerRadius = new UDim(1, 0)

        let aspectRatio = new Instance("UIAspectRatioConstraint")
        aspectRatio.Parent = colorFrame
        aspectRatio.AspectRatio = 1
        aspectRatio.Name = "a"
        
        let picker = new Instance("Frame")
        picker.Parent = colorFrame
        picker.Name = "picker"
        picker.BackgroundTransparency = 0
        picker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        picker.BorderSizePixel = 0
        picker.Size = UDim2.fromScale(0.15, 0.15)
        picker.Position = new UDim2(0, 0, 0, 0)
        picker.Visible = true
        picker.ZIndex = 100
        
        let pickerAspectRatio = new Instance("UIAspectRatioConstraint")
        pickerAspectRatio.Parent = picker
        pickerAspectRatio.AspectRatio = 1
        pickerAspectRatio.Name = "a"
        
        let pickerCorner = new Instance("UICorner")
        pickerCorner.Parent = picker
        pickerCorner.Name = "corner"
        pickerCorner.CornerRadius = new UDim(1, 0)

        let decal = new Instance("ImageButton")
        decal.Image = "rbxassetid://3678860818"
        decal.BackgroundTransparency = 1
        decal.Parent = colorFrame
        decal.Name = "wheel"
        decal.Size = UDim2.fromScale(1, 1)
        decal.Rotation = 180
        
        let rainbow =new Array<Color3>()
        rainbow.push(Color3.fromRGB(255, 0 , 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130), Color3.fromRGB(148, 0, 211))
       
        let fakeThis = this
        let lastSelectedColor: Color3 = Color3.fromRGB(0, 0, 0)
        function DefaultSetterMB1Up()
        {
            ts.Create(defaultSetter, new TweenInfo(0.075, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), 
            {
                TextColor3: (fakeThis.selectedColor === undefined ? textCoffee : textVanilla), 
                BackgroundColor3: (fakeThis.selectedColor !== undefined ? blackCoffee : vanilla)
            }).Play()
        }
        DefaultSetterMB1Up()
        defaultSetter.MouseButton1Up.Connect(function()
        {        
            fakeThis.selectedColor = fakeThis.selectedColor === undefined ? lastSelectedColor : undefined
            DefaultSetterMB1Up()    
        })
        decal.MouseButton1Up.Connect(function()
        {
            let mouseLoc =      game.GetService("Players").LocalPlayer.GetMouse()
            let pos =           UDim2.fromOffset(mouseLoc.X, mouseLoc.Y)
            let _myS =          picker.AbsoluteSize

            let p =             (picker.Parent as Frame).AbsolutePosition
            let res =           pos.sub(UDim2.fromOffset(p.X, p.Y))
            let myS =           UDim2.fromOffset(_myS.X / 2, _myS.Y / 2)
            picker.Position =   res.sub(myS)


            let r =                         decal.AbsoluteSize.X / 2
            let d =                         new Vector2(mouseLoc.X, mouseLoc.Y).sub(decal.AbsolutePosition).sub(decal.AbsoluteSize.div(2))
            if (d.Dot(d) > r * r)
            {
                d = d.Unit.mul(r);
            }
            let phi =                       ToPolar(d.mul( new Vector2(1, -1) ))
            let len =                       d.mul( new Vector2(1, -1) ).Magnitude
            let hue =                       RadToDegree(phi) / (360) 
            let saturation =                len / r;
            fakeThis.selectedColor =        Color3.fromHSV(hue, saturation, 1)
            lastSelectedColor =             Color3.fromHSV(hue, saturation, 1)
            DefaultSetterMB1Up()
        })
        
    }
    Disable()
    {
        this.thisFrame.Destroy()
    }
}
export { ColorPicker }