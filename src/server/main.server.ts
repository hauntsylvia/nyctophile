export { }
import { PlayerCard } from "shared/entities/playerCard"
import { PlayerState } from "shared/entities/playerState"
import { Database } from "./modules/database"
import { APIResult } from "shared/api/apiResult"
import { APIArgs } from "shared/api/apiArgs"

const apiDirectory = new Instance("Folder", game.GetService("ReplicatedStorage"))
apiDirectory.Name = "api"
const apiHandler = new Instance("RemoteFunction", apiDirectory)
apiHandler.Name = "func"
const databaseStructure = new Database()
const plrs = new Array<PlayerState>()

const internalAPIDirectory = new Instance("Folder", game.GetService("ServerStorage"))
internalAPIDirectory.Name = "api"

function GetEquatingBindableFunction(upper: string, lower: string)
{
    for(let i = 0; i < internalAPIDirectory.GetChildren().size(); i++)
    {
        let folderS = internalAPIDirectory.GetChildren()[i]
        if(folderS.IsA("Folder") && folderS.Name.lower() === upper.lower())
        {
            for(let x = 0; x < folderS.GetChildren().size(); x++)
            {
                let f = folderS.GetChildren()[x]
                if(f.IsA("BindableFunction") && f.Name.lower() === lower.lower())
                {
                    return f
                }
            }
        }
    }
}

apiHandler.OnServerInvoke = function(user, _upperServiceName, _lowerServiceName, clientsArgs)
{
    let upperServiceName = _upperServiceName as string
    let lowerServiceName = _lowerServiceName as string
    let apiLowerServices = apiDirectory.FindFirstChild(upperServiceName)
    let currentTarget = GetEquatingBindableFunction(upperServiceName, lowerServiceName)
    if(currentTarget !== undefined)
    {
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
        let apiArgs = new APIArgs(player, clientsArgs)
        let result = currentTarget.Invoke(apiArgs)
        database.SetAsync(tostring(user.UserId), player)
        return result
    }
    else
    {
        return new APIResult<unknown>(undefined, "Service not found.")
    }
}
