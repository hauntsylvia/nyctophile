import { PlayerCard } from "shared/entities/player-card"
import { PlayerKeySettings } from "shared/entities/player-key-settings"
import { PlayerSettings } from "shared/entities/player-settings"
import { PlayerState } from "shared/entities/player-state"

const players = new Array<PlayerState>()
class Database
{
    constructor()
    {
        let name = ("11-02-2021.A.1")
        this.database = game.GetService("DataStoreService").GetDataStore(name)
    }
    GetPlayerState(user: Player)
    {
        let player
        for(let i = 0; i < players.size(); i++)
        {
            if(players[i].userId === user.UserId)
            {
                player = players[i]
                break
            }
        }
        if(player === undefined)
        {
            player = player ?? this.database.GetAsync(tostring(user.UserId)) as PlayerState
            if(player === undefined)
            {
                player = new PlayerState
                (
                    user.UserId, 
                    500,
                    new PlayerCard
                    (
                        0, 
                        "new"
                    ), 
                    new PlayerSettings
                    (
                        new PlayerKeySettings
                        (
                            "E",
                            "G"
                        )
                    )
                )
            }
            players.push(player)
        }
        return player
    }
    SavePlayerState(player: PlayerState)
    {
        let d = this.database
        d.SetAsync(tostring(player.userId), player)
    }
    database: GlobalDataStore
}
export {Database}