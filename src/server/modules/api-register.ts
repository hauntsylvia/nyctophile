
const apiDirectory = game.GetService("ServerStorage").WaitForChild("api")
class APIRegister
{
    _service: Instance
    constructor(service: string)
    {
        this._service = new Instance("Folder", apiDirectory)
        this._service.Name = service
    }
    RegisterNewLowerService(name: string)
    {
        let apiHandler = new Instance("BindableFunction", this._service)
        apiHandler.Name = name
        return apiHandler
    }
}
export {APIRegister}