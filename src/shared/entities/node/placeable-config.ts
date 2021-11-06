class PlaceableConfig
{
    cost: number
    name: string
    description: string
    maxOfThisAllowed: number
    placeableCategory: PlaceableCategories
    constructor(cost: number, name: string, description: string, maxOfThisAllowed: number, placeableCategory: PlaceableCategories)
    {
        this.cost = cost
        this.name = name
        this.description = description
        this.maxOfThisAllowed = maxOfThisAllowed
        this.placeableCategory = placeableCategory
    }
}
enum PlaceableCategories
{
    Furniture,
    Production,
    Defense,
    Lighting,
    
    Misc
}
export { PlaceableConfig, PlaceableCategories }