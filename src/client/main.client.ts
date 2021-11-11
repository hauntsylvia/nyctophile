import { Interactable } from "shared/entities/interactable/interactable";
import { Node } from "shared/entities/node/node";
import { NodeConfig } from "shared/entities/node/node-config";
import { Placeable } from "shared/entities/node/placeable";
import { PlaceableConfig } from "shared/entities/node/placeable-config";
import { blackCoffee, coffee, textCoffee, textVanilla, vanilla, vanillaHalf } from "shared/modules/colors/colors";
import { BellaEnum, BellaEnumValue } from "shared/modules/enums/bella-enum";
import { uiFillTween } from "shared/modules/tweens/tween";
import { BuildSystem } from "./modules/helpers/build-system";
import { Draw } from "./modules/helpers/interactable-draw";
import { Client } from "./modules/net/lib";
import { ColorPicker } from "./modules/ui/color-picker";
import { MaterialPicker } from "./modules/ui/material-picker";
import { UIHover } from "./modules/ui/ui-hover";
import { VersionDisplayLabel } from "./modules/ui/version-display";

const lib = new Client()
const plr = game.GetService("Players").LocalPlayer

let draws = new Array<Draw>()
let me = lib.GetMe()
let node: Node | undefined
let buildUIEnabled = false
let lastColorPicker: ColorPicker | undefined
let lastMatPicker: MaterialPicker | undefined

const buildSystem = new BuildSystem(lib)
const buildUI = plr.WaitForChild("PlayerGui").WaitForChild("BuildingsGUI") as ScreenGui
const buildUIScreen = (buildUI.WaitForChild("Screen") as Frame)
buildUIScreen.Position = UDim2.fromScale(1, 0)

const runService = game.GetService("RunService")
const userInputService = game.GetService("UserInputService")
const tweenService = game.GetService("TweenService")

function VersionDisplay()
{
    let versDisplay = new VersionDisplayLabel(lib.gameVersion)
}
VersionDisplay()
function DrawBuildUICategories()
{
    let fr = buildUI.WaitForChild("Screen").WaitForChild("Categorization").WaitForChild("InternalFrame")
    if(fr !== undefined && fr.IsA("Frame"))
    {
        let chldrn = fr.GetChildren()
        for(let i = 0; i < chldrn.size(); i++)
        {
            if(chldrn[i].Name.lower() !== "a" && chldrn[i].IsA("Frame"))
            {
                chldrn[i].Destroy()
            }
        }
        let placeableEnums = BellaEnum.placeableCategories.GetEnums()
        let lastSel: TextButton | undefined
        let lastFr: Frame | undefined
        for(let i = 0; i < placeableEnums.size(); i++)
        {
            let base = (fr.WaitForChild("A") as Frame).Clone()
            base.BackgroundColor3 = coffee
            base.Name = "B"
            base.Parent = fr
            base.Visible = true
            let baseTextBtn = (base.WaitForChild("B") as TextButton)
            let baseImageBtn = (base.WaitForChild("I") as ImageButton)
            baseTextBtn.Font = Enum.Font.SourceSansItalic
            baseTextBtn.TextSize = 18
            baseTextBtn.TextColor3 = textVanilla
            baseTextBtn.Text = placeableEnums[i].name
            function Press()
            {
                if((lastSel !== undefined && lastFr !== undefined) || (lastSel === baseTextBtn && lastFr === base))
                {
                    tweenService.Create(lastSel, uiFillTween, {TextColor3: textVanilla}).Play()
                    tweenService.Create(lastFr, uiFillTween, {BackgroundColor3: coffee}).Play()
                }
                if(buildSystem.isEnabled)
                {
                    if(lastUIS !== undefined)
                    {
                        lastUIS.Disconnect()
                    }
                    buildSystem.Disable()
                }
                DrawBuildUIItems(placeableEnums[i])
                tweenService.Create(baseTextBtn, uiFillTween, {TextColor3: textCoffee}).Play()
                tweenService.Create(base, uiFillTween, {BackgroundColor3: vanilla}).Play()
                lastSel = baseTextBtn
                lastFr = base
            }
            baseTextBtn.MouseButton1Up.Connect(Press)
            baseImageBtn.MouseButton1Up.Connect(Press)
        }
    }
}
let lastUIS: RBXScriptConnection | undefined
let allUIHovers = new Array<UIHover>()
function DrawBuildUIItems(category: BellaEnumValue)
{
    let customizeableFrame = buildUI.FindFirstChild("Screen")?.FindFirstChild("Customization") as Frame
    let scrollFrame = buildUI.FindFirstChild("Screen")?.FindFirstChild("Placeables")?.FindFirstChild("Placeables") as ScrollingFrame
    let children = scrollFrame?.GetChildren()
    for(let i = 0; i < allUIHovers.size(); i++)
    {
        allUIHovers[i].Dispose()
    }
    if(children !== undefined)
    {
        for(let i = 0; i < children.size(); i++)
        {
            let thisChild = children[i]
            if(thisChild.Name.lower() !== "a" && thisChild.IsA("Frame"))
            {
                thisChild.GetDescendants().forEach(desc =>
                {
                    if(desc.IsA("GuiButton"))
                    {
                        let t = desc.IsA("TextButton") ? tweenService.Create(desc, uiFillTween, {TextTransparency: 1, BackgroundTransparency: 1}) : tweenService.Create(desc, uiFillTween, {Transparency: 1, BackgroundTransparency: 1})
                        t.Play()
                    }
                })
                tweenService.Create(thisChild, uiFillTween, {Transparency: 1, BackgroundTransparency: 1}).Play()
                coroutine.resume(coroutine.create(function()
                {
                    wait(uiFillTween.Time)
                    thisChild.Destroy()
                }))
            }
        }
    }
    wait(uiFillTween.Time)
    let larry = lib.GetAllPossiblePlaceables()
    if(larry !== undefined && node !== undefined)
    {
        let lastButtonSel:  TextButton | undefined
        let lastFrameSel:   Frame | undefined
        for(let i = 0; i < larry.size(); i++)
        {
            if((larry[i].config.placeableCategory !== undefined && category.name === larry[i].config.placeableCategory?.name) || (larry[i].config.placeableCategory === undefined && category === BellaEnum.placeableCategories.TryParse("misc")))
            {
                let placementUIFrame = scrollFrame?.FindFirstChild("A")?.Clone() as Frame
                placementUIFrame.Parent = scrollFrame
                placementUIFrame.Visible = true
                placementUIFrame.Name = "_"
                placementUIFrame.BackgroundTransparency = 1
                placementUIFrame.BackgroundColor3 = blackCoffee
                let uiHvr = new UIHover(placementUIFrame, larry[i].config.name, `[$${larry[i].config.cost}]\n${larry[i].config.description}`)
                allUIHovers.push(uiHvr)
                let b = placementUIFrame.FindFirstChild("B") as TextButton
                b.Font = Enum.Font.SourceSansItalic
                b.Text = larry[i].config.name
                b.TextTransparency = 1
                b.TextColor3 = textVanilla
                tweenService.Create(placementUIFrame, uiFillTween, {BackgroundTransparency: 0, Transparency: 0}).Play()
                tweenService.Create(b, uiFillTween, {TextTransparency: 0}).Play()
                b.MouseButton1Up.Connect(function()
                {
                    if(larry !== undefined && larry.size() > 0)
                    {
                        if(lastButtonSel !== undefined && lastFrameSel !== undefined)
                        {
                            tweenService.Create(lastFrameSel, uiFillTween, {BackgroundColor3: blackCoffee}).Play()
                            tweenService.Create(lastButtonSel, uiFillTween, {TextColor3: textVanilla}).Play()
                        }
                        if(lastUIS !== undefined)
                        {
                            lastUIS.Disconnect()
                        }
                        lastFrameSel = placementUIFrame
                        lastButtonSel = b
                        buildSystem.Disable()
                        buildSystem.Enable(larry[i], undefined, undefined, node)
                        tweenService.Create(placementUIFrame, uiFillTween, {BackgroundColor3: vanilla}).Play()
                        tweenService.Create(b, uiFillTween, {TextColor3: textCoffee}).Play()
                        lastColorPicker = lastColorPicker ?? new ColorPicker(customizeableFrame.FindFirstChild("ColorPicker") as Frame)
                        lastMatPicker = lastMatPicker ?? new MaterialPicker(customizeableFrame.FindFirstChild("MaterialPicker") as Frame)
                        lastUIS = userInputService.InputEnded.Connect(function(inputObj, isProcessed)
                        {
                            if(!isProcessed && inputObj.UserInputType === Enum.UserInputType.MouseButton1 && larry !== undefined && lastColorPicker !== undefined && lastMatPicker !== undefined && buildSystem.isEnabled && lastUIS?.Connected)
                            {
                                let placeable = lib.PlacePlaceable(larry[i], buildSystem.actualResult, lastColorPicker.selectedColor, lastMatPicker.selectedMat)
                                if(placeable !== undefined)
                                {
                                    tweenService.Create(placementUIFrame, uiFillTween, {BackgroundColor3: blackCoffee}).Play()
                                    tweenService.Create(b, uiFillTween, {TextColor3: textVanilla}).Play()
                                    buildSystem.Disable()
                                    if(lastUIS !== undefined)
                                    {
                                        lastUIS.Disconnect()
                                    }
                                }
                            }
                        })
                    }
                    else
                    {
                        print("No placeables.")
                    }
                })
            }
        }
    }
}
function EvaluateInteractables()
{
    let ints = lib.GetInteractables()
    if(ints !== undefined)
    {
        for(let i = 0; i < ints.size(); i++)
        {
            let canPush = true
            for(let x = 0; x < draws.size(); x++)
            {
                if(draws[x].int.attachedPart === ints[i].attachedPart)
                {
                    canPush = false
                    break
                }
            }
            if(canPush)
            {
                draws.push(new Draw(ints[i]))
            }
        }
    }
    else
    {
        print("ints undefined")
    }
}
let closestDraw: Draw | undefined = undefined
runService.Heartbeat.Connect(function(deltaTime)
{
    if(draws.size() > 0 && !buildSystem.isEnabled)
    {
        for(let i = 0; i < draws.size(); i++)
        {
            if(closestDraw !== undefined)
            {
                let int = draws[i]
                let distanceOfCurrentIteration  = int.GetDistanceFromPlayer(plr)
                let currentDistance             = closestDraw.GetDistanceFromPlayer(plr)
                let inRange                     = int.IsInRange(plr)
                if((distanceOfCurrentIteration < currentDistance) && inRange)
                {
                    closestDraw.Disable()
                    closestDraw = draws[i]
                }
            }
            else
            {
                closestDraw = draws[i]
            }
        }
        if(closestDraw !== undefined && !closestDraw.isEnabled)
        {
            closestDraw.Enable(true, plr)
        }
    }
    else if(buildSystem.isEnabled)
    {
        for(let i = 0; i < draws.size(); i++)
        {
            let int = draws[i]
            if(int !== undefined)
            {
                int.Disable()
            }
        }
    }
})
userInputService.InputEnded.Connect(function(inputObject, isProcessed)
{
    if(!isProcessed && me !== undefined)
    {
        let keySettings = me.playerSettings.playerKeys
        if(inputObject.KeyCode.Name === keySettings.interactKey && closestDraw !== undefined && closestDraw.IsInRange(plr) && !buildSystem.isEnabled)
        {
            closestDraw.Interact()
        }
        else if(inputObject.KeyCode.Name === keySettings.buildSystemKey)
        {
            node = node ?? lib.GetNode()
            if(!buildSystem.isEnabled)
            {
                if(node !== undefined)
                {
                    if(buildUIEnabled)
                    {
                        tweenService.Create((buildUI.WaitForChild("Screen") as Frame), new TweenInfo(uiFillTween.Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position: UDim2.fromScale(1, 0)}).Play()
                    }
                    else
                    {
                        tweenService.Create((buildUI.WaitForChild("Screen") as Frame), new TweenInfo(uiFillTween.Time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position: UDim2.fromScale(0, 0)}).Play()

                    }
                    buildUIEnabled = !buildUIEnabled
                }
                else
                {
                    let acceptInpType = Enum.UserInputType.MouseButton1
                    buildSystem.Enable(new Placeable(new Node(me.userId, new Vector3(0, 0, 0), new NodeConfig(0, new Array())), buildSystem.MakeNodeRepresentation(), new PlaceableConfig(1, "", "", 0, undefined), 0), acceptInpType)
                }
            }
            else
            {
                if(lastUIS !== undefined)
                {
                    lastUIS.Disconnect()
                }
                buildSystem.Disable()
            }
        }
    }
})
DrawBuildUICategories()
EvaluateInteractables()
while(wait(120))
{
    EvaluateInteractables()
}