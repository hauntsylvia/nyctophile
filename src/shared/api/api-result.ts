class APIResult<T>
{
    constructor(result: T, message: string) 
    { 
        this.result = result 
        this.message = message
    }  
    result: T
    message: string
}
export {APIResult}