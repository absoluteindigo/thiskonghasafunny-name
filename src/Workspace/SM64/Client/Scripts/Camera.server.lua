local camera = workspace.CurrentCamera
local subject = Instance.new('Model', workspace.SM64.Ignore)

--[[part.Anchored = true; part.CanCollide = false; part.Transparency = 0; part.Size = Vector3.zero; part.CanTouch = false; part.Locked = true; part.Archivable = false;
subject.PrimaryPart = part]]

-- camera.CameraSubject = subject

local Package = require(script.Parent.Parent.Package)
local Tick = require(script.Parent.Parent.Tick)

local Util = Package.Util
local FFlags = Package.FFlags
local Object = Package.Game.Object

local ObjectListProcessor = Object.ObjectListProcessor

local offset = Vector3.new(0, 5.5, 0)
local cframe = CFrame.new

camera.CameraSubject = subject

local goal = ObjectListProcessor.gMarioObject and ObjectListProcessor.gMarioObject.Position
Tick.AddTickLoop(function()
	local gMarioObject = ObjectListProcessor.gMarioObject

	lastPos = goal
	goal = gMarioObject.Position
end)
Tick.AddUpdateLoop(function(dt, subframe)
	local gMarioObject = ObjectListProcessor.gMarioObject
	if not goal then return end
	
	camera = workspace.CurrentCamera
	
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = subject
	
	subject:PivotTo(cframe(
		Util.ToRoblox(((FFlags.CHARACTER_INTERPOLATION and lastPos) and lastPos:Lerp(goal, subframe)) or goal) + offset))
	-- camera.CameraSubject = camera.CameraSubject == subject and part or subject
end)

camera.FieldOfView = 45