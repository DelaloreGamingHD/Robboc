local client = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = client:GetMouse()
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")


for _, v in pairs(getgc(true)) do
    if type(v) == "table" and type(rawget(v, 'getbodyparts')) == 'function' then
        getbody = v
    end
end

if not getgenv().aim_smooth then
    getgenv().aim_smooth = 2
end

if not getgenv().aim_at then
    getgenv().aim_at = "head"
end


local function CheckRay(from,to)
    local rayOrigin = from.Position
    local rayDirection = CFrame.new(from.Position,to.Position).LookVector.Unit*(from.Position-to.Position).Magnitude

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {client.Character.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart.Parent.Name == "Player" then
            return true
        else
            return false
        end
    end
end


local function closestPlayer(fov)
    local target = nil
    local closest = fov or math.huge
    for i,v in ipairs(players:GetPlayers()) do
        local character = getbody.getbodyparts(v)
        if character and client.Character and v ~= client and v.TeamColor ~= client.TeamColor  then
            local _, onscreen = camera:WorldToScreenPoint(character.head.Position)
            if onscreen then
                local targetPos = camera:WorldToViewportPoint(character.head.Position)
                local mousePos = camera:WorldToViewportPoint(mouse.Hit.p)
                local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetPos.X, targetPos.Y)).magnitude
                if dist < closest and CheckRay(game.Players.LocalPlayer.Character.Head,character.head) then
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

local isAiming = false
uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end
end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
end)

rs.RenderStepped:connect(function()
    local t = closestPlayer(800)
    if isAiming and t then
        aimAt(getbody.getbodyparts(t)[getgenv().aim_at].Position, getgenv().aim_smooth)
    end
end)
