import { InteractableConfig } from "./interactable-config"
import { PlayerState } from "./player-state"

class Interactable
{
    attachedPart: Part
    attachedPlayerUserId: number
    config: InteractableConfig
    constructor(attachedPart: Part, attachedPlayerUserId: number, config: InteractableConfig) 
    { 
        this.attachedPart = attachedPart
        this.attachedPlayerUserId = attachedPlayerUserId
        this.config = config
    }  
    IsRegisteredToAllPlayers()
    {
        return this.attachedPlayerUserId <= 0
    }
}
export {Interactable}