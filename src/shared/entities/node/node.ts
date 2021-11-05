import { PlayerState } from "../player/player-state"
import { NodeConfig } from "./node-config"
import { Placeable } from "./placeable"

class Node
{
    owner: PlayerState
    position: Vector3
    config: NodeConfig
    activePlaceables: Array<Placeable>
    constructor(owner: PlayerState, position: Vector3, config: NodeConfig) 
    { 
        this.owner = owner
        this.position = position
        this.config = config
        this.activePlaceables = new Array<Placeable>()
    }  
}
export { Node }