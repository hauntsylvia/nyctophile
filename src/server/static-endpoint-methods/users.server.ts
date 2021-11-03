import { PlayerCard } from "shared/entities/playerCard"
import { PlayerState } from "shared/entities/playerState"
import { Database } from "server/modules/database"
import { APIArgs } from "shared/api/apiArgs"
import { APIRegister } from "server/modules/api-register"
import { APIResult } from "shared/api/apiResult"

const thisService = new APIRegister("users")

function GetSelf(args: APIArgs)
{
    print("get self")
    return new APIResult<PlayerState>(args.caller, "")
}
thisService.RegisterNewLowerService("GetSelf").OnInvoke = GetSelf

