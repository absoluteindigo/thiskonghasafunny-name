-- JS NOTE: "ptr" is given as an indexed object <o> and an index <px>
-- Try this style out to eliminate the need for a wrapper.

local function approach_number_ptr(o: Object, px: any, target, delta)
	if o[px] > target then
		delta = -delta
	end

	o[px] += delta

	if (o[px] - target) * delta >= 0 then
		o[px] = target
		return true
	end
	return false
end

local Package = script.Parent.Parent.Parent
local Object = script.Parent
local ObjectConstants = require(Object.ObjectConstants)
local ObjectHelpers = require(Object.ObjectHelpers)
local SpawnSound = require(Object.SpawnSound)
local Model = require(Object.Models)

local Util = require(Package.Util)
local Types = require(Package.Types)
local Enums = require(Package.Enums)
local Sounds = require(Package.Sounds)
local gMarioObject = nil :: Types.MarioState

local function RBLXVECTORapproach_number_ptr(o: any, key: string, axis: string, target, delta)
	local func = Util['Set' .. axis]

	if o[key][axis] > target then
		delta = -delta
	end

	o[key] = func(o[key], o[key][axis] + delta)

	if (o[key][axis] - target) * delta >= 0 then
		-- o[key][axis] = target
		o[key] = func(o[key], target)
		return true
	end
	return false
end

type Object = Types.ObjectState

-- u might want to change this cause
-- js and lua math.random acts differently
local OBJ_FLAG_30 = ObjectConstants.OBJ_FLAG_30
local math_random = math.random
local parseInt = math.floor

local abs_angle_diff = ObjectHelpers.abs_angle_diff
--[[local math_random = function()
	return math.random(0xFFFF) / 0xFFFF
end]]



-- class ObjectHelpers
local ObjBehaviors2 = {}

function ObjBehaviors2.setMario(Mario: Types.MarioState)
	gMarioObject = Mario
end

ObjBehaviors2.ATTACK_HANDLER_NOP = 0
ObjBehaviors2.ATTACK_HANDLER_DIE_IF_HEALTH_NON_POSITIVE = 1
ObjBehaviors2.ATTACK_HANDLER_KNOCKBACK = 2
ObjBehaviors2.ATTACK_HANDLER_SQUISHED = 3
ObjBehaviors2.ATTACK_HANDLER_SPECIAL_KOOPA_LOSE_SHELL = 4
ObjBehaviors2.ATTACK_HANDLER_SET_SPEED_TO_ZERO = 5
ObjBehaviors2.ATTACK_HANDLER_SPECIAL_WIGGLER_JUMPED_ON = 6
ObjBehaviors2.ATTACK_HANDLER_SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED = 7
ObjBehaviors2.ATTACK_HANDLER_SQUISHED_WITH_BLUE_COIN = 8

ObjBehaviors2.POS_OP_SAVE_POSITION    = 0
ObjBehaviors2.POS_OP_COMPUTE_VELOCITY = 1
ObjBehaviors2.POS_OP_RESTORE_POSITION = 2

ObjBehaviors2.WAYPOINT_FLAGS_END = -1
ObjBehaviors2.WAYPOINT_FLAGS_INITIALIZED = 0x8000
ObjBehaviors2.WAYPOINT_MASK_00FF = 0x00FF
ObjBehaviors2.WAYPOINT_FLAGS_PLATFORM_ON_TRACK_PAUSE = 3

-- TODO: get_move_angle
-- TODO: init_obj

-- TODO: obj_bounce_off_walls_edges_objects

local todoreminded = true
function ObjBehaviors2.obj_die_if_health_non_positive(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	if todoreminded then
		todoreminded= false
		warn('TODO: o.DeathSound')
		warn('TODO: SPAWN BLUE COIN FUNCTIONALITY MISSING')
		warn('TODO: SPAWN COIN FUNCTIONALITY MISSING')

	end

	if (o.Health <= 0) then
		if o.DeathSound == 0 then
			ObjectHelpers.spawn_mist_particles_with_sound(o, Sounds.OBJ_DEFAULT_DEATH);
			ObjectHelpers.spawn_mist_particles(o)
		elseif o.DeathSound > 0 then
			ObjectHelpers.spawn_mist_particles_with_sound(o, o.DeathSound)
			ObjectHelpers.spawn_mist_particles(o)
		else
			ObjectHelpers.spawn_mist_particles(o)
		end

		if o.NumLootCoins < 0 then
			ObjectHelpers.spawn_object(o, Model.BLUE_COIN, 'bhvMrIBlueCoin')
		else
			ObjectHelpers.obj_spawn_loot_yellow_coins(o, o.NumLootCoins, 20.0)
		end

		if o.Health < 0 then
			ObjectHelpers.cur_obj_hide(o)
			ObjectHelpers.cur_obj_become_intangible(o)
		else
			ObjectHelpers.obj_mark_for_deletion(o)
		end
	end
end

function ObjBehaviors2.obj_resolve_object_collisions(o: Object, targetYawWrapper)
	-- local gMarioObject = gLinker.ObjectListProcessor.gMarioObject;

	if (o.NumCollidedObjs ~= 0) then
		local otherObject = o.CollidedObjs[1] --- aaaahhh indexed by zero.. gulp..
		-- note::: switched to 1

		if (otherObject ~= gMarioObject) then
			--! If one object moves after collisions are detected and this code
			--  runs, the objects can move toward each other (transport cloning)

			local dx = otherObject.Position.X - o.Position.X
			local dz = otherObject.Position.Z - o.Position.Z
			local angle = Util.Atan2s(dx, dz) --! This should be Util.Atan2s(dz, dx)

			local radius = o.HitboxRadius
			local otherRadius = otherObject.HitboxRadius
			local relativeRadius = radius / (radius + otherRadius)

			local newCenterX = o.Position.X + dx * relativeRadius
			local newCenterZ = o.Position.Z + dz * relativeRadius

			o.Position =  Vector3.new(
				newCenterX - radius * Util.Coss(angle),
				o.Position.Y,
				newCenterZ - radius * Util.Sins(angle)
			)
			-- o.Position.X = newCenterX - radius * Util.Coss(angle)
			-- o.Position.Z = newCenterZ - radius * Util.Sins(angle)

			otherObject.Position = Vector3.new(
				newCenterX + otherRadius * Util.Coss(angle),
				otherObject.Position.Y,
				newCenterZ + otherRadius * Util.Sins(angle)
			)

			-- otherObject.Position.X = newCenterX + otherRadius * Util.Coss(angle)
			-- otherObject.Position.Z = newCenterZ + otherRadius * Util.Sins(angle)

			if (targetYawWrapper.value and abs_angle_diff(o.MoveAngleYaw, angle) < 0x4000) then
				-- Bounce off object (or it would, if the above Util.Atan2s bug
				-- were fixed)
				targetYawWrapper.value = parseInt(angle - o.MoveAngleYaw + angle + 0x8000)
				return true
			end
		end
	end

	return false
end

function ObjBehaviors2.random_linear_offset(base, range)
	return parseInt(base + (range * math_random()))
end

function ObjBehaviors2.obj_random_fixed_turn(o: Object, delta)
	return parseInt(o.MoveAngleYaw + Util.random_sign() * delta)
end

function ObjBehaviors2.obj_bounce_off_walls_edges_objects(o: Object, targetYawWrapper)
	--warn('TODO!: obj_bounce_off_walls_edges_objects')
	--if true then return true end

	if o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_HIT_WALL) then
		targetYawWrapper.value = ObjectHelpers.cur_obj_reflect_move_angle_off_wall(o)
	elseif o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_HIT_EDGE) then
		-- targetYawWrapper.value = int16(o.rawData[oMoveAngleYaw] + 0x8000
		targetYawWrapper.value = bit32.band(o.MoveAngleYaw + 0x8000, 0xFFFF)
	elseif not ObjBehaviors2.obj_resolve_object_collisions(o, targetYawWrapper) then
		return false
	end

	return true
end

--[[
 * If we are far from home (> threshold away), then set oAngleToMario to the
 * angle to home and oDistanceToMario to 25000.
 * If we are close to home, but Mario is far from us (> threshold away), then
 * keep oAngleToMario the same and set oDistanceToMario to 20000.
 * If we are close to both home and Mario, then keep both oAngleToMario and
 * oDistanceToMario the same.
 *
 * The point of this function is to avoid having to write extra code to get
 * the object to return to home. When Mario is far away and the object is far
 * from home, it could theoretically re-use the "approach Mario" logic to approach
 * its home instead.
 * However, most objects that use this function handle the far-from-home case
 * separately anyway.
 * This function causes seemingly erroneous behavior in some objects that try to
 * attack Mario (e.g. fly guy shooting fire or lunging), especially when combined
 * with partial updates.
 ]]
function ObjBehaviors2.treat_far_home_as_mario(o: Object, threshold)
	-- local gMarioObject = gMarioObject
	local dx = o.Home.X - o.Position.X
	local dy = o.Home.Y - o.Position.Y
	local dz = o.Home.Z - o.Position.Z
	local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

	if distance > threshold then
		o.AngleToMario = Util.Atan2s(dz, dx)
		o.DistanceToMario = 25000.0
	else
		dx = o.Home.X - gMarioObject.Position.X
		dy = o.Home.Y - gMarioObject.Position.Y
		dz = o.Home.Z - gMarioObject.Position.Z
		distance = math.sqrt(dx * dx + dy * dy + dz * dz)

		if distance > threshold then
			o.DistanceToMario = 20000.0
		end
	end
end

function ObjBehaviors2.obj_act_knockback(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;

	ObjectHelpers.cur_obj_update_floor_and_walls(o)

	if o.AnimCurrent then
		-- if (o.gfx.animInfo.curAnim) then
		ObjectHelpers.cur_obj_extend_animation_if_at_end(o)
	end

	--[[if ((o.rawData[oMoveFlags] &
		(OBJ_MOVE_MASK_ON_GROUND | OBJ_MOVE_MASK_IN_WATER | OBJ_MOVE_HIT_WALL | OBJ_MOVE_ABOVE_LAVA))
		|| (o.rawData[oAction] == OBJ_ACT_VERTICAL_KNOCKBACK && o.rawData[oTimer] >= 9)) {
			obj_die_if_health_non_positive()
	end]]
	if o.MoveFlags:Has(
		ObjectConstants.OBJ_MOVE_MASK_ON_GROUND,
		ObjectConstants.OBJ_MOVE_MASK_IN_WATER,
		ObjectConstants.OBJ_MOVE_HIT_WALL,
		ObjectConstants.OBJ_MOVE_ABOVE_LAVA
		) 
			or (o.Action == ObjectConstants.OBJ_ACT_VERTICAL_KNOCKBACK and o.Timer >= 9) then	
		--if (bit32.band(o.MoveFlags, bit32.bor(OBJ_MOVE_MASK_ON_GROUND, OBJ_MOVE_MASK_IN_WATER, OBJ_MOVE_HIT_WALL, OBJ_MOVE_ABOVE_LAVA)) ~= 0) 
		--	or (o.Action == ObjectConstants.OBJ_ACT_VERTICAL_KNOCKBACK and o.Timer >= 9) then
		ObjBehaviors2.obj_die_if_health_non_positive(o)
	end

	ObjectHelpers.cur_obj_move_standard(o, -78)
end

function ObjBehaviors2.obj_act_squished(o: Object, baseScale)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	local targetScaleY = baseScale * 0.3

	ObjectHelpers.cur_obj_update_floor_and_walls(o)

	if o.AnimCurrent then
		ObjectHelpers.cur_obj_extend_animation_if_at_end(o)
	end
	--[[if (o.gfx.animInfo.curAnim) then
		cur_obj_extend_animation_if_at_end()
	end]]

	local result = RBLXVECTORapproach_number_ptr(o, 'GfxScale', 'Y', targetScaleY, baseScale * 0.14)

	if (result) then
		o.GfxScale = Vector3.new(
			baseScale * 2.0 - o.GfxScale.Y,
			o.GfxScale.Y,
			baseScale * 2.0 - o.GfxScale.Y
		)
		-- o.GfxScale.X = baseScale * 2.0 - o.GfxScale.Y
		-- o.GfxScale.Z = baseScale * 2.0 - o.GfxScale.Y

		if (o.Timer >= 16) then
			ObjBehaviors2.obj_die_if_health_non_positive(o)
		end

	end

	o.ForwardVel = 0.0
	ObjectHelpers.cur_obj_move_standard(o, -78)

end

function ObjBehaviors2.obj_update_standard_actions(o: Object, scale)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;

	if (o.Action < 100) then
		return true
	else
		ObjectHelpers.cur_obj_become_intangible(o)
		Util.Switch(o.Action, {
			[ObjectConstants.OBJ_ACT_HORIZONTAL_KNOCKBACK] = function()
				ObjBehaviors2.obj_act_knockback(o, scale)
			end,
			[ObjectConstants.OBJ_ACT_VERTICAL_KNOCKBACK] = function()
				ObjBehaviors2.obj_act_knockback(o, scale)
			end,
			[ObjectConstants.OBJ_ACT_SQUISHED] = function()
				ObjBehaviors2.obj_act_squished(o, scale)
			end,
		})
        --[[switch (o.rawData[oAction]) {
            case OBJ_ACT_HORIZONTAL_KNOCKBACK:
            case OBJ_ACT_VERTICAL_KNOCKBACK:
                obj_act_knockback(scale)
                break
            case OBJ_ACT_SQUISHED:
                obj_act_squished(scale)
                break
        }]]

		return false
	end

end



function ObjBehaviors2.obj_forward_vel_approach(o: Object, target, delta)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	-- return approach_number_ptr(o.rawData, oForwardVel, target, delta)
	return approach_number_ptr(o, 'ForwardVel', target, delta)
	-- return Util.ApproachFloat(o, 'ForwardVel', target, delta)
end

function ObjBehaviors2.obj_resolve_collisions_and_turn(o, targetYaw, turnSpeed)
	ObjBehaviors2.obj_resolve_object_collisions(o, {})

	if ObjectHelpers.cur_obj_rotate_yaw_toward(o, targetYaw, turnSpeed) then
		return false
	else
		return true
	end
end

function ObjBehaviors2.obj_set_squished_action(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	SpawnSound.cur_obj_play_sound_2(o, Sounds.OBJ_STOMPED);
	o.Action = ObjectConstants.OBJ_ACT_SQUISHED;
end

--[[function ObjBehaviors2.obj_die_if_health_non_positive = ()
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.Health <= 0) {
        if (o.DeathSound == 0) {
            spawn_mist_particles_with_sound(SOUND_OBJ_DEFAULT_DEATH);
            spawn_mist_particles()
        elseif (o.DeathSound > 0) {
            spawn_mist_particles_with_sound(o.DeathSound);
            spawn_mist_particles()
        } else {
            spawn_mist_particles()
        }

        console.log(o.NumLootCoins)
        if (o.NumLootCoins < 0) {
            spawn_object(o, MODEL_BLUE_COIN, bhvMrIBlueCoin)
        } else {
            obj_spawn_loot_yellow_coins(o, o.NumLootCoins, 20.0)
        }

        if (o.Health < 0) {
            cur_obj_hide()
            cur_obj_become_intangible()
        } else {
            obj_mark_for_deletion(o)
        }
    }
}]]

local OBJ_ACT = Enums.Object.Action	
local ATTACK = Enums.Interaction.AttackType

local knockbackAttackCase = {
	[ATTACK.FAST_ATTACK] = function(o)
		o.Action = OBJ_ACT.VERTICAL_KNOCKBACK
		o.ForwardVel = 20.0
		Util.SetY(o.Velocity, 50)
		-- o.VelY = 50.0
	end,
	none = function(o)
		o.Action = OBJ_ACT.HORIZONTAL_KNOCKBACK
		o.ForwardVel = 50.0
		Util.SetY(o.Velocity, 30)
		-- o.VelY = 30.0
	end
}
knockbackAttackCase[ATTACK.KICK_OR_TRIP] = knockbackAttackCase[ATTACK.FAST_ATTACK]

function ObjBehaviors2.obj_set_knockback_action(o: Object, attackType)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	-- const gMarioObject = gLinker.ObjectListProcessor.gMarioObject;

    --[[switch (attackType) {
        case ATTACK_KICK_OR_TRIP:
        case ATTACK_FAST_ATTACK:
            o.Action = OBJ_ACT_VERTICAL_KNOCKBACK
            o.ForwardVel = 20.0
            o.VelY = 50.0
            break

        default:
            o.Action = OBJ_ACT_HORIZONTAL_KNOCKBACK
            o.ForwardVel = 50.0
            o.VelY = 30.0
            break
    }]]
	Util.Switch(attackType, knockbackAttackCase, o)

	o.Flags:Remove(ObjectConstants.OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW)
	-- o.Flags:Clear(Enums.Object.Flag.SET_FACE_YAW_TO_MOVE_YAW)
	o.MoveAngleYaw = ObjectHelpers.obj_angle_to_object(gMarioObject, o)
end

--[[function ObjBehaviors2.obj_die_if_above_lava_and_health_non_positive(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;

	if o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_UNDERWATER_ON_GROUND) then
		--if o.Gravity + o.Buoyancy > 0.0 or SurfaceCollision.find_water_level(o.Position.X, o.Position.Z) - o.Position.Y < 150.0)
		if o.Gravity + o.Buoyancy > 0.0 or Util.GetWaterLevel(o.Position) - o.Position.Y < 150.0 then
			return false
		end
	elseif not o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_ABOVE_LAVA) then
		if o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_ENTERED_WATER) then
			if o.WallHitboxRadius < 200.0 then
				SpawnSound.cur_obj_play_sound_2(o, Sounds.OBJ_DIVING_INTO_WATER);
			else
				SpawnSound.cur_obj_play_sound_2(o, Sounds.OBJ_DIVING_IN_WATER)
			end
		end
		return false;
	end
	
	ObjBehaviors2.obj_die_if_health_non_positive(o);
	return true;
end]]
warn('function ObjBehaviors2.obj_die_if_above_lava_and_health_non_positive(o: Object) FUNCTINALIY MIGHT BE INNACURATE')
-- https://github.com/rovertronic/Mario-Builder-64/blob/ef1ca4e1e58d90f8650b5a23092544d9803b5389/src/game/obj_behaviors_2.c#L538
function ObjBehaviors2.obj_die_if_above_lava_and_health_non_positive(o: Object)
	-- Check lava
	if not (o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_ABOVE_LAVA) and o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_ON_GROUND, ObjectConstants.OBJ_MOVE_BOUNCE)) then
   -- if (!((o->oMoveFlags & (OBJ_MOVE_ABOVE_LAVA))&&(o->oMoveFlags & (OBJ_MOVE_ON_GROUND|OBJ_MOVE_BOUNCE))) ) then
        return false
    end
	
	print(o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_ABOVE_LAVA))
	print(o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_ON_GROUND))
	print(o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_BOUNCE))
	
	ObjBehaviors2.obj_die_if_health_non_positive(o);
    return true
end

local attackHandlerCase = {
	-- break
	[Enums.Interaction.AttackHandler.NOP] = function() end,
	[Enums.Interaction.AttackHandler.DIE_IF_HEALTH_NON_POSITIVE] = function(o)
		ObjBehaviors2.obj_die_if_health_non_positive(o);
	end,
	[Enums.Interaction.AttackHandler.KNOCKBACK] = function(o, attackType)
		ObjBehaviors2.obj_set_knockback_action(o, attackType)
	end,
	[Enums.Interaction.AttackHandler.SQUISHED] = function(o)
		ObjBehaviors2.obj_set_squished_action(o)
	end,
	[Enums.Interaction.AttackHandler.SPECIAL_KOOPA_LOSE_SHELL] = function(o)
		print("shelled_koopa_attack_handler not implemented")
		-- shelled_koopa_attack_handler(attackType);
	end,
	[Enums.Interaction.AttackHandler.SET_SPEED_TO_ZERO] = function(o)
		-- obj_set_speed_to_zero();
		print("obj_set_speed_to_zero not implemented")
	end,
	[Enums.Interaction.AttackHandler.SPECIAL_WIGGLER_JUMPED_ON] = function(o)
		-- wiggler_jumped_on_attack_handler();
		print("wiggler_jumped_on_attack_handler not implemented")
	end,
	[Enums.Interaction.AttackHandler.SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED] = function(o)
		-- huge_goomba_weakly_attacked();
		print("huge_goomba_weakly_attacked not implemented")
	end,
	[Enums.Interaction.AttackHandler.SQUISHED_WITH_BLUE_COIN] = function(o)
		o.NumLootCoins = -1
		ObjBehaviors2.obj_set_squished_action(o)
	end,      
}

local INT_STATUS = Enums.Interaction.Status

function ObjBehaviors2.obj_handle_attacks(o, hitbox, attackedMarioAction, attackHandlers)
	ObjectHelpers.obj_set_hitbox(o, hitbox)
	
	-- Die immediately if above lava
	-- https://github.com/n64decomp/sm64/blob/9921382a68bb0c865e5e45eb594d9c64db59b1af/src/game/obj_behaviors_2.c#L704
	if ObjBehaviors2.obj_die_if_above_lava_and_health_non_positive(o) then
		return false
	elseif o.InteractStatus:Has(INT_STATUS.INTERACTED) then
		if o.InteractStatus:Has(INT_STATUS.ATTACKED_MARIO) then
			if (o.Action ~= attackedMarioAction) then
				o.Action = attackedMarioAction
				o.Timer = 0
			end
		else
			-- INT_STATUS_ATTACK_MASK
			local attackType = bit32.band(o.InteractStatus(), INT_STATUS.ATTACK_MASK)
			-- local attackType = o.InteractStatus:Has(INT_STATUS.ATTACK_MASK)

			Util.Switch(attackHandlers[attackType - 1], attackHandlerCase, o, attackType)

			o.InteractStatus:Clear()
			return attackType
		end
	end

	o.InteractStatus:Clear()
	return false
end

function ObjBehaviors2.cur_obj_play_sound_at_anim_range(o: Object, frame1, frame2, sound)

	local rangeLength = o.AnimAccel / 0x10000
	-- local rangeLength = o.gfx.animInfo.animAccel / 0x10000

	if rangeLength <= 0 then
		rangeLength = 1
	end

	if ObjectHelpers.cur_obj_check_anim_frame_in_range(o, frame1, rangeLength) or ObjectHelpers.cur_obj_check_anim_frame_in_range(o, frame2, rangeLength) then
		-- print('PLAY SOUNDS')
		SpawnSound.cur_obj_play_sound_2(o, sound)
		-- cur_obj_play_sound_2(sound)
		return true
	end

	return false
end

function ObjBehaviors2.obj_update_blinking(o, blinkTimer, baseCycleLength, cycleLengthRange, blinkLength)
    -- const o = gLinker.ObjectListProcessor.gCurrentObject;

    if blinkTimer.value ~= 0 then
        blinkTimer.value -= 1
    else
        blinkTimer.value = ObjBehaviors2.random_linear_offset(baseCycleLength, cycleLengthRange)
    end

    if blinkTimer.value > blinkLength then
        o.AnimState = 0
    else
        o.AnimState = 1
    end
end





local ObjBhvs2 = ObjBehaviors2

;(function()
	ObjBhvs2 = setmetatable({}, {
		__index = function(_, k)
			local helper = ObjBehaviors2[k]
			if not helper then
				warn('NO BHV2 FOR')
				print(k)
			end
			return helper, function()
				return 0
			end
		end,
	})
end)()

return ObjBhvs2