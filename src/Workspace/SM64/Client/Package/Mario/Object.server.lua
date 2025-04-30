--!strict

local System = require(script.Parent)
local Animations = System.Animations
local Sounds = System.Sounds
local Enums = System.Enums
local Util = System.Util

local Action = Enums.Action

local InputFlags = Enums.InputFlags
local MarioFlags = Enums.MarioFlags

local InteractionSubtype = Enums.Interaction.Subtype

type Mario = System.Mario

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local DEF_ACTION: (number, (Mario) -> boolean) -> () = System.RegisterAction

--[[
 * Used by Action.PUNCHING to determine Mario's forward velocity during each
 * animation frame.
]]
local sPunchingForwardVelocities = { 0, 1, 1, 2, 3, 5, 7, 10 }

local function animatedStationaryGroundStep(m: Mario, animation: Animation, endAction: number)
	m:StationaryGroundStep()
	m:SetAnimation(animation)
	if m:IsAnimAtEnd() then
		m:SetAction(endAction)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DEF_ACTION(Action.PUNCHING, function(m: Mario)
	if m.Input:Has(InputFlags.STOMPED) then
		return m:SetAction(Action.SHOCKWAVE_BOUNCE)
	end

	if m.Input:Has(InputFlags.NONZERO_ANALOG, InputFlags.A_PRESSED, InputFlags.OFF_FLOOR, InputFlags.ABOVE_SLIDE) then
		return m:CheckCommonActionExits()
	end

	if m.ActionState and m.Input:Has(InputFlags.A_DOWN) then
		return m:SetAction(Action.JUMP_KICK)
	end

	m.ActionState = 1

	if m.ActionArg == 0 then
		m.ActionTimer = 7
	end

	m:SetForwardVel(sPunchingForwardVelocities[m.ActionTimer + 1])

	if m.ActionTimer > 0 then
		m.ActionTimer -= 1
	end

	m:UpdatePunchSequence()
	m:PerformGroundStep()

	return false
end)

DEF_ACTION(Action.PICKING_UP, function(m: Mario)
	if m.Input:Has(InputFlags.STOMPED) then
		return m:DropAndSetAction(Action.SHOCKWAVE_BOUNCE)
	end

	if m.Input:Has(InputFlags.OFF_FLOOR) then
		return m:DropAndSetAction(Action.FREEFALL)
	end

	if m.ActionState == 0 and m:IsAnimAtEnd() then
		--! While the animation is playing, it is possible for the used object
		-- to unload. This allows you to pick up a vacant or newly loaded object
		-- slot (cloning via fake object).
		m:GrabUsedObject()
		m:PlaySoundIfNoFlag(Sounds.MARIO_HRMM, MarioFlags.MARIO_SOUND_PLAYED)
		m.ActionState = 1
	end

	if m.ActionState == 1 then
		local heldObj: any = (m :: any).HeldObj

		if heldObj then
			if heldObj.InteractionSubtype:Has(InteractionSubtype.GRABS_MARIO) then
				m.BodyState.GrabPos = 0x02 -- GRAB_POS_HEAVY_OBJ
				m:SetAnimation(Animations.GRAB_HEAVY_OBJECT)
				if m:IsAnimAtEnd() then
					m:SetAction(Action.HOLD_HEAVY_IDLE)
				end
			else
				m.BodyState.GrabPos = 0x01 -- GRAB_POS_LIGHT_OBJ
				m:SetAnimation(Animations.PICK_UP_LIGHT_OBJ)
				if m:IsAnimAtEnd() then
					m:SetAction(Action.HOLD_IDLE)
				end
			end
		end
	end

	m:StationaryGroundStep()
	return false
end)

DEF_ACTION(Action.DIVE_PICKING_UP, function(m: Mario)
	if m.Input:Has(InputFlags.STOMPED) then
		return m:DropAndSetAction(Action.SHOCKWAVE_BOUNCE)
	end

	--! Hands-free holding. Landing on a slope or being pushed off a ledge while
	-- landing from a dive grab sets Mario's action to a non-holding action
	-- without dropping the object, causing the hands-free holding glitch.
	if m.Input:Has(InputFlags.OFF_FLOOR) then
		return m:SetAction(Action.FREEFALL)
	end

	if m.Input:Has(InputFlags.ABOVE_SLIDE) then
		return m:SetAction(Action.BEGIN_SLIDING)
	end

	animatedStationaryGroundStep(m, Animations.STOP_SLIDE_LIGHT_OBJ, Action.HOLD_IDLE)
	return false
end)

DEF_ACTION(Action.PLACING_DOWN, function(m: Mario)
	if m.Input:Has(InputFlags.STOMPED) then
		return m:DropAndSetAction(Action.SHOCKWAVE_BOUNCE)
	end

	if m.Input:Has(InputFlags.OFF_FLOOR) then
		return m:DropAndSetAction(Action.FREEFALL)
	end

	m.ActionTimer += 1

	if m.ActionTimer == 8 then
		m:DropHeldObject(m)
	end

	animatedStationaryGroundStep(m, Animations.PLACE_LIGHT_OBJ, Action.IDLE)
	return false
end)

DEF_ACTION(Action.THROWING, function(m: Mario)
	local heldObj = (m :: any).HeldObj

	if heldObj and heldObj.InteractionSubtype:Has(InteractionSubtype.HOLDABLE_NPC) then
		return m:SetAction(Action.PLACING_DOWN)
	end

	if m.Input:Has(InputFlags.STOMPED) then
		return m:DropAndSetAction(Action.SHOCKWAVE_BOUNCE)
	end

	if m.Input:Has(InputFlags.OFF_FLOOR) then
		return m:DropAndSetAction(Action.FREEFALL)
	end

	m.ActionTimer += 1

	if m.ActionTimer == 7 then
		m:ThrowHeldObject()
		m:PlaySoundIfNoFlag(Sounds.MARIO_WAH2, MarioFlags.MARIO_SOUND_PLAYED)
		m:PlaySoundIfNoFlag(Sounds.ACTION_THROW, MarioFlags.ACTION_SOUND_PLAYED)
	end

	animatedStationaryGroundStep(m, Animations.GROUND_THROW, Action.IDLE)
	return false
end)

DEF_ACTION(Action.HEAVY_THROW, function(m: Mario)
	if m.Input:Has(InputFlags.STOMPED) then
		return m:DropAndSetAction(Action.SHOCKWAVE_BOUNCE)
	end

	if m.Input:Has(InputFlags.OFF_FLOOR) then
		return m:DropAndSetAction(Action.FREEFALL)
	end

	m.ActionTimer += 1

	if m.ActionTimer == 13 then
		m:DropHeldObject()
		m:PlaySoundIfNoFlag(Sounds.MARIO_WAH2, MarioFlags.MARIO_SOUND_PLAYED)
		m:PlaySoundIfNoFlag(Sounds.ACTION_THROW, MarioFlags.ACTION_SOUND_PLAYED)
	end

	animatedStationaryGroundStep(m, Animations.HEAVY_THROW, Action.IDLE)
	return false
end)

DEF_ACTION(Action.STOMACH_SLIDE_STOP, function(m: Mario)
	if m.Input:Has(InputFlags.STOMPED) then
		return m:SetAction(Action.SHOCKWAVE_BOUNCE)
	end

	if m.Input:Has(InputFlags.OFF_FLOOR) then
		return m:SetAction(Action.FREEFALL)
	end

	if m.Input:Has(InputFlags.ABOVE_SLIDE) then
		return m:SetAction(Action.BEGIN_SLIDING)
	end

	animatedStationaryGroundStep(m, Animations.SLOW_LAND_FROM_DIVE, Action.IDLE)
	return false
end)

DEF_ACTION(Action.PICKING_UP_BOWSER, function(m: Mario)
	if m.ActionState == 0 then
		m.ActionState = 1
		Util.SetY(m.AngleVel, 0)
		m.BodyState.GrabPos = GRAB_POS_BOWSER or 0
		-- m.BodyState.GrabPos = GRAB_POS_BOWSER
		m:GrabUsedObject()
		-- play_sound(SOUND_MARIO_HRMM, m.marioObj.gfx.cameraToObject)
		m:PlayMarioSound(Sounds.MARIO_WAH)

	end
	m:SetAnimation(Animations.GRAB_BOWSER)
	if m:IsAnimAtEnd() then
		m:SetAction(Action.HOLDING_BOWSER)
	end

	m:StationaryGroundStep()

	return false
end)

DEF_ACTION(Action.HOLDING_BOWSER, function(m: Mario)
	local spin = (nil :: any) :: number -- a 16 bit interger

	if m.Input:Has(InputFlags.B_PRESSED) then
		if m.AngleVel.Y <= -0xE00 or m.AngleVel.Y >= 0xE00 then
			m:PlayMarioSound(Sounds.MARIO_SO_LONGA_BOWSER)
			-- play_sound(SOUND_MARIO_SO_LONGA_BOWSER, m.marioObj.gfx.cameraToObject)
		else
			m:PlayMarioSound(Sounds.MARIO_HERE_WE_GO)
			-- play_sound(SOUND_MARIO_HERE_WE_GO, m.marioObj.gfx.cameraToObject)
		end
		return m:SetAction(Action.RELEASING_BOWSER)
	end

	if m.AngleVel.Y == 0 then
		if m.ActionTimer > 120 then
			return m:SetAction(Action.RELEASING_BOWSER, 1)
		end
		m.ActionTimer += 1
		m:SetAnimation(Animations.HOLDING_BOWSER)
	else
		m.ActionTimer = 0
		m:SetAnimation(Animations.SWINGING_BOWSER) -- SWINGING_BOWSER doesnt exist=
	end

	if m.IntendedMag > 20.0 then
		if m.ActionArg == 0 then
			m.ActionArg = 1
			m.TwirlYaw = m.IntendedYaw
		else
			-- // spin = acceleration
			-- spin = s16(m.intendedYaw - m.twirlYaw) / 0x80
			spin = Util.SignedShort(m.IntendedYaw - m.TwirlYaw) / 0x80

			if spin < -0x80 then
				spin = -0x80
			end
			if spin > 0x80 then
				spin = 0x80
			end

			m.TwirlYaw = m.IntendedYaw
			Util.SetY(m.AngleVel, Util.SignedShort(m.AngleVel.Y + spin))

			if m.AngleVel.Y > 0x1000 then
				Util.SetY(m.AngleVel, 0x1000)
			end
			if m.AngleVel.Y < -0x1000 then
				Util.SetY(m.AngleVel, -0x1000)
			end
		end
	else
		m.ActionArg = 0
		Util.SetY(m.AngleVel, Util.ApproachInt(m.AngleVel.Y, 0, 64, 64))
	end

	--  // spin = starting yaw
	-- spin = m.faceAngle[1]
	spin = m.FaceAngle.Y
	Util.SetY(m.FaceAngle, Util.SignedShort(m.FaceAngle.Y + m.AngleVel.Y))

	-- play sound on overflow
	-- TODO: fix this ig
	if m.AngleVel.Y <= -0x100 and spin < m.FaceAngle.Y then
		m:PlayActionSound(Sounds.OBJ_BOWSER_SPINNING)
		--play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.gfx.cameraToObject)
	end
	if m.AngleVel.Y >= 0x100 and spin > m.FaceAngle.Y then
		m:PlayActionSound(Sounds.OBJ_BOWSER_SPINNING)
		-- play_sound(SOUND_OBJ_BOWSER_SPINNING, m.marioObj.gfx.cameraToObject)
	end

	m:StationaryGroundStep()
	-- TODO: this
	if m.AngleVel.Y >= 0 then
		-- m.marioObj.gfx.angle[0] = -m.angleVel[1]
	else
		-- m.marioObj.gfx.angle[0] = m.angleVel[1]
	end

	return false
end)