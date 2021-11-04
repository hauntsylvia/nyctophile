import { PlayerCard } from "shared/entities/player/player-card"
import { PlayerInventory } from "./player-inventory"
import { PlayerSettings } from "./player-settings"
class PlayerState
{
    constructor(userId: number, ashlin: number, playerCard: PlayerCard, playerSettings: PlayerSettings, playerInventory: PlayerInventory) 
    { 
        this.userId = userId 
        this.ashlin = ashlin
        this.playerCard = playerCard
        this.playerSettings = playerSettings
        this.playerInventory = playerInventory
    }  
    userId: number
    ashlin: number
    playerCard: PlayerCard
    playerSettings: PlayerSettings
    playerInventory: PlayerInventory
    GetAttachedPlayer()
    {
        return game.GetService("Players").GetPlayerByUserId(this.userId)
    }
}
export {PlayerState}