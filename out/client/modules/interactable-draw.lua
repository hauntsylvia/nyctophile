-- Compiled with roblox-ts v1.2.7
local tweenService = game:GetService("TweenService")
local Draw
do
	Draw = setmetatable({}, {
		__tostring = function()
			return "Draw"
		end,
	})
	Draw.__index = Draw
	function Draw.new(...)
		local self = setmetatable({}, Draw)
		return self:constructor(...) or self
	end
	function Draw:constructor(int)
		self.isEnabled = false
		self.int = int
		self.attached = Instance.new("Part", game:GetService("Workspace"))
		self.attached.Name = int.config.name .. "--interact-part"
		self.attached.CanCollide = false
		self.attached.Transparency = 1
		self.attached.Anchored = true
		self.attached.Material = Enum.Material.Neon
		self.attached.Color = Color3.fromRGB(255, 255, 255)
	end
	function Draw:Enable(closeWhenOutOfRange)
		self.isEnabled = true
		local t = self
		local plr = game:GetService("Players").LocalPlayer
		local _condition = plr.Character
		if _condition == nil then
			_condition = { plr.CharacterAdded:Wait() }
		end
		local char = _condition
		local root = char:FindFirstChild("HumanoidRootPart")
		local p = self.int
		local interactPart = self.attached
		tweenService:Create(self.attached, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
			Transparency = 0.6,
		}):Play()
		self.event = game:GetService("RunService").RenderStepped:Connect(function(step)
			local _position = p.attachedPart.Position
			local _position_1 = root.Position
			local v = _position + _position_1
			local _position_2 = p.attachedPart.Position
			local _position_3 = root.Position
			local distance = (_position_2 - _position_3).Magnitude
			v = v / 2
			interactPart.CFrame = CFrame.new(v, p.attachedPart.Position)
			interactPart.Size = Vector3.new(0.05, 0.05, distance)
			if closeWhenOutOfRange and distance > p.config.range then
				t:Disable()
			end
		end)
	end
	function Draw:Disable()
		self.isEnabled = false
		tweenService:Create(self.attached, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
			Transparency = 1,
		}):Play()
		wait(0.2)
		if self.event ~= nil then
			self.event:Disconnect()
		end
	end
	function Draw:GetDistanceFromPlayer(player)
		local _position = ((player.Character or { player.CharacterAdded:Wait() }):FindFirstChild("HumanoidRootPart")).Position
		local _position_1 = self.int.attachedPart.Position
		return (_position - _position_1).Magnitude
	end
	function Draw:IsInRange(player)
		local distance = self:GetDistanceFromPlayer(player)
		return distance <= self.int.config.range
	end
end
return {
	Draw = Draw,
}
