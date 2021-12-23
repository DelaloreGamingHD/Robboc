local library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua")))()
local w = library:CreateWindow("SHOOT OUT!") -- Creates the window
local b = w:CreateFolder("Main") -- Creates the folder(U will put here your buttons,etc)
weaponData = game:GetService("ReplicatedFirst")["_0xS0URC3X"].Shared.WeaponDataManager
local UIS = game:GetService("UserInputService")
local Player = game:GetService("Players").LocalPlayer
local DefaultWalkspeed = Player.Character.Humanoid.WalkSpeed
local mouse = Player:GetMouse()
getgenv().triggerBot = nil
getgenv().HeadSize = 10

function bypassJump()
    local out = rconsoleprint or function()
        end

    local mt = getrawmetatable(game)
    local oldindex = mt.__index
    local oldnewindex = mt.__newindex
    setreadonly(mt, false)

    local hum = game:service "Players".LocalPlayer.Character.Humanoid
    local oldws = hum.WalkSpeed
    local oldjp = hum.JumpPower

    mt.__newindex =
        newcclosure(
        function(t, k, v)
            if checkcaller() then
                return oldnewindex(t, k, v)
            elseif (t:IsA "Humanoid" and k == "WalkSpeed") then
                v = tonumber(v)
                if not v then
                    v = 0
                end
                oldws = v
            elseif (t:IsA "Humanoid" and k == "JumpPower") then
                v = tonumber(v)
                if not v then
                    v = 0
                end
                oldjp = v
            else
                return oldnewindex(t, k, v)
            end
        end
    )

    mt.__index =
        newcclosure(
        function(t, k)
            if checkcaller() then
                return oldindex(t, k)
            elseif (t:IsA "Humanoid" and k == "WalkSpeed") then
                return oldws
            elseif (t:IsA "Humanoid" and k == "JumpPower") then
                return oldjp
            else
                return oldindex(t, k)
            end
        end
    )

    setreadonly(mt, true)
end

for i, v in pairs(weaponData:GetChildren()) do
    guns = require(v)
    for i2, v2 in pairs(guns) do
        if getfenv().infAmmo then
            v2.MAX_AMMO = math.huge
        end
        if getfenv().rapidFire then
            v2.SPREAD = 0
            v2.ROF = math.huge
            v2.MAX_DAMAGE_RANGE = math.huge
        end
        if getfenv().noRecoil then
            v2.RECOIL_STRENGTH = 0
        end
        if getfenv().noReloadTime then
            v2.RELOAD_TIME = 0
        end
        if getfenv().makeAllGunsAutomatic then
            v2.AUTOMATIC = true
        end
    end
end

b:Button(
    "Inf Ammo",
    function()
        for i, v in pairs(weaponData:GetChildren()) do
            guns = require(v)
            for i2, v2 in pairs(guns) do
                v2.MAX_AMMO = math.huge
            end
        end
    end
)

b:Button(
    "Rapid Fire",
    function()
        for i, v in pairs(weaponData:GetChildren()) do
            guns = require(v)
            for i2, v2 in pairs(guns) do
                v2.SPREAD = 0
                v2.ROF = math.huge
                v2.MAX_DAMAGE_RANGE = math.huge
            end
        end
    end
)

b:Button(
    "No Recoil",
    function()
        for i, v in pairs(weaponData:GetChildren()) do
            guns = require(v)
            for i2, v2 in pairs(guns) do
                v2.RECOIL_STRENGTH = 0
            end
        end
    end
)

b:Button(
    "Automatic",
    function()
        for i, v in pairs(weaponData:GetChildren()) do
            guns = require(v)
            for i2, v2 in pairs(guns) do
                v2.AUTOMATIC = true
            end
        end
    end
)

b:Button(
    "No Reload",
    function()
        for i, v in pairs(weaponData:GetChildren()) do
            guns = require(v)
            for i2, v2 in pairs(guns) do
                v2.RELOAD_TIME = 0
            end
        end
    end
)

b:Toggle(
    "Infinity jump",
    function(bool)
        shared.toggle = bool
        game:GetService("UserInputService").JumpRequest:connect(
            function()
                if shared.toggle then
                    game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass "Humanoid":ChangeState(
                        "Jumping"
                    )
                end
            end
        )
    end
)

b:Button(
    "HitBox buggy",
    function()
        while true do
            wait(1)

            getgenv().Disabled = true

            if getgenv().Disabled then
                for i, v in next, game:GetService("Players"):GetPlayers() do
                    if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                        pcall(
                            function()
                                v.Character.HumanoidRootPart.Name = "xC6M3Vuz7QpsY5nv"
                                v.Character.xC6M3Vuz7QpsY5nv.Size =
                                    Vector3.new(getgenv().HeadSize, getgenv().HeadSize, getgenv().HeadSize)
                                v.Character.xC6M3Vuz7QpsY5nv.Transparency = 0.5
                                v.Character.xC6M3Vuz7QpsY5nv.CanCollide = true
                                v.Character.xC6M3Vuz7QpsY5nv.Color = Color3.fromRGB(210, 44, 255)
                            end
                        )
                    end
                end
            end
        end
    end
)

b:Button(
    "Shift walkspeed",
    function()
        UIS.InputBegan:Connect(
            function(input)
                if input.KeyCode == Enum.KeyCode.LeftShift then
                    local Players = game:GetService("Players")
                    Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
                end
            end
        )

        UIS.InputEnded:Connect(
            function(input)
                if input.KeyCode == Enum.KeyCode.LeftShift then
                    local Players = game:GetService("Players")
                    Players.LocalPlayer.Character.Humanoid.WalkSpeed = DefaultWalkspeed
                end
            end
        )
    end
)

b:Slider(
    "Hitbox size",
    {
        min = 0, -- min value of the slider
        max = 30, -- max value of the slider
        precise = true -- max 2 decimals
    },
    function(value)
        getgenv().HeadSize = value
    end
)

b:Toggle(
    "Trigger bot",
    function(bool)
        shared.toggle = bool
        getgenv().triggerBot = shared.toggle
        game:GetService("RunService").RenderStepped:Connect(
            function()
                if
                    getgenv().triggerBot == true and mouse.Target.Parent:FindFirstChild("Humanoid") and
                        mouse.Target.Parent.Name ~= Player.Name
                 then
                    mouse1press()
                    wait(2)
                    mouse1release()
                end
            end
        )
    end
)

bypassJump()
b:DestroyGui()
