export {}
import {PlayerCard} from "shared/entities/playerCard"
import {PlayerState} from "shared/entities/playerState"
import { Database } from "./modules/database"

const apiDirectory = new Instance("Folder", game.GetService("ReplicatedStorage"))
apiDirectory.Name = "api"

const apiHandler = new Instance("RemoteFunction", apiDirectory)
apiHandler.Name = "event"

const databaseStructure = new Database()

const plrs = new Array<PlayerState>()

apiHandler.OnServerInvoke = function(user, upperServiceName, lowerServiceName, clientsArgs)
{
    try
    {
        let serviceString = ("./static-endpoint-methods/" + (upperServiceName as string)) as string
        let serviceRequesting = import(serviceString)
        
        //serviceRequesting[lowerServiceName as string]()
        let database = databaseStructure.database
        let player
        for(let i = 0; i < plrs.size(); i++)
        {
            if(plrs[i].userId === user.UserId)
            {
                player = plrs[i]
                break
            }
        }
        if(player === undefined)
        {
            player = player ?? database.GetAsync(tostring(user.UserId)) as PlayerState
            plrs.insert(plrs.size(), player)
        }
        player = player ?? new PlayerState(user.UserId, 500, new PlayerCard(0, "new"))
        player.ashlin -= 5
        database.SetAsync(tostring(user.UserId), player)
        return player
    }
    catch(e)
    {
        print(e)
    }
}
