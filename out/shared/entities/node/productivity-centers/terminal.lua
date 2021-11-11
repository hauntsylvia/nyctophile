-- Compiled with roblox-ts v1.2.7
local Terminal
do
	Terminal = setmetatable({}, {
		__tostring = function()
			return "Terminal"
		end,
	})
	Terminal.__index = Terminal
	function Terminal.new(...)
		local self = setmetatable({}, Terminal)
		return self:constructor(...) or self
	end
	function Terminal:constructor()
	end
end
return {
	Terminal = Terminal,
}
