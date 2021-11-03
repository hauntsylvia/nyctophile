-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
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
		local _exitType, _returns = TS.try(function()
			local myEvents = game:GetService("ReplicatedStorage"):WaitForChild("player")
			local serversEvent = game:GetService("ReplicatedStorage"):WaitForChild("api"):WaitForChild("func")
			if serversEvent:IsA("RemoteFunction") then
				local result = serversEvent:InvokeServer(lower, upper, args)
				return TS.TRY_RETURN, { result.result }
			end
		end, function()
			return TS.TRY_RETURN, { nil }
		end)
		if _exitType then
			return unpack(_returns)
		end
		return nil
	end
end
return {
	Client = Client,
}
