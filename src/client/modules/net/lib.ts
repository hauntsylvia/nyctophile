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
        let n = this.client.Send<Array< Partial<Node> >>("nodes", "all", undefined)
        return n
    }
    PlacePlaceable(placeable: Placeable)
    {
        let n = this.client.Send<Array<Placeable>>("nodes", "placeables.create", placeable)
        return n
    }
    GetAllPossiblePlaceables()
    {
        let n = this.client.Send<Array<Placeable>>("nodes", "placeables.all", undefined)
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