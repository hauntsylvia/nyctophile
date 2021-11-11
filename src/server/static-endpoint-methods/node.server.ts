import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerState } from "shared/entities/player/player-state"
import { Database } from "server/modules/helpers/database"
import { APIArgs } from "shared/api/api-args"
import { APIRegister } from "server/modules/helpers/api-register"
import { APIResult } from "shared/api/api-result"
import { Node } from "shared/entities/node/node"
import { NodeConfig } from "shared/entities/node/node-config"
import { Placeable } from "shared/entities/node/placeable"
import { NodeHelper } from "server/modules/helpers/node-helper"
import { SetPlayerState } from "server/modules/lib/player-state-consistency"

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
const thisService = new APIRegister("nodes")
const nodes = new Array<Node>()
const tweenService = game.GetService("TweenService")

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

function Internal_CustomizePlaceable(placeable: Placeable, color?: Color3, mat?: Enum.Material, tween?: boolean)
{
    tween = tween ?? true
    let custParts = placeable.GetCustomizeableParts()
    custParts.forEach(part =>
        {
            if(color !== undefined && (part.IsA("Light") || part.IsA("BasePart")))
            {
                if(tween)
                {
                    tweenService.Create(part, new TweenInfo(0.4), {Color: color}).Play()
                }
                else
                {
                    part.Color = color
                }
            }
            if(mat !== undefined && part.IsA("BasePart"))
            {
                part.Material = mat
            }
        })
}

function PlaceNode(args: APIArgs)
{
    let askingPosition = args.clientArgs as Vector3
    for(let i = 0; i < nodes.size(); i++)
    {
        if(nodes[i].owner === args.caller.userId)
        {
            return new APIResult<any>(undefined, "Your node has already been placed.", false)
        }
        else if(nodes[i].position.sub(askingPosition).Magnitude <= nodes[i].config.radius * 2)
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
function CreatePlaceable(args: APIArgs)
{
    let reqPlayersNode = GetSelfNode(args)
    if(reqPlayersNode.success)
    {
        let usersArgs = args.clientArgs as Array<unknown>

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
                    let nodeCanUse: Node | undefined
                    for(let i = 0; i < nodes.size(); i++)
                    {
                        let r = nodes[i].config.radius
                        let isInNode = requestedPosition.Position.sub(nodes[i].position).Magnitude < r
                        let canUseNode = nodes[i].config.trustedUsers.filter(x => x === args.caller.userId).size() > 0 || nodes[i].owner === args.caller.userId
                        // if node isnt players node and doesnt trust the player
                        if(nodes[i].owner !== args.caller.userId && canUseNode && isInNode)
                        {
                            return new APIResult<any>(undefined, "Invalid location: must be placed within a trusted node.", false)
                        }
                        else if(canUseNode && isInNode)
                        {
                            nodeCanUse = nodes[i]
                            break
                        }
                    }
                    if(nodeCanUse !== undefined)
                    {
                        print(args.caller.ashlin)
                        args.caller.ashlin -= realPlaceable.config.cost
                        print(args.caller.ashlin)
                        let color: Color3 | undefined = typeOf(usersArgs[2]) !== undefined ? usersArgs[2] as Color3 : undefined
                        let material: Enum.Material | undefined = typeOf(usersArgs[3]) !== undefined ? usersArgs[3] as Enum.Material : undefined
                        Internal_CustomizePlaceable(realPlaceable, color, material, false)
                        realPlaceable.attachedModel.Parent = game.GetService("Workspace")
                        realPlaceable.attachedModel.SetPrimaryPartCFrame(requestedPosition)
                        playersNode.activePlaceables.push(realPlaceable)
                        
                        SetPlayerState(args.caller)
                        return new APIResult<Placeable>(realPlaceable, "Successfully placed.", true)
                    }
                    else
                    {
                        return new APIResult<any>(undefined, "Invalid location: no node present.", false)
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
function CustomizeExistingPlaceable(args: APIArgs)
{
    let reqPlayersNode = GetSelfNode(args)

    let usersArgs =             args.clientArgs as Array<unknown>
    let requestedPlaceableId =  usersArgs[0] as number
    let color: Color3 | undefined = typeOf(usersArgs[1]) !== undefined ? usersArgs[1] as Color3 : undefined
    let material: Enum.Material | undefined = typeOf(usersArgs[2]) !== undefined ? usersArgs[2] as Enum.Material : undefined

    let thisPlaceable: Placeable | undefined
    let playersNode = reqPlayersNode.result as Node | undefined
    if(playersNode !== undefined)
    { // search players own node first, as this is more likely
        let p = playersNode as Node
        let placeableCustomizing = p.activePlaceables.filter(x => x.id === requestedPlaceableId)
        thisPlaceable = placeableCustomizing.size() > 0 ? placeableCustomizing[0] : undefined
    }
    if(thisPlaceable === undefined)
    { // search all nodes - if user is trusted and placeable id is found, return placeable of id
        for(let i = 0; i < nodes.size(); i++)
        {
            if(nodes[i].config.trustedUsers.filter(x => x === args.caller.userId).size() > 0)
            {
                let a = nodes[i].activePlaceables.filter(x => x.id === requestedPlaceableId)
                if(a.size() > 0)
                {
                    thisPlaceable = a[0]
                }
            }
        }
    }
    if(thisPlaceable !== undefined)
    {
        Internal_CustomizePlaceable(thisPlaceable, color, material)
        return new APIResult<Placeable>(thisPlaceable, "Successfully customized placeable.", true)
    }
    else
    {
        return new APIResult<any>(undefined, "No matching placeable found.", false)
    }
}

thisService.RegisterNewLowerService("create").OnInvoke = PlaceNode
thisService.RegisterNewLowerService("all").OnInvoke = GetAllNodes
thisService.RegisterNewLowerService("me").OnInvoke = GetSelfNode

thisService.RegisterNewLowerService("placeables.create").OnInvoke = CreatePlaceable
thisService.RegisterNewLowerService("placeables.all").OnInvoke = GetAllPlaceables
thisService.RegisterNewLowerService("placeables.customize").OnInvoke = CustomizeExistingPlaceable