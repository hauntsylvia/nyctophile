import { Node } from "shared/entities/node/node"
import { Placeable } from "shared/entities/node/placeable"
import { PlaceableConfig } from "shared/entities/node/placeable-config"

const defaultPlaceableConfig = new PlaceableConfig(10, "Placeable", "A generic placeable.", 5)

class NodeHelper
{
    buildablesDirectory: Folder
    constructor(buildablesDirectory: Folder)
    {
        this.buildablesDirectory = buildablesDirectory
    }
    private GetRealPlaceableConfigFromPhysicalConfig(model: Model)
    {
        let configFolder = model.FindFirstChild("config")
        if(configFolder !== undefined && configFolder.IsA("Configuration"))
        {
            let placeableConfig = defaultPlaceableConfig
            let module = configFolder.FindFirstChildWhichIsA("ModuleScript")
            if(module !== undefined)
            {
                placeableConfig = (require(module) as PlaceableConfig) ?? defaultPlaceableConfig
                return placeableConfig
            }
        }
        return defaultPlaceableConfig
    }
    GetAllPossiblePlaceables(hypotheticalOwner: Node)
    {
        let placeables = new Array<Placeable>()
        let ch = this.buildablesDirectory.GetChildren()
        for(let i = 0; i < ch.size(); i++)
        {
            let thisModel = ch[i]
            if(thisModel.IsA("Model") && thisModel.PrimaryPart !== undefined)
            {
                placeables.push(new Placeable(hypotheticalOwner, thisModel, this.GetRealPlaceableConfigFromPhysicalConfig(thisModel)))
            }
        }
        return placeables
    }
    GetRealFromUntrustedPlaceable(placeable: Placeable)
    {
        let allP = this.GetAllPossiblePlaceables(placeable.ownerNode)
        for(let i = 0; i < allP.size(); i++)
        {
            let thisP = allP[i]
            if(thisP.attachedModel === placeable.attachedModel)
            {
                return thisP
            }
        }
    }
}
export { NodeHelper }