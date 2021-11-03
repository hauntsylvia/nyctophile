import { APIResult } from "shared/api/api-result"
import { Interactable } from "shared/entities/interactable"
import { PlayerState } from "shared/entities/player-state"

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
}

class InternalClient
{
    Send<T>(lower: string, upper: string, args: any)
    {
        try
        {
            let myEvents = game.GetService("ReplicatedStorage").WaitForChild("player")
            let serversEvent = game.GetService("ReplicatedStorage").WaitForChild("api").WaitForChild("func")
            if(serversEvent.IsA("RemoteFunction"))
            {
                let result = serversEvent.InvokeServer(lower, upper, args) as APIResult<T>
                return result.result
            }
        }
        catch
        {
            return undefined
        }
        return undefined
    }
}
export { Client }