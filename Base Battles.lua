local client = game:GetService("Players").LocalPlayer
local mouse = client:GetMouse()

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()

local w = library:CreateWindow("Base Battles")

local b = w:CreateFolder("Gun")
local aimBot = w:CreateFolder("Aimbot")

local player = game:GetService("Players").LocalPlayer

getgenv().fov_Visible = false
getgenv().fov = 400
local fovcircle = Drawing.new("Circle")
fovcircle.Visible = getgenv().fov_Visible
fovcircle.Radius = getgenv().fov
fovcircle.Color = Color3.fromRGB(0, 255, 136)
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 0.3
fovcircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

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
aimBot:Toggle(
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
    if not getgenv().FontValue then
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Base%20Battles-ESP.lua')))()
    end
end)



aimBot:Button(
    "Aimbot",
    function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Base_Battles_aimbot.lua", true))()
    end
)

aimBot:Slider("Aim Smoothness",{
    min = 0; -- min value of the slider
    max = 10; -- max value of the slider
    precise = true; -- max 2 decimals
},function(value)
    getgenv().aim_smooth = value
end)

aimBot:Slider("Fov",{
    min = 1; -- min value of the slider
    max = 800; -- max value of the slider
    precise = true; -- max 2 decimals
},function(value)
    getgenv().fov = value
    fovcircle.Radius = getgenv().fov
end)

aimBot:Dropdown("Aimlock Method",{'Head', "Torso"},true,function(mob) --true/false, replaces the current title "Dropdown" with the option that t
    getgenv().aim_at = mob
end)


aimBot:Toggle("Show fov",function(bool)
    getgenv().fov_Visible = bool
    fovcircle.Visible = getgenv().fov_Visible
end)

b:DestroyGui()
aimBot:DestroyGui()
