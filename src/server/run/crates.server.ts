export {}
import { Database } from "server/modules/helpers/database"
import { InteractableHelper } from "server/modules/helpers/interactable-helper"
import { Interactable } from "shared/entities/interactable"
import { InteractableConfig } from "shared/entities/interactable-config"
let h = new InteractableHelper()
const db = new Database()
let allCrates = game.GetService("Workspace").WaitForChild("Crates").GetChildren()
function GenerateRandom()
{
    
}
for(let i = 0; i < allCrates.size(); i++)
{
    let bp = (allCrates[i] as Model).PrimaryPart
    if(bp !== undefined)
    {
        let crateRemote = new Instance("RemoteFunction")
        crateRemote.Name = "interact"
        crateRemote.Parent = bp       
        let thisInteractable = new Interactable(bp as Part, 0, new InteractableConfig("Crate", "A generic crate containing misc. items.", 24), crateRemote)
        crateRemote.OnServerInvoke = function(user)
        {
            let player = db.GetPlayerState(user)

        }
        
        h.RegisterInteractable(thisInteractable)
    }
    else
    {
        print("no primary part for this interactable crate")
    }
}