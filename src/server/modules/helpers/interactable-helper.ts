import { Interactable } from "shared/entities/interactable/interactable"
import { PlayerState } from "shared/entities/player/player-state"

const allInteractablesRegistered = new Array<Interactable>()
class InteractableHelper
{
    constructor()
    {
    }
    GetInteractablesOfPlayerByUserId(userId: number)
    {
        let arrayRes = new Array<Interactable>()
        for(let i = 0; i < allInteractablesRegistered.size(); i++)
        {
            if(allInteractablesRegistered[i].attachedPlayerUserId === userId || allInteractablesRegistered[i].attachedPlayerUserId <= 0)
            {
                arrayRes.push(allInteractablesRegistered[i])
            }
        }
        return arrayRes
    }
    GetInteractablesOfPlayerByState(player: PlayerState)
    {
        return this.GetInteractablesOfPlayerByUserId(player.userId)
    }
    RegisterInteractable(interactable: Interactable)
    {
        allInteractablesRegistered.push(interactable)
    }
}
export { InteractableHelper }