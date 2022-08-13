-- Localizing
local game = game
local pairs = pairs
local workspace = workspace

--Namecalls
local GetService = game.GetService
local FindFirstChild = game.FindFirstChild


-- services
local players = GetService(game, "Players")
local RunService = GetService(game, "RunService")
local UserInputService = GetService(game, "UserInputService")


-- Variables
local client = players.LocalPlayer
local camera = workspace.CurrentCamera
local WorldToViewportPoint = camera.WorldToViewportPoint
local mouseLocation = UserInputService.GetMouseLocation

getgenv().smoothness = 1
getgenv().fov = 250
getgenv().team_check = false

local circle = Drawing.new("Circle")
circle.Thickness = 2
circle.NumSides = 12
circle.Radius = getgenv().fov
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.new(1, 0.5, 0)
circle.Visible = true


local rootPart = "HumanoidRootPart"
for _, v in pairs(players:GetPlayers()) do
  if v ~= client and v.Character then
    if v.Character:FindFirstChild("HumanoidRootPart") then
      rootPart = "HumanoidRootPart"
    elseif v.Character:FindFirstChild("Torso") then
      rootPart = "Torso"
    elseif v.Character:FindFirstChild("PrimaryPart") then
      rootPart = "PrimaryPart"
    end
  end
end



local function isTeam(plr)
    if getgenv().team_check == false then
        return false
    end
    return plr.Team == client.Team
end


local function isAlive(plr)
    if game.PlaceId == 292439477 then
        return plr.Character.Torso.Parent ~= "Dead"
    end
    if FindFirstChild(plr.Character, "Humanoid") then
        return plr.Character.Humanoid.Health > 0
    else
        return true
    end
end
getgenv().vischeck = false
local function Is_visible(pos,...)
    if getgenv().no_vis == true then
        return true
    end
    return #camera:GetPartsObscuringTarget({pos},{client.Character,...}) == 0
end

local function get_closest_player(fov)
    local target
    local magnitude = fov or math.huge
    for _, plr in pairs(players:GetPlayers()) do
        if plr.Name ~= client.Name and plr.Character ~= nil and FindFirstChild(plr.Character, "Head") and Is_visible(plr.Character.PrimaryPart.Position,plr.Character) and isTeam(plr) == false and FindFirstChild(plr.Character, rootPart) and isAlive(plr) then
            local character = plr.Character
            local screen_pos, on_screen = WorldToViewportPoint(camera, character.Head.Position)
            local screen_pos = Vector2.new(screen_pos.X, screen_pos.Y)
            local new_magnitude = (screen_pos - mouseLocation(UserInputService)).Magnitude
            if new_magnitude < magnitude and on_screen then
                magnitude = new_magnitude
                target = plr
            end
        end
    end
    return target
end


local function aim_at(position, smoothness)
    local smoothness = smoothness or 1
    local pos = WorldToViewportPoint(camera,position)
    local mouse_pos = mouseLocation(UserInputService)
    mousemoverel((pos.X - mouse_pos.X) / smoothness, (pos.Y - mouse_pos.Y) / smoothness)
end

game.StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "Available commands:\n!setfov [number] 🤪\n!setsm [number] 🤪\n!teamcheck [true/false] \n!vischeck [true/false]";
    Color = Color3.fromRGB(255,0,0);
    Font = Enum.Font.SourceSansBold;
    FontSize = Enum.FontSize.Size60;
})

for key, value in pairs(getgc(true)) do
    if type(value) == "table" and rawget(value,"GetEquippingItem") then
        foo = value
    end
end

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(Self) == "SayMessageRequest" and method == "FireServer" then
        if string.find(args[1]:lower(), "!setfov") then
            local command = string.split(args[1], " ")
            getgenv().fov = tonumber(command[2])
            return
        elseif string.find(args[1]:lower(), "!setsm") then
            local command = string.split(args[1], " ")
            getgenv().smoothness = tonumber(command[2])
            return
        elseif string.find(args[1]:lower(), "!teamcheck") then
            local command = string.split(args[1], " ")
            if command[2] == "true" then
                getgenv().team_check = true
            else
                getgenv().team_check = false
            end
            return
        elseif string.find(args[1]:lower(), "!vischeck") then
                local command = string.split(args[1], " ")
                if command[2] == "true" then
                    getgenv().vischeck = true
                else
                    getgenv().vischeck = false
                end
                return
		elseif string.find(args[1]:sub(1, 1), "!") then
			game.StarterGui:SetCore("ChatMakeSystemMessage", {
				Text = "What??";
				Color = Color3.fromRGB(255, 242, 0);
				Font = Enum.Font.SourceSansBold;
				FontSize = Enum.FontSize.Size60;
			})
			return
        end
		
    end
    return OldNamecall(Self, ...)
end))

local newvector = Vector3.zero
local dot = newvector.Dot


local function trajectory(o, a, t, s, e)
    local f = -a
    local ld = t - o
    local a = dot(f, f)
    local b = 4 * dot(ld, ld)
    local k = (4 * (dot(f, ld) + s * s)) / (2 * a)
    local v = (k * k - b / a) ^ 0.5
    local t, t0 = k - v, k + v

    if not (t > 0) then
        t = t0
    end

    t = t ^ 0.5
    return f * t / 2 + (e or newvector) + ld / t, t
end


local gun = foo:GetEquippingItem(client)

local function predict_position(part)
    gun = foo:GetEquippingItem(game.Players.LocalPlayer)
    if gun == nil or gun.SharedData == nil or gun.SharedData.ProjectilePower == nil then
        return part.Position
    end
    local Origin
    if gun.GripWeld and gun.GripWeld.Parent and gun.GripWeld.Parent:FindFirstChild("Barrel") then
        Origin = gun.GripWeld.Parent:FindFirstChild("Barrel").Position
    elseif gun.GripWeld and gun.GripWeld.Parent and gun.GripWeld.Parent:FindFirstChild("Trigger") then
        Origin = gun.GripWeld.Parent:FindFirstChild("Trigger").Position
    elseif client.Character and client.Character:FindFirstChild("Trigger",true) and client.Character:FindFirstChild("Trigger",true).Position then
        Origin = client.Character:FindFirstChild("Trigger",true).Position
    else
        Origin = client.Character.Head.Position
    end
    local _,traveltime = trajectory(Origin, Vector3.new(0,-1,0), part.Position, gun.SharedData.ProjectilePower)
    
    return part.position + (part.Velocity * traveltime)
end



getgenv().aim_key = Enum.KeyCode.F
RunService.RenderStepped:Connect(function()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService:IsKeyDown(getgenv().aim_key) then
        local target = get_closest_player(getgenv().fov)
        if target then
            local position = predict_position(target.Character.Head)
            aim_at(position, getgenv().smoothness)
        end
    end
    if circle.__OBJECT_EXISTS then
        circle.Radius = getgenv().fov
        circle.Position = mouseLocation(UserInputService)
    end
end)


--- Calculate velocity
local RunService = GetService(game, "RunService")
local Heartbeat = RunService.Heartbeat
local deltaTime
function setDelat()
    while true do
        deltaTime = Heartbeat:Wait()
    end
end

coroutine.wrap(setDelat)()

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
