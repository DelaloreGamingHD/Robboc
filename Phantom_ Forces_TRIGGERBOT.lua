local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
mouse.TargetFilter = game:GetService("Workspace").Players[tostring(player.TeamColor)]

game:GetService("Workspace").ChildRemoved:Connect(function()
    mouse.TargetFilter = game:GetService("Workspace").Players[tostring(player.TeamColor)]
end)
getgenv().triggerBot = true
getgenv().head_check = false

releasetime = 0
function SendNot(ED)
    local CoreGui = game:GetService("StarterGui")

    CoreGui:SetCore(
        "SendNotification",
        {
            Title = "Notification",
            Text = ED,
            Duration = 1.5
        }
    )
end

-- A sample function providing one usage of InputBegan
local function onInputBegan(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and getgenv().triggerBot == false then
        getgenv().triggerBot = true
        SendNot(tostring(getgenv().triggerBot))
    elseif input.KeyCode == Enum.KeyCode.RightShift and getgenv().triggerBot == true then
        getgenv().triggerBot = false
        SendNot(tostring(getgenv().triggerBot))
    elseif input.KeyCode == Enum.KeyCode.Home then
        releasetime = 2
    elseif input.KeyCode == Enum.KeyCode.End then
        releasetime = 0
    elseif input.KeyCode == Enum.KeyCode.Delete then
        getgenv().head_check = true
        SendNot(string.format("Head check is on"))
    elseif input.KeyCode == Enum.KeyCode.PageUp then
        getgenv().head_check = false
        SendNot("Head check is off")
    end
    
end

UserInputService.InputBegan:Connect(onInputBegan)

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().triggerBot == true  then
        if getgenv().head_check == false then
            if mouse.Target.Parent:FindFirstChild("Head") and mouse.Target.Parent.Parent.Name ~= "DeadBody" then
                mouse1press()
                wait(releasetime)
                mouse1release()
            end
        elseif mouse.Target.Name == "Head" and mouse.Target.Parent.Parent.Name ~= "DeadBody" and getgenv().head_check == true then
                mouse1press()
                wait(releasetime)
                mouse1release()
        end
    end
end)
