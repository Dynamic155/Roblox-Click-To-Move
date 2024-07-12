--[[
Uses Roblox's pathfinding to move to the position that you click on. This script disables the defualt movement. 
There is a queue with a max of 2. This means, if you click somewhere, then click somewhere else, it will first walk to the first position, then it will walk to the 2nd. 
yeah that is about it, not much to say, I mean it just makes you walk to where you click.
]]

local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local pathfindingService = game:GetService("PathfindingService")
local contextActionService = game:GetService("ContextActionService")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

require(players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Disable()

local destinationQueue = {}
local isMoving = false

local function moveToPosition(destination)
	isMoving = true
	local path = pathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentJumpHeight = humanoid.JumpHeight
	})
	
	path:ComputeAsync(character.PrimaryPart.Position, destination)
	local waypoints = path:GetWaypoints()

	for _, waypoint in pairs(waypoints) do
		humanoid:MoveTo(waypoint.Position)
		humanoid.MoveToFinished:Wait()
	end

	isMoving = false

	if #destinationQueue > 0 then
		moveToPosition(table.remove(destinationQueue, 1))
	end
	
end

userInputService.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

	local mousePos = input.Position
	local unitRay = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
	local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
	local hit, position = workspace:FindPartOnRay(ray)

	if not hit then return end

	if isMoving then
		if #destinationQueue < 1 then
			table.insert(destinationQueue, position)
		end
	else
		moveToPosition(position)
	end
end)
