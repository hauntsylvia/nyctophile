import { Node } from "./node";
import { PlaceableConfig } from "./placeable-config"

class Placeable
{
    ownerNode: Node
    attachedModel: Model
    config: PlaceableConfig
    id: number
    constructor(ownerNode: Node, attachedModel: Model, config: PlaceableConfig, id: number)
    {
        this.ownerNode = ownerNode
        this.attachedModel = attachedModel
        this.config = config
        this.id = id
    }
    GetCustomizeableParts()
    {
        let toReturn = new Array<BasePart>()
        let d = this.attachedModel.GetDescendants()
        for(let i = 0; i < d.size(); i++)
        {
            let thisDescendant = d[i]
            if(thisDescendant.IsA("Configuration") && thisDescendant.Parent !== this.attachedModel)
            {
                if(thisDescendant.Parent !== undefined)
                {
                    let theseChildren = thisDescendant.Parent.GetChildren()
                    for(let childrenOf = 0; childrenOf < theseChildren.size(); childrenOf++)
                    {
                        let thisChild = theseChildren[childrenOf]
                        if(thisChild.IsA("BasePart"))
                        {
                            toReturn.push(thisChild)
                        }
                    }
                }
            }
        }
        return toReturn
    }
}
export { Placeable }