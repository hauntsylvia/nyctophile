import { InteractableConfig } from "./interactable-config"
import { PlayerState } from "./player-state"

class Item
{
    attachedModel: Model
    attachedInteractable: InteractableConfig
    remote: RemoteFunction
    constructor(attachedModel: Model, attachedPlayerUserId: number, attachedInteractable: InteractableConfig, remote: RemoteFunction) 
    { 
        this.attachedModel = attachedModel
        this.attachedInteractable = attachedInteractable
        this.remote = remote
    }
    ServerDo()
    {
        print("empty server item")
    }
}
export { Item }