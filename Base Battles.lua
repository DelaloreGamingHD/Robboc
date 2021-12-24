local library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua")))()

local w = library:CreateWindow("Base Battles")

local b = w:CreateFolder("Gun")

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()





function getRealTeam()
    local net = require(game:GetService("ReplicatedStorage").Libraries.Global)
    local old_index
    old_index =
        hookmetamethod(
        game,
        "__index",
        function(t, i)
            if checkcaller() and i == "Team" then
                local pp = net.Teams[t]
                if pp then
                    return pp
                end
            end
            return old_index(t, i)
        end
    )
end

--thx to bluwu
function DoESP()
    getRealTeam()
    if not getgenv() then
        game.Players.LocalPlayer:Kick("your exploit 100% will not support this damn, bye!")
    end
    getgenv().colors = {
        ["r"] = 255,
        ["g"] = 255,
        ["b"] = 255
    }
    getgenv().names = true
    function WTS(part)
        local screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        return Vector2.new(screen.x, screen.y)
    end
    
    function ESP(part, text, color)
        local name = Drawing.new("Text")
        name.Text = text
        name.Color = color
        name.Position = WTS(part)
        name.Size = 20.0
        name.Outline = true
        name.Center = true
        name.Visible = true
        
        local lol = game:GetService("RunService").Stepped:connect(function()
            pcall(function()
                if not getgenv().names then
                    name:Remove()
                    lol:Disconnect()
                end
                local destroyed = not part:IsDescendantOf(workspace)
                if destroyed and name ~= nil then
                    name:Remove()
                    lol:Disconnect()
                end
                if part ~= nil then
                    name.Position = WTS(part)
                end
                local _, screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if screen then
                    name.Visible = true
                else
                    name.Visible = false
                end
            end)
        end)
    end
    for i,v in pairs(game.Players:GetPlayers()) do
        if i~=1 and v.Character and v.Character:FindFirstChild("Head") and v.Team~=game.Players.LocalPlayer.Team then
            ESP(v.Character.Head,v.Name,Color3.new(getgenv().colors["r"]/255,getgenv().colors["g"]/255,getgenv().colors["b"]/255))
        end
        v.CharacterAdded:Connect(function(c)
            repeat task.wait() until c:FindFirstChild("Head") and v.Team~=game.Players.LocalPlayer.Team
            ESP(c.Head,v.Name,Color3.new(getgenv().colors["r"]/255,getgenv().colors["g"]/255,getgenv().colors["b"]/255))
        end)
    end
    game.Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(c)
            task.wait()
            ESP(c.Head,p.Name,Color3.new(getgenv().colors["r"]/255,getgenv().colors["g"]/255,getgenv().colors["b"]/255))
        end)
    end)
end


--no recoil
b:Button(
    "No recoil",
    function()
        for i, v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "damage") then
                v.bloomFactor = 0
                v.noYawRecoil = "true"
                v.recoilCoefficient = 1
            end
        end
    end
)


--HitBox
b:Button(
    "HitBox",
    function()
        getRealTeam()
        while true do
            wait(1)
            getgenv().HeadSize = 15
            getgenv().Disabled = true

            if getgenv().Disabled then
                for i, v in next, game:GetService("Players"):GetPlayers() do
                    if v.Name ~= game:GetService("Players").LocalPlayer.Name and v.Team ~= game:GetService("Players").LocalPlayer.Team  then
                        pcall(
                            function()
                                v.Character.HumanoidRootPart.Name = "xC6M3Vuz7QpsY5nv"
                                v.Character.xC6M3Vuz7QpsY5nv.Size =
                                    Vector3.new(getgenv().HeadSize, getgenv().HeadSize, getgenv().HeadSize)
                                v.Character.xC6M3Vuz7QpsY5nv.Transparency = 0.5
                                v.Character.xC6M3Vuz7QpsY5nv.CanCollide = false
                                v.Character.xC6M3Vuz7QpsY5nv.Color = Color3.fromRGB(210, 44, 255)
                            end
                        )
                    end
                end
            end
        end
    end
)
--Make all guns automatic
b:Button(
    "Automatic",
    function()
        for i, v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "damage") then
                v.automatic = "true"
            end
        end
    end
)
--inf ammo
b:Bind(
    "Infinity ammo",
    Enum.KeyCode.C,
    function()
        for i, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "ammo") then
                v.ammo = math.huge
            end
        end
    end
)

--Triggerbot
b:Toggle(
    "Triggerbot ",
    function(bool)
        shared.toggle = bool
        if shared.toggle then
            game:GetService("RunService").RenderStepped:Connect(
                function()
                    if mouse.Target.Parent:FindFirstChild("Humanoid") and mouse.Target.Parent.Name ~= player.Name then
                        local target = game:GetService("Players"):FindFirstChild(mouse.Target.Parent.Name)
                        if shared.toggle then
                            mouse1press()
                            wait()
                            mouse1release()
                        end
                    end
                end
            )
        end
    end
)

b:Button("ESP", function()
    DoESP()
end)

b:DestroyGui()
