-- Compiled with roblox-ts v1.2.7
local Item
do
	Item = setmetatable({}, {
		__tostring = function()
			return "Item"
		end,
	})
	Item.__index = Item
	function Item.new(...)
		local self = setmetatable({}, Item)
		return self:constructor(...) or self
	end
	function Item:constructor(attachedModel, attachedInteractable, remote)
		self.attachedModel = attachedModel
		self.attachedInteractable = attachedInteractable
		self.remote = remote
	end
	function Item:ServerDo()
		print("empty server item")
	end
end
return {
	Item = Item,
}
