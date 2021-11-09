class BellaMainEnum
{
    enums: Array<BellaEnumValue>
    constructor(enums: Array<BellaEnumValue>)
    {
        this.enums = enums
    }
    GetEnums(): Array<BellaEnumValue>
    {
        return this.enums
    }
    TryParse(name: string): BellaEnumValue | undefined
    {
        for(let i = 0; i < this.enums.size(); i++)
        {
            if(this.enums[i].name.lower() === name.lower())
            {
                return this.enums[i]
            }
        }
    }
}
class BellaEnumValue
{
    name: string
    constructor(name: string)
    {
        this.name = name
    }
}
class BellaEnum
{
    static placeableCategories: BellaMainEnum = new BellaMainEnum(
    [
        new BellaEnumValue("Furniture"),
        new BellaEnumValue("Production"),
        new BellaEnumValue("Defense"),
        new BellaEnumValue("Lighting"),
        new BellaEnumValue("Misc"),
    ])
}


export { BellaEnumValue, BellaEnum }