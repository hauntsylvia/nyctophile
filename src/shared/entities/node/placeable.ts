import { Node } from "./node";
import { PlaceableConfig } from "./placeable-config"

class Placeable
{
    ownerNode: Node
    attachedModel: Model
    config: PlaceableConfig
    constructor(ownerNode: Node, attachedModel: Model, config: PlaceableConfig)
    {
        this.ownerNode = ownerNode
        this.attachedModel = attachedModel
        this.config = config
    }
}
export { Placeable }