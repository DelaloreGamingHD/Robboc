if not game:IsLoaded() then
    game.Loaded:Wait()
end
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = tostring("Anarchy"), HidePremium = false, SaveConfig = false})
if not getgenv().aimloaded then
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/aimbot_Anarchy.lua')))()
    getgenv().aimloaded = true
end
local guiservice = game:GetService("GuiService")
local fovcircle = Drawing.new("Circle")
local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local TabAim = Window:MakeTab({
    Name = "Aimbot",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Tab = Window:MakeTab({
        Name = "Visual",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
})



local micTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


getgenv().cham = false
getgenv().nameESP = false
getgenv().boxESP = false


getgenv().esp_loaded = false
getgenv().Visibility = false



function SendNote(message : string, time)
    OrionLib:MakeNotification({
        Name = "Title!",
        Content = message,
        Image = "rbxassetid://4483345998",
        Time = time or 3
    })
end



TabAim:AddToggle({
	Name = "Visible Check",
	Default = true,
	Callback = function(Value)
        getgenv().visibleCheck = Value
	end    
})



TabAim:AddToggle({
	Name = "Random Aimlock",
	Default = true,
	Callback = function(Value)
        getgenv().random_aim = Value
	end    
})





TabAim:AddDropdown({
	Name = "Aimlock Method",
	Default = "Head",
	Options = {"Head", "Torso"},
	Callback = function(Value)
		getgenv().aim_at = Value
	end    
})


TabAim:AddSlider({
	Name = "Aim Smoothness",
	Min = 0,
	Max = 10,
	Default = getgenv().aim_smooth or 3,
	Color = Color3.fromRGB(0, 255, 55),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
		getgenv().aim_smooth = Value
	end    
})

TabAim:AddToggle({
	Name = "Aim prediction",
	Default = true,
	Callback = function(Value)
        getgenv().predict = Value
        SendNote("It is recommended that you set aim smoothness to 1",3)
	end    
})

TabAim:AddSlider({
	Name = "Prediction time",
	Min = 0.01,
	Max = 4,
	Default = 0.05,
	Color = Color3.fromRGB(208, 0, 255),
	Increment = 0.01,
	ValueName = "Sec",
	Callback = function(Value)
		getgenv().timP = Value
	end    
})


TabAim:AddSlider({
	Name = "Fov",
	Min = 0,
	Max = 800,
	Default = getgenv().fov or 400,
	Color = Color3.fromRGB(255, 0, 136),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
		getgenv().fov = Value
        fovcircle.Radius = getgenv().fov
	end    
})





local function TP()
    local player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local Mouse = player:GetMouse()


    local deb = false  
    local opos = player.Character.HumanoidRootPart.CFrame

    local OldIndex = nil

    OldIndex = hookmetamethod(game, "__index", function(Self, Key)
        if not checkcaller() and self == "HumanoidRootPart" and self.Parent == player.Character and key == "CFrame" and deb then
            return opos
        end
        return OldIndex(Self, Key)
    end)


    local function tp(newpos)
        if player.Character ~= nil and player.Character:FindFirstChild("HumanoidRootPart") ~= nil then
            opos = player.Character.HumanoidRootPart.CFrame
            deb = true
            player.Character.HumanoidRootPart.CFrame = CFrame.new(newpos)
            deb = false
        end
    end

    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            if (Mouse.Hit.p - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 900 then
                tp(Mouse.Hit.p + Vector3.new(0, 3, 0))
            end
            
        end
    end)
end






getgenv().fov_Visible = true

fovcircle.Visible = getgenv().fov_Visible
fovcircle.Radius = getgenv().fov or 400
fovcircle.Color = Color3.fromRGB(0, 255, 136)
fovcircle.Thickness = 1.5
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

game:GetService("RunService").RenderStepped:Connect(function()
    fovcircle.Position = Vector2.new(mouse.X, mouse.Y + (guiservice.GetGuiInset(guiservice).Y))
end)
TabAim:AddToggle({
	Name = "Fov Circle",
	Default = getgenv().fov_Visible,
	Callback = function(Value)
        getgenv().fov_Visible = Value
        fovcircle.Visible = getgenv().fov_Visible
	end    
})




Tab:AddToggle({
	Name = "Visual",
	Default = getgenv().Visibility,
	Callback = function(Value)
		if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
		getgenv().Visibility = Value
	end    
})

Tab:AddToggle({
	Name = "Box ESP",
	Default = getgenv().Visibility,
	Callback = function(Value)
		if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
		getgenv().boxESP = Value
	end    
})


Tab:AddToggle({
	Name = "Name",
	Default = getgenv().Visibility,
	Callback = function(Value)
		if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
		getgenv().nameESP = Value
	end    
})


Tab:AddToggle({
	Name = "Chams",
	Default = getgenv().Visibility,
	Callback = function(Value)
		if getgenv().esp_loaded == false and Value == true then
            getgenv().esp_loaded = true
            loadstring(game:HttpGet("https://raw.githubusercontent.com/skatbr/Roblox-Releases/main/A_simple_esp.lua", true))()
        end
		getgenv().cham = Value
	end    
})





Tab:AddToggle({
        Name = "Use Team-Color",
        Default = false,
        Callback = function(Value)
			getgenv().useTeamColor = Value
        end
})


micTab:AddButton({
	Name = "Ctrl + Click TP",
	Callback = function()
      		TP()
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
