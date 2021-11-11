import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerState } from "shared/entities/player/player-state"
import { Database } from "server/modules/helpers/database"
import { APIArgs } from "shared/api/api-args"
import { APIRegister } from "server/modules/helpers/api-register"
import { APIResult } from "shared/api/api-result"
import { NyctoVersion } from "shared/entities/nycto-version"

const thisService = new APIRegister("version")
const versionDatabase = new Database("version_11-10-2021.A.1")
let thisVersion: NyctoVersion
let preV = versionDatabase.GetObject<NyctoVersion>("v") 
if(preV !== undefined)
{
    let v = preV
    v.build++
    thisVersion = v
}
else
{
    thisVersion = new NyctoVersion(0, 1, 0, (DateTime.now().UnixTimestamp - os.time({year: 2020, month: 4, day: 15})) / 2)
}
versionDatabase.SaveObject("v", thisVersion)

thisService.RegisterNewLowerService("v").OnInvoke = function(args: APIArgs)
{
    return new APIResult<NyctoVersion>(thisVersion, "", true)
}