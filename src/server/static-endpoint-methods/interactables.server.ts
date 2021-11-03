import { PlayerCard } from "shared/entities/player-card"
import { PlayerState } from "shared/entities/player-state"
import { Database } from "server/modules/helpers/database"
import { APIArgs } from "shared/api/api-args"
import { APIRegister } from "shared/modules/api-register"
import { APIResult } from "shared/api/api-result"
import { InteractableHelper } from "server/modules/helpers/interactable-helper"
import { Interactable } from "shared/entities/interactable"

const thisService = new APIRegister("interactables")
const h = new InteractableHelper()

function GetCurrent(args: APIArgs)
{
    let arrayOfInteractables = h.GetInteractablesOfPlayerByUserId(args.caller.userId)
    return new APIResult<Array<Interactable>>(arrayOfInteractables, "")
}

thisService.RegisterNewLowerService("getcurrent").OnInvoke = GetCurrent
export {}
