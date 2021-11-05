import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerState } from "shared/entities/player/player-state"
import { Database } from "server/modules/helpers/database"
import { APIArgs } from "shared/api/api-args"
import { APIRegister } from "shared/modules/api-register"
import { APIResult } from "shared/api/api-result"
import { Node } from "shared/entities/node/node"
import { NodeConfig } from "shared/entities/node/node-config"
import { Placeable } from "shared/entities/node/placeable"
import { NodeHelper } from "server/modules/helpers/node-helper"

const thisService = new APIRegister("nodes")
const nodes = new Array<Node>()
let helper: NodeHelper

let dir = game.GetService("ReplicatedStorage").FindFirstChild("Placeables")
if(dir === undefined)
{
    const dir = new Instance("Folder", game.GetService("ReplicatedStorage"))
    dir.Name = "Placeables"
    helper = new NodeHelper(dir)
}
else
{
    helper = new NodeHelper(dir as Folder)
}

const globalConfig = new NodeConfig(100, new Array<number>())

game.GetService("Players").PlayerRemoving.Connect(function(user)
{
    for(let i = 0; i < nodes.size(); i++)
    {
        if(user.UserId === nodes[i].owner)
        {
            let nodeRemoving = nodes.remove(i)
            if(nodeRemoving !== undefined)
            {
                print(`node at ${nodeRemoving.position} removed from global array`)
            }
            break
        }
    }
})

function PlaceNode(args: APIArgs)
{
    let askingPosition = args.clientArgs as Vector3
    for(let i = 0; i < nodes.size(); i++)
    {
        if(nodes[i].owner === args.caller.userId)
        {
            return new APIResult<any>(undefined, "Your node has already been placed.", false)
        }
        else if(nodes[i].position.sub(askingPosition).Magnitude <= nodes[i].config.radius)
        {
            return new APIResult<any>(undefined, "Can not place a node inside another player's node.", false)
        }
    }
    let newNode = new Node(args.caller.userId, askingPosition, globalConfig)
    nodes.push(newNode)
    return new APIResult<Node>(newNode, "Node successfully created and placed.", true)
}
function GetAllNodes(args: APIArgs)
{
    return new APIResult<  Array< Node >  >(nodes, "Successfully grabbed all other nodes in game.", true)
}
function GetSelfNode(args: APIArgs)
{
    for(let i = 0; i < nodes.size(); i++)
    {
        if(nodes[i].owner === args.caller.userId)
        {
            return new APIResult<Node>(nodes[i], "Successfully fetched your node.", true)
        }
    }
    return new APIResult<any>(undefined, "Node not found.", false)
}
function CreateStructure(args: APIArgs)
{
    let reqPlayersNode = GetSelfNode(args)
    if(reqPlayersNode.success)
    {
        let playersNode = reqPlayersNode.result as Node
        let requestedPlaceable = (args.clientArgs as Array<any>)[0] as Placeable
        let requestedPosition = (args.clientArgs as Array<any>)[1] as CFrame
        let realPlaceable = helper.GetRealFromUntrustedPlaceable(requestedPlaceable)
        if(realPlaceable !== undefined)
        {
            if(args.caller.ashlin >= realPlaceable.config.cost)
            {
                let numberOfThisAlreadyPlaced = 0
                numberOfThisAlreadyPlaced = playersNode.activePlaceables.filter(x => x.config.name === realPlaceable?.config.name).size()
                if(numberOfThisAlreadyPlaced < realPlaceable.config.maxOfThisAllowed)
                {
                    if(playersNode.position.sub(requestedPosition.Position).Magnitude <= playersNode.config.radius)
                    {
                        args.caller.ashlin -= realPlaceable.config.cost
                        realPlaceable.attachedModel.Parent = game.GetService("Workspace")
                        realPlaceable.attachedModel.SetPrimaryPartCFrame(requestedPosition)
                        return new APIResult<Placeable>(realPlaceable, "Successfully placed.", true)
                    }
                    else
                    {
                        return new APIResult<any>(undefined, "Invalid location. Placeable must be inside of node.", false)
                    }
                }
                else
                {
                    return new APIResult<any>(undefined, "Maximum number of this placeable reached.", false)
                }
            }
            else
            {
                return new APIResult<any>(undefined, "You do not have enough ashlin to build this.", false)
            }
        }
        else
        {
            return new APIResult<any>(undefined, "No real placeable equivalent found.", false)
        }
    }
    else
    {
        return reqPlayersNode
    }
}
function GetAllPlaceables(args: APIArgs)
{
    let reqPlayersNode = GetSelfNode(args)
    
    if(reqPlayersNode.success)
    {
        let all = helper.GetAllPossiblePlaceables(reqPlayersNode.result)
        return new APIResult<Array<Placeable>>(all, "Successfully fetched all possible placeables.", true) 
    }
    return reqPlayersNode
}

thisService.RegisterNewLowerService("create").OnInvoke = PlaceNode
thisService.RegisterNewLowerService("all").OnInvoke = GetAllNodes
thisService.RegisterNewLowerService("me").OnInvoke = GetSelfNode
thisService.RegisterNewLowerService("placeables.create").OnInvoke = CreateStructure
thisService.RegisterNewLowerService("placeables.all").OnInvoke = GetAllPlaceables
