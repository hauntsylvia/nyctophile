-- Compiled with roblox-ts v1.2.7
local updatePlayer = game:GetService("ServerStorage"):WaitForChild("upd-player"):WaitForChild("u")
local function SetPlayerState(plr)
	updatePlayer:Fire(plr)
end
return {
	SetPlayerState = SetPlayerState,
}
