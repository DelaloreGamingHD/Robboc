if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")


local FontValue = 1

if game.PlaceId == 292439477 then
    for _, v in next, getgc(true) do
        if type(v) == "table" then
            if rawget(v, "getbodyparts") then
                replication = v;
            end
        end
    end

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local OldIndex = nil

    OldIndex = hookmetamethod(game, "__index", function(Self, Key)
        if checkcaller() and Self ~= LocalPlayer and Key == "Character" then
            local char = replication.getbodyparts(Self)
            if type(char) == "table" then
                Self.Character = char.torso.Parent
            end
        end
        return OldIndex(Self, Key)
    end)
end



getgenv().changeFont = function CycleFont()
    if FontValue + 1 > 3 then
        FontValue = 1
    else
        FontValue = FontValue + 1
    end
end


local function isTeam(plr)
    if getgenv().TeamCheck == false then return false end
    if plr.TeamColor == Player.TeamColor then return true else return false end
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
local folder = Instance.new("Folder", game:GetService("CoreGui"))
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
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = getgenv().cham
    highlight.Parent = folder
    local function Update()
        local c
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().Visibility == true and plr.Character ~= nil and isTeam(plr) == false and plr.Character:FindFirstChild("Head") ~= nil and plr.Character:FindFirstChild("Torso") ~= nil then
                local Distance = (Camera.CFrame.Position - plr.Character.Torso.Position).Magnitude
                local Vector, OnScreen = Camera:WorldToScreenPoint(plr.Character.Head.Position)


                highlight.Adornee = plr.Character
                highlight.Enabled = getgenv().cham
                if getgenv().useTeamColor then
                    highlight.FillColor = plr.TeamColor.Color
                else
                    highlight.FillColor = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
                end



                if OnScreen and getgenv().nameESP then
                    Name.Position = Vector2.new(Vector.X, Vector.Y + math.clamp(Distance / 10, 10, 30) - 10)
                    Name.Size = math.clamp(30 - Distance / 10, 10, 30)
                    if getgenv().useTeamColor then
                        Name.Color = plr.TeamColor.Color
                    else
                        Name.Color = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
                    end
                    Name.Visible = true
                    Name.Font = FontValue
                    Name.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
                else
                    Name.Visible = false
                end

                Name.Text = string.format(plr.Name.." ["..tostring(math.floor(Distance*0.28)).."m]")

                local PartCorners = GetPartCorners(plr.Character.Torso)
                local VectorTR, OnScreenTR = Camera:WorldToScreenPoint(PartCorners.TR)
                local VectorBR, OnScreenBR = Camera:WorldToScreenPoint(PartCorners.BR)
                local VectorTL, OnScreenTL = Camera:WorldToScreenPoint(PartCorners.TL)
                local VectorBL, OnScreenBL = Camera:WorldToScreenPoint(PartCorners.BL)

                if (OnScreenBL or OnScreenTL or OnScreenBR or OnScreenTR) and getgenv().boxESP then
                    Box.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
                    Box.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
                    Box.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
                    Box.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
                    if getgenv().useTeamColor then
                        Box.Color = plr.TeamColor.Color
                    else
                        Box.Color = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
                    end

                    Box.Thickness = math.clamp(3 - (Distance / 100), 0, 3)
                    Box.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
                    Box.Visible = true
                else
                    Box.Visible = false
                end
            else
                Box.Visible = false
                Name.Visible = false
                highlight.Enabled = false
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
