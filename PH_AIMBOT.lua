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

getgenv().aim_at = "head"

function CheckRay(from,to)
    local ray = Ray.new(from.Position,CFrame.new(from.Position,to.Position).LookVector.Unit*(from.Position-to.Position).Magnitude)
	local part,pos = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character})
	if part.Name == "Head" then
        print(part)
		return true
	elseif not part then
		return false
	end
end

local function closestPlayer(fov)
   local target = nil --The player to return
   local closest = fov or math.huge --The farthest a player can be (The fov circle)
   for i,v in ipairs(players:GetPlayers()) do
        local character = getbody.getbodyparts(v)
        if character and client.Character and v ~= client and v.TeamColor ~= client.TeamColor  then --You can add teamcheck here or make it a variable in the function's parameters
           local _, onscreen = camera:WorldToScreenPoint(character.head.Position) --Sometimes their position is not even on the screen so you have to make sure
           if onscreen then
               local targetPos = camera:WorldToViewportPoint(character.head.Position) --Their screen position
               local mousePos = camera:WorldToViewportPoint(mouse.Hit.p) --More acurate position of the mouse than just mouse.X
               local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(targetPos.X, targetPos.Y)).magnitude --Distance from mouse
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
        if CheckRay(game.Players.LocalPlayer.Character.Head, getbody.getbodyparts(t).head) then
            aimAt(getbody.getbodyparts(t)[getgenv().aim_at].Position, getgenv().aim_smooth)
        end
    end
end)
