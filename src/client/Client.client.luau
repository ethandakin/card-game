local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = require(ReplicatedStorage.Player)
Player:Initialize()

local t = workspace.Gragas.Humanoid.Animator:LoadAnimation(workspace.oppa) 
t:Play()

local MAX_TILT = 30

local camera = workspace.CurrentCamera
local cameraPart = workspace.CameraPart

repeat
	task.wait()
	camera.CameraType = Enum.CameraType.Scriptable
until camera.CameraType == Enum.CameraType.Scriptable

RunService:BindToRenderStep("MenuCamera", Enum.RenderPriority.Camera.Value +1, function(deltaTime)
	local mousePos = UIS:GetMouseLocation()

	camera.CFrame = cameraPart.CFrame * CFrame.Angles(
		math.rad(((mousePos.Y - camera.ViewportSize.Y/2) / camera.ViewportSize.Y) * -MAX_TILT),
		math.rad(((mousePos.X - camera.ViewportSize.X/2) / camera.ViewportSize.X) * -MAX_TILT),
		0
	)
end)

