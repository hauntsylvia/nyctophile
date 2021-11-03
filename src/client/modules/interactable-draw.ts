import { APIResult } from "shared/api/api-result";
import { Interactable } from "shared/entities/interactable";
import { Client } from "./net/lib";

const tweenService = game.GetService("TweenService")

class Draw
{
    isEnabled: boolean
    int: Interactable
    attached: Part
    constructor(int: Interactable)
    {
        this.isEnabled = false
        this.int = int
        this.attached = new Instance("Part", game.GetService("Workspace"))
        this.attached.Name = int.config.name + "--interact-part"
        this.attached.CanCollide = false
        this.attached.Transparency = 1
        this.attached.Anchored = true
        this.attached.Material = Enum.Material.Neon
        this.attached.Color = Color3.fromRGB(255, 255, 255)
    }
    event: RBXScriptConnection | undefined
    Enable(closeWhenOutOfRange: boolean, plr: Player)
    {
        this.isEnabled = true
        let t = this
        let char = (plr.Character ?? plr.CharacterAdded.Wait()) as Model
        let root = char.FindFirstChild("HumanoidRootPart") as Part
        let p = this.int
        let interactPart = this.attached
        tweenService.Create(this.attached, new TweenInfo(0.1, Enum.EasingStyle.Linear), {Transparency: 0.6}).Play()
        this.event = game.GetService("RunService").RenderStepped.Connect(function(step)
        {
            let v = p.attachedPart.Position.add(root.Position)
            let distance = p.attachedPart.Position.sub(root.Position).Magnitude
            v = v.div(2)
            interactPart.CFrame = new CFrame(v, p.attachedPart.Position)
            interactPart.Size = new Vector3(0.05, 0.05, distance)
            if(closeWhenOutOfRange && distance > p.config.range)
            {
                t.Disable()
            }
        })
    }
    Disable()
    {
        this.isEnabled = false
        tweenService.Create(this.attached, new TweenInfo(0.1, Enum.EasingStyle.Linear), {Transparency: 1}).Play()        
        wait(0.2)
        if(this.event !== undefined)
        {
            this.event.Disconnect()
        }
    }
    GetDistanceFromPlayer(player: Player)
    {
        return ((((player.Character || player.CharacterAdded.Wait()) as Model).FindFirstChild("HumanoidRootPart") as Part).Position.sub(this.int.attachedPart.Position)).Magnitude
    }
    IsInRange(player: Player)
    {
        let distance = this.GetDistanceFromPlayer(player)
        return distance <= this.int.config.range
    }
    Interact()
    {
        this.int.remote.InvokeServer()
    }
}

export { Draw }