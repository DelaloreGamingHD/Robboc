local client = game:GetService("Players").LocalPlayer
local mouse = client:GetMouse()

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()

local w = library:CreateWindow("Base Battles")

local b = w:CreateFolder("Gun")
local aimBot = w:CreateFolder("Aimbot")
local Misc = w:CreateFolder("Misc")

local player = game:GetService("Players").LocalPlayer



getgenv().fov_Visible = false
getgenv().fov = 400
local fovcircle = Drawing.new("Circle")
fovcircle.Visible = getgenv().fov_Visible
fovcircle.Radius = getgenv().fov
fovcircle.Color = Color3.fromRGB(0, 255, 136)
fovcircle.Thickness = 2
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)


local function hitbox()
    local Players = game:GetService("Players")
    local OldNewIndex
    local parent = game.Parent
    getgenv().HeadSize = 50
    OldNewIndex = hookmetamethod(game, "__newindex", function(Self, Index, ...)
        if not checkcaller() and tostring(Self) == "Head" and tostring(Index) == "Size" and Self ~= Players.LocalPlayer.Character.Head then
            return Vector3.new(getgenv().HeadSize,getgenv().HeadSize,getgenv().HeadSize)
        end
        return OldNewIndex(Self, Index, ...)
    end)



    local OldIndex
    OldIndex = hookmetamethod(game, "__index", function(Self, Index)
        if tostring(Self) == "OriginalSize" and tostring(Index) == "Value" and tostring(Self.parent) == "Head" and Self.parent ~= Players.LocalPlayer.Character.Head then
            return Vector3.new(getgenv().HeadSize,getgenv().HeadSize,getgenv().HeadSize)
        end
        if tostring(Self) == "Head" and tostring(Index) == "Size" and Self ~= Players.LocalPlayer.Character.Head then
            return Vector3.new(getgenv().HeadSize,getgenv().HeadSize,getgenv().HeadSize)
        end
        return OldIndex(Self, Index)
    end)

    for _, value in pairs(Players:GetPlayers()) do
        if value.Character and value.Character:FindFirstChild("Head") then
            print(value.Character.Head.Size)
        end
    end
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
        if not getgenv().HeadSize then
            hitbox()
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "Takes time for hitbox to work!"; --chat notification
                Font = Enum.Font.ArialBold; --font changeable
                FontSize = Enum.FontSize.Size48; --font size changeable
            })
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
                    if shared.toggle and (mouse.Target.Parent:FindFirstChild("Humanoid") or mouse.Target.Parent:FindFirstChild("Head")) and mouse.Target.Parent.Name ~= player.Name then
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

Misc:Button("Load ESP", function()
    if getgenv().FontValue == nil then
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Base%20Battles-ESP.lua')))()
    end
end)

Misc:Bind(
    "ESP ON/OFf",
    Enum.KeyCode.H,
    function()
        if getgenv().FontValue ~= nil then
            getgenv().Visibility = not getgenv().Visibility
        end
    end
)

Misc:Toggle("Box esp",function(bool)
    if getgenv().FontValue ~= nil then
        getgenv().boxVis = bool
    end
end)



Misc:Button("[Shift-hold] speed & Jump", function()
    if getgenv().lll == nil then
        getgenv().lll = true
        local Players = game:GetService("Players")
        if not hookmetamethod then
            Players.LocalPlayer:Kick("Your exploit is not supported")
        end
        local OldNameCall
        OldNameCall = hookmetamethod(game, "__newindex", function(Self, Index, ...)
            if not checkcaller()  and (Index == "WalkSpeed" or Index == "JumpPower") then
                return
            end
            return OldNameCall(Self, Index, ...)
        end)

        local UIS = game:GetService("UserInputService")
        local Player = Players.LocalPlayer
        local DefaultWalkspeed = Player.Character.Humanoid.WalkSpeed
        local DefaultJumpPower = Player.Character.Humanoid.jumpPower
        if DefaultWalkspeed == 0 then
            DefaultWalkspeed = 22
            DefaultJumpPower = 50
        end
        if getgenv().walkSpeed == nil or getgenv().jumpPower == nil then
            getgenv().jumpPower = 250
            getgenv().walkSpeed = 250
        end
        UIS.InputBegan:Connect(
            function(input)
                if input.KeyCode == Enum.KeyCode.LeftShift then
                    Player.Character.Humanoid.WalkSpeed = getgenv().walkSpeed
                    Player.Character.Humanoid.JumpPower = getgenv().jumpPower
                end
            end
        )

        UIS.InputEnded:Connect(
            function(input)
                if input.KeyCode == Enum.KeyCode.LeftShift then
                    Player.Character.Humanoid.WalkSpeed = DefaultWalkspeed
                    Player.Character.Humanoid.JumpPower = DefaultJumpPower
                end
            end
        )
    end
end)


Misc:Slider("Walk speed",{
    min = 22; -- min value of the slider
    max = 500; -- max value of the slider
    precise = true; -- max 2 decimals
},function(value)
    getgenv().walkSpeed = value
end)


Misc:Slider("Jump Power",{
    min = 50; -- min value of the slider
    max = 500; -- max value of the slider
    precise = true; -- max 2 decimals
},function(value)
    getgenv().jumpPower = value
end)



aimBot:Button(
    "Load Aimbot",
    function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Waring aimbot!";
            Text = "For the aimbot to work correctly set your camera sensitivity to [0.2]";
            Duration = 20;
            })
        if getgenv().Loaded == nil then
            getgenv().Loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Base_Battles_aimbot.lua", true))()
        end
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

aimBot:Dropdown("Aimlock Method",{'Head', "UpperTorso"},true,function(mob) --true/false, replaces the current title "Dropdown" with the option that t
    getgenv().aim_at = mob
end)

getgenv().visibleCheck = false
aimBot:Toggle("Visible Check!",function(bool)
    getgenv().visibleCheck = bool
end)


aimBot:Toggle("Show fov",function(bool)
    getgenv().fov_Visible = bool
    fovcircle.Visible = getgenv().fov_Visible
end)



aimBot:ColorPicker("Fov Color",Color3.fromRGB(0, 255, 136),function(color) --Default color
    fovcircle.Color = color
end)

b:DestroyGui()
aimBot:DestroyGui()
