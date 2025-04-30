-- TODO: GoombaTargetYaw
-- TODO: GoombaSize

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)
local Enums = require(Package.Enums)
local Interaction = require(Package.Game.Interaction)
local Types = require(Package.Types)
local Sounds = require(Package.Sounds)

local ObjectListProcessor = require(Object.ObjectListProcessor)
local Helpers = require(Object.ObjectHelpers)
local ObjBhvs2 =  require(Object.ObjBehaviors2)
local Constants = require(Object.ObjectConstants)
local SpawnSound = require(Object.SpawnSound)
local Models = require(Object.Models)
-- params = params
local parseInt = math.floor
-- local INTERACT_BOUNCE_TOP = Interaction.InteractBounceTop

type Object = Types.ObjectState

-- class
local goombaBhv = {}

local sGoombaProperties = {
	[0] = 
		{ scale = 1.5, deathSound = nil, drawDistance = 4000, damage = 1 },
	{ scale = 3.5, deathSound = nil, drawDistance = 4000, damage = 2 },
	{ scale = 0.5, deathSound = nil, drawDistance = 1500, damage = 0 }
}

local sGoombaHitbox = {
	-- InteractType = INTERACT_BOUNCE_TOP,
	InteractType = Enums.Interaction.Method.BOUNCE_TOP,
	downOffset =         0,
	DamageOrCoinValue =  1,
	health =             0,
	numLootCoins =       1,
	radius =             72,
	height =             50,
	HurtboxRadius =      42,
	HurtboxHeight =      40
}

local sGoombaAttackHandlers = {
	-- regular and tiny
	[0] =
	{[0] =
		--[[ ATTACK_PUNCH:                 ]] ObjBhvs2.ATTACK_HANDLER_KNOCKBACK,
		--[[ ATTACK_KICK_OR_TRIP:          ]] ObjBhvs2.ATTACK_HANDLER_KNOCKBACK,
		--[[ ATTACK_FROM_ABOVE:            ]] ObjBhvs2.ATTACK_HANDLER_SQUISHED,
		--[[ ATTACK_GROUND_POUND_OR_TWIRL: ]] ObjBhvs2.ATTACK_HANDLER_SQUISHED,
		--[[ ATTACK_FAST_ATTACK:           ]] ObjBhvs2.ATTACK_HANDLER_KNOCKBACK,
		--[[ ATTACK_FROM_BELOW:            ]] ObjBhvs2.ATTACK_HANDLER_KNOCKBACK,
	},
	-- huge
	{[0] =
		--[[ ATTACK_PUNCH:                 ]] ObjBhvs2.ATTACK_HANDLER_SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED,
		--[[ ATTACK_KICK_OR_TRIP:          ]] ObjBhvs2.ATTACK_HANDLER_SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED,
		--[[ ATTACK_FROM_ABOVE:            ]] ObjBhvs2.ATTACK_HANDLER_SQUISHED,
		--[[ ATTACK_GROUND_POUND_OR_TWIRL: ]] ObjBhvs2.ATTACK_HANDLER_SQUISHED_WITH_BLUE_COIN,
		--[[ ATTACK_FAST_ATTACK:           ]] ObjBhvs2.ATTACK_HANDLER_SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED,
		--[[ ATTACK_FROM_BELOW:            ]] ObjBhvs2.ATTACK_HANDLER_SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED,
	}
}

local function goomba_act_jump(o: Object)
	ObjBhvs2.obj_resolve_object_collisions(o, {})
	--! If we move outside the goomba's drawing radius the frame it enters the
	--  jump action, then it will keep its velY, but it will still be counted
	--  as being on the ground.
	--  Next frame, the jump action will think it has already ended because it is
	--  still on the ground.
	--  This puts the goomba back in the walk action, but the positive velY will
	--  make it hop into the air. We can then trigger another jump.
	if o.MoveFlags:Has(Constants.OBJ_MOVE_MASK_ON_GROUND) then
		o.Action = Constants.GOOMBA_ACT_WALK
	else
		Helpers.cur_obj_rotate_yaw_toward(o, o.GoombaTargetYaw, 0x800)
	end
end

local function goomba_begin_jump(o: Object)
	SpawnSound.cur_obj_play_sound_2(o, Sounds.OBJ_GOOMBA_ALERT)
	--play sound

	o.Action = Constants.GOOMBA_ACT_JUMP
	o.ForwardVel = 0.0
	-- o.Velocity.Y = 50.0 / 3.0 * o.GoombaScale
	o.Velocity = Util.SetY(o.Velocity, 50.0 / 3.0 * o.GoombaScale)
end

local function mark_goomba_as_dead(o: Object)
	--[[if (o.parentObj ~= o) then
		ObjectListProc.set_object_respawn_info_bits(o.parentObj, (o.BhvParams2ndByte & GOOMBA_BP_TRIPLET_FLAG_MASK) >> 2)

		o.parentObj.BhvParams = o.parentObj.BhvParams or (o.BhvParams2ndByte & GOOMBA_BP_TRIPLET_FLAG_MASK) << 6
	end]]
	if o.parentObj ~= o then
		ObjectListProcessor.set_object_respawn_info_bits(
			o.parentObj,
			bit32.rshift(bit32.band(o.BhvParams2ndByte, Constants.GOOMBA_BP_TRIPLET_FLAG_MASK), 2)
		)

		o.parentObj.BhvParams = o.parentObj.BhvParams or 
			bit32.lshift(bit32.band(o.BhvParams2ndByte, Constants.GOOMBA_BP_TRIPLET_FLAG_MASK), 6)
	end

end

local function goomba_act_attacked_mario(o: Object)

	if o.GoombaSize == Constants.GOOMBA_SIZE_TINY then
		mark_goomba_as_dead(o)
		o.NumLootCoins = 0
		ObjBhvs2.obj_die_if_health_non_positive(o)
	else
		--! This can happen even when the goomba is already in the air. It's
		--  hard to chain these in practice
		goomba_begin_jump(o)
		o.GoombaTargetYaw = o.AngleToMario
		o.GoombaTurningAwayFromWall = 0
	end
end

local function bhv_goomba_init(o: Object)

	o.GoombaSize = bit32.band(o.BhvParams2ndByte, Constants.GOOMBA_BP_SIZE_MASK) -- o.BhvParams2ndByte & GOOMBA_BP_SIZE_MASK

	o.GoombaScale = sGoombaProperties[o.GoombaSize].scale

	Helpers.obj_set_hitbox(o, sGoombaHitbox)

	o.DrawingDistance = sGoombaProperties[o.GoombaSize].drawDistance
	o.DamageOrCoinValue = sGoombaProperties[o.GoombaSize].damage

	o.Gravity = -8.0 / 3.0 * o.GoombaScale

end

local function goomba_act_walk(o)
	-- --[[const]] local o = ObjectListProc.gCurrentObject

	ObjBhvs2.treat_far_home_as_mario(o, 1000.0)

	ObjBhvs2.obj_forward_vel_approach(o, o.GoombaRelativeSpeed * o.GoombaScale, 0.4)

	if o.GoombaRelativeSpeed > 4.0 / 3.0 then
		ObjBhvs2.cur_obj_play_sound_at_anim_range(o, 2, 17, Sounds.OBJ_GOOMBA_WALK)
	end

	--! By strategically hitting a wall, steep slope, or another goomba, we can
	--  prevent the goomba from turning back toward home for a while (goomba
	--  chase extension)
	--! It seems theoretically possible to get 2-3 goombas to repeatedly touch
	--  each other and move arbitrarily far from their home, but it's
	--  extremely precise and chaotic in practice, so probably can't be performed
	--  for nontrivial distances
	if (o.GoombaTurningAwayFromWall) then
		o.GoombaTurningAwayFromWall = ObjBhvs2.obj_resolve_collisions_and_turn(o, o.GoombaTargetYaw, 0x200)
	else
		-- If far from home, walk toward home.
		if (o.DistanceToMario >= 25000.0) then
			o.GoombaTargetYaw = o.AngleToMario
			o.GoombaWalkTimer = ObjBhvs2.random_linear_offset(20, 30)
		end

		--[[const]] local targetYawWrapper = { value = o.GoombaTargetYaw }
		o.GoombaTurningAwayFromWall = ObjBhvs2.obj_bounce_off_walls_edges_objects(o, targetYawWrapper)
		o.GoombaTargetYaw = targetYawWrapper.value

		if (not (o.GoombaTurningAwayFromWall)) then
			if (o.DistanceToMario < 500.0) then
				-- If close to mario, begin chasing him. If not already chasing
				-- him, jump first

				if (o.GoombaRelativeSpeed <= 2.0) then
					goomba_begin_jump(o);
				end

				o.GoombaTargetYaw = o.AngleToMario
				o.GoombaRelativeSpeed = 20.0
			else
				-- If mario is far away, walk at a normal pace, turning randomly
				-- and occasionally jumping

				o.GoombaRelativeSpeed = 4.0 / 3.0
				if (o.GoombaWalkTimer ~= 0) then
					o.GoombaWalkTimer -= 1
				else
					-- if (parseInt((math.random() * 65500)) & 3) then
					-- WHY WAS THIS 65499???
					if bit32.band(parseInt(math.random() * 65500), 3) ~= 0 then
						o.GoombaTargetYaw = ObjBhvs2.obj_random_fixed_turn(o, 0x2000)
						o.GoombaWalkTimer = ObjBhvs2.random_linear_offset(100, 100)
					else
						goomba_begin_jump(o);
						o.GoombaTargetYaw = ObjBhvs2.obj_random_fixed_turn(o, 0x6000)
					end
				end

			end
		end

		Helpers.cur_obj_rotate_yaw_toward(o, o.GoombaTargetYaw, 0x200)
	end

end

--[[local goombaActionCase = {
	[Constants.GOOMBA_ACT_WALK] = function()
		goomba_act_walk(o)
	end,
	[Constants.GOOMBA_ACT_ATTACKED_MARIO] = function()
		goomba_act_attacked_mario(o)
	end,
	[Constants.GOOMBA_ACT_JUMP] = function()
		goomba_act_jump(o)
	end,
	none = function()
		error('goomba act not implemented')
	end,
}]]
local goombaActionCase = {
	[Constants.GOOMBA_ACT_WALK] = goomba_act_walk,
	[Constants.GOOMBA_ACT_ATTACKED_MARIO] = goomba_act_attacked_mario,
	[Constants.GOOMBA_ACT_JUMP] = goomba_act_jump,
	none = function(o)
		o.Action = Constants.GOOMBA_ACT_WALK
		error('goomba act not implemented')
	end,
}

warn('TODO: utalize GoombaBlinkTimer')

local function bhv_goomba_update(o: Object)
	-- --[[const]] local o = ObjectListProc.gCurrentObject
	if ObjBhvs2.obj_update_standard_actions(o, o.GoombaScale) then

		-- If this goomba has a spawner and mario moved away from the spawner, unload
		if o.parentObj ~= o then
			if o.parentObj.Action == Constants.GOOMBA_TRIPLET_SPAWNER_ACT_UNLOADED then
				Helpers.obj_mark_for_deletion(o)
			end
		end

		Helpers.cur_obj_scale(o, o.GoombaScale)

		local blinkWrapper = { value = o.GoombaBlinkTimer }
		ObjBhvs2.obj_update_blinking(o, blinkWrapper, 30, 50, 5)
		o.GoombaBlinkTimer = blinkWrapper.value

		Helpers.cur_obj_update_floor_and_walls(o)

		local animSpeed = o.ForwardVel / o.GoombaScale * 0.4
		if (animSpeed < 1.0) then
			animSpeed = 1.0
		end
		
		Helpers.cur_obj_init_animation_with_accel_and_sound(o, 0, animSpeed)

		Util.Switch(o.Action, goombaActionCase, o)
		
		if ObjBhvs2.obj_handle_attacks(
			o,
			sGoombaHitbox,
			Constants.GOOMBA_ACT_ATTACKED_MARIO,
			sGoombaAttackHandlers[bit32.band(o.GoombaSize, 1)]
			) then
			mark_goomba_as_dead(o)
		end

		Helpers.cur_obj_move_standard(o, -78)

	else
		o.AnimState = 1
	end
end

--[[bhv_goomba_update = function(o)
	Util.Switch(o.Action, {
		[Constants.GOOMBA_ACT_WALK] = goomba_act_walk,
		[Constants.GOOMBA_ACT_ATTACKED_MARIO] = goomba_act_attacked_mario,
		[Constants.GOOMBA_ACT_JUMP] = goomba_act_jump,
		none = function(o)
			error('goomba act not implemented')
		end,
	}, o)
	-- print(o.Position)
end]]


local function bhv_goomba_triplet_spawner_update(o: Object)

	-- If mario is close enough and the goombas aren't currently loaded, then spawn them
	if o.Action == Constants.GOOMBA_TRIPLET_SPAWNER_ACT_UNLOADED then
		if o.DistanceToMario < 3000.0 then
			-- The spawner is capable of spawning more than 3 goombas, but this is not used in the game
			-- local dAngle = 0x10000 / (((o.rawData[oBhvParams2ndByte & GOOMBA_TRIPLET_SPAWNER_BP_EXTRA_GOOMBAS_MASK]) >> 2) + 3)
			local dAngle = 0x10000 / (bit32.rshift(bit32.band(o.BhvParams2ndByte, Constants.GOOMBA_TRIPLET_SPAWNER_BP_EXTRA_GOOMBAS_MASK), 2) + 3)

			local angle = 0
			local goombaFlag = bit32.lshift(1, 8)
			while angle < 0xFFFF do
			-- for angle = 0, 0xFFFF, dAngle do
				-- for (let angle = 0, goombaFlag = 1 << 8; angle < 0xFFFF; angle += dAngle, goombaFlag <<= 1) {

				if not o.BhvParams:Has(goombaFlag) then
					--if (!(o.rawData[oBhvParams] & goombaFlag)) then
					local dx = 500 * Util.Coss(angle)
					local dz = 500 * Util.Sins(angle)
					
					Helpers.spawn_object_relative(
						bit32.bor(bit32.band(o.BhvParams2ndByte, Constants.GOOMBA_TRIPLET_SPAWNER_BP_SIZE_MASK), bit32.rshift(goombaFlag, 6)),
						-- (o.BhvParams2ndByte & GOOMBA_TRIPLET_SPAWNER_BP_SIZE_MASK) | (goombaFlag >> 6),
						dx, 0, dz, o, Models.GOOMBA, 'bhvGoomba')
				end
				angle = angle + dAngle
				goombaFlag = bit32.lshift(goombaFlag, 1)
			end

			o.Action += 1
		end

	elseif o.DistanceToMario > 4000.0 then
		o.Action = Constants.GOOMBA_TRIPLET_SPAWNER_ACT_UNLOADED
	end

end

goombaBhv.bhv_goomba_init = bhv_goomba_init
goombaBhv.bhv_goomba_update = bhv_goomba_update
goombaBhv.bhv_goomba_triplet_spawner_update = bhv_goomba_triplet_spawner_update -- nil

require(script.Parent).Register(goombaBhv)
-- return goombaBhv