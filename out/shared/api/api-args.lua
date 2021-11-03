-- Compiled with roblox-ts v1.2.7
local APIArgs
do
	APIArgs = setmetatable({}, {
		__tostring = function()
			return "APIArgs"
		end,
	})
	APIArgs.__index = APIArgs
	function APIArgs.new(...)
		local self = setmetatable({}, APIArgs)
		return self:constructor(...) or self
	end
	function APIArgs:constructor(caller, clientArgs)
		self.caller = caller
		self.clientArgs = clientArgs
	end
end
return {
	APIArgs = APIArgs,
}
