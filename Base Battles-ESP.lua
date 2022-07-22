if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not getgenv() then
    game.Players.LocalPlayer:Kick("Your exploit does not support this!")
end


if not getgenv().FontValue then
    local teams
    for key, value in pairs(getgc(true)) do
        if type(value) == "table" and rawget(value, "Teams") then
            local Teamtable = value.Teams
            if type(Teamtable) == "table" then
                teams = Teamtable
            end
            break
        end
    end


    local old_index
    old_index = hookmetamethod(game, "__index", function(t, i)
        if checkcaller() and i == "Team" or i == "TeamColor" then
            local pp = teams[t]
            if pp ~= nil then
                return pp
            end
        end
        return old_index(t, i)
    end)

end


local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")

getgenv().useTeamColor = true
getgenv().FontValue = 1
getgenv().Visibility = true

if getgenv().boxVis == nil then
    getgenv().boxVis = false
end


local function GetPartCorners(Part)
    local Size = Part.Size * Vector3.new(1, 1.5)
    return {
        TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
        BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
        TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
        BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position,
    }
end

local function DrawESP(plr)
    local Name = Drawing.new("Text")
    Name.Center = true
    Name.Visible = false
    Name.Outline = true
    Name.Transparency = 1
    local Box = Drawing.new("Quad")
    Box.Visible = false
    Box.PointA = Vector2.new(0, 0)
    Box.PointB = Vector2.new(0, 0)
    Box.PointC = Vector2.new(0, 0)
    Box.PointD = Vector2.new(0, 0)
    Box.Color = Color3.fromRGB(255, 255, 255)
    Box.Thickness = 2
    Box.Transparency = 1
    local function Update()
        local c
        c = game:GetService("RunService").RenderStepped:Connect(function()
            task.wait()
            if plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Distance = (Camera.CFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                local Vector, OnScreen = Camera:WorldToScreenPoint(plr.Character.Head.Position)
                if OnScreen and getgenv().Visibility then
                    Name.Position = Vector2.new(Vector.X, Vector.Y + math.clamp(Distance / 10, 10, 30) - 10)
                    Name.Size = math.clamp(30 - Distance / 10, 15, 30)
                    if plr.TeamColor == Player.TeamColor then
                        Name.Color = Color3.fromRGB(0, 255, 26)
                    elseif plr.TeamColor ~= Player.TeamColor then
                        Name.Color = Color3.fromRGB(255, 0, 0)
                    else
                        Name.Color = Color3.fromRGB(174, 0, 255)
                    end
                    Name.Visible = true
                    Name.Font = 1
                else
                    Name.Visible = false
                end

                Name.Text = string.format(plr.Name.." ["..tostring(math.floor(Distance*0.28)).."m]")
                if getgenv().boxVis then
                    local PartCorners = GetPartCorners(plr.Character.HumanoidRootPart)
                    local VectorTR, OnScreenTR = Camera:WorldToScreenPoint(PartCorners.TR)
                    local VectorBR, OnScreenBR = Camera:WorldToScreenPoint(PartCorners.BR)
                    local VectorTL, OnScreenTL = Camera:WorldToScreenPoint(PartCorners.TL)
                    local VectorBL, OnScreenBL = Camera:WorldToScreenPoint(PartCorners.BL)
                    if (OnScreenBL or OnScreenTL or OnScreenBR or OnScreenTR) and getgenv().Visibility then
                        Box.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
                        Box.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
                        Box.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
                        Box.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
                        if getgenv().useTeamColor then
                            if plr.TeamColor == Player.TeamColor then
                                Box.Color = Color3.fromRGB(0, 255, 26)
                            elseif plr.TeamColor ~= Player.TeamColor then
                                Box.Color = Color3.fromRGB(255, 0, 0)
                            else
                                Box.Color = Color3.fromRGB(174, 0, 255)
                            end
                        else
                            Box.Color = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
                        end
    
                        Box.Thickness = math.clamp(3 - (Distance / 100), 0, 3)
                        Box.Visible = true
                    else
                        Box.Visible = false
                    end
                end
            else
                Box.Visible = false
                Name.Visible = false
                if game.Players:FindFirstChild(plr.Name) == nil then
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _,v in pairs(game:GetService("Players"):GetChildren()) do
    if v.Name ~= Player.Name then
        DrawESP(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(v)
    DrawESP(v)
end)
