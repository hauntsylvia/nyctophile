import { coffee, textVanilla, vanilla, vanillaHalf } from "shared/modules/colors/colors"

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
        box.BackgroundColor3 = coffee
        box.PlaceholderText = "Default Material"
        box.PlaceholderColor3 = vanillaHalf
        box.Text = ""
        box.TextSize = 18
        box.TextScaled = false
        box.ClearTextOnFocus = false
        box.TextXAlignment = Enum.TextXAlignment.Center
        box.TextColor3 = textVanilla
        box.Size = UDim2.fromScale(1, 1)
        box.Visible = true

        let boxCorner = new Instance("UICorner")
        boxCorner.Parent = box
        boxCorner.Name = "corner"
        boxCorner.CornerRadius = new UDim(1, 0)

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
                    let foundMat: Enum.Material | undefined
                    for(let i = 0; i < fakeThis.mats.size(); i++)
                    {
                        if(fakeThis.mats[i].Name.lower() === box.Text.lower())
                        {
                            foundMat = fakeThis.mats[i]
                        }
                    }
                    if(foundMat === undefined)
                    {
                        fakeThis.selectedMat = undefined
                    }
                    else
                    {
                        fakeThis.selectedMat = foundMat
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