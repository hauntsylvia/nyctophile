import { Node } from "shared/entities/node/node"
import { Client } from "../net/lib"

const tweenService = game.GetService("TweenService")

class BuildSystem
{   
    client: Client
    constructor(client: Client)
    {   this.client = client
    }
    isEnabled: boolean = false
    internallyHandleDisabling: boolean = true
    private attachedModel: Model | undefined
    private connection: RBXScriptConnection | undefined
    private uisConnection: RBXScriptConnection | undefined
    Enable(attachedModel: Model, pressedToReturn: Enum.UserInputType, pressedToDisable: Enum.KeyCode, internallyHandleDisabling: boolean, node?: Node)
    {
        if(this.isEnabled)
        {
            this._Disable()
        }
        this.internallyHandleDisabling = internallyHandleDisabling
        this.attachedModel = attachedModel
        if(this.attachedModel.PrimaryPart !== undefined)
        {
            let actualPosition: Vector3
            this.isEnabled = true
            let plr = game.GetService("Players").LocalPlayer
            let mouse = plr.GetMouse()
            let char = (plr.Character ?? plr.CharacterAdded.Wait()) as Instance
            let isValid = false
            let s = this

            let modelsDescendants = this.attachedModel.GetDescendants()
            for(let i = 0; i < modelsDescendants.size(); i++)
            {
                if(modelsDescendants[i].IsA("BasePart"))
                {
                    let thisPart = modelsDescendants[i] as BasePart
                    thisPart.Anchored = true
                    tweenService.Create(thisPart, new TweenInfo(1), {Transparency: 0.8}).Play()
                }
            }

            this.uisConnection = game.GetService("UserInputService").InputEnded.Connect(function(inputObject, isProcessed)
            {
                if(!isProcessed && s.attachedModel !== undefined && s.attachedModel.PrimaryPart !== undefined)
                {
                    if(inputObject.UserInputType === pressedToReturn && isValid)
                    {
                        s._Disable()
                        return actualPosition
                    }
                    else if(inputObject.KeyCode === pressedToDisable)
                    {
                        s._Disable()
                        return undefined
                    }
                }
            })
            let allNodesInGame = this.client.GetAllOtherPlayersNodes() ?? new Array<Node>()
            this.connection = game.GetService("RunService").RenderStepped.Connect(function(deltaTime)
            {
                if(s.attachedModel !== undefined)
                {
                    let ray = game.GetService("Workspace").CurrentCamera?.ScreenPointToRay(mouse.X, mouse.Y)
                    if(ray !== undefined && s.attachedModel.PrimaryPart !== undefined)
                    {
                        let raycastParams = new RaycastParams()
                        let ignore = new Array<Instance>()
                        ignore.push(s.attachedModel, char)
                        raycastParams.FilterDescendantsInstances = ignore
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        let raycastResult = game.GetService("Workspace").Raycast(ray.Origin, ray.Direction.mul(1000), raycastParams)
                        if(raycastResult !== undefined)
                        {
                            if(node !== undefined)
                            {                        
                                isValid = node.position.sub(s.attachedModel.PrimaryPart.Position).Magnitude <= node.config.radius
                            }
                            else if(allNodesInGame !== undefined)
                            {
                                for(let i = 0; i < allNodesInGame.size(); i++)
                                {
                                    let thisN = allNodesInGame[i]
                                    if(thisN.config !== undefined && thisN.position !== undefined)
                                    {
                                        if(thisN.position?.sub(s.attachedModel.PrimaryPart.Position).Magnitude <= (thisN.config?.radius * 2))
                                        {
                                            isValid = true
                                            break
                                        }
                                    }
                                }
                            }
                            let colorToTweenTo = isValid ? Color3.fromRGB(135, 255, 135) : Color3.fromRGB(255, 135, 135)
                            let allDesc = s.attachedModel.GetDescendants()
                            for(let i = 0; i < allDesc.size(); i++)
                            {
                                let thisPart = allDesc[i]
                                if(thisPart.IsA("BasePart"))
                                {
                                    tweenService.Create(thisPart, new TweenInfo(0.4), {Color: colorToTweenTo}).Play()
                                }
                            }
                            actualPosition = raycastResult.Position.add(s.attachedModel.GetExtentsSize()).div(2)
                            let fakePosition = s.attachedModel.PrimaryPart.CFrame.Lerp(new CFrame(actualPosition), 0.2)
                            s.attachedModel.SetPrimaryPartCFrame(fakePosition)
                        }
                    }
                    else if(s.attachedModel.PrimaryPart === undefined)
                    {
                        error("Primary part removed.")
                    }
                }
            })
        }
        else
        {
            error("No primary part exists on this model.")
        }
    }
    private _Disable(overrideInternallyHandleDisabling: boolean = false)
    {
        if(this.internallyHandleDisabling || overrideInternallyHandleDisabling)
        {
            this.isEnabled = false
            if(this.attachedModel !== undefined)
            {
                this.attachedModel.Destroy()
            }
            if(this.connection !== undefined)
            {
                this.connection.Disconnect()
            }
            if(this.uisConnection !== undefined)
            {
                this.connection?.Disconnect()
            }
        }
    }
    Disable()
    {   
        this._Disable(true)
    }
}
export { BuildSystem }