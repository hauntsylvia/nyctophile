class APIResult<T>
{
    constructor(result: T, message: string, success: boolean) 
    { 
        this.result = result 
        this.message = message
        this.success = success
    }  
    result: T
    message: string
    success: boolean
}
export { APIResult }