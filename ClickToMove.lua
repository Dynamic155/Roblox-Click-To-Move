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

mouse.Button1Down:Connect(function()
	if debounce then return end

	local target = mouse.Target
	if target ~= part then return end

	local clickPosition = mouse.Hit.p
	local startPosition = character.PrimaryPart.Position
	local direction = (clickPosition - startPosition).unit * (clickPosition - startPosition).magnitude

	local ray = Ray.new(startPosition, direction)
	local hitPart, hitPosition = game.Workspace:FindPartOnRay(ray, character)

	if hitPart == part or hitPart == nil then
		debounce = true
		local distance = (clickPosition - startPosition).magnitude
		local travelTime = distance / movementSpeed

		print("Clicked position: " .. tostring(clickPosition))
		print("Distance: " .. tostring(math.floor(distance)) .. " studs")
		print("Travel time: " .. tostring(math.floor(travelTime * 10) / 10) .. " seconds")

		local pos = Vector3.new(clickPosition.X, character.HumanoidRootPart.Position.Y, clickPosition.Z)

		local movementTween = tweenService:Create(character.HumanoidRootPart, TweenInfo.new(travelTime, Enum.EasingStyle.Exponential), {CFrame = CFrame.new(pos)})
		movementTween:Play()

		movementTween.Completed:Connect(function()
			task.wait()
			debounce = false
		end)
	else
		print("Cannot reach the clicked position in a straight line.")
	end
end)

