import { Item } from "../item"

class PlayerInventory
{
    maxItemAmount: number
    private items: Array<Item>
    constructor(maxItemAmount: number) 
    { 
        this.maxItemAmount = maxItemAmount
        this.items = new Array<Item>()
    }  
    AddItem(item: Item)
    {
        if(this.items.size() < this.maxItemAmount)
        {
            this.items.push(item)
            return true
        }
        return false
    }
    RemoveItem(item: Item)
    {
        this.items = this.items.filter(x => x.attachedInteractable.remote !== item.attachedInteractable.remote)
    }
    ReturnItems()
    {
        return this.items
    }
}
export { PlayerInventory }