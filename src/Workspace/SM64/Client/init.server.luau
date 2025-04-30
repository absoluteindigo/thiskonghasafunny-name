--[[
hi this is spritesworkshop (sprite)

THIS IS ALL EXTEMRELY UNFINISHED!! DO NOT USE THIS FOR AN ACTUAL GAME
im just releasing this unfinished while i work on a new project

note: there might be some rude language in here

]]
--!stjrict

local Core = script.Parent

if Core:GetAttribute("HotLoading") then
	task.wait(5)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Package = require(script.Package)

local FFlags = Package.FFlags
local Shared = Package.Shared
local Sounds = Shared.Sounds

local Enums = Package.Enums
local Mario = Package.Mario
local Types = Package.Types
local Util = Package.Util

local Object = Package.Game.Object
local Interaction = Package.Game.Interaction
local PlatformDisplacement = Package.Game.PlatformDisplacement

local Action = Enums.Action
local Buttons = Enums.Buttons
local MarioFlags = Enums.MarioFlags
local ParticleFlags = Enums.ParticleFlags

local SurfaceClass = Enums.SurfaceClass

type InputType = Enum.UserInputType | Enum.KeyCode
type Controller = Package.Controller
type Mario = Mario.Class

local player: Player = assert(Players.LocalPlayer)
local mario: Mario = Mario.new()

local STEP_RATE = FFlags.STEP_RATE
local NULL_TEXT = `<font color="#FF0000">NULL</font>`
local TRUE_TEXT = `<font color="#00FF00">TRUE</font>`
local FALSE_TEXT = `<font color="#FF0000">FALSE</font>`
local FLIP = CFrame.Angles(0, math.pi, 0)

local debugStats = Instance.new("BoolValue")
debugStats.Name = "DebugStats"
debugStats.Archivable = false
debugStats.Parent = game

local PARTICLE_CLASSES = {
	Fire = true,
	Smoke = true,
	Sparkles = true,
	ParticleEmitter = true,
}

local AUTO_STATS = {
	"Position",
	"Velocity",
	"AnimFrame",
	"FaceAngle",

	"ActionState",
	"ActionTimer",
	"ActionArg",

	"ForwardVel",
	"SlideVelX",
	"SlideVelZ",

	"CeilHeight",
	"FloorHeight",
	"WaterLevel",
	"QuicksandDepth",
}

local ControlModule: {
	GetMoveVector: (self: any) -> Vector3,
}

while not ControlModule do
	local inst = player:FindFirstChild("ControlModule", true)

	if inst then
		ControlModule = (require :: any)(inst)
	end

	task.wait(0.1)
end

script.DescendantAdded:Connect(function(desc)
	if desc:IsA("BaseScript") then
		desc.Enabled = true
	end
end)
for _, desc in script:GetDescendants() do
	if desc:IsA("BaseScript") then
		desc.Enabled = true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Input Driver
-------------------------------------------------------------------------------------------------------------------------------------------------

-- NOTE: I had to replace the default BindAction via KeyCode and UserInputType
-- BindAction forces some mappings (such as R2 mapping to MouseButton1) which you
-- can't turn off otherwise.

local InputDriver = require(script.Input)
local updateController = InputDriver.updateController

-- Too lazy to make a require lazy loader
do
	local Mario = Mario :: any

	if type(Interaction.ProcessMarioInteractions) == "function" then
		function Mario.ProcessInteractions(m: Mario)
			return Interaction.ProcessMarioInteractions(m)
		end
	end

	if type(Interaction.MarioStopRidingAndHolding) == "function" then
		function Mario.DropAndSetAction(m: Mario, action: number, actionArg: number?): boolean
			Interaction.MarioStopRidingAndHolding(m)
			return m:SetAction(action, actionArg)
		end
	end

	if type(Interaction.MarioDropHeldObject) == "function" then
		function Mario.DropHeldObject(m: Mario)
			return Interaction.MarioDropHeldObject(m)
		end
	end

	if type(Interaction.MarioThrowHeldObject) == "function" then
		function Mario.ThrowHeldObject(m: Mario)
			return Interaction.MarioThrowHeldObject(m)
		end
	end

	if type(Interaction.MarioCheckObjectGrab) == "function" then
		function Mario.CheckObjectGrab(m: Mario)
			return Interaction.MarioCheckObjectGrab(m)
		end
	end

	if type(Interaction.MarioGrabUsedObject) == "function" then
		function Mario.GrabUsedObject(m: Mario)
			return Interaction.MarioGrabUsedObject(m)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Network Dispatch
-------------------------------------------------------------------------------------------------------------------------------------------------------------

local Commands = {}
local soundDecay = {}

local lazyNetwork = ReplicatedStorage:WaitForChild("LazyNetwork")
assert(lazyNetwork:IsA("UnreliableRemoteEvent"), "bad lazyNetwork!")

local function stepDecay(sound: Sound)
	local decay = soundDecay[sound]

	if decay then
		task.cancel(decay)
	end

	soundDecay[sound] = task.delay(0.1, function()
		sound:Stop()
		sound:Destroy()
		soundDecay[sound] = nil
	end)

	sound.Playing = true
end

function Commands.PlaySound(player: Player, name: string)
	local sound: Sound? = Sounds[name]
	local character = player.Character
	local rootPart = character and character.PrimaryPart

	if rootPart and sound then
		local oldSound: Instance? = rootPart:FindFirstChild(name)
		local canPlay = true

		if oldSound and oldSound:IsA("Sound") then
			canPlay = false

			if name:sub(1, 6) == "MOVING" or sound:GetAttribute("Decay") then
				-- Keep decaying audio alive.
				stepDecay(oldSound)
			elseif name:sub(1, 5) == "MARIO" then
				-- Restart mario sound if a 30hz interval passed.
				local now = os.clock()
				local lastPlay = oldSound:GetAttribute("LastPlay") or 0

				if now - lastPlay >= 2 / FFlags.STEP_RATE then
					oldSound.TimePosition = 0
					oldSound:SetAttribute("LastPlay", now)
				end
			else
				-- Allow stacking.
				canPlay = true
			end
		elseif name:sub(1, 5) == "MARIO" then
			-- If the mario sound has a higher priority, delete
			-- the ones that are lower/equal the priority.
			-- On the other side, don't play if there's a sound
			-- with a higher priority playing than the one
			-- we wish to play.
			local nextMarioSound = Sounds[name]

			if nextMarioSound then
				local nextPriority = tonumber(nextMarioSound:GetAttribute("Priority")) or 128

				for _, instance: Instance in rootPart:GetChildren() do
					if (not instance:IsA("Sound")) or (instance.Name:sub(1, 5) ~= "MARIO") then
						continue
					end

					local priority = tonumber(instance:GetAttribute("Priority")) or 128
					if nextPriority >= priority then
						instance:Destroy()
					elseif priority >= nextPriority then
						canPlay = false
					end
				end
			end
		end

		if canPlay then
			local newSound: Sound = sound:Clone()
			newSound.Parent = rootPart
			newSound:Play()

			if name:find("MOVING") then
				-- Audio will decay if PlaySound isn't continuously called.
				stepDecay(newSound)
			end

			newSound.Ended:Connect(function()
				newSound:Destroy()
			end)

			newSound:SetAttribute("LastPlay", os.clock())
		end
	end
end

function Commands.SetParticle(player: Player, name: string, set: boolean)
	local character = player.Character
	local rootPart = character and character.PrimaryPart

	if rootPart then
		local particles = rootPart:FindFirstChild("Particles")
		local inst = particles and particles:FindFirstChild(name, true)

		if inst and PARTICLE_CLASSES[inst.ClassName] then
			local particle = inst :: ParticleEmitter
			local emit = particle:GetAttribute("Emit")

			if typeof(emit) == "number" then
				particle:Emit(emit)
			elseif set ~= nil then
				particle.Enabled = set
			end
		else
			warn("particle not found:", name)
		end
	end
end

function Commands.SetTorsoAngle(player: Player, angle: Vector3int16)
	local character = player.Character
	local waist = character and character:FindFirstChild("Waist", true)

	if waist and waist:IsA("Motor6D") then
		local props = { C1 = Util.ToRotation(-angle) + waist.C1.Position }
		local tween = TweenService:Create(waist, TweenInfo.new(0.1), props)
		tween:Play()
	end
end

function Commands.SetHeadAngle(player: Player, angle: Vector3int16)
	local character = player.Character
	local neck = character and character:FindFirstChild("Neck", true)

	if neck and neck:IsA("Motor6D") then
		local props = { C1 = Util.ToRotation(-angle) + neck.C1.Position }
		local tween = TweenService:Create(neck, TweenInfo.new(0.1), props)
		tween:Play()
	end
end

function Commands.SetHealth(player: Player, health: number)
	local character = player.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	health = math.max(health, 0.01) -- Don't kill Humanoid by keeping >0

	if humanoid then
		humanoid.MaxHealth = 8
		humanoid.Health = health
	end
end

function Commands.SetCamera(player: Player, cf: CFrame?)
	local camera = workspace.CurrentCamera

	if cf ~= nil then
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = cf
	else
		camera.CameraType = Enum.CameraType.Custom
	end
end

local function processCommand(player: Player, cmd: string, ...: any)
	local command = Commands[cmd]

	if command then
		task.spawn(command, player, ...)
	else
		warn("Unknown Command:", cmd, ...)
	end
end

local function networkDispatch(cmd: string, ...: any)
	lazyNetwork:FireServer(cmd, ...)
	processCommand(player, cmd, ...)
end

local function onNetworkReceive(target: Player, cmd: string, ...: any)
	if target ~= player then
		processCommand(target, cmd, ...)
	end
end

lazyNetwork.OnClientEvent:Connect(onNetworkReceive)

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mario Driver
-------------------------------------------------------------------------------------------------------------------------------------------------------------

local lastUpdate = os.clock()
local lastHeadAngle: Vector3int16?
local lastTorsoAngle: Vector3int16?
local lastHealth: number?

-- local activeScale = 1
local subframe = 0 -- 30hz subframe
local emptyId = ""

local goalCF: CFrame
local prevCF: CFrame
local goalCameraOffset: Vector3 = Vector3.zero
local prevCameraOffset: Vector3 = Vector3.zero

local activeTrack: AnimationTrack?

local reset = Instance.new("BindableEvent")
reset.Archivable = false
reset.Parent = script
reset.Name = "Reset"

-- To not reach the 256 tracks limit warning
local loadedAnims: { [string]: AnimationTrack } = {}

if RunService:IsStudio() then
	local dummySequence = Instance.new("KeyframeSequence")
	local provider = game:GetService("KeyframeSequenceProvider")
	emptyId = provider:RegisterKeyframeSequence(dummySequence)
end

local function setDebugStat(key: string, value: any)
	if typeof(value) == "Vector3" then
		value = string.format("%.3f, %.3f, %.3f", value.X, value.Y, value.Z)
	elseif typeof(value) == "Vector3int16" then
		value = string.format("%i, %i, %i", value.X, value.Y, value.Z)
	elseif type(value) == "number" then
		if math.abs(value) == math.huge then
			local sign = math.sign(value) == -1 and "-" or ""
			value = `{sign}∞`
		else
			value = string.format("%.3f", value)
		end
	end

	debugStats:SetAttribute(key, value)
end

local autoResetThread: thread? = nil
local function onReset()
	if autoResetThread then
		pcall(task.cancel, autoResetThread)
		autoResetThread = nil :: any
	end

	local spawnPos = Vector3.new(0, 100, 0)
	local faceAngle = Vector3int16.new()

	if FFlags.USE_SPAWNLOCATIONS then
		local newSpawnPos, newFaceAngle = Util.GetSpawnPosition()
		if newSpawnPos then
			spawnPos, faceAngle = newSpawnPos, newFaceAngle
		end
	end

	local char = player.Character

	if char then
		local rootPart = char:FindFirstChild("HumanoidRootPart")
		local reset = char:FindFirstChild("Reset")

		local cf = CFrame.new(spawnPos) * Util.ToRotation(mario.FaceAngle) * FLIP
		char:PivotTo(cf)

		goalCF = cf
		prevCF = cf

		if reset and reset:IsA("RemoteEvent") then
			reset:FireServer()
		end

		if rootPart then
			for _, child: Instance in pairs(rootPart:GetChildren()) do
				if child:IsA("Sound") and child.Name:sub(1, 5) == "MARIO" then
					child:Destroy()
				end
			end
		end
	end
	
	
	mario.SlideVelX = 0
	mario.SlideVelZ = 0
	mario.ForwardVel = 0
	mario.IntendedYaw = 0

	mario.InvincTimer = 0
	mario.HealCounter = 0
	mario.HurtCounter = 0
	mario.Health = 0x880

	mario.CapTimer = 1
	mario.BurnTimer = 0
	mario.SquishTimer = 0
	mario.QuicksandDepth = 0

	mario:DropHeldObject()
	-- mario.PoleObj = nil

	mario.Position = Util.ToSM64(spawnPos)
	mario.FaceAngle = faceAngle
	mario.Velocity = Vector3.zero

	mario.Flags:Remove(MarioFlags.SPECIAL_CAPS)
	mario:SetAction(Action.SPAWN_SPIN_AIRBORNE)
end

local Tick = require(script.Tick)

local function update(dt)
	--[[local character = player.Character

	if not character then
		return
	end]]
	
	STEP_RATE = FFlags.STEP_RATE
	
	local now = os.clock()
	-- local dt = math.min(dt, 0.1)
	local gfxRot = CFrame.identity
	
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local simSpeed = FFlags.TIME_SCALE

	Util.DebugCollisionFaces(mario.Wall, mario.Ceil, mario.Floor)
	Util.DebugWater(mario.WaterLevel)

	subframe += math.min(now - lastUpdate, FFlags.UPDATE_DELTA_MAX) * (STEP_RATE * simSpeed)
	lastUpdate = now

	--! This code interferes with obtaining the caps normally.
	--  TODO solve this better
	if mario.CapTimer == 0 then
		if Core:GetAttribute("WingCap") then
			mario.Flags:Add(MarioFlags.WING_CAP)
		else
			mario.Flags:Remove(MarioFlags.WING_CAP)
		end

		if Core:GetAttribute("Metal") then
			mario.Flags:Add(MarioFlags.METAL_CAP)
		else
			mario.Flags:Remove(MarioFlags.METAL_CAP)
		end
	end

	subframe = math.min(subframe, 4) -- Prevent execution runoff
	while subframe >= 1 do
		-- update_objects
		
		Util.GlobalTimer += 1
		subframe -= 1
		-- updateCollisions()

		PlatformDisplacement.ApplyMarioPlatformDisplacement(mario)
		updateController(mario, humanoid)
		Object.tick()
		
		Tick.Tick()
	end

	-- Auto reset logic (Optional)
	-- Remove if you have your own solutions
	if FFlags.AUTO_RESET_ON_DEAD then
		--stylua: ignore
		local function isDead(): boolean
			local action = mario.Action()
			return mario.Health < 0x100 or (
				(action == Action.QUICKSAND_DEATH and mario.QuicksandDepth >= 100)
			)
		end

		if isDead() and not autoResetThread then
			autoResetThread = task.delay(3, function()
				if isDead() then
					return onReset()
				end

				if autoResetThread then
					pcall(task.cancel, autoResetThread)
					autoResetThread = nil :: any
				end
			end)
		end
	end
	
	Object.update(dt, subframe)
	Tick.Update(dt, subframe)
end

onReset()
reset.Event:Connect(onReset)
shared.LocalMario = mario

Object.initalize(mario)

-- set mario bhv script
mario.bhvScript = Object.BehaviorData.BehaviorScripts.waitForBehavior('bhvMario') -- Object.BehaviorData.BehaviorScripts.bhvMario

-- set mario model
mario.Model = Package.Custom.Model.new(mario)
mario.Model:SetModel(Object.Models.MARIO)
-- workspace.CurrentCamera.CameraSubject = mario.Model.Model:WaitForChild('cam')

player.CharacterAdded:Connect(function()
	-- Reset loaded animations if a new character
	-- has been loaded/replaced to
	table.clear(loadedAnims)
end)

RunService.Heartbeat:Connect(function(dt: number)
	debug.profilebegin("SM64::update")
	update(dt)
	debug.profileend()
end)

while true do
	local success = pcall(function()
		return StarterGui:SetCore("ResetButtonCallback", reset)
	end)

	if success then
		break
	end

	task.wait(0.25)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
