import { Interactable } from "./interactable/interactable"
import { InteractableConfig } from "./interactable/interactable-config"
import { PlayerState } from "./player/player-state"

class Item
{
    attachedModel: Model
    attachedInteractable: Interactable
    remote: RemoteFunction
    constructor(attachedModel: Model, attachedInteractable: Interactable, remote: RemoteFunction) 
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