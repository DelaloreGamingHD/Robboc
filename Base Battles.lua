local client = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = client:GetMouse()
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua")))()

local w = library:CreateWindow("Base Battles")

local b = w:CreateFolder("Gun")

local player = game:GetService("Players").LocalPlayer


local net = require(game:GetService("ReplicatedStorage").Libraries.Global)
local GetTeam = function(v) 
    return net.Teams[v]
end



--thx to e621
function DoESP()
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
        if i~=1 and v.Character and v.Character:FindFirstChild("Head") and GetTeam(v) ~= GetTeam(game.Players.LocalPlayer) then
            ESP(v.Character.Head,v.Name,Color3.new(1, 0, 0))
        end
        v.CharacterAdded:Connect(function(c)
            repeat task.wait() until c:FindFirstChild("Head") and GetTeam(v) == GetTeam(game.Players.LocalPlayer)
            ESP(c.Head,v.Name,Color3.new(0.082352, 1, 0))
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
        
        while true do
            wait(1)
            getgenv().HeadSize = 15
            getgenv().Disabled = true

            if getgenv().Disabled then
                for i, v in next, game:GetService("Players"):GetPlayers() do
                    if v.Name ~= game:GetService("Players").LocalPlayer.Name and GetTeam(v) ~= GetTeam(game.Players.LocalPlayer)  then
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


--Make all guns automatic
b:Button(
    "Aimbot",
    function()
        local function closestPlayer(fov)
            local target = nil
            local closest = fov or math.huge
            for i,v in ipairs(players:GetPlayers()) do
                if v.Character and client.Character and v ~= client then
                    local _, onscreen = camera:WorldToScreenPoint(v.Character.Head.Position)
                    if onscreen then
                        local targetPos = camera:WorldToViewportPoint(v.Character.Head.Position)
                        local mousePos = camera:WorldToViewportPoint(mouse.Hit.p)
                        local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetPos.X, targetPos.Y)).magnitude
                        if dist < closest then
                            closest = dist
                            target = v
                        end
                    end
                end
            end
            return target
         end
        
         local function aimAt(pos,smooth)
            local targetPos = camera:WorldToScreenPoint(pos)
            local mousePos = camera:WorldToScreenPoint(mouse.Hit.p)
            mousemoverel((targetPos.X-mousePos.X)/smooth,(targetPos.Y-mousePos.Y)/smooth)
          end
        
          local isAiming = false
        uis.InputBegan:Connect(function(input)
           if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end
        end)
        uis.InputEnded:Connect(function(input)
           if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
        end)
        
        rs.RenderStepped:connect(function()
            local t = closestPlayer(800)
            if t and isAiming then
                aimAt(t.Character.Head.Position, 2)
            end
         end)
    end
)


b:DestroyGui()
