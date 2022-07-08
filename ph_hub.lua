local windows = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZepsyyCodesLUA/Synapse-Library-OBFUSCATED-/main/Source.lua"))()
local win = windows:Create({
    Title = "22 hub",
    Game = "Phantom Forces!"
})

local tab = win:NewTab({
    Title = "Main"
})

tab:Label({
    Title = "Welcome!"
})

getgenv().aimbot_loaded = false
tab:Button({
    Title = "Load Aimbot",
    Callback = function()
        if not getgenv().aimbot_loaded then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/PH_AIMBOT.lua", true))()
            getgenv().aimbot_loaded = true
        end
        
    end
})

getgenv().esp_loaded = false
tab:Button({
    Title = "Load ESP",
    Callback = function()
        if not getgenv().esp_loaded then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Phantom_%20Forces_ESP.lua", true))()
            getgenv().esp_loaded = true
        end
    end
})

tab:TextBox({
    Title = "ESP Info",
    PlaceHolder = "5 to enable/disable ESP,4 to change text size",

    Callback = function(args)
        print(args)
    end
})

tab:DropDown({
    Text = "Aimlock Method",
    PlaceHolder = 'Choose An Aim Method...',
    Options = {'head', "torso","random"},
    Callback = function(args)
        if args == "random" then
            getgenv().random_aim = true
        else
            getgenv().random_aim = false
            getgenv().aim_at = args
        end
    end
})

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

tab:Slider({
    Title = "Smoothing",
    MinValue = 1,
    Def = 2,
    MaxValue = 25,
    callback = function(args)
        getgenv().aim_smooth = args
    end
})


tab:Toggle({
    Title = "Show fov",
    Description = "Draw Circle",
    Callback = function(args)
        getgenv().fov_Visible = args
        fovcircle.Visible = getgenv().fov_Visible
    end
})

tab:Slider({
    Title = "Fov",
    MinValue = 1,
    Def = 400,
    MaxValue = 800,
    callback = function(args)
        getgenv().fov = args
        fovcircle.Radius = getgenv().fov
    end
})



local tab = win:NewTab({
    Title = "TriggerBot"
})

getgenv().TriggerBot_loaded = false
tab:Toggle({
    Title = "Enable TriggerBot",
    Description = "Automatically shoots when cursor is placed over an enemy.",
    Callback = function(args)
        if not getgenv().TriggerBot_loaded then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/Phantom_%20Forces_TRIGGERBOT.lua", true))()
        end
        getgenv().triggerBot = args
    end
})

tab:Toggle({
    Title = "Head only",
    Description = "Shoot only if you aim at the head.",
    Callback = function(args)
        getgenv().head_check = args
    end
})

tab:Slider({
    Title = "releasetime",
    MinValue = 0,
    Def = 0,
    MaxValue = 6,
    callback = function(args)
        getgenv().releasetime = args
    end
})

tab:Slider({
    Title = "Reaction time",
    MinValue = 0,
    Def = 0,
    MaxValue = 4,
    callback = function(args)
        getgenv().reaction_time = args
    end
})


local tab = win:NewTab({
    Title = "Unsafe"
})
if not getgenv().head_size then
    getgenv().head_size = 2
end
getgenv().exp = "Torso"
getgenv().doRandom = false
local parts = {"Head", "Torso"}
spawn(function()
    while true do 
        if getgenv().doRandom == true then
            getgenv().exp =  parts[math.random(1, #parts)]
        end
        wait(0.3)
    end
end)



function hitbox2x()
    local players = game:GetService("Workspace").Players

    local OldIndex = nil

    OldIndex =
        hookmetamethod(
        players,
        "__index",
        function(Self, Key)
            if not checkcaller() and getgenv().expandHitbox then
                
                if not checkcaller() and tostring(Self) == getgenv().exp and Key == "Size" then
                    return Vector3.new(getgenv().head_size, getgenv().head_size, getgenv().head_size)
                end
            end

            return OldIndex(Self, Key)
        end
    )
end



tab:DropDown({
    Text = "Hitbox",
    PlaceHolder = 'Choose An Part...',
    Options = {'Head', "Torso", "Random"},
    Callback = function(args)
        if args ~= "Random" then
            getgenv().exp = args
            getgenv().doRandom = false
        end
        if args == "Random" then
            getgenv().doRandom = true
        end
        
    end
})



tab:Slider({
    Title = "Hitbox Size",
    MinValue = 1,
    Def = 2,
    MaxValue = 5,
    callback = function(args)
        getgenv().head_size = args
    end
})

tab:Toggle({
    Title = "Enable",
    Description = "Hitbox becomes bigger!",
    Callback = function(args)
        if not getgenv().expandHitbox then
            hitbox2x()
        end
        getgenv().expandHitbox = args
    end
})
