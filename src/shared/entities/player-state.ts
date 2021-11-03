import { PlayerCard } from "shared/entities/player-card"
import { PlayerSettings } from "./player-settings"
class PlayerState
{
    constructor(userId: number, ashlin: number, playerCard: PlayerCard, playerSettings: PlayerSettings) 
    { 
        this.userId = userId 
        this.ashlin = ashlin
        this.playerCard = playerCard
        this.playerSettings = playerSettings
    }  
    userId: number
    ashlin: number
    playerCard: PlayerCard
    playerSettings: PlayerSettings
    GetAttachedPlayer()
    {
        return game.GetService("Players").GetPlayerByUserId(this.userId)
    }
}
export {PlayerState}