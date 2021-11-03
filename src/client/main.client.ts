import { APIResult } from "shared/api/apiResult"
import { PlayerState } from "shared/entities/playerState"

const apiEndpoint = game.GetService("ReplicatedStorage").WaitForChild("api").WaitForChild("func") as RemoteFunction
let me = (apiEndpoint.InvokeServer("users", "GetSelf") as APIResult<PlayerState>)
print(`$${me.result.ashlin}`)