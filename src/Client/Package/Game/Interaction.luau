-- SM64 Objects are a nightmare!!!!!!!!!!!!!!!!!
-- WE HAVE TO COME UP WITH OBJECT-LESS SOLUTIONS
--
-- This module will attempt to emulate these objects,
-- but if you have your own SM64 object port, change
-- anything otherwise-related.

--!strict
local Interaction = {}
setmetatable(Interaction, {
	__index = function(self, key)
		warn('Interaction.' .. key.. 'is missing')
	end,
})

local SM64 = script.Parent.Parent
local Root = SM64.Parent

local Mario = require(SM64.Mario)
local Enums = require(SM64.Enums)
local Util = require(SM64.Util)

local Sounds = Mario.Sounds

local Action = Enums.Action
local ActionFlags = Enums.ActionFlags
local InputFlags = Enums.InputFlags

local MarioFlags = Enums.MarioFlags
local ParticleFlags = Enums.ParticleFlags

local InteractionType = Enums.Interaction.Type
local AttackType = Enums.Interaction.AttackType
local InteractionStatus = Enums.Interaction.Status
local InteractionMethod = Enums.Interaction.Method
local InteractionSubtype = Enums.Interaction.Subtype

local CameraShake = Enums.Camera.Shake

type Mario = Mario.Mario

local Text = require(script.Parent.Text)
local DIALOG_022, DIALOG_023, DIALOG_024, DIALOG_025, DIALOG_026, DIALOG_027, DIALOG_028, DIALOG_029 = Text.US.Dialogs.DIALOG_022, Text.US.Dialogs.DIALOG_023, Text.US.Dialogs.DIALOG_024, Text.US.Dialogs.DIALOG_025, Text.US.Dialogs.DIALOG_026, Text.US.Dialogs.DIALOG_027, Text.US.Dialogs.DIALOG_028, Text.US.Dialogs.DIALOG_029

local sDelayInvincTimer = 0
local sInvulnerable = 0
local sJustTeleported = 0
local sDisplayingDoorText = 0

-- Replace with your own Object type, if any
type Object = {
	Position: Vector3,
	Velocity: Vector3,

	MoveAnglePitch: number,
	MoveAngleYaw: number,
	MoveAngleRoll: number,

	FaceAnglePitch: number,
	FaceAngleYaw: number,
	FaceAngleRoll: number,

	HitboxRadius: number,
	HitboxHeight: number,

	DamageOrCoinValue: number,

	Behavior: any, -- ?

	-- PseudoObject values, they're SPECIFICALLY for
	-- emulating SM64 objects.
	RbxPart: BasePart?,
	CapFlag: number?,
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Knockback Actions
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local sForwardKnockbackActions = {
	{ Action.SOFT_FORWARD_GROUND_KB, Action.FORWARD_GROUND_KB, Action.HARD_FORWARD_GROUND_KB },
	{ Action.FORWARD_AIR_KB, Action.FORWARD_AIR_KB, Action.HARD_FORWARD_GROUND_KB },
	{ Action.FORWARD_WATER_KB, Action.FORWARD_WATER_KB, Action.FORWARD_WATER_KB },
}

local sBackwardKnockbackActions = {
	{ Action.SOFT_BACKWARD_GROUND_KB, Action.BACKWARD_GROUND_KB, Action.HARD_BACKWARD_GROUND_KB },
	{ Action.BACKWARD_AIR_KB, Action.BACKWARD_AIR_KB, Action.HARD_BACKWARD_GROUND_KB },
	{ Action.BACKWARD_WATER_KB, Action.BACKWARD_WATER_KB, Action.BACKWARD_WATER_KB },
}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Roblox Helpers
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local FLIP = CFrame.Angles(0, math.pi, 0)

-- Helper for pseudo-objects
local function isPseudoObject(t: any): boolean
	-- I'd use metatables for objects, like Mario does.
	-- Only returns true for simple tables.
	if typeof(t) == "table" and not getmetatable(t) then
		return true
	end

	return false
end

-- Helper for pseudo-objects
local function preparePseudoObject(o: any): any
	if isPseudoObject(o) then
		local rbxPart = o.RbxPart :: BasePart?

		if rbxPart then
			-- We're gonna emulate some properties using just a part.
			local pos = Util.ToSM64(rbxPart.Position)
			local extents = Util.GetExtents(rbxPart) / Util.Scale
			local extentsSize = extents - pos

			-- Move the position downwards.
			pos -= Vector3.yAxis * extentsSize.Y

			-- Emulate values.
			o.Position = pos
			o.HitboxRadius = math.max(extentsSize.X, extentsSize.Z)
			o.HitboxHeight = extentsSize.Y

			local pitch, yaw, roll = Util.CFrameToSM64Angles(rbxPart.CFrame * FLIP)
			o.FaceAnglePitch = pitch
			o.FaceAngleYaw = yaw
			o.FaceAngleRoll = roll

			return o
		end

		-- Or not
		o.Position = o.Position or Vector3.zero
		o.HitboxHeight = o.HitboxHeight or 0
		o.HitboxRadius = o.HitboxRadius or 0
		-- ?
		o.FaceAnglePitch = o.FaceAnglePitch or 0
		o.FaceAngleYaw = o.FaceAngleYaw or 0
		o.FaceAngleRoll = o.FaceAngleRoll or 0
	end

	return o
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local sDelayInvincTimer = false
local sInvulnerable = false

-- local sDisplayingDoorText = false
-- local sJustTeleported = false

local acceptableCapFlags: { number } = {
	MarioFlags.NORMAL_CAP,
	MarioFlags.VANISH_CAP,
	MarioFlags.METAL_CAP,
	MarioFlags.WING_CAP,
}

local function marioObjAngleToObject(m: Mario, o: Object): number
	local dx = o.Position.X - m.Position.X
	local dz = o.Position.Z - m.Position.Z

	return Util.Atan2s(dz, dx)
end

--[[
 * Determines Mario's interaction with a given object depending on their proximity,
 * action, speed, and position.
]]
local function determineInteraction(m: Mario, o: Object): number
	local interaction = 0

	local action = m.Action()

	if m.Action:Has(ActionFlags.ATTACKING) then
		if action == Action.PUNCHING or action == Action.MOVE_PUNCHING or action == Action.JUMP_KICK then
			local dYawToObject = Util.SignedShort(marioObjAngleToObject(m, o) - m.FaceAngle.Y)

			if m.Flags:Has(MarioFlags.PUNCHING) then
				-- 120 degrees total, or 60 each way
				if -0x2AAA <= dYawToObject and dYawToObject <= 0x2AAA then
					interaction = InteractionType.PUNCH
				end
			end
			if m.Flags:Has(MarioFlags.KICKING) then
				-- 120 degrees total, or 60 each way
				if -0x2AAA <= dYawToObject and dYawToObject <= 0x2AAA then
					interaction = InteractionType.KICK
				end
			end
			if m.Flags:Has(MarioFlags.TRIPPING) then
				-- 180 degrees total, or 90 each way
				if -0x4000 <= dYawToObject and dYawToObject <= 0x4000 then
					interaction = InteractionType.TRIP
				end
			end
		elseif action == Action.GROUND_POUND or action == Action.TWIRLING then
			if m.Velocity.Y < 0.0 then
				interaction = InteractionType.GROUND_POUND_OR_TWIRL
			end
		elseif action == Action.GROUND_POUND_LAND or action == Action.TWIRL_LAND then
			-- Neither ground pounding nor twirling change Mario's vertical speed on landing,
			-- so the speed check is nearly always true (perhaps not if you land while going upwards?)
			-- Additionally, actionState it set on each first thing in their action, so this is
			-- only true prior to the very first frame (i.e. active 1 frame prior to it run).
			if m.Velocity.Y < 0.0 and m.ActionState == 0 then
				interaction = InteractionType.GROUND_POUND_OR_TWIRL
			end
		elseif action == Action.SLIDE_KICK or action == Action.SLIDE_KICK_SLIDE then
			interaction = InteractionType.SLIDE_KICK
		elseif m.Action:Has(ActionFlags.RIDING_SHELL) then
			interaction = InteractionType.FAST_ATTACK_OR_SHELL
		elseif m.ForwardVel < -26.0 or 26.0 <= m.ForwardVel then
			interaction = InteractionType.FAST_ATTACK_OR_SHELL
		end
	end

	-- Prior to this, the interaction type could be overwritten. This requires, however,
	-- that the interaction not be set prior. This specifically overrides turning a ground
	-- pound into just a bounce.
	if interaction == 0 and m.Action:Has(ActionFlags.AIR) then
		if m.Velocity.Y < 0.0 then
			if m.Position.Y > o.Position.Y then
				interaction = InteractionType.HIT_FROM_ABOVE
			end
		else
			if m.Position.Y < o.Position.Y then
				interaction = InteractionType.HIT_FROM_BELOW
			end
		end
	end

	return interaction
end

local function determineKnockbackAction(m: Mario, o: Object): number
	local oDamageOrCoinValue = tonumber(o.DamageOrCoinValue) or 0

	local bonkAction

	local terrainIndex = 0 -- 1 = air, 2 = water, 0 = default
	local strengthIndex = 0

	local angleToObject = marioObjAngleToObject(m, o)
	local facingDYaw = Util.SignedShort(angleToObject - m.FaceAngle.Y)
	local remainingHealth = Util.SignedShort(m.Health - 0x40 * m.HurtCounter)

	if m.Action:Has(ActionFlags.SWIMMING, ActionFlags.METAL_WATER) then
		terrainIndex = 2
	elseif m.Action:Has(ActionFlags.AIR, ActionFlags.ON_POLE, ActionFlags.HANGING) then
		terrainIndex = 1
	end

	if remainingHealth < 0x100 or oDamageOrCoinValue >= 4 then
		strengthIndex = 2
	elseif oDamageOrCoinValue >= 2 then
		strengthIndex = 1
	end

	m.FaceAngle = Util.SetY(m.FaceAngle, angleToObject)

	if terrainIndex == 2 then
		if m.ForwardVel < 28.0 then
			m:SetForwardVel(28.0)
		end
	else
		if m.ForwardVel < 16.0 then
			m:SetForwardVel(16.0)
		end
	end

	-- indexes start at 64
	terrainIndex += 1
	strengthIndex += 1

	if -0x4000 <= facingDYaw and facingDYaw <= 0x4000 then
		m.ForwardVel *= -1.0
		bonkAction = sBackwardKnockbackActions[terrainIndex][strengthIndex]
	else
		m.FaceAngle += Vector3int16.new(0, 0x8000, 0)
		bonkAction = sForwardKnockbackActions[terrainIndex][strengthIndex]
	end

	return bonkAction
end

local function takeDamageFromInteractObject(m: Mario, o: Object): number
	local damage = math.floor(tonumber(o.DamageOrCoinValue) or 0)

	local shake = CameraShake.SMALL_DAMAGE
	if damage >= 4 then
		shake = CameraShake.LARGE_DAMAGE
	elseif damage >= 2 then
		shake = CameraShake.MED_DAMAGE
	end

	if not m.Flags:Has(MarioFlags.CAP_ON_HEAD) then
		damage += (damage + 1) / 2
	end

	if m.Flags:Has(MarioFlags.METAL_CAP) then
		damage = 0
	end

	-- setCameraShakeFromHit(shake)

	m.HurtCounter += 4 * damage
	return damage
end

local function takeDamageAndKnockback(m: Mario, o: Object): boolean
	local damage = 0

	local delayInvinc = (o :: any).InteractionSubtype
		and (o :: any).InteractionSubtype:Has(InteractionSubtype.DELAY_INVINCIBILITY)
	local mInvulnerable = (m.InvincTimer > 0 or m.Action:Has(ActionFlags.INVULNERABLE))
		or m.Flags:Has(MarioFlags.VANISH_CAP)

	if not (mInvulnerable or delayInvinc) then
		damage = takeDamageFromInteractObject(m, o)

		if damage > 0 then
			m:PlaySound(Sounds.MARIO_ATTACKED)
		end

		return m:DropAndSetAction(determineKnockbackAction(m, o), damage)
	end

	return false
end

local function bounceOffObject(m: Mario, o: Object, velY: number)
	m.Position = Util.SetY(m.Position, o.Position.Y + o.HitboxHeight)
	m.Velocity = Util.SetY(m.Velocity, velY)

	m.Flags:Add(MarioFlags.MOVING_UP_IN_AIR)
	m:PlaySound(Sounds.ACTION_BOUNCE_OFF_OBJECT)
end

local function pushMarioOutOfObject(m: Mario, o: Object, padding: number?)
	local padding = tonumber(padding) or 0

	local oPos = o.Position
	local HitboxRadius = o.HitboxRadius
	local minDistance = HitboxRadius + m.HitboxRadius + padding

	local offsetX = m.Position.X - oPos.X
	local offsetZ = m.Position.Z - oPos.Z
	local distance = math.sqrt(offsetX * offsetX + offsetZ * offsetZ)

	if distance < minDistance then
		local pushAngle
		local newMarioX
		local newMarioZ

		if distance == 0.0 then
			pushAngle = m.FaceAngle.Y
		else
			pushAngle = Util.Atan2s(offsetZ, offsetX)
		end

		newMarioX = oPos.X + minDistance * Util.Sins(pushAngle)
		newMarioZ = oPos.Z + minDistance * Util.Coss(pushAngle)

		local pos = Util.FindWallCollisions(Vector3.new(newMarioX, m.Position.Y, newMarioZ), 60.0, 50.0)
		local _floorHeight, floor = Util.FindFloor(pos)

		if floor ~= nil then
			--! Doesn't update Mario's referenced floor (allows oob death when
			-- an object pushes you into a steep slope while in a ground action)
			m.Position = pos
		end
	end
end

local function resetMarioPitch(m: Mario)
	local action = m.Action()

	if action == Action.WATER_JUMP or action == Action.SHOT_FROM_CANNON or action == Action.FLYING then
		m.FaceAngle = Util.SetX(m.FaceAngle, 0)
	end
end

local function attackObject(o: Object, interaction: number): number
	local attackType = 0

	if interaction == InteractionType.GROUND_POUND_OR_TWIRL then
		attackType = AttackType.GROUND_POUND_OR_TWIRL
	elseif interaction == InteractionType.PUNCH then
		attackType = AttackType.PUNCH
	elseif interaction == InteractionType.KICK or interaction == InteractionType.TRIP then
		attackType = AttackType.KICK_OR_TRIP
	elseif interaction == InteractionType.SLIDE_KICK or interaction == InteractionType.FAST_ATTACK_OR_SHELL then
		attackType = AttackType.FAST_ATTACK
	elseif interaction == InteractionType.HIT_FROM_ABOVE then
		attackType = AttackType.FROM_ABOVE
	elseif interaction == InteractionType.HIT_FROM_BELOW then
		attackType = AttackType.FROM_BELOW
	end

	local o = o :: any
	if o.InteractStatus then
		o.InteractStatus.Value = attackType + bit32.bor(InteractionStatus.INTERACTED, InteractionStatus.WAS_ATTACKED)
	end

	return attackType
end

-- obsolete atm
local function marioStopRidingObject(m: Mario)
	--[[
	if m.RiddenObj ~= nil then
		m.RiddenObj.InteractStatus:Add(InteractionStatus.STOP_RIDING)
		stopShellMusic()
		m.RiddenObj = nil
	end
	]]
end

-- obsolete atm
local function marioGrabUsedObject(m: any)
	if m.HeldObj == nil then
		m.HeldObj = m.UsedObj
		m.HeldObj:SetHeldState("bhvCarrySomething3")
	end
end

-- obsolete atm
local function marioDropHeldObject(m: any)
	local heldObj = m.HeldObj

	if heldObj ~= nil then
		--if m.HeldObj.Behavior == "bhvKoopaShellUnderwater" then
		--	stopShellMusic()
		--end

		heldObj:SetHeldState("bhvCarrySomething4")

		-- ! When dropping an object instead of throwing it, it will be put at Mario's
		--  y-positon instead of the HOLP's y-position. This fact is often exploited when
		--  cloning objects.

		local holp = m.BodyState.HeldObjLastPos
		heldObj.Position = Vector3.new(holp.X, m.Position.Y, holp.Z)

		heldObj.MoveAngleYaw = m.FaceAngle.Y

		m.HeldObj = nil
	end
end

-- obsolete atm
local function marioThrowHeldObject(m: any)
	if m.HeldObj ~= nil then
		if m.HeldObj.Behavior == "bhvKoopaShellUnderwater" then
			-- stopShellMusic()
		end

		m.HeldObj:SetHeldState("bhvCarrySomething5")

		local holp = m.BodyState.HeldObjLastPos
		m.HeldObj.Position = Vector3.new(
			holp.X + 32.0 * Util.Sins(m.FaceAngle.Y),
			m.Position.Y,
			holp.Z + 32.0 * Util.Coss(m.FaceAngle.Y)
		)

		m.HeldObj.MoveAngleYaw = m.FaceAngle.Y

		m.HeldObj = nil
	end
end

local function doesMarioHaveNormalCapOnHead(m: Mario): boolean
	return bit32.band(m.Flags(), bit32.bor(MarioFlags.CAPS, MarioFlags.CAP_ON_HEAD))
		== bit32.bor(MarioFlags.NORMAL_CAP, MarioFlags.CAP_ON_HEAD)
end

-- obsolete atm
local function marioBlowOffCap(m: Mario, capSpeed: number)
	local capObject = nil

	if doesMarioHaveNormalCapOnHead(m) then
		m.Flags:Remove(MarioFlags.NORMAL_CAP, MarioFlags.CAP_ON_HEAD)

		-- capObject = spawnObject(...?)

		-- capObject.Position = Util.SetY(capObject.Position, m.Action:Has(ActionFlags.SHORT_HITBOX) and 120 or 180)
		-- capObject.ForwardVel = capSpeed
		-- capObject.MoveAngleYaw = Util.SignedShort(m.FaceAngle.Y + 0x400)

		--if m.ForwardVel < 0.0 then
		--	capObject.MoveAngleYaw = Util.SignedShort(m.FaceAngle.Y + 0x8000)
		--end
	end
end

-- obsolete atm
local function marioLoseCapToEnemy(m: Mario, arg: number)
	local wasWearingCap = false

	if doesMarioHaveNormalCapOnHead(m) then
		-- saveFileSetFlags(arg == 1 and SaveFlag.CAP_ON_KLEPTO or SaveFlag.CAP_ON_UKIKI)
		m.Flags:Remove(MarioFlags.NORMAL_CAP, MarioFlags.CAP_ON_HEAD)
		wasWearingCap = true
	end

	return wasWearingCap
end

-- obsolete atm
local function marioRetreiveCap(m: Mario)
	marioDropHeldObject(m)
	-- saveFileClearFlags(SaveFlag.CAP_ON_KLEPTO, SaveFlag.CAP_ON_UKIKI)
	m.Flags:Remove(MarioFlags.CAP_ON_HEAD)
	m.Flags:Remove(MarioFlags.NORMAL_CAP, MarioFlags.CAP_IN_HAND)
end

local function ableToGrabObject(m: Mario, o: Object): boolean
	local action = m.Action()

	if action == Action.DIVE_SLIDE or action == Action.DIVE then
		if not (o :: any).InteractionSubtype:Has(InteractionSubtype.GRABS_MARIO) then
			return true
		end
	elseif action == Action.PUNCHING or action == Action.MOVE_PUNCHING then
		if m.ActionArg < 2 then
			return true
		end
	end

	return false
end

-- Advanced objects only
local function marioGetCollidedObject(m: Mario, InteractType: number)
	local marioObj = (m :: any).MarioObj :: any

	for _, object in marioObj.CollidedObjs do
		if object.InteractType == InteractType then
			return object
		end
	end

	return nil
end

local function marioCheckObjectGrab(m: Mario)
	local result = false
	local interactObj = (m :: any).InteractObj

	if m.Input:Has(InputFlags.INTERACT_OBJ_GRABBABLE) and interactObj then
		local Script = interactObj.Behavior

		if Script == "bhvBowser" then
			--
		else
			local facingDYaw = Util.SignedShort(marioObjAngleToObject(m, interactObj) - m.FaceAngle.Y)
			if facingDYaw >= -0x2AAA and facingDYaw <= 0x2AAA then
				(m :: any).UsedObj = interactObj

				if not m.Action:Has(ActionFlags.AIR) then
					m:SetAction(m.Action:Has(ActionFlags.DIVING) and Action.DIVE_PICKING_UP or Action.PICKING_UP)
				end

				result = true
			end
		end
	end

	return result
end

-- ?
local function hitObjectFromBelow(m: Mario)
	m.Velocity = Util.SetY(m.Velocity, 0)
	-- setCameraShakeFromHit(SHAKE_HIT_FROM_BELOW)
end

local function bounceBackFromAttack(m: Mario, interaction: number)
	local action = m.Action()

	if bit32.btest(interaction, bit32.bor(InteractionType.PUNCH, InteractionType.KICK, InteractionType.TRIP)) then
		if action == Action.PUNCHING then
			m:SetAction(Action.MOVE_PUNCHING)
		end

		if m.Action:Has(ActionFlags.AIR) then
			m:SetForwardVel(-16.0)
		else
			m:SetForwardVel(-48.0)
		end

		m.ParticleFlags:Add(ParticleFlags.TRIANGLE)
	end

	if
		bit32.btest(
			interaction,
			bit32.bor(
				InteractionType.PUNCH,
				InteractionType.KICK,
				InteractionType.TRIP,
				InteractionType.FAST_ATTACK_OR_SHELL
			)
		)
	then
		m:PlaySound(Sounds.ACTION_HIT)
	end
end

local function checkObjectGrabMario(m: Mario, _, o: Object): boolean
	local interactionSubtype = (o :: any).InteractionSubtype

	if not interactionSubtype then
		return false
	end

	if
		(not m.Action:Has(ActionFlags.AIR, ActionFlags.INVULNERABLE, ActionFlags.ATTACKING) or not sInvulnerable)
		and interactionSubtype:Has(InteractionSubtype.GRABS_MARIO)
	then
		Interaction.MarioStopRidingAndHolding(m);
		(o :: any).InteractStatus.Value = bit32.bor(InteractionStatus.INTERACTED, InteractionStatus.GRABBED_MARIO)

		m.FaceAngle.Y = o.MoveAngleYaw or 0;
		(m :: any).InteractObj = o;
		(m :: any).UsedObj = o

		m:PlaySound(Sounds.MARIO_OOOF)
		return m:SetAction(Action.GRABBED)
	end

	pushMarioOutOfObject(m, o, -5.0)
	return false
end

--[[
local function shouldPushOrPullDoor(m: Mario, point: Vector3, cframe: CFrame): number
	local dx = point.X - m.Position.X
	local dz = point.Z - m.Position.Z

	local _, dYaw = Util.CFrameToSM64Angles(cframe)
	dYaw = Util.SignedShort(dYaw - Util.Atan2s(dz, dx))

	return (dYaw >= -0x4000 and dYaw <= 0x4000) and 0x00000001 or 0x00000002
end
]]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mario Interactions
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Interaction.InteractFlame(m: Mario, o: Object): boolean
	local burningAction = Action.BURNING_JUMP

	if
		m.Health > 0xFF
		and m.InvincTimer <= 0
		and not m.Action:Has(ActionFlags.INVULNERABLE, ActionFlags.INTANGIBLE)
		and not m.Flags:Has(MarioFlags.METAL_CAP, MarioFlags.VANISH_CAP)
	then
		if (o :: any).InteractStatus then
			(o :: any).InteractStatus.Value = InteractionStatus.INTERACTED
		end
		(m :: any).InteractObj = o

		if m.Action:Has(ActionFlags.SWIMMING, ActionFlags.METAL_WATER) and m.WaterLevel - m.Position.Y > 50.0 then
			m:PlaySound(Sounds.GENERAL_FLAME_OUT)
		else
			m.BurnTimer = 0
			m:PlaySound(Sounds.MARIO_ON_FIRE)

			if m.Action:Has(ActionFlags.AIR) and m.Velocity.Y < 0 then
				burningAction = Action.BURNING_FALL
			end

			return m:DropAndSetAction(burningAction, 1)
		end
	end

	return false
end

-- Vector3 point must be in SM64 Units.
function Interaction.InteractDamage(m: Mario, o: Object): boolean
	preparePseudoObject(o)

	if takeDamageAndKnockback(m, o) then
		return true
	end

	if (o :: any).InteractionSubtype and (o :: any).InteractionSubtype:Has(InteractionSubtype.DELAY_INVINCIBILITY) then
		sDelayInvincTimer = true
	end

	return false
end

-- Vector3 point must be in SM64 Units.
function Interaction.InteractKoopaShell(m: Mario, o: Object): boolean
	preparePseudoObject(o)

	if not m.Action:Has(ActionFlags.RIDING_SHELL) then
		local interaction = determineInteraction(m, o)

		if
			interaction == InteractionType.HIT_FROM_ABOVE
			or m.Action() == Action.WALKING
			or m.Action() == Action.HOLD_WALKING
		then
			(m :: any).InteractObj = o;
			(m :: any).UsedObj = o
			-- m.RiddenObj = o

			attackObject(o, interaction)
			-- updateMarioSoundAndCamera(m)
			-- playShellMusic()
			Interaction.MarioDropHeldObject(m)

			--! Puts Mario in ground action even when in air, making it easy to
			-- escape air actions into crouch slide (shell cancel)
			return m:SetAction(Action.RIDING_SHELL_GROUND, 0)
		end

		if o then
			pushMarioOutOfObject(m, o, 2.0)
		end
	end

	return false
end

function Interaction.InteractCap(m: Mario, o: Object | number): boolean
	local capMusic = 0
	local capTime = 0

	preparePseudoObject(o :: any)

	-- stylua: ignore
	local capFlag: number = if typeof(o) == "table" then
		(tonumber(o.CapFlag) or 0)
		else (tonumber(o) or 0)

	if m.Action() ~= Action.GETTING_BLOWN and table.find(acceptableCapFlags, capFlag) then
		(m :: any).InteractObj = o
		if isPseudoObject(o) and (o :: any).InteractStatus then
			(o :: any).InteractStatus.Value = InteractionStatus.INTERACTED
		end

		m.Flags:Remove(MarioFlags.CAP_ON_HEAD, MarioFlags.CAP_IN_HAND)
		m.Flags:Add(capFlag)

		if capFlag == MarioFlags.VANISH_CAP then
			capTime = 600
			-- capMusic = SEQUENCE_ARGS(4, SEQ_EVENT_POWERUP)
		elseif capFlag == MarioFlags.METAL_CAP then
			capTime = 600
			-- capMusic = SEQUENCE_ARGS(4, SEQ_EVENT_METAL_CAP)
		elseif capFlag == MarioFlags.WING_CAP then
			capTime = 1800
			-- capMusic = SEQUENCE_ARGS(4, SEQ_EVENT_POWERUP)
		end

		if capTime > m.CapTimer then
			m.CapTimer = capTime
		end

		if m.Action:Has(ActionFlags.IDLE) or m.Action() == Action.WALKING then
			m.Flags:Add(MarioFlags.CAP_IN_HAND)
			m:SetAction(Action.PUTTING_ON_CAP)
		else
			m.Flags:Add(MarioFlags.CAP_ON_HEAD)
		end

		m:PlaySound(Sounds.MARIO_HERE_WE_GO)

		if capMusic ~= 0 then
			-- playCapMusic(capMusic)
		end

		return true
	end

	return false
end

function Interaction.InteractStarOrKey(m: Mario, o: Object): boolean
	preparePseudoObject(o)

	local starGrabAction = Action.STAR_DANCE_EXIT
	print('what are we doing hereee')
	local noExit = true -- (o->oInteractionSubtype & INT_SUBTYPE_NO_EXIT) != 0;
	local grandStar = false -- (o->oInteractionSubtype & INT_SUBTYPE_GRAND_STAR) != 0;

	if m.Health >= 0x100 then
		Interaction.MarioStopRidingAndHolding(m)

		if not noExit then
			m.HurtCounter = 0
			m.HealCounter = 0
			if m.CapTimer > 1 then
				m.CapTimer = 1
			end
		end

		if noExit then
			starGrabAction = Action.STAR_DANCE_NO_EXIT
		end

		if m.Action:Has(ActionFlags.SWIMMING) then
			starGrabAction = Action.STAR_DANCE_WATER
		end

		if m.Action:Has(ActionFlags.AIR) then
			starGrabAction = Action.FALL_AFTER_STAR_GRAB
		end

		if (o :: any).InteractStatus then
			(o :: any).InteractStatus.Value = InteractionStatus.INTERACTED
		end

		(m :: any).InteractObj = o;
		(m :: any).UsedObj = o

		-- starIndex = bit32.band(bit32.rshift(o.BhvParams, 24), 0x1F)
		-- saveFileCollectStarOrKey(m.NumCoins, starIndex)

		-- m.NumStars = saveFileGetTotalStarCount(gCurrSaveFileNum - 1, COURSE_MIN - 1, COURSE_MAX - 1)

		--if not noExit then
		--	dropQueuedBackgroundMusic()
		--	fadeoutLevelMusic(126)
		--end

		m:PlaySound(Sounds.MENU_STAR_SOUND)

		if grandStar then
			return m:SetAction(Action.JUMBO_STAR_CUTSCENE)
		end

		return m:SetAction(starGrabAction, (noExit and 1 or 0) + 2 * (grandStar and 1 or 0))
	end

	return false
end

function Interaction.InteractBounceTop(m: Mario, o: Object): boolean
	preparePseudoObject(o)

	local interaction = 0

	if m.Flags:Has(MarioFlags.METAL_CAP) then
		interaction = InteractionType.FAST_ATTACK_OR_SHELL
	else
		interaction = determineInteraction(m, o)
	end

	if bit32.btest(interaction, InteractionType.ATTACK_NOT_FROM_BELOW) then
		attackObject(o, interaction)
		bounceBackFromAttack(m, interaction)

		if bit32.btest(interaction, InteractionType.HIT_FROM_ABOVE) then
			local isTwirlBounce = (o :: any).TwirlBounce
			if not isPseudoObject(o) and (o :: any).InteractionSubtype then
				isTwirlBounce = (o :: any).InteractionSubtype:Has(InteractionSubtype.TWIRL_BOUNCE)
			end

			if isTwirlBounce then
				bounceOffObject(m, o, 80.0)
				resetMarioPitch(m)

				m:PlaySound(Sounds.MARIO_TWIRL_BOUNCE)
				return m:DropAndSetAction(Action.TWIRLING)
			else
				bounceOffObject(m, o, 30.0)
			end
		end
	elseif takeDamageAndKnockback(m, o) then
		return true
	end

	if (o :: any).InteractionSubtype and (o :: any).InteractionSubtype:Has(InteractionSubtype.DELAY_INVINCIBILITY) then
		sDelayInvincTimer = true
	end

	return false
end

function Interaction.InteractShock(m: Mario, o: Object): boolean
	preparePseudoObject(o)

	sInvulnerable = (m.Action:Has(ActionFlags.INVULNERABLE) or m.InvincTimer ~= 0)
	if not sInvulnerable and not m.Flags:Has(MarioFlags.VANISH_CAP) then
		local actionArg = m.Action:Has(ActionFlags.AIR, ActionFlags.ON_POLE, ActionFlags.HANGING) == false;

		(m :: any).InteractObj = o

		takeDamageFromInteractObject(m, o)
		m:PlaySound(Sounds.MARIO_ATTACKED)

		if m.Action:Has(ActionFlags.SWIMMING, ActionFlags.METAL_WATER) then
			return m:DropAndSetAction(Action.WATER_SHOCKED)
		else
			return m:DropAndSetAction(Action.SHOCKED, actionArg and 1 or 0)
		end
	end

	return false
end

--[[function Interaction.InteractPole(m: Mario, o: Object): boolean
	preparePseudoObject(o)
	local oPos = o.Position
	local actionId = bit32.band(m.Action(), 0x1FF)

	if actionId >= 0x080 and actionId < 0x0A0 then
		if not m.PrevAction:Has(ActionFlags.ON_POLE) then
			local velConv = m.ForwardVel
			local lowSpeed = m.ForwardVel <= 10.0

			Interaction.MarioStopRidingAndHolding(m);
			(m :: any).InteractObj = o

			--! Still using BaseParts for poles.
			--  Change to your own solution for SM64 objects if any
			m.PoleObj = o.RbxPart
			m.Velocity = Util.SetY(m.Velocity, 0)
			m.ForwardVel = 0

			m.PoleYawVel = 0
			m.PolePos = m.Position.Y - oPos.Y

			if lowSpeed then
				return m:SetAction(Action.GRAB_POLE_SLOW)
			end

			--! @bug Using m.ForwardVel here is assumed to be 0.0f due to the set from earlier.
			--       This is fixed in the Shindou version.
			m.PoleYawVel = velConv * 0x100 + 0x1000 -- FIXED VER
			-- m.PoleYawVel = m.ForwardVel * 0x100 + 0x1000 -- UNFIXED VER

			resetMarioPitch(m)
			return m:SetAction(Action.GRAB_POLE_FAST)
		end
	end

	return false
end]]
function Interaction.InteractPole(m: Mario, o: Object) preparePseudoObject(o)
	local actionId = bit32.band(m.Action(), 0x1FF)
	if actionId >= 0x80 and actionId < 0x0A0 then
		-- ACT_FLAG_ON_POLE
		if not m.PrevAction:Has(ActionFlags.ON_POLE) or m.UsedObj ~= o then
			local lowSpeed = m.ForwardVel <= 10
			local marioObj = m.MarioObj

			m.InteractObj = o
			m.UsedObj = o
			m.Velocity = Util.SetY(m.Velocity, 0)
			m.ForwardVel = 0

			--[[marioObj.MarioPoleUnk108 = 0
			marioObj.MarioPoleYawVel = 0
			marioObj.MarioPolePos = m.Position.Y - o.Position.Y]]
			marioObj.PoleUnk108 = 0
			marioObj.PoleYawVel = 0
			marioObj.PolePos = m.Position.Y - o.Position.Y

			if lowSpeed then
				return m:SetAction(Action.GRAB_POLE_SLOW, 0)
			end

			-- marioObj.MarioPoleYawVel = (m.ForwardVel * 0x100) + 0x1000
			marioObj.PoleYawVel = (m.ForwardVel * 0x100) + 0x1000

			resetMarioPitch(m)
			-- reset_mario_pitch(m)
			return m:SetAction(Action.GRAB_POLE_FAST, 0)
		end
	end

	return false
end


function Interaction.InteractCoin(m: Mario, o: Object): boolean
	preparePseudoObject(o)
	local coinValue = tonumber(o.DamageOrCoinValue) or 1

	m.NumCoins += coinValue
	m.HealCounter += 4 * coinValue

	if o and (o :: any).InteractStatus then
		(o :: any).InteractStatus.Value = InteractionStatus.INTERACTED
	end

	--[[
	if CourseIsMainCourse(gCurrCourseNum) and m.NumCoins - coinValue < 100 and m.NumCoins >= 100 then
		bhvSpawnStarNoLevelExit(StarIndex.HUNDRED_COINS)
	end
	]]

	return false
end

-- Advanced objects only
function Interaction.InteractGrabbable(m: Mario, o: Object, InteractType: number): boolean
	local Script = o.Behavior
	local interactionSubtype = (o :: any).InteractionSubtype

	if not interactionSubtype then
		return false
	end

	if interactionSubtype:Has(InteractionSubtype.KICKABLE) then
		local interaction = determineInteraction(m, o)

		if bit32.btest(interaction, bit32.bor(InteractionType.KICK, InteractionType.TRIP)) then
			attackObject(o, interaction)
			bounceBackFromAttack(m, interaction)
			return false
		end
	end

	if interactionSubtype:Has(InteractionSubtype.GRABS_MARIO) then
		if checkObjectGrabMario(m, InteractType, o) then
			return true
		end
	end

	if ableToGrabObject(m, o) then
		if not interactionSubtype:Has(InteractionSubtype.NOT_GRABBABLE) then
			(m :: any).InteractObj = o
			m.Input:Add(InputFlags.INTERACT_OBJ_GRABBABLE)
			return true
		end
	end

	if Script ~= "bhvBowser" then
		pushMarioOutOfObject(m, o, -5.0)
	end

	return false
end

-- HI guys hi, its me; yep
-- HI hey guys hey, yep its me
local function should_push_or_pull_door(m: Mario, o: Object)
	local dx = o.Position.X - m.Position.X
	local dz = o.Position.Z - m.Position.Z

	local dYaw = Util.s16(o.MoveAngleYaw - Util.Atan2s(dz, dx))

	return (dYaw >= -0x4000 and dYaw <= 0x4000) and 0x00000001 or 0x00000002
end

warn('TODO: numStars')
local ACT_PULLING_DOOR = Action.PULLING_DOOR
local ACT_PUSHING_DOOR = Action.PUSHING_DOOR
local ACT_ENTERING_STAR_DOOR = Action.ENTERING_STAR_DOOR
local ACT_UNLOCKING_STAR_DOOR = Action.UNLOCKING_STAR_DOOR
local ACT_READING_AUTOMATIC_DIALOG = Action.READING_AUTOMATIC_DIALOG

local INT_SUBTYPE_STAR_DOOR = InteractionSubtype.STAR_DOOR

warn('TODO: get_door_save_file_flag')
function get_door_save_file_flag(door)
	return 0
    --[[let saveFileFlag = 0
    let requiredNumStars = door.rawData[oBehParams] >> 24

    let isCcmDoor = door.rawData[oPosX] < 0.0
    let isPssDoor = door.rawData[oPosY] > 500.0

    switch (requiredNumStars) {
        [1:
            if (isPssDoor) {
                saveFileFlag = SAVE_FLAG_UNLOCKED_PSS_DOOR
            } else {
                saveFileFlag = SAVE_FLAG_UNLOCKED_WF_DOOR
            }
            break

        [3:
            if (isCcmDoor) {
                saveFileFlag = SAVE_FLAG_UNLOCKED_CCM_DOOR
            } else {
                saveFileFlag = SAVE_FLAG_UNLOCKED_JRB_DOOR
            }
            break

        [8:
            saveFileFlag = SAVE_FLAG_UNLOCKED_BITDW_DOOR
            break

        [30:
            saveFileFlag = SAVE_FLAG_UNLOCKED_BITFS_DOOR
            break

        [50:
            saveFileFlag = SAVE_FLAG_UNLOCKED_50_STAR_DOOR
            break
    }

    return saveFileFlag]]
end

warn('TODO: save_file_get_flags')
local function interact_door(m: Mario, o: Object)
	local --[[s16]] requiredNumStars = bit32.rshift(o.BhvParams(), 24) -- o.BhvParams >> 24
	local --[[s16]] numStars = 0 -- save_file_get_total_star_count(Area.gCurrSaveFileNum - 1, COURSE_MIN - 1, COURSE_MAX - 1)

	if m.Action() == Action.WALKING or m.Action() == Action.DECELERATING then
		-- if (m.Action == ACT_WALKING || m.Action == ACT_DECELERATING) {
		if numStars >= requiredNumStars then
			local --[[u32]] actionArg = should_push_or_pull_door(m, o)
			local --[[u32]] enterDoorAction
			local --[[u32]] doorSaveFileFlag

			if bit32.band(actionArg, 0x00000001) then
				-- if (actionArg & 0x00000001) {
				enterDoorAction = ACT_PULLING_DOOR
			else
				enterDoorAction = ACT_PUSHING_DOOR
			end

			doorSaveFileFlag = get_door_save_file_flag(o)
			m.InteractObj = o
			m.UsedObj = o

			if o.InteractionSubtype:Has(INT_SUBTYPE_STAR_DOOR) then
				enterDoorAction = ACT_ENTERING_STAR_DOOR
			end

            --[[if (doorSaveFileFlag != 0 and !(save_file_get_flags() & doorSaveFileFlag)) {
                enterDoorAction = ACT_UNLOCKING_STAR_DOOR
            }]]


			return m:SetAction(enterDoorAction, actionArg)
		elseif not (sDisplayingDoorText ~= 0) then
			warn('TODO', requiredNumStars)
			
			local text = DIALOG_022.str -- u32

			Util.Switch(requiredNumStars, {
				[1] = function() text = DIALOG_024.str end,
				[3] = function() text = DIALOG_025.str end,
				[8] = function() text = DIALOG_026.str end,
				[30] = function() text = DIALOG_027.str end,
				[50] = function() text = DIALOG_028.str end,
				[70] = function() text = DIALOG_029.str end,
			})

			-- text += requiredNumStars - numStars
			-- text = text .. tostring(requiredNumStars - numStars)
			print(text)
			text = string.byte(text) + requiredNumStars - numStars
			
			sDisplayingDoorText = 1
			return m:SetAction(ACT_READING_AUTOMATIC_DIALOG, text)
		end
	elseif m.Action:Has(Action.IDLE) and sDisplayingDoorText == 1 and requiredNumStars == 70 then
		m.InteractObj = o
		m.UsedObj = o
		return m:SetAction(ACT_ENTERING_STAR_DOOR, should_push_or_pull_door(m, o))
	end

	return false
end
Interaction.InteractDoor = interact_door

function mario_obj_angle_to_object(m: Mario, o: Object)
	local dx = o.Position.X - m.Position.X
	local dz = o.Position.Z - m.Position.Z

	return Util.Atan2s(dz, dx)
end


function mario_can_talk(m: Mario, arg: number)
	local val6

	if m.Action:Has(Action.IDLE) then
		-- if ((m.action & ACT_FLAG_IDLE) != 0x00000000) then
		return true
	end

	if m.Action:Has(Action.WALKING) then
		-- if (m.action == ACT_WALKING) then
		if arg ~= 0 then -- 0 would be falsey or sum
			return true
		end

		-- TODO: this
        --[[val6 = m.marioObj.gfx.animInfo.animID
		
		-- i think it would be better if they werent just numberss mannnn aaahhh
		if val6 == 0x0080 or val6 == 0x007F or val6 == 0x006C then
            return true
        end]]
	end

	return false
end

--[[/**
 * Returns true if the passed in object has a moving angle yaw
 * in the angular range given towards Mario.
 */]]
-- angleRange: s16
local function object_facing_mario(m: Mario, o: Object, angleRange: number)
	local dx = m.Position.X - o.Position.X
	local dz = m.Position.Z - o.Position.Z

	local angleToMario = Util.Atan2s(dz, dx)
	local dAngle = Util.SignedShort(angleToMario - o.MoveAngleYaw)

	if -angleRange <= dAngle and dAngle <= angleRange then
		return true
	end

	return false
end

-- i hated using (m :: any) here, just fix the typechecking dude..!! : (
function check_read_sign(m: Mario, o: Object)
	-- const check_read_sign = (m, o) => {
	if (m.Input:Has(InputFlags.B_PRESSED) or m.Input:Has(InputFlags.A_PRESSED)) and mario_can_talk(m, 0) and object_facing_mario(m, o, 0x4000) then
		-- const
		local facingDYaw = Util.SignedShort(Util.SignedShort(o.MoveAngleYaw + 0x8000) - m.FaceAngle.Y)
		if (facingDYaw >= -0x4000 and facingDYaw <= 0x4000) then
			-- const
			local targetX = o.Position.X + 105.0 * Util.Sins(o.MoveAngleYaw)
			-- const
			local targetZ = o.Position.Z + 105.0 * Util.Coss(o.MoveAngleYaw)
			-- local targetZ = o.rawData[oPosZ] + 105.0 * coss(o.rawData[oMoveAngleYaw])

			local marioObj = (m :: any).MarioObj :: any
			--[[
			marioObj.oMarioReadingSignDYaw = facingDYaw;
			marioObj.oMarioReadingSignDPosX = targetX - m.pos[0]
			marioObj.oMarioReadingSignDPosZ = targetZ - m.pos[2] ]]

			marioObj.oMarioReadingSignDYaw = facingDYaw;
			marioObj.oMarioReadingSignDPosX = targetX - m.Position.X
			marioObj.oMarioReadingSignDPosZ = targetZ - m.Position.Z

			;(m :: any).InteractObj = o;
			(m :: any).UsedObj = o;
			return m:SetAction(Action.READING_SIGN, 0)
		end
	end

	return false
end

function check_npc_talk(m: Mario, o: Object)
	if (m.Input:Has(InputFlags.B_PRESSED) or m.Input:Has(InputFlags.A_PRESSED)) and mario_can_talk(m, 1) then
		-- if ((m.input & (INPUT_B_PRESSED | INPUT_A_PRESSED)) and mario_can_talk(m, 1)) {
		-- const
		local facingDYaw = Util.SignedShort(

			mario_obj_angle_to_object(m, o) - m.FaceAngle.Y
		)
		if facingDYaw >= -0x4000 and facingDYaw <= 0x4000 then
			-- if (facingDYaw >= -0x4000 and facingDYaw <= 0x4000) {

			-- o.rawData[oInteractStatus] = INT_STATUS_INTERACTED

			(m :: any).InteractObj = o;
			(m :: any).UsedObj = o;

			pushMarioOutOfObject(m, o, -10.0)
			return m:SetAction(Action.WAITING_FOR_DIALOG, 0)
		end
	end

	pushMarioOutOfObject(m, o, -10.0)
	return false
end

function Interaction.InteractText(m: Mario, o: Object)
	preparePseudoObject(o)
	local interact = 0 :: any

	if (o :: any).InteractionSubtype:Has(InteractionSubtype.SIGN) then
		-- if (o.rawData[oInteractionSubtype] & INT_SUBTYPE_SIGN) {
		interact = check_read_sign(m, o)
	elseif (o :: any).InteractionSubtype:Has(InteractionSubtype.NPC) then
		--  elseif (o.rawData[oInteractionSubtype] & INT_SUBTYPE_NPC) {
		interact = check_npc_talk(m, o)
	else
		pushMarioOutOfObject(m, o, 2.0)
	end

	return interact
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Initialize
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Outside redirect, if needed
function Interaction.PreparePseudoObject(o: Object): Object
	return preparePseudoObject(o)
end

function Interaction.ProcessMarioInteractions(m: Mario)
	sDelayInvincTimer = false
	sInvulnerable = (m.Action:Has(ActionFlags.INVULNERABLE) or m.InvincTimer ~= 0)

	if m.InvincTimer > 0 and not sDelayInvincTimer then
		m.InvincTimer -= 1
	end

	-- Advanced objects only
	local marioObj = (m :: any).MarioObj :: any

	if marioObj then
		if not m.Action:Has(ActionFlags.INTANGIBLE) and marioObj.CollidedObjInteractTypes() ~= 0 then
			for _, handler in Interaction.InteractionHandlers do
				local InteractType = handler[1]

				if marioObj.CollidedObjInteractTypes:Has(InteractType) then
					local object = marioGetCollidedObject(m, InteractType)

					marioObj.CollidedObjInteractTypes:Remove(InteractType)

					if object and not object.InteractStatus:Has(InteractionStatus.INTERACTED) then
						-- id rather have the game break
						return handler[2](m, object, InteractType)
						--[[local intSuccess, intOut = pcall(function()
							return handler[2](m, object, InteractType)
						end)

						if intSuccess and intOut then
							break
						elseif not intSuccess then
							warn(`Failed executing interaction because {intOut}`, debug.traceback())
						end]]
					end
				end
			end
		end
	end

	--! If the kick/punch flags are set and an object collision changes Mario's
	--  action, he will get the kick/punch wall speed anyway.
	m:CheckKickOrPunchWall()
	m.Flags:Remove(MarioFlags.PUNCHING, MarioFlags.KICKING, MarioFlags.TRIPPING)

	--[[
	if marioObj then
		if not marioObj.CollidedObjInteractTypes:Has(InteractionMethod.WARP_DOOR, InteractionMethod.DOOR) then
			sDisplayingDoorText = false
		end
		if not marioObj.CollidedObjInteractTypes:Has(InteractionMethod.WARP) then
			sJustTeleported = false
		end
	end
	]]
end

function Interaction.MarioStopRidingAndHolding(m: Mario)
	marioDropHeldObject(m)
	marioStopRidingObject(m)

	--if m.Action() == Action.RIDING_HOOT then
	--	 m.UsedObj.InteractStatus = false
	--	 m.UsedObj.HootMarioReleaseTime = Util.GlobalTimer
	--end
end

function Interaction.MarioDropHeldObject(m: Mario)
	return marioDropHeldObject(m)
end

function Interaction.MarioThrowHeldObject(m: Mario)
	return marioThrowHeldObject(m)
end

function Interaction.MarioCheckObjectGrab(m: Mario)
	return marioCheckObjectGrab(m)
end

function Interaction.MarioGrabUsedObject(m: Mario)
	return marioGrabUsedObject(m)
end

-- @interaction.c
-- interactType, handler
--[[Interaction.InteractionHandlers = {
	{ InteractionMethod.COIN, Interaction.InteractCoin },
	{ InteractionMethod.FLAME, Interaction.InteractFlame },
	{ InteractionMethod.SHOCK, Interaction.InteractShock },
	{ InteractionMethod.BOUNCE_TOP, Interaction.InteractBounceTop },
	{ InteractionMethod.BOUNCE_TOP2, Interaction.InteractBounceTop },
	{ InteractionMethod.DAMAGE, Interaction.InteractDamage },
	{ InteractionMethod.POLE, Interaction.InteractPole },
	{ InteractionMethod.KOOPA_SHELL, Interaction.InteractKoopaShell },
	{ InteractionMethod.GRABBABLE, Interaction.InteractGrabbable },
	{ InteractionMethod.STAR_OR_KEY, Interaction.InteractStarOrKey },
	{ InteractionMethod.MR_BLIZZARD, Interaction.InteractDamage },
} :: { { any } }]]

-- const sInteractionHandlers = {
Interaction.InteractionHandlers = {
	{ InteractionMethod.COIN, Interaction.InteractCoin },
	{ InteractionMethod.WATER_RING, Interaction.Null },
	{ InteractionMethod.STAR_OR_KEY, Interaction.InteractStarOrKey },
	{ InteractionMethod.BBH_ENTRANCE, Interaction.Null },
	{ InteractionMethod.WARP, Interaction.InteractWarp },
	{ InteractionMethod.WARP_DOOR, Interaction.InteractWarpDoor },
	{ InteractionMethod.DOOR, Interaction.InteractDoor },
	{ InteractionMethod.CANNON_BASE, Interaction.InteractCannonBase },
	{ InteractionMethod.IGLOO_BARRIER, Interaction.Null },
	{ InteractionMethod.TORNADO, Interaction.Null },
	{ InteractionMethod.WHIRLPOOL, Interaction.Null },
	{ InteractionMethod.STRONG_WIND, Interaction.Null },
	{ InteractionMethod.FLAME, Interaction.InteractFlame },
	{ InteractionMethod.SNUFIT_BULLET, Interaction.Null },
	{ InteractionMethod.CLAM_OR_BUBBA, Interaction.Null },
	{ InteractionMethod.BULLY, Interaction.InteractBully },
	{ InteractionMethod.SHOCK, Interaction.InteractShock },
	{ InteractionMethod.BOUNCE_TOP2, Interaction.Null },
	{ InteractionMethod.MR_BLIZZARD, Interaction.InteractMrBlizzard },
	{ InteractionMethod.HIT_FROM_BELOW, Interaction.InteractHitFromBelow },
	{ InteractionMethod.BOUNCE_TOP, Interaction.InteractBounceTop },
	{ InteractionMethod.DAMAGE, Interaction.InteractDamage },
	{ InteractionMethod.POLE, Interaction.InteractPole },
	{ InteractionMethod.HOOT, Interaction.Null },
	{ InteractionMethod.BREAKABLE, Interaction.InteractBreakable },
	{ InteractionMethod.KOOPA, Interaction.Null },
	{ InteractionMethod.KOOPA_SHELL, Interaction.Null },
	{ InteractionMethod.UNKNOWN_08, Interaction.Null },
	{ InteractionMethod.CAP, Interaction.InteractCap },
	{ InteractionMethod.GRABBABLE, Interaction.InteractGrabbable },
	{ InteractionMethod.TEXT, Interaction.InteractText },
} :: { { any } }

return Interaction
