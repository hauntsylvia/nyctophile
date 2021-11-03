export {}
import {PlayerCard} from "shared/entities/playerCard"
import {PlayerState} from "shared/entities/playerState"
import {Database} from "server/modules/database"

function GetUserById(userId:number)
{
    let databaseNow = new Database()
    return databaseNow.database.GetAsync(tostring(userId))
}