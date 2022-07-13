local client = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local mouse = client:GetMouse()
local players = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")



if not getgenv().aim_smooth then
    getgenv().aim_smooth = 3
    getgenv().fov = 400
end

if not getgenv().aim_at then
    getgenv().aim_at = "Head"
end


local Rayparams = RaycastParams.new();
Rayparams.FilterType = Enum.RaycastFilterType.Blacklist;

if not getgenv().visibleCheck then
    getgenv().visibleCheck = false
end

local function CheckRay(pos, part)
    if getgenv().visibleCheck == false then
        return true
    end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {client.Character, part.Parent}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = workspace:Raycast(client.Character.HumanoidRootPart.Position, (pos - client.Character.HumanoidRootPart.Position).unit * (pos - client.Character.HumanoidRootPart.Position).magnitude, params)
    if Result ~= nil then
        return false
    end
    return true
end





local function closestPlayer(fov)
    local target = nil
    local closest = fov or math.huge
    for i,v in ipairs(players:GetPlayers()) do
        local character = v.Character
        if v ~= client and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character:FindFirstChild("Head") ~= nil then
            local _, onscreen = camera:WorldToScreenPoint(character.Head.Position)
            if onscreen then
                local targetPos = camera:WorldToViewportPoint(character.PrimaryPart.Position)
                local mousePos = camera:WorldToViewportPoint(mouse.Hit.p)
                local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetPos.X, targetPos.Y)).magnitude
                Rayparams.FilterDescendantsInstances = {client.Character}
                if dist < closest and CheckRay(character.HumanoidRootPart.Position,character.HumanoidRootPart) then
                    closest = dist
                    target = v
                end
            end
        end
    end
    return target
end


local aimParts = {"Head","Torso"}
local function randomAimPart(table)
    local value = math.random(1,#table) -- Get random number with 1 to length of table.
    return table[value]
end



local function aimAt(pos,smooth)
    local targetPos = camera:WorldToScreenPoint(pos)
    local mousePos = camera:WorldToScreenPoint(mouse.Hit.p)
    mousemoverel((targetPos.X-mousePos.X)/smooth,(targetPos.Y-mousePos.Y)/smooth)
end
getgenv().random_aim = true
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

rs.RenderStepped:connect(function()
    local t = closestPlayer(getgenv().fov)
    
    if isAiming and t and CheckRay(t.Character.HumanoidRootPart.Position,t.Character.HumanoidRootPart)then
        aimAt(t.Character[getgenv().aim_at].Position,getgenv().aim_smooth)
    end
end)
