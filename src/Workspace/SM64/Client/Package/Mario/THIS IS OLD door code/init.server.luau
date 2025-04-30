--!strict

local System = require(script.Parent)
local Animations = System.Animations
local Sounds = System.Sounds
local Enums = System.Enums
local Util = System.Util

local Action = Enums.Action
local SurfaceClass = Enums.SurfaceClass

local AirStep = Enums.AirStep
local MarioEyes = Enums.MarioEyes
local InputFlags = Enums.InputFlags
local MarioFlags = Enums.MarioFlags
local ParticleFlags = Enums.ParticleFlags

local InteractionStatus = Enums.Interaction.Status
local InteractionSubtype = Enums.Interaction.Subtype

type Mario = System.Mario

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

warn('TODO::: replace old findMarioAnimFlagsAndTranslation and updateMarioPosForAnim code')

local ANIM_FLAG_HOR_TRANS = 1
local ANIM_FLAG_VERT_TRANS = 2
local ANIM_FLAG_6 = 4

local transformations = require(script:WaitForChild('transformations'))
-- not 100% accurate, but does exactly what i need it to do
function wrapAngle(n) -- wrap a number to be between -0x8000 and 0x8000
	if n < -0x8000 then
		return n + 0x10000
	elseif n > 0x8000 then
		return n - 0x10000
	end
	return n
	--return ((result + 0x8000) % 0x10000) - 0x8000
end
function System.findMarioAnimFlagsAndTranslation	(m: Mario, yaw: number)--, traslation: Vector3| Vector3int16)
	local AnimCurrent = m.AnimCurrent
	local AnimFrame = m.AnimFrame

	yaw = wrapAngle(yaw + 0x8000) -- NOT IN THE ORIGINAL C CODE

	local s = Util.Sins(yaw)
	local c = Util.Coss(yaw)

	local translation = transformations[AnimCurrent][AnimFrame]

	local dx = translation.X
	local dz = translation.Z
	local newTranslation = Vector3.new(
		(dx * c) + (dz * s),
		translation.Y,
		(-dx * s) + (dz * c)
	)

	return newTranslation, 0 -- TODO: add flags
end

function System.updateMarioPosForAnim(m: Mario)
	--[[ TODO: FLAGS!
	local translation, flags = {0, 0, 0}
	local flags = m:find_mario_anim_flags_and_translation(m.FaceAngle.Y, translation)
	local translation = Vector3.new(table.unpack(translation))]]
	local translation, flags = m:findMarioAnimFlagsAndTranslation(m.FaceAngle.Y)

	-- TODOL implement flags for horizontal and vertical translations
	-- i just only needed horizontal translations so i didnt do this
	if true then --bit32.btest(flags, bit32.bor(ANIM_FLAG_HOR_TRANS, ANIM_FLAG_6)) then
		m.GfxPos = Util.SetY(-translation, 0)
		m.GfxAngle = Vector3int16.new(0, m.FaceAngle.Y, 0)
		m.Position = Util.SetY(m.Position + translation, m.Position.Y)
	end

	if false then
		m.GfxPos = Util.SetY(Vector3.zero, -translation.Y)
		m.Position = Util.SetY(m.Position, m.Position.Y + translation.Y)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Actions
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local AIR_STEP_CHECK_BOTH = bit32.bor(AirStep.CHECK_LEDGE_GRAB, AirStep.CHECK_HANG)
local DEF_ACTION: (number, (Mario) -> boolean) -> () = System.RegisterAction

local function act_going_through_door(m: Mario)
	local InteractObj = (m :: any).InteractObj -- an object/pseudo
	local UsedObj = (m :: any).UsedObj -- an object/pseudo


	if m.ActionTimer == 0 then
		if m.ActionArg == 1 then
			InteractObj.InteractStatus:Set(InteractionStatus.UNK16)
			m:SetAnimation(Animations.PULL_DOOR_WALK_IN)
		else
			InteractObj.InteractStatus:Set(InteractionStatus.UNK17)
			m:SetAnimation(Animations.PUSH_DOOR_WALK_IN)
		end
		--[[ Set animation to pull door and update interact object status

		InteractObj.oInteractStatus = InteractionStatus.UNK16
		m:SetAnimation(Animations.PULL_DOOR_WALK_IN)]]
	end

	-- Align Mario with the door and update position
	--TODO: set mario's face angle
	-- m->faceAngle[1] = m->usedObj->oMoveAngleYaw;
	--print(UsedObj.MoveAngleYaw)
	m.FaceAngle = Util.SetY(m.FaceAngle, UsedObj.MoveAngleYaw)
	m.Position = Util.SetY(UsedObj.Position, m.Position.Y) --Vector3.new(usedObjPos.X, m.Position.Y, usedObjPos.Z)
	--m.Pos[0] = UsedObj.oPosX
	--m.Pos[2] = UsedObj.oPosZ
	
	
	
	-- update marios position based on the animation
	-- TODO:
	--updateMarioPosForAnim(m)
	m:updateMarioPosForAnim()
	m:StopAndSetHeightToFloor()
	
	-- Trigger warp or finish action based on condition
	if m.ActionArg == 4 then
		if m.ActionTimer == 16 then
			-- WARP_OP_WARP_DOOR
			--levelTriggerWarp(m, WarpOp.WarpDoor)
		end
	elseif m:IsAnimAtEnd() then
		if m.ActionArg == 2 then
			-- TODO

			-- unported code
			--m->faceAngle[1] += 0x8000;
			--m.FaceAngle[2] = m.FaceAngle[2] + 0x8000
			m.FaceAngle = Util.SetY(m.FaceAngle, m.FaceAngle.Y + 0x8000)
		end
		m:SetAction(Action.IDLE)
		m.GfxPos = Vector3.zero
		m.GfxAngle = Vector3int16.new()
	end

	m.ActionTimer = m.ActionTimer + 1
	return false
end

DEF_ACTION(Action.PULLING_DOOR, act_going_through_door)
DEF_ACTION(Action.PUSHING_DOOR, act_going_through_door)

--[[DEF_ACTION(Action.PUSHING_DOOR, function(m: Mario)
	-- You can set an animation, sound, or logic specific to pushing the door here.
	local anim = Animations.p
	commonGroundActionStep(m, Action.PUSHING_DOOR, anim)

	-- Optionally, set the Mario state for door opening
	if m.Position then
		m:SetAction(Action.DOOR_OPEN)
	end

	return false
end)

-- Pulling the door action
DEF_ACTION(Action.PULLING_DOOR, function(m: Mario)
	-- You can set an animation, sound, or logic specific to pulling the door here.
	local anim = Animations.PULLING_DOOR
	commonGroundActionStep(m, Action.PULLING_DOOR, anim)

	-- Optionally, set the Mario state for door opening
	if m.Position then
		m:SetAction(Action.DOOR_OPEN)
	end

	return false
end)]]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
