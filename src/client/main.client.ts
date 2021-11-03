import { Interactable } from "shared/entities/interactable";
import { Draw } from "./modules/interactable-draw";
import { Client } from "./modules/net/lib";

const lib = new Client()
let draws = new Array<Draw>()
let plr = game.GetService("Players").LocalPlayer
let me = lib.GetMe()

let runService = game.GetService("RunService")
let userInputService = game.GetService("UserInputService")

function EvaluateInteractables()
{
    let ints = lib.GetInteractables()
    if(ints !== undefined)
    {
        for(let i = 0; i < ints.size(); i++)
        {
            let canPush = true
            for(let x = 0; x < draws.size(); x++)
            {
                if(draws[x].int.attachedPart === ints[i].attachedPart)
                {
                    canPush = false
                    break
                }
            }
            if(canPush)
            {
                draws.push(new Draw(ints[i]))
            }
        }
    }
    else
    {
        print("ints undefined")
    }
}
let closestDraw: Draw | undefined = undefined
runService.Heartbeat.Connect(function(deltaTime)
{
    if(draws.size() > 0)
    {
        for(let i = 0; i < draws.size(); i++)
        {
            if(closestDraw !== undefined)
            {
                let int = draws[i]
                let distanceOfCurrentIteration  = int.GetDistanceFromPlayer(plr)
                let currentDistance             = closestDraw.GetDistanceFromPlayer(plr)
                let inRange                     = int.IsInRange(plr)
                if((distanceOfCurrentIteration < currentDistance) && inRange)
                {
                    closestDraw.Disable()
                    closestDraw = draws[i]
                }
            }
            else
            {
                closestDraw = draws[i]
            }
        }
        if(closestDraw !== undefined && !closestDraw.isEnabled)
        {
            closestDraw.Enable(true)
        }
    }
})
userInputService.InputEnded.Connect(function(inputObject, isProcessed)
{
    if(!isProcessed && me?.playerSettings.playerKeys.interactKey && closestDraw !== undefined && closestDraw.IsInRange(plr))
    {
        
    }
})
while(wait(5))
{
    EvaluateInteractables()
}