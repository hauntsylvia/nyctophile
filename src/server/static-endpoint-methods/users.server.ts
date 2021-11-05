import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerState } from "shared/entities/player/player-state"
import { Database } from "server/modules/helpers/database"
import { APIArgs } from "shared/api/api-args"
import { APIRegister } from "shared/modules/api-register"
import { APIResult } from "shared/api/api-result"

const thisService = new APIRegister("users")

function GetSelf(args: APIArgs)
{
    print("get self")
    return new APIResult<PlayerState>(args.caller, "", true)
}
function GetPlayerRotations(args: APIArgs)
{

}
function UpdatePlayerRotations(args: APIArgs)
{
    
}

thisService.RegisterNewLowerService("me").OnInvoke = GetSelf
thisService.RegisterNewLowerService("getplayerrotations").OnInvoke = GetSelf
