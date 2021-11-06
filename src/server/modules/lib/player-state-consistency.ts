import { PlayerState } from "shared/entities/player/player-state"

const updatePlayer = game.GetService("ServerStorage").WaitForChild("upd-player").WaitForChild("u") as BindableEvent
function SetPlayerState(plr: PlayerState)
{
    updatePlayer.Fire(plr)
}
export { SetPlayerState }