-- Compiled with roblox-ts v1.2.7
local InternalClient
local Client
do
	Client = setmetatable({}, {
		__tostring = function()
			return "Client"
		end,
	})
	Client.__index = Client
	function Client.new(...)
		local self = setmetatable({}, Client)
		return self:constructor(...) or self
	end
	function Client:constructor()
		self.client = InternalClient.new()
	end
	function Client:GetMe()
		local me = self.client:Send("users", "me", nil)
		return me
	end
	function Client:GetPlayerRotations(player)
		local rots = self.client:Send("users", "getplayerrotations", player.UserId)
		return rots
	end
	function Client:GetInteractables()
		local ints = self.client:Send("interactables", "getcurrent", nil)
		return ints
	end
	function Client:PlaceNode(position)
		local n = self.client:Send("nodes", "create", position)
		return n
	end
	function Client:GetNode()
		local n = self.client:Send("nodes", "me", nil)
		return n
	end
	function Client:GetAllOtherPlayersNodes()
		local n = self.client:Send("nodes", "all", nil)
		return n
	end
	function Client:PlacePlaceable(placeable, c, color, material)
		local toSend = table.create(3)
		toSend[1] = placeable
		toSend[2] = c
		toSend[3] = color
		toSend[4] = material
		local n = self.client:Send("nodes", "placeables.create", toSend)
		return n
	end
	function Client:GetAllPossiblePlaceables()
		local n = self.client:Send("nodes", "placeables.all", nil)
		return n
	end
	function Client:CustomizePlaceable(placeableId, color, material)
		local toSend = table.create(3)
		toSend[1] = placeableId
		toSend[2] = color
		toSend[3] = material
		local n = self.client:Send("nodes", "placeables.customize", toSend)
		return n
	end
end
do
	InternalClient = setmetatable({}, {
		__tostring = function()
			return "InternalClient"
		end,
	})
	InternalClient.__index = InternalClient
	function InternalClient.new(...)
		local self = setmetatable({}, InternalClient)
		return self:constructor(...) or self
	end
	function InternalClient:constructor()
	end
	function InternalClient:Send(lower, upper, args)
		print(lower .. ("/" .. upper))
		local myEvents = game:GetService("ReplicatedStorage"):WaitForChild("player")
		local serversEvent = game:GetService("ReplicatedStorage"):WaitForChild("api"):WaitForChild("func")
		if serversEvent:IsA("RemoteFunction") then
			local result = serversEvent:InvokeServer(lower, upper, args)
			if not result.success then
				print("- - " .. (result.message .. " - -"))
			end
			return result.result
		end
	end
end
return {
	Client = Client,
}
