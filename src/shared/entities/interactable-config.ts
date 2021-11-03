class InteractableConfig
{
    name: string
    description: string
    range: number
    constructor(name:string, description: string, range: number) 
    { 
        this.name = name
        this.description = description
        this.range = range
    }  
    
}
export { InteractableConfig }