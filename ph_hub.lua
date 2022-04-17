local windows = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZepsyyCodesLUA/Synapse-Library-OBFUSCATED-/main/Source.lua"))()
local win = windows:Create({
    Title = "Skatbr",
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

tab:DropDown({
    Text = "Aimlock Method",
    PlaceHolder = 'Choose An Aim Method...',
    Options = {'head', "torso"},
    Callback = function(args)
        print(args)
		getgenv().aim_at = args
    end
})

tab:Slider({
    Title = "Smoothing",
    MinValue = 1,
    Def = 2,
    MaxValue = 25,
    callback = function(args)
        getgenv().aim_smooth = args
    end
})

local tab = win:NewTab({
    Title = "TriggerBot"
})

local tab = win:NewTab({
    Title = "Misc."
})
