class PlaceableConfig
{
    cost: number
    name: string
    description: string
    maxOfThisAllowed: number
    constructor(cost: number, name: string, description: string, maxOfThisAllowed: number)
    {
        this.cost = cost
        this.name = name
        this.description = description
        this.maxOfThisAllowed = maxOfThisAllowed
    }
}
export { PlaceableConfig }