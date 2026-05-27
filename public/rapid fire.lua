local localCharacter = game.Players.LocalPlayer.Character
local localRightArm = localCharacter:FindFirstChild("Right Arm")
local localLeftArm = localCharacter:FindFirstChild("Left Arm")
local vrService = game:GetService("VRService")

function getHeldGun()
	if vrService.VREnabled then
		if localRightArm then
			local rightHeld = localRightArm:FindFirstChild("Hold")
			if rightHeld and rightHeld:IsA("Weld") and rightHeld.Part1 then
				local grip = rightHeld.Part1
				if grip then
					local gun = grip:FindFirstAncestorWhichIsA("Model")
					if gun and gun:FindFirstChild("Config") then
						return gun
					end
				end
			end
		end
		if localLeftArm then
			local leftHeld = localLeftArm:FindFirstChild("Hold")
			if leftHeld and leftHeld:IsA("Weld") and leftHeld.Part1 then
				local grip = leftHeld.Part1
				if grip then
					local gun = grip:FindFirstAncestorWhichIsA("Model")
					if gun and gun:FindFirstChild("Config") then
						return gun
					end
				end
			end
		end
	else
		if localCharacter then
			local childCount = 0
			for _, child in pairs(localCharacter:GetChildren()) do
				childCount = childCount + 1
				if child:IsA("Tool") then
					for _, toolChild in pairs(child:GetChildren()) do
						if toolChild:IsA("Model") and toolChild:FindFirstChild("Config") then
							return toolChild
						end
					end
					if child:FindFirstChild("Config") then
						for _, toolChild in pairs(child:GetChildren()) do
							if toolChild:IsA("Model") and (toolChild:FindFirstChild("Parts") or toolChild:FindFirstChild("Barrel")) then
								return toolChild
							end
						end
					end
				end
			end
		end
	end
	return nil
end

function bulletImpactSpam()
    local isPressed = false
	if vrService.VREnabled then
		isPressed = game:GetService("UserInputService"):IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
	else
		isPressed = game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q)
	end
    if not isPressed then return end
    
	local weapon = getHeldGun()
	if not weapon then return end

	local events = weapon:FindFirstChild("Events")
	if not events then return end

	local serverImpact = events:FindFirstChild("ServerImpact")
	if not serverImpact then return end

	local parts = weapon:FindFirstChild("Parts")
	if not parts then return end

	local barrel = parts:FindFirstChild("Barrel")
	if not barrel then return end

	local barrelCF = barrel.CFrame
	local rayStart, rayDir

	if vrService.VREnabled and localRightArm then
		rayStart = barrelCF.Position
		rayDir = (localRightArm.CFrame * CFrame.Angles(math.rad(-90), 0, 0)).LookVector * 3500
	else
		rayStart = workspace.CurrentCamera.CFrame.Position
		rayDir = workspace.CurrentCamera.CFrame.LookVector * 3500
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include

	local filter = {}
	local mapContent = workspace.Map:FindFirstChild("Content")
	if mapContent then
		table.insert(filter, mapContent)
	end
	if workspace:FindFirstChild("Items") then
		table.insert(filter, workspace.Items)
	end
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= game.Players.LocalPlayer and p.Character then
			local head = p.Character:FindFirstChild("Head")
			local torso = p.Character:FindFirstChild("Torso")
			if head then table.insert(filter, head) end
			if torso then table.insert(filter, torso) end
		end
	end
	raycastParams.FilterDescendantsInstances = filter

	local raycastResult = workspace:Raycast(rayStart, rayDir, raycastParams)

	local hitInstance = raycastResult and raycastResult.Instance
	local hitPosition = raycastResult and raycastResult.Position or (rayStart + rayDir)

	local lookVector = (hitPosition - barrelCF.Position).Unit
	local distance = (hitPosition - barrelCF.Position).Magnitude
	local travelTime = distance / 1000

    serverImpact:FireServer(
        barrelCF,
        lookVector,
        hitInstance,
        hitInstance and (hitPosition - hitInstance.Position) or Vector3.new(0, 0, 0),
        travelTime
    )
end

game:GetService("RunService").Heartbeat:Connect(function()
    localCharacter = game.Players.LocalPlayer.Character
    if not localCharacter then return end
    localRightArm = localCharacter:FindFirstChild("Right Arm")
    localLeftArm = localCharacter:FindFirstChild("Left Arm")
    if not localLeftArm or not localRightArm then return end

    bulletImpactSpam()
end)
