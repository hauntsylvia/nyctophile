import { PlayerState } from "shared/entities/playerState"
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