local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
mouse.TargetFilter = game:GetService("Workspace").Players[tostring(player.TeamColor)]

game:GetService("Workspace").ChildRemoved:Connect(function()
    mouse.TargetFilter = game:GetService("Workspace").Players[tostring(player.TeamColor)]
end)

if not getgenv().triggerBot then
    getgenv().triggerBot = false
end
if not getgenv().head_check then
    getgenv().head_check = false
end

if not getgenv().releasetime then
    getgenv().releasetime = 0
end

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().triggerBot == true and game:GetService("Players").LocalPlayer.Character then
        if getgenv().head_check == false then
            if mouse.Target.Parent:FindFirstChild("Head") and mouse.Target.Parent.Parent.Name ~= "DeadBody" then
                mouse1press()
                wait(getgenv().releasetime)
                mouse1release()
            end
        elseif mouse.Target.Name == "Head" and mouse.Target.Parent.Parent.Name ~= "DeadBody" and getgenv().head_check == true then
                mouse1press()
                wait(getgenv().releasetime)
                mouse1release()
        end
    end
end)
