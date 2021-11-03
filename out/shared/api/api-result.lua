-- Compiled with roblox-ts v1.2.7
local APIResult
do
	APIResult = setmetatable({}, {
		__tostring = function()
			return "APIResult"
		end,
	})
	APIResult.__index = APIResult
	function APIResult.new(...)
		local self = setmetatable({}, APIResult)
		return self:constructor(...) or self
	end
	function APIResult:constructor(result, message)
		self.result = result
		self.message = message
	end
end
return {
	APIResult = APIResult,
}
