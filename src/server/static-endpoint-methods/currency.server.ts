import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerState } from "shared/entities/player/player-state"
import { Database } from "server/modules/helpers/database"
import { APIArgs } from "shared/api/api-args"
import { APIRegister } from "shared/modules/api-register"
import { APIResult } from "shared/api/api-result"

const thisService = new APIRegister("currency")

