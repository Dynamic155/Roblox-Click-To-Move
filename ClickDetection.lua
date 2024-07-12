--[[
This script essentially detects where you click on a specific part.
If there is no other parts in the way, it will print the position, otherwise it will print "Cannot reach the clicked position"
It does this with raycasting. It checks the position the player clicked, and check if there are any obstacles in the way of the position. 

]]

local part = game.Workspace:WaitForChild("Baseplate") -- The part that you want to use

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()

mouse.Button1Down:Connect(function()
	local target = mouse.Target
	if target ~= part then return end

	local clickPosition = mouse.Hit.p
	local startPosition = character.PrimaryPart.Position
	local direction = (clickPosition - startPosition).unit * (clickPosition - startPosition).magnitude
	
	local ray = Ray.new(startPosition, direction)
	local hitPart, hitPosition = game.Workspace:FindPartOnRay(ray, character)

	if hitPart == part then
		print("Clicked position: " .. tostring(math.floor(clickPosition.X)) .. ", " .. tostring(math.floor(clickPosition.Y)) .. ", " .. tostring(math.floor(clickPosition.Z)))
	else
		print("Cannot reach the clicked position")
	end
end)
