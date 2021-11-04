-- Compiled with roblox-ts v1.2.7
local PlayerInventory
do
	PlayerInventory = setmetatable({}, {
		__tostring = function()
			return "PlayerInventory"
		end,
	})
	PlayerInventory.__index = PlayerInventory
	function PlayerInventory.new(...)
		local self = setmetatable({}, PlayerInventory)
		return self:constructor(...) or self
	end
	function PlayerInventory:constructor(maxItemAmount)
		self.maxItemAmount = maxItemAmount
		self.items = {}
	end
	function PlayerInventory:AddItem(item)
		if #self.items < self.maxItemAmount then
			local _items = self.items
			-- ▼ Array.push ▼
			_items[#_items + 1] = item
			-- ▲ Array.push ▲
			return true
		end
		return false
	end
	function PlayerInventory:RemoveItem(item)
		local _items = self.items
		local _arg0 = function(x)
			return x.attachedInteractable.remote ~= item.attachedInteractable.remote
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_items) do
			if _arg0(_v, _k - 1, _items) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self.items = _newValue
	end
	function PlayerInventory:ReturnItems()
		return self.items
	end
end
return {
	PlayerInventory = PlayerInventory,
}
