import { Interactable } from "shared/entities/interactable";
import { Node } from "shared/entities/node/node";
import { NodeConfig } from "shared/entities/node/node-config";
import { Placeable } from "shared/entities/node/placeable";
import { PlaceableConfig } from "shared/entities/node/placeable-config";
import { blackCoffee, coffee, textCoffee, textVanilla, vanilla, vanillaHalf } from "shared/modules/colors/colors";
import { BellaEnum, BellaEnumValue } from "shared/modules/enums/bella-enum";
import { BuildSystem } from "./modules/helpers/build-system";
import { Draw } from "./modules/helpers/interactable-draw";
import { Client } from "./modules/net/lib";
import { ColorPicker } from "./modules/ui/color-picker";
import { MaterialPicker } from "./modules/ui/material-picker";

const lib = new Client()

let draws = new Array<Draw>()
let plr = game.GetService("Players").LocalPlayer
let me = lib.GetMe()
let node: Node | undefined

const buildSystem = new BuildSystem(lib)
const buildUI = plr.WaitForChild("PlayerGui").WaitForChild("BuildingsGUI") as ScreenGui

const runService = game.GetService("RunService")
const userInputService = game.GetService("UserInputService")
const tweenService = game.GetService("TweenService")

const ti = new TweenInfo(0.075, Enum.EasingStyle.Quint)

let canInteractableHeartbeatRun = true
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
                    tweenService.Create(lastSel, ti, {TextColor3: textVanilla}).Play()
                    tweenService.Create(lastFr, ti, {BackgroundColor3: coffee}).Play()
                }
                tweenService.Create(baseTextBtn, ti, {TextColor3: textCoffee}).Play()
                tweenService.Create(base, ti, {BackgroundColor3: vanilla}).Play()
                lastSel = baseTextBtn
                lastFr = base
                DrawBuildUIItems(placeableEnums[i])
            }
            baseTextBtn.MouseButton1Up.Connect(Press)
            baseImageBtn.MouseButton1Up.Connect(Press)
        }
    }
}
function DrawBuildUIItems(category: BellaEnumValue)
{
    let customizeableFrame = buildUI.FindFirstChild("Screen")?.FindFirstChild("Customization") as Frame
    let scrollFrame = buildUI.FindFirstChild("Screen")?.FindFirstChild("Placeables")?.FindFirstChild("Placeables") as ScrollingFrame
    let children = scrollFrame?.GetChildren()
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
                        let t = desc.IsA("TextButton") ? tweenService.Create(desc, ti, {TextTransparency: 1, BackgroundTransparency: 1}) : tweenService.Create(desc, ti, {Transparency: 1, BackgroundTransparency: 1})
                        t.Play()
                    }
                })
                tweenService.Create(thisChild, ti, {Transparency: 1, BackgroundTransparency: 1}).Play()
                coroutine.resume(coroutine.create(function()
                {
                    wait(ti.Time)
                    thisChild.Destroy()
                }))
            }
        }
    }
    wait(ti.Time)
    let larry = lib.GetAllPossiblePlaceables()
    if(larry !== undefined && node !== undefined)
    {
        let lastButtonSel:  TextButton | undefined
        let lastFrameSel:   Frame | undefined
        for(let i = 0; i < larry.size(); i++)
        {
            if(larry[i].config.placeableCategory === category || (larry[i].config.placeableCategory === undefined && category === BellaEnum.placeableCategories.TryParse("misc")))
            {
                let placementUIFrame = scrollFrame?.FindFirstChild("A")?.Clone() as Frame
                placementUIFrame.Parent = scrollFrame
                placementUIFrame.Visible = true
                placementUIFrame.Name = "_"
                placementUIFrame.BackgroundTransparency = 1
                placementUIFrame.BackgroundColor3 = coffee
                tweenService.Create(placementUIFrame, ti, {BackgroundTransparency: 0}).Play()
                let b = placementUIFrame.FindFirstChild("B") as TextButton
                b.Text = larry[i].config.name
                b.TextColor3 = textVanilla
                b.MouseButton1Up.Connect(function()
                {
                    if(larry !== undefined && larry.size() > 0)
                    {
                        if(lastButtonSel !== undefined && lastFrameSel !== undefined)
                        {
                            tweenService.Create(lastFrameSel, ti, {BackgroundColor3: coffee}).Play()
                            tweenService.Create(lastButtonSel, ti, {TextColor3: textVanilla}).Play()
                        }
                        lastFrameSel = placementUIFrame
                        lastButtonSel = b
                        buildSystem.Disable()
                        buildSystem.Enable(larry[i], undefined, undefined, node)
                        tweenService.Create(placementUIFrame, ti, {BackgroundColor3: vanilla}).Play()
                        tweenService.Create(b, ti, {TextColor3: textCoffee}).Play()
                        lastColorPicker = lastColorPicker ?? new ColorPicker(customizeableFrame.FindFirstChild("ColorPicker") as Frame)
                        lastMatPicker = lastMatPicker ?? new MaterialPicker(customizeableFrame.FindFirstChild("MaterialPicker") as Frame)
                        canInteractableHeartbeatRun = false
                        let uisEv = userInputService.InputEnded.Connect(function(inputObj, isProcessed)
                        {
                            if(!isProcessed && inputObj.UserInputType === Enum.UserInputType.MouseButton1 && larry !== undefined && lastColorPicker !== undefined && lastMatPicker !== undefined && buildSystem.isEnabled)
                            {
                                let placeable = lib.PlacePlaceable(larry[i], buildSystem.actualResult, lastColorPicker.selectedColor, lastMatPicker.selectedMat)
                                if(placeable !== undefined)
                                {
                                    tweenService.Create(placementUIFrame, ti, {BackgroundColor3: coffee}).Play()
                                    tweenService.Create(b, ti, {TextColor3: textVanilla}).Play()
                                    canInteractableHeartbeatRun = true
                                    buildSystem.Disable()
                                    uisEv.Disconnect()
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
    if(draws.size() > 0 && canInteractableHeartbeatRun)
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
    else
    {
        if(closestDraw !== undefined)
        {
            closestDraw.Disable()
        }
    }
})
let lastColorPicker: ColorPicker | undefined
let lastMatPicker: MaterialPicker | undefined
userInputService.InputEnded.Connect(function(inputObject, isProcessed)
{
    if(!isProcessed && me !== undefined)
    {
        let keySettings = me.playerSettings.playerKeys
        if(inputObject.KeyCode.Name === keySettings.interactKey && closestDraw !== undefined && closestDraw.IsInRange(plr) && canInteractableHeartbeatRun)
        {
            closestDraw.Interact()
        }
        else if(inputObject.KeyCode.Name === keySettings.buildSystemKey)
        {
            let selfNode = node ?? lib.GetNode()
            node = selfNode
            if(!buildSystem.isEnabled)
            {
                if(selfNode !== undefined)
                {
                    buildUI.Enabled = !buildUI.Enabled
                    if(buildUI.Enabled)
                    {
                        DrawBuildUICategories()
                    }
                }
                else
                {
                    let acceptInpType = Enum.UserInputType.MouseButton1
                    buildSystem.Enable(new Placeable(new Node(me.userId, new Vector3(0, 0, 0), new NodeConfig(0, new Array())), buildSystem.MakeNodeRepresentation(), new PlaceableConfig(1, "", "", 0, undefined), 0), acceptInpType)
                }
            }
            else
            {
                buildSystem.Disable()
            }
        }
    }
})
EvaluateInteractables()
while(wait(120))
{
    EvaluateInteractables()
}