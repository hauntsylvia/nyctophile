import { PlayerState } from "shared/entities/playerState"
class APIArgs
{
    constructor(caller: PlayerState) 
    { 
        this.caller = caller 
    }  
    caller: PlayerState
}
export {APIArgs}