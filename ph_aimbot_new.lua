assert(mousemoverel, "missing dependency: mousemoverel")

if not game.Loaded then game.Loaded:Wait() end

local client = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local mouse = client:GetMouse()
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

if not mousemoverel or not getgenv or not getgc then
    client:Kick("Your exploit is not supported")
end

for _, v in pairs(getgc(true)) do
    if type(v) == "table" and type(rawget(v, 'getbodyparts')) == 'function' then
        getbody = v
    end
end

for _, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "sensitivity") then
        if v.sensitivity > 0.7 then
            v.sensitivity = 0.5
        end
    end
end

for _, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "aimsensitivity") then
        if v.aimsensitivity > 0.7 then
            v.aimsensitivity = 0.5
        end
    end
end



if not getgenv().aim_smooth then
    getgenv().aim_smooth = 2
end

if not getgenv().aim_at then
    getgenv().aim_at = "head"
end

if not getgenv().fov then
    getgenv().fov = 400
end

local aimParts = {"head","torso"}
local function randomAimPart(table)
    local value = math.random(1,#table) -- Get random number with 1 to length of table.
    return table[value]
end


local Rayparams = RaycastParams.new();
Rayparams.FilterType = Enum.RaycastFilterType.Blacklist;


if not getgenv().visibleCheck then
    getgenv().visibleCheck = true
end
local function CheckRay(from,to)
    if getgenv().visibleCheck == false then
        return true
    end
    local pass = false
    local CF = CFrame.new(from.Position, to.Position);
    local Hit = workspace:Raycast(CF.p, CF.LookVector * (from.Position - to.Position).magnitude, Rayparams);
    if Hit.Instance.Name == "Head" then
        pass = true
    else
        pass = false
    end
    return pass
end


if not getgenv().aimbotPrediction or not getgenv().predictionTime then
    getgenv().aimbotPrediction = true
    getgenv().predictionTime = 0.1
end

local function predictPosition(part, timeInterval)
    if getgenv().aimbotPrediction == false then
        return part.Position
    end
    return part.Position + part.Velocity * timeInterval
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
                Rayparams.FilterDescendantsInstances = {client.Character}
                if dist < closest and CheckRay(client.Character.Head,character.head) then
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
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = true
    end
end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end
end)

rs.RenderStepped:connect(function()
    if not client.Character or not isAiming then return end
    local t = closestPlayer(getgenv().fov)

    if t and getgenv().aim_at ~= "Random" then
        aimAt(predictPosition(getbody.getbodyparts(t)[getgenv().aim_at],getgenv().predictionTime), getgenv().aim_smooth)

    elseif t and getgenv().aim_at == "Random" then
        aimAt(predictPosition(getbody.getbodyparts(t)[randomAimPart(aimParts)],getgenv().predictionTime), getgenv().aim_smooth)
    end
end)


--- Calculate velocity
local Heartbeat = rs.Heartbeat
local deltaTime
function setDelat()
    while true do
        deltaTime = Heartbeat:Wait()
    end
end

coroutine.wrap(setDelat)()

print("Working "..tostring(deltaTime))

local OldIndex
local previousPosition = Vector3.new()
OldIndex = hookmetamethod(game, "__index", function(Self, Index)
    if checkcaller() and Index == "Velocity" then
        local velocity = (Self.Position - previousPosition) / deltaTime
        previousPosition = Self.Position
        if velocity.Magnitude > 100 then
            return Vector3.new(0,0,0)
        end

        return velocity
    end
    return OldIndex(Self, Index)
end)