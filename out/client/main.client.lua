-- Compiled with roblox-ts v1.2.7
local apiEndpoint = game:GetService("ReplicatedStorage"):WaitForChild("api"):WaitForChild("func")
local me = (apiEndpoint:InvokeServer("users", "GetSelf"))
print("$" .. tostring(me.result.ashlin))
