local client = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local mouse = client:GetMouse()
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "Recommend that you set your camera sensitivity to [0.2]"; --chat notification
    Font = Enum.Font.SourceSansBold; --font changeable
    FontSize = Enum.FontSize.Size24; --font size changeable
})






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

hitbox()


if getgenv().aim_smooth == nil then
    getgenv().aim_smooth = 2
    getgenv().fov = 400
end

if getgenv().aim_at == nil then
    getgenv().aim_at = "Head"
end

if getgenv().FontValue == nil then
    local teams
    for key, value in pairs(getgc(true)) do
        if type(value) == "function" and debug.getinfo(value).name =="sortTeamList" then
            local Teamtable = debug.getupvalue(value, 1)
            if type(Teamtable) == "table" then
                teams = Teamtable
            end
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


local Rayparams = RaycastParams.new();
Rayparams.FilterType = Enum.RaycastFilterType.Blacklist;


if getgenv().visibleCheck == nil then
    getgenv().visibleCheck = true
end
local function isVisible(p,...)
    if getgenv().visibleCheck == false then
        return true
    end

    return #camera:GetPartsObscuringTarget({p}, {camera, client.Character,...}) == 0
end




local function closestPlayer(fov)
    local target = nil
    local closest = fov or math.huge
    for i,v in ipairs(players:GetPlayers()) do
        local character = v.Character
        if v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character:FindFirstChild("Head") ~= nil and v.TeamColor ~= client.TeamColor then
            local _, onscreen = camera:WorldToScreenPoint(character.Head.Position)
            if onscreen then
                local targetPos = camera:WorldToViewportPoint(character.Head.Position)
                local mousePos = camera:WorldToViewportPoint(mouse.Hit.p)
                local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetPos.X, targetPos.Y)).magnitude
                Rayparams.FilterDescendantsInstances = {client.Character}
                if dist < closest and isVisible(character.Head.Position, character) then
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
getgenv().random_aim = false
local isAiming = false
uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = true
        if getgenv().random_aim then
            getgenv().aim_at = randomAimPart(aimParts)
        end
    end
end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
end)

local userInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local number = 0.2

local mouseDeltaSensitivity = number  / UserGameSettings.MouseSensitivity 
userInputService.MouseDeltaSensitivity = mouseDeltaSensitivity

UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"):Connect(function()
	mouseDeltaSensitivity = number  / UserGameSettings.MouseSensitivity 
	userInputService.MouseDeltaSensitivity = mouseDeltaSensitivity
end)

rs.RenderStepped:connect(function()
    local t = closestPlayer(getgenv().fov)
    
    if isAiming and t then
        aimAt(t.Character[getgenv().aim_at].Position,getgenv().aim_smooth)
    end
end)
