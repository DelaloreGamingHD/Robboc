-- made by [skatbr | No idea#7972]
if not game.Loaded then game.Loaded:Wait() end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local client = Players.LocalPlayer
local camera = workspace.CurrentCamera



getgenv().ESP = {
    esp_is_enabled = true;
    TeamCheck = false;
    close = {0, 255, 0};
    far = {255, 0, 0};
}


local teams = 0
for i, v in pairs(game:GetService("Teams"):GetTeams()) do
  teams += 1
end
if teams >= 2 then
    getgenv().ESP.TeamCheck = true
end


local function get_part_corners(part)
  local size = part.Size * Vector3.new(1, 1.5)
  return {
    ["TopRight"] = (part.CFrame * CFrame.new(-size.X, size.Y, 0)).Position,
    ["TopLeft"] = (part.CFrame * CFrame.new(size.X, size.Y, 0)).Position,
    ["BottomLeft"] = (part.CFrame * CFrame.new(size.X, -size.Y, 0)).Position,
    ["BottomRight"] = (part.CFrame * CFrame.new(-size.X, -size.Y, 0)).Position
  }
end

if game.PlaceId == 292439477 then
  for _, v in next, getgc(true) do
    if type(v) == "table" then
      if rawget(v, "getbodyparts") then
        replication = v;
      elseif type(v) == "table" and rawget(v, "getplayerhealth") then
        hud = v
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


local function isAlive(plr : Player)
  if game.PlaceId == 292439477 then
    return plr.Character.Name ~= "Dead"
  else
    if plr.Character:FindFirstChild("Humanoid") then
        return plr.Character:FindFirstChild("Humanoid").Health > 0
    end
  end
  return true
end




local function isTeam(plr)
  if getgenv().ESP.TeamCheck == false then return false end
  if plr.TeamColor == client.TeamColor then return true else return false end
end



local rootPart = "HumanoidRootPart"
for _, v in pairs(Players:GetPlayers()) do
  if v ~= Players.LocalPlayer and v.Character then
    if v.Character:FindFirstChild("HumanoidRootPart") then
      rootPart = "HumanoidRootPart"
    elseif v.Character:FindFirstChild("Torso") then
      rootPart = "Torso"
    elseif v.Character:FindFirstChild("PrimaryPart") then
      rootPart = "PrimaryPart"
    end
  end
end


local running_esp = {}


local function create_esp(plr : Player)
  local quad = Drawing.new("Quad")
  quad.Thickness = 2
  quad.Filled = false
  quad.Visible = false
  quad.Transparency = 1
  running_esp[plr.Name] = quad
  local text_info = Drawing.new("Text")
  text_info.Center = true
  text_info.Font = 1
  text_info.Outline = true
  local function update_esp()
    local UpdateESP
    UpdateESP = RunService.RenderStepped:Connect(function(deltaTime)
    if getgenv().ESP.esp_is_enabled and plr.Name ~= client.Name and plr.Character and isTeam(plr) == false and plr.Character:FindFirstChild(rootPart) and plr.Character:FindFirstChild("Head") and isAlive(plr) and running_esp[plr.Name] ~= nil then
      local _,is_visible = camera:WorldToViewportPoint(plr.Character[rootPart].Position)
      local distance = client:DistanceFromCharacter(plr.Character[rootPart].Position)
      if is_visible then

        local corners = get_part_corners(plr.Character[rootPart])

        local topRight,TR_visible = camera:WorldToViewportPoint(corners.TopRight)
        local topLeft,TL_visible = camera:WorldToViewportPoint(corners.TopLeft)
        local bottomLeft,BL_visible = camera:WorldToViewportPoint(corners.BottomLeft)
        local bottomRight,BL_visible = camera:WorldToViewportPoint(corners.BottomRight)

        if  (TR_visible or TL_visible or BL_visible or BL_visible) then
          --local headPos, _ = camera:WorldToViewportPoint(topRight)
          text_info.Position = Vector2.new(topRight.X, topRight.Y)
          text_info.Color = Color3.new(getgenv().ESP.close[1], getgenv().ESP.close[2], getgenv().ESP.close[3]):Lerp(Color3.new(getgenv().ESP.far[1], getgenv().ESP.far[2], getgenv().ESP.close[3]),distance / 150)
          text_info.Size = math.clamp(30 - distance / 10, 10, 30)
          text_info.Text = plr.Name .. " | " .. math.round(distance) .. " sd"
          text_info.Visible = true
          text_info.Transparency = math.clamp((500 - distance) / 200, 0.2, 1)
          quad.PointA = Vector2.new(topRight.X, topRight.Y)
          quad.PointB = Vector2.new(topLeft.X, topLeft.Y)
          quad.PointC = Vector2.new(bottomLeft.X, bottomLeft.Y)
          quad.PointD = Vector2.new(bottomRight.X, bottomRight.Y)
          quad.Color = Color3.new(getgenv().ESP.close[1] , getgenv().ESP.close[2], getgenv().ESP.close[3]):Lerp(Color3.new(getgenv().ESP.far[1] , getgenv().ESP.far[2], getgenv().ESP.far[3]), distance / 150)
          quad.Thickness = math.clamp(3 - (distance / 100), 0, 3)
          quad.Visible = true

        else
          quad.Visible = false
          text_info.Visible = false
        end
      else
        quad.Visible = false
        text_info.Visible = false
      end
    else
      if quad.__OBJECT_EXISTS and text_info.__OBJECT_EXISTS then
        quad.Visible = false
        text_info.Visible = false
      end
      if Players:FindFirstChild(plr.Name) == nil then
        text_info:Remove()
        UpdateESP:Disconnect()
      end
    end
    end)
  end
  coroutine.wrap(update_esp)()
end



for _, plr in pairs(Players:GetPlayers()) do
  create_esp(plr)
end


Players.PlayerAdded:Connect(function(player)
print(player.Name.." joined!")
delay(0.5, function()create_esp(player)end)
end)

Players.PlayerRemoving:Connect(function(player)
print(player.Name.." leaved!")

print(running_esp[player.Name]," Removing box!")

running_esp[player.Name]:Remove()
running_esp[player.Name] = nil

print(running_esp[player.Name]," Box removed!")
end)


UserInputService.InputBegan:Connect(function(input)
if input.KeyCode == Enum.KeyCode.End then
  getgenv().ESP.esp_is_enabled = not getgenv().ESP.esp_is_enabled
elseif input.KeyCode == Enum.KeyCode.Home then
  game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,game:GetService'Players'.LocalPlayer)
end
end)
