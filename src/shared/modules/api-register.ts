const apiDirectory = game.GetService("ServerStorage").WaitForChild("api")
class APIRegister
{
    _service: Instance
    constructor(service: string)
    {
        let serviceFolder = apiDirectory.FindFirstChild(service)
        if(serviceFolder !== undefined && serviceFolder.IsA("Folder"))
        {
            this._service = serviceFolder 
        }
        else
        {
            this._service = new Instance("Folder", apiDirectory)
        }
        this._service.Name = service
    }
    RegisterNewLowerService(name: string)
    {
        let apiHandler = new Instance("BindableFunction", this._service)
        apiHandler.Name = name
        return apiHandler
    }
}
export { APIRegister }