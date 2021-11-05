import { PlayerState } from "../player/player-state"

class NodeConfig
{
    radius: number
    trustedUsers: Array<number>
    constructor(radius: number, trustedUsers: Array<number>) 
    { 
        this.radius = radius
        this.trustedUsers = trustedUsers
    }  
}
export { NodeConfig }