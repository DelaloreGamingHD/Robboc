local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "{skatbr} Phantom Forces-Empire", HidePremium = false, SaveConfig = false, ConfigFolder = "OrionPH"})
local SLIDER
local aimbotTab = Window:MakeTab({
	Name = "Aimbot",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local aimbotTab2 = Window:MakeTab({
	Name = "More Aimbot",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "Visual",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

function SendNote(message, time)
    OrionLib:MakeNotification({
        Name = "Hub",
        Content = message,
        Image = "rbxassetid://4483345998",
        Time = time or 3
    })
end

getgenv().aimbotLoaded = false
aimbotTab:AddButton({
	Name = "Load Aimbot",
	Callback = function()
            if getgenv().aimbotLoaded == false then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/ph_aimbot_new.lua", true))()
                getgenv().aimbotLoaded = true
                SendNote("Aimbot Loaded!")
            
      		elseif getgenv().aimbotLoaded == true then
                SendNote("Aimbot is already Loaded!")
            end
  	end    
})

aimbotTab:AddButton({
	Name = "Use recommended sensitivity",
	Callback = function()
        SLIDER:Set(1)
        getgenv().aim_smooth = 1
        if not getgenv().useRC then
            getgenv().useRC = true
            local userInputService = game:GetService("UserInputService")
            local UserGameSettings = UserSettings():GetService("UserGameSettings")

            local number = 0.2

            local mouseDeltaSensitivity = number  / UserGameSettings.MouseSensitivity 
            userInputService.MouseDeltaSensitivity = mouseDeltaSensitivity

            UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"):Connect(function()
                mouseDeltaSensitivity = number  / UserGameSettings.MouseSensitivity 
                userInputService.MouseDeltaSensitivity = mouseDeltaSensitivity
            end)
        end
  	end    
})


aimbotTab:AddToggle({
	Name = "Visible check",
	Default = false,
	Callback = function(Value)
		getgenv().visibleCheck = Value
	end
})



local fovcircle = Drawing.new("Circle")
fovcircle.Radius = getgenv().fov or 400
fovcircle.Color = Color3.fromRGB(255, 0, 132)
fovcircle.Thickness = 1.5
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local guiservice = game:GetService("GuiService")

game:GetService("RunService").RenderStepped:Connect(function()
    fovcircle.Position = Vector2.new(mouse.X, mouse.Y + (guiservice.GetGuiInset(guiservice).Y))
end)


aimbotTab:AddSlider({
	Name = "Fov",
	Min = 0,
	Max = 800,
	Default = 400,
	Color = Color3.fromRGB(0, 255, 166),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
        getgenv().fov = Value
		fovcircle.Radius = Value
	end    
})


SLIDER = aimbotTab:AddSlider({
	Name = "Aim Smoothness",
	Min = 0,
	Max = 20,
	Default = 3,
	Color = Color3.fromRGB(0, 255, 55),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
		getgenv().aim_smooth = Value
	end    
})

aimbotTab:AddSlider({
	Name = "Fov",
	Min = 0,
	Max = 800,
	Default = 400,
	Color = Color3.fromRGB(115, 0, 255),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
        getgenv().fov = Value
		fovcircle.Radius = Value
	end    
})


aimbotTab:AddToggle({
	Name = "Show Fov",
	Default = true,
	Callback = function(Value)
		fovcircle.Visible = Value
	end
})

aimbotTab:AddColorpicker({
	Name = "Colorpicker",
	Default = Color3.fromRGB(255, 0, 132),
	Callback = function(Value)
		fovcircle.Color = Value
	end	  
})


aimbotTab:AddDropdown({
	Name = "Aimlock Method",
	Default = "head",
	Options = {"head", "torso","Random"},
	Callback = function(Value)
		getgenv().aim_at = Value
	end    
})

aimbotTab2:AddToggle({
	Name = "Aimbot Prediction",
	Default = true,
	Callback = function(Value)
        getgenv().predict = Value
        SendNote("Recommend that you set aim smoothness to 1 & your camera senv to 0.2",10)
	end    
})

aimbotTab2:AddDropdown({
	Name = "Prediction Method",
	Default = "Advanced",
	Options = {"Simple", "Advanced"},
	Callback = function(Value)
		getgenv().predictionMethod = Value
		if Value == "Advanced" then
			SendNote("Prediction time won't be used!",5)
		end
	end
})
aimbotTab2:AddSlider({
	Name = "Prediction time",
	Min = 0.01,
	Max = 4,
	Default = 0.1,
	Color = Color3.fromRGB(255, 0, 60),
	Increment = 0.01,
	ValueName = "sec",
	Callback = function(Value)
		getgenv().predictionTime = Value
	end    
})



getgenv().esp_loaded = false
Tab:AddButton({
	Name = "Load ESP!",
	Callback = function()
            if getgenv().esp_loaded == false then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/ph_esp_new.lua", true))()
                getgenv().esp_loaded = true
                SendNote("ESP Loaded!")
            
      		elseif getgenv().esp_loaded == true then
                SendNote("ESP is already Loaded!")
            end
  	end    
})


Tab:AddToggle({
	Name = "Visual",
	Default = true,
	Callback = function(Value)
		getgenv().Visibility = Value
	end    
})

Tab:AddToggle({
	Name = "Box ESP",
	Default = true,
	Callback = function(Value)
		getgenv().boxESP = Value
	end    
})


Tab:AddToggle({
	Name = "Name",
	Default = true,
	Callback = function(Value)
		getgenv().nameESP = Value
	end    
})


Tab:AddSlider({
	Name = "Font",
	Min = 0,
	Max = 3,
	Default = 1,
	Color = Color3.fromRGB(174, 0, 255),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
        getgenv().FontValue = Value
	end    
})

Tab:AddToggle({
	Name = "Highlight",
	Default = false,
	Callback = function(Value)
		getgenv().cham = Value
	end    
})

Tab:AddToggle({
    Name = "Team check",
    Default = true,
    Callback = function(Value)
        getgenv().TeamCheck = Value
    end
})


Tab:AddToggle({
        Name = "Use Team-Color",
        Default = false,
        Callback = function(Value)
			getgenv().useTeamColor = Value
        end
})


local orionion = game:GetService("CoreGui"):FindFirstChild("Orion")

local destroygui = Tab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        orionion:Destroy()
        OrionLib:Destroy()
        
        wait(1)
        
        OrionLib:MakeNotification({
            Name = "Removing GUI...",
            Content = "GUI is removed!",
            Time = 3
        })
    end    
})

OrionLib:Init()
