import { Interactable } from "shared/entities/interactable";
import { Node } from "shared/entities/node/node";
import { NodeConfig } from "shared/entities/node/node-config";
import { Placeable } from "shared/entities/node/placeable";
import { PlaceableConfig } from "shared/entities/node/placeable-config";
import { BuildSystem } from "./modules/helpers/build-system";
import { Draw } from "./modules/helpers/interactable-draw";
import { Client } from "./modules/net/lib";

const lib = new Client()
const buildSystem = new BuildSystem(lib)

let draws = new Array<Draw>()
let plr = game.GetService("Players").LocalPlayer
let me = lib.GetMe()
let node: Node | undefined

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
            let selfNode = node ?? lib.GetNode()
            node = selfNode
            if(!buildSystem.isEnabled)
            {
                if(selfNode !== undefined)
                {
                    let larry = lib.GetAllPossiblePlaceables()
                    if(larry !== undefined && larry.size() > 0)
                    {
                        let thisModel = larry[0].attachedModel.Clone()
                        thisModel.Parent = game.GetService("Workspace")
                        buildSystem.Enable(new Placeable(selfNode, thisModel, new PlaceableConfig(1, "", "", 0)), Enum.UserInputType.MouseButton1, undefined, selfNode)
                    }
                    else
                    {
                        print("No placeables.")
                    }
                }
                else
                {
                    
                    let acceptInpType = Enum.UserInputType.MouseButton1
                    buildSystem.Enable(new Placeable(new Node(me.userId, new Vector3(0, 0, 0), new NodeConfig(0, new Array())), buildSystem.MakeNodeRepresentation(), new PlaceableConfig(1, "", "", 0)), acceptInpType)
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