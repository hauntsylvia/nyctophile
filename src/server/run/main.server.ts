export { }
import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerState } from "shared/entities/player/player-state"
import { Database } from "../modules/helpers/database"
import { APIResult } from "shared/api/api-result"
import { APIArgs } from "shared/api/api-args"
import { PlayerSettings } from "shared/entities/player/player-settings"
import { PlayerKeySettings } from "shared/entities/player/player-key-settings"

const playerDirectory = new Instance("Folder", game.GetService("ReplicatedStorage"))
playerDirectory.Name = "player"

const apiDirectory = new Instance("Folder", game.GetService("ReplicatedStorage"))
apiDirectory.Name = "api"
const apiHandler = new Instance("RemoteFunction", apiDirectory)
apiHandler.Name = "func"
const database = new Database()

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
    try
    {
        let upperServiceName = _upperServiceName as string
        let lowerServiceName = _lowerServiceName as string
        let currentTarget = GetEquatingBindableFunction(upperServiceName, lowerServiceName)
        if(currentTarget !== undefined)
        {
            let apiArgs = new APIArgs(database.GetPlayerState(user), clientsArgs)
            let result = currentTarget.Invoke(apiArgs)
            return result
        }
        else
        {
            return new APIResult<unknown>(undefined, "Service not found.")
        }
    }
    catch
    {
        return new APIResult<unknown>(undefined, "Malformed client data or internal server failure.")
    }
}

game.GetService("Players").PlayerRemoving.Connect(function(user)
{
    database.SavePlayerState(database.GetPlayerState(user))
})
