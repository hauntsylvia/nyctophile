-- Compiled with roblox-ts v1.2.7
local apiEndpoint = game:GetService("ReplicatedStorage"):WaitForChild("api"):WaitForChild("event")
local me = (apiEndpoint:InvokeServer())
print(me.ashlin)
print(me.userId)
print(me.playerCard.phrase)
