--[[
In this version it uses tweenservice to move the character to where you click. 
]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local part = game.Workspace:WaitForChild("Baseplate")
local character = player.Character or player.CharacterAdded:Wait()
local tweenService = game:GetService("TweenService")
local movementSpeed = 50
local debounce = false

local function getClickPosition()
  local target = mouse.Target
  if target ~= part then return nil end
  return mouse.Hit.p
end

local function calculateTravelDetails(startPosition, clickPosition)
  local distance = (clickPosition - startPosition).magnitude
  local travelTime = distance / movementSpeed
  return distance, travelTime
end

local function createMovementTween(character, clickPosition, travelTime)
  local pos = Vector3.new(clickPosition.X, character.HumanoidRootPart.Position.Y, clickPosition.Z)
  return tweenService:Create(character.HumanoidRootPart, TweenInfo.new(travelTime, Enum.EasingStyle.Exponential), {CFrame = CFrame.new(pos)})
end

local function moveToPosition()
  if debounce then return end
  local clickPosition = getClickPosition()
  if not clickPosition then return end

  local startPosition = character.PrimaryPart.Position
  local direction = (clickPosition - startPosition).unit * (clickPosition - startPosition).magnitude
  local ray = Ray.new(startPosition, direction)
  local hitPart, hitPosition = game.Workspace:FindPartOnRay(ray, character)

  if hitPart == part or hitPart == nil then
    debounce = true
    local distance, travelTime = calculateTravelDetails(startPosition, clickPosition)

    local movementTween = createMovementTween(character, clickPosition, travelTime)
    movementTween:Play()

    movementTween.Completed:Connect(function()
      task.wait()
      debounce = false
    end)
  else
    print("Cannot reach the clicked position in a straight line.")
    if hitPart then
      print(hitPart.Name)
    end
  end
end

mouse.Button1Down:Connect(moveToPosition)
