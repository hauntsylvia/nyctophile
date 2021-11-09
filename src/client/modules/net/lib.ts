import { APIResult } from "shared/api/api-result"
import { Interactable } from "shared/entities/interactable"
import { Node } from "shared/entities/node/node"
import { Placeable } from "shared/entities/node/placeable"
import { PlayerState } from "shared/entities/player/player-state"

class Client
{
    client: InternalClient
    constructor()
    {
        this.client = new InternalClient()
    }
    GetMe()
    {
        let me = this.client.Send<PlayerState>("users", "me", undefined)
        return me
    }
    GetPlayerRotations(player: Player)
    {
        let rots = this.client.Send<CFrame>("users", "getplayerrotations", player.UserId)
        return rots
    }
    GetInteractables()
    {
        let ints = this.client.Send<Array<Interactable>>("interactables", "getcurrent", undefined)
        return ints
    }
    PlaceNode(position: Vector3)
    {
        let n = this.client.Send<Node>("nodes", "create", position)
        return n
    }
    GetNode()
    {
        let n = this.client.Send<Node>("nodes", "me", undefined)
        return n
    }
    GetAllOtherPlayersNodes()
    {
        let n = this.client.Send<Array<Node>>("nodes", "all", undefined)
        return n
    }
    PlacePlaceable(placeable: Placeable, c: CFrame, color?: Color3, material?: Enum.Material)
    {
        let toSend = new Array<any>(3)
        toSend[0] = placeable
        toSend[1] = c
        toSend[2] = color
        toSend[3] = material
        let n = this.client.Send<Placeable>("nodes", "placeables.create", toSend)
        return n
    }
    GetAllPossiblePlaceables()
    {
        let n = this.client.Send<Array<Placeable>>("nodes", "placeables.all", undefined)
        return n
    }
    CustomizePlaceable(placeableId: number, color?: Color3, material?: Enum.Material)
    {
        let toSend = new Array<any>(3)
        toSend[0] = placeableId
        toSend[1] = color
        toSend[2] = material
        let n = this.client.Send<Placeable>("nodes", "placeables.customize", toSend)
        return n
    }
}

class InternalClient
{
    Send<T>(lower: string, upper: string, args: any)
    {
        let myEvents = game.GetService("ReplicatedStorage").WaitForChild("player")
        let serversEvent = game.GetService("ReplicatedStorage").WaitForChild("api").WaitForChild("func")
        if(serversEvent.IsA("RemoteFunction"))
        {
            let result = serversEvent.InvokeServer(lower, upper, args) as APIResult<T>
            if(!result.success)
            {
                print(`- - ${result.message} - -`)
            }
            return result.result
        }
    }
}
export { Client }