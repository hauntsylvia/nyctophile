import { InteractableConfig } from "./interactable-config"

class Interactable
{
    attachedPart: BasePart
    attachedPlayerUserId: number
    config: InteractableConfig
    
    remote: RemoteFunction
    constructor(attachedPart: BasePart, attachedPlayerUserId: number, config: InteractableConfig, remote: RemoteFunction) 
    { 
        this.attachedPart = attachedPart
        this.attachedPlayerUserId = attachedPlayerUserId
        this.config = config
        this.remote = remote
    }
}
export { Interactable }