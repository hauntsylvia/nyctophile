import { PlayerState } from "shared/entities/player/player-state"
class APIArgs
{
    constructor(caller: PlayerState, clientArgs: any) 
    { 
        this.caller = caller 
        this.clientArgs = clientArgs
    }  
    caller: PlayerState
    clientArgs: any
}
export {APIArgs}