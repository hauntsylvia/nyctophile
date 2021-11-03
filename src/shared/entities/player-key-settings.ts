
class PlayerKeySettings
{
    interactKey: Enum.KeyCode
    inventoryKey: Enum.KeyCode
    constructor(interactKey: Enum.KeyCode, inventoryKey: Enum.KeyCode) 
    { 
        this.interactKey = interactKey
        this.inventoryKey = inventoryKey
    } 
}
export { PlayerKeySettings }