class MaterialPicker
{
    private mats: Array<Enum.Material>
    private u: RBXScriptConnection | undefined
    selectedMat: Enum.Material | undefined
    thisFrame: Frame
    constructor(parent: Frame)
    {
        this.thisFrame = new Instance("Frame")
        this.thisFrame.Parent = parent
        this.thisFrame.Name = "mat-picker"
        this.thisFrame.BackgroundTransparency = 1
        this.thisFrame.BorderSizePixel = 0
        this.thisFrame.Size =       new UDim2(0.95, 0, 0.95, 0)
        this.thisFrame.Position =   new UDim2(0.025, 0, 0.025, 0)
        this.thisFrame.Visible = true
        this.thisFrame.AnchorPoint = new Vector2(0.5, 0.5)
        this.thisFrame.Position = UDim2.fromScale(0.5, 0.5)

        let aspectRatio = new Instance("UIAspectRatioConstraint")
        aspectRatio.Parent = this.thisFrame
        aspectRatio.AspectRatio = 1.5
        aspectRatio.Name = "a"

        let box = new Instance("TextBox")
        box.Parent = this.thisFrame
        box.Name = "box"
        box.BorderSizePixel = 0
        box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        box.PlaceholderText = "Default"
        box.Text = ""
        box.TextSize = 18
        box.TextScaled = false
        box.ClearTextOnFocus = false
        box.TextXAlignment = Enum.TextXAlignment.Center
        box.TextColor3 = Color3.fromRGB(180, 180, 180)
        box.Size = UDim2.fromScale(0.95, 0.95)
        box.Position = new UDim2(0.025, 0, 0.025, 0)
        box.Visible = true
        box.AnchorPoint = new Vector2(0.5, 0.5)
        box.Position = UDim2.fromScale(0.5, 0.5)

        let corner = new Instance("UICorner")
        corner.Parent = box
        corner.Name = "corner"
        corner.CornerRadius = new UDim(0, 18)
        
        this.mats = Enum.Material.GetEnumItems()

        let fakeThis = this
        this.u = game.GetService("UserInputService").InputEnded.Connect(function(inputObject, isProcessed)
        {
            if(!isProcessed)
            {
                if(inputObject.KeyCode === Enum.KeyCode.Return)
                {
                    for(let i = 0; i < fakeThis.mats.size(); i++)
                    {
                        if(fakeThis.mats[i].Name.lower() === box.Text.lower())
                        {
                            fakeThis.selectedMat = fakeThis.mats[i]
                            break
                        }
                    }
                }
            }
        })
    }
    Disable()
    {
        if(this.u !== undefined)
        {
            this.u.Disconnect()
        }
        this.thisFrame.Destroy()
    }
}
export { MaterialPicker }