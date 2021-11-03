import { PlayerCard } from "shared/entities/player-card"
class PlayerState
{
    constructor(userId: number, ashlin: number, playerCard: PlayerCard) 
    { 
        this.userId = userId 
        this.ashlin = ashlin
        this.playerCard = playerCard
    }  
    userId: number
    ashlin: number
    playerCard: PlayerCard
    GetAttachedPlayer()
    {
        return game.GetService("Players").GetPlayerByUserId(this.userId)
    }
}
export {PlayerState}