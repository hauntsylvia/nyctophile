import { Node } from "shared/entities/node/node"
import { Placeable } from "shared/entities/node/placeable"
import { PlaceableConfig } from "shared/entities/node/placeable-config"
import { BellaEnum } from "shared/modules/enums/bella-enum"


const defaultPlaceableConfig = new PlaceableConfig(10, "Placeable", "A generic placeable.", 5, BellaEnum.placeableCategories.TryParse("misc"))

class NodeHelper
{
    buildablesDirectory: Folder
    constructor(buildablesDirectory: Folder)
    {
        this.buildablesDirectory = buildablesDirectory
    }
    private GetRealPlaceableConfigFromPhysicalConfig(model: Model)
    {
        let fullConfigFolder = model.FindFirstChildWhichIsA("Configuration")
        if(fullConfigFolder !== undefined && fullConfigFolder.IsA("Configuration"))
        {
            let configFolder = fullConfigFolder.WaitForChild("Placeable")
            if(configFolder !== undefined && configFolder.IsA("Configuration"))
            {
                let placeableConfig: PlaceableConfig = new PlaceableConfig
                (
                    defaultPlaceableConfig.cost, 
                    defaultPlaceableConfig.name,
                    defaultPlaceableConfig.description, 
                    defaultPlaceableConfig.maxOfThisAllowed, 
                    defaultPlaceableConfig.placeableCategory
                )
                let categoryV =         configFolder.FindFirstChild("Category")             
                let nameV =             configFolder.FindFirstChild("Name")
                let descriptionV =      configFolder.FindFirstChild("Description")
                let maxAllowedV =       configFolder.FindFirstChild("MaxAllowed")
                let costV =             configFolder.FindFirstChild("Cost")
                
                placeableConfig.placeableCategory   = (categoryV !== undefined && categoryV.IsA("StringValue")) ? BellaEnum.placeableCategories.TryParse(categoryV.Value) : undefined
                placeableConfig.name                = (nameV !== undefined && nameV.IsA("StringValue")) ? nameV.Value : "unknown"
                placeableConfig.description         = (descriptionV !== undefined && descriptionV.IsA("StringValue")) ? descriptionV.Value : "unknown"
                placeableConfig.maxOfThisAllowed    = (maxAllowedV !== undefined && maxAllowedV.IsA("NumberValue")) ? maxAllowedV.Value : 0
                placeableConfig.cost                = (costV !== undefined && costV.IsA("NumberValue")) ? costV.Value : 0
                return placeableConfig
            }
        }
        return defaultPlaceableConfig
    }
    GetAllPossiblePlaceables(hypotheticalOwner: Node)
    {
        let ch = this.buildablesDirectory.GetChildren()
        let p = new Array<Placeable>()
        for(let i = 0; i < ch.size(); i++)
        {
            let thisModel = ch[i]
            if(thisModel.IsA("Model") && thisModel.PrimaryPart !== undefined)
            {
                let parsedConfig = this.GetRealPlaceableConfigFromPhysicalConfig(thisModel)
                let thisPlaceable = new Placeable(hypotheticalOwner, thisModel, parsedConfig, tick())
                p.push((thisPlaceable))
            }
            else if(thisModel.IsA("Model") && thisModel.PrimaryPart === undefined)
            {
                print(`Placeable ${thisModel.GetFullName()} does not have PrimaryPart set.`)
            }
        }
        return p
    }
    GetRealFromUntrustedPlaceable(untrusted: Placeable)
    {
        let allP = this.GetAllPossiblePlaceables(untrusted.ownerNode)
        for(let i = 0; i < allP.size(); i++)
        {
            let thisP = allP[i]
            if(thisP.config.name === untrusted.config.name)
            {
                thisP.attachedModel = thisP.attachedModel.Clone()
                thisP.attachedModel.Name = "_"
                return thisP
            }
        }
    }
}
export { NodeHelper }