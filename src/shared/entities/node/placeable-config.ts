import { BellaEnumValue } from "shared/modules/enums/bella-enum"

class PlaceableConfig
{
    cost: number
    name: string
    description: string
    maxOfThisAllowed: number
    placeableCategory: BellaEnumValue | undefined
    constructor(cost: number, name: string, description: string, maxOfThisAllowed: number, placeableCategory?: BellaEnumValue)
    {
        this.cost = cost
        this.name = name
        this.description = description
        this.maxOfThisAllowed = maxOfThisAllowed
        this.placeableCategory = placeableCategory
    }
}
export { PlaceableConfig }