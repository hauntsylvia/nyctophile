import { PlayerState } from "shared/entities/playerState"

export {}

const apiEndpoint = game.GetService("ReplicatedStorage").WaitForChild("api").WaitForChild("event") as RemoteFunction
let me = (apiEndpoint.InvokeServer() as PlayerState)

print(me.ashlin)
print(me.userId)
print(me.playerCard.phrase)
print("a")