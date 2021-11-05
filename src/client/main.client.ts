import { Interactable } from "shared/entities/interactable";
import { Node } from "shared/entities/node/node";
import { BuildSystem } from "./modules/helpers/build-system";
import { Draw } from "./modules/helpers/interactable-draw";
import { Client } from "./modules/net/lib";

const lib = new Client()
const buildSystem = new BuildSystem(lib)

let draws = new Array<Draw>()
let plr = game.GetService("Players").LocalPlayer
let me = lib.GetMe()

const runService = game.GetService("RunService")
const userInputService = game.GetService("UserInputService")

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
            let selfNode = lib.GetNode()
            if(!buildSystem.isEnabled)
            {
                if(selfNode !== undefined)
                {
                    let larry = lib.GetAllPossiblePlaceables()
                    if(larry !== undefined)
                    {
                        let thisModel = larry[0].attachedModel.Clone()
                        thisModel.Parent = game.GetService("Workspace")
                        buildSystem.Enable(thisModel, Enum.UserInputType.MouseButton1, inputObject.KeyCode, false, selfNode)
                    }
                }
                else
                {
                    let nodeModel = new Instance("Model", game.GetService("Workspace"))
                    nodeModel.Name = "temp-node-model"
                    let nodePart = new Instance("Part", nodeModel)
                    nodePart.Name = "temp-node-part"
                    nodeModel.PrimaryPart = nodePart
                    buildSystem.Enable(nodeModel, Enum.UserInputType.MouseButton1, inputObject.KeyCode, false)
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
while(wait(30))
{
    EvaluateInteractables()
}