
class PlayerKeySettings
{
    interactKey: string
    inventoryKey: string
    buildSystemKey: string
    constructor(interactKey: string, inventoryKey: string, buildSystemKey: string) 
    { 
        this.interactKey = interactKey
        this.inventoryKey = inventoryKey
        this.buildSystemKey = buildSystemKey
    } 
}
export { PlayerKeySettings }