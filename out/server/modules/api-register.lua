-- Compiled with roblox-ts v1.2.7
local apiDirectory = game:GetService("ServerStorage"):WaitForChild("api")
local APIRegister
do
	APIRegister = setmetatable({}, {
		__tostring = function()
			return "APIRegister"
		end,
	})
	APIRegister.__index = APIRegister
	function APIRegister.new(...)
		local self = setmetatable({}, APIRegister)
		return self:constructor(...) or self
	end
	function APIRegister:constructor(service)
		self._service = Instance.new("Folder", apiDirectory)
		self._service.Name = service
	end
	function APIRegister:RegisterNewLowerService(name)
		local apiHandler = Instance.new("BindableFunction", self._service)
		apiHandler.Name = name
		return apiHandler
	end
end
return {
	APIRegister = APIRegister,
}
