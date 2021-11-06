import { Interactable } from "shared/entities/interactable";
import { Node } from "shared/entities/node/node";
import { NodeConfig } from "shared/entities/node/node-config";
import { Placeable } from "shared/entities/node/placeable";
import { PlaceableCategories, PlaceableConfig } from "shared/entities/node/placeable-config";
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
const buildUI = plr.WaitForChild("PlayerGui").WaitForChild("BuildingsGUI")

const runService = game.GetService("RunService")
const userInputService = game.GetService("UserInputService")
const tweenService = game.GetService("TweenService")

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
    if(draws.size() > 0)
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
})
let lastColorPicker: ColorPicker | undefined
let lastMatPicker: MaterialPicker | undefined
userInputService.InputEnded.Connect(function(inputObject, isProcessed)
{
    if(!isProcessed && me !== undefined)
    {
        let keySettings = me.playerSettings.playerKeys
        if(inputObject.KeyCode.Name === keySettings.interactKey && closestDraw !== undefined && closestDraw.IsInRange(plr))
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
                    let customizeableFrame = buildUI.FindFirstChild("Screen")?.FindFirstChild("Customization") as Frame
                    let scrollFrame = buildUI.FindFirstChild("Screen")?.FindFirstChild("Placeables")?.FindFirstChild("Placeables") as ScrollingFrame
                    let children = scrollFrame?.GetChildren()
                    if(children !== undefined)
                    {
                        for(let i = 0; i < children.size(); i++)
                        {
                            if(children[i].Name.lower() !== "a" && children[i].IsA("Frame"))
                            {
                                children[i].Destroy()
                            }
                        }
                    }
                    let larry = lib.GetAllPossiblePlaceables()
                    if(larry !== undefined)
                    {
                        for(let i = 0; i < larry.size(); i++)
                        {
                            let placementUIFrame = scrollFrame?.FindFirstChild("A")?.Clone() as Frame
                            placementUIFrame.Parent = scrollFrame
                            placementUIFrame.Visible = true
                            placementUIFrame.Name = "_"
                            placementUIFrame.BackgroundTransparency = 1
                            tweenService.Create(placementUIFrame, new TweenInfo(0.2), {BackgroundTransparency: 0}).Play()
                            let b = placementUIFrame.FindFirstChild("B") as TextButton
                            print(larry[i].config.name)
                            b.Text = larry[i].config.name
                            b.MouseButton1Up.Connect(function()
                            {
                                if(larry !== undefined && larry.size() > 0)
                                {
                                    buildSystem.Disable()
                                    buildSystem.Enable(larry[i], undefined, undefined, selfNode)
                                    lastColorPicker = lastColorPicker ?? new ColorPicker(customizeableFrame.FindFirstChild("ColorPicker") as Frame)
                                    lastMatPicker = lastMatPicker ?? new MaterialPicker(customizeableFrame.FindFirstChild("MaterialPicker") as Frame)
                                    let uisEv = userInputService.InputBegan.Connect(function(inputObj, isProcessed)
                                    {
                                        if(!isProcessed && inputObj.UserInputType === Enum.UserInputType.MouseButton1 && larry !== undefined && lastColorPicker !== undefined && lastMatPicker !== undefined)
                                        {
                                            let ar = new Array<any>()
                                            ar.push(larry[i], buildSystem.actualResult)
                                            let placeable = lib.PlacePlaceable(ar)
                                            if(placeable !== undefined)
                                            {
                                                buildSystem.Disable()
                                                lib.CustomizePlaceable(placeable.id, lastColorPicker.selectedColor, lastMatPicker.selectedMat)
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
                else
                {
                    let acceptInpType = Enum.UserInputType.MouseButton1
                    buildSystem.Enable(new Placeable(new Node(me.userId, new Vector3(0, 0, 0), new NodeConfig(0, new Array())), buildSystem.MakeNodeRepresentation(), new PlaceableConfig(1, "", "", 0, PlaceableCategories.Misc), 0), acceptInpType)
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