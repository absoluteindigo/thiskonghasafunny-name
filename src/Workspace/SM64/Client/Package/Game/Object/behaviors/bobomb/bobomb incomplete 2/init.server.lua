local Behavior = {}

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)
local Enums = require(Package.Enums)
local Interaction = require(Package.Game.Interaction)
local Types = require(Package.Types)
local Sounds = require(Package.Sounds)

local ObjectListProcessor = require(Object.ObjectListProcessor)
local Helpers = require(Object.ObjectHelpers)
local ObjBehaviors = require(Object.ObjBehaviors)
local ObjBhvs2 =  require(Object.ObjBehaviors2)
local Constants = require(Object.ObjectConstants)
local SpawnSound = require(Object.SpawnSound)
local behaviors = require(Object.BehaviorData).BehaviorScripts
local SpawnObject = require(Object.SpawnObject)
local MODEL = require(Object.Models)
local GraphNodeConstats = require(Object.GraphNodeConstats)

type Object = Types.ObjectState

local parseInt = math.floor
local sqrtf = Helpers.sqrtf

local INT_STATUS_INTERACTED = Enums.Interaction.Status.INTERACTED

local obj_turn_toward_object, obj_attack_collided_from_other_object, cur_obj_scale, spawn_object, obj_mark_for_deletion, obj_set_hitbox, cur_obj_nearest_object_with_behavior, approach_s16_symmetric, cur_obj_init_animation, cur_obj_set_pos_relative, cur_obj_enable_rendering, cur_obj_get_dropped = Helpers.obj_turn_toward_object, Helpers.obj_attack_collided_from_other_object, Helpers.cur_obj_scale, Helpers.spawn_object, Helpers.obj_mark_for_deletion, Helpers.obj_set_hitbox, Helpers.cur_obj_nearest_object_with_behavior, Helpers.approach_s16_symmetric, Helpers.cur_obj_init_animation, Helpers.cur_obj_set_pos_relative, Helpers.cur_obj_enable_rendering, Helpers.cur_obj_get_dropped

local int32 = Util.SignedInt
warn('int32')
-- import { int32 } from "../../utils"
warn('create_respawner MISSING')
function create_respawner(...) warn(...) end
-- import { create_respawner } from "./corkbox.inc"
local cur_obj_play_sound_1, cur_obj_play_sound_2 = SpawnSound.cur_obj_play_sound_1, SpawnSound.cur_obj_play_sound_2
local BOBOMB_ACT_LAUNCHED, ACTIVE_FLAGS_DEACTIVATED, BOBOMB_BP_STYPE_GENERIC, HELD_HELD, HELD_FREE, HELD_THROWN, HELD_DROPPED, BOBOMB_ACT_PATROL, BOBOMB_ACT_CHASE_MARIO, BOBOMB_ACT_EXPLODE, BOBOMB_ACT_LAVA_DEATH, BOBOMB_ACT_DEATH_PLANE_DEATH = Constants.BOBOMB_ACT_LAUNCHED, Constants.ACTIVE_FLAGS_DEACTIVATED, Constants.BOBOMB_BP_STYPE_GENERIC, Constants.HELD_HELD, Constants.HELD_FREE, Constants.HELD_THROWN, Constants.HELD_DROPPED, Constants.BOBOMB_ACT_PATROL, Constants.BOBOMB_ACT_CHASE_MARIO, Constants.BOBOMB_ACT_EXPLODE, Constants.BOBOMB_ACT_LAVA_DEATH, Constants.BOBOMB_ACT_DEATH_PLANE_DEATH
--import { INT_SUBTYPE_NPC, INT_SUBTYPE_KICKABLE, INTERACT_GRABBABLE, INT_STATUS_INTERACTED,
--INT_STATUS_MARIO_UNK1, INT_STATUS_TOUCHED_BOB_OMB, INT_STATUS_MARIO_DROP_OBJECT } from "../Interaction"
local INT_STATUS_MARIO_UNK1 = Enums.Interaction.Status.MARIO_UNK1
local INT_STATUS_TOUCHED_BOB_OMB = Enums.Interaction.Status.TOUCHED_BOB_OMB
local INT_STATUS_MARIO_DROP_OBJECT = Enums.Interaction.Status.MARIO_DROP_OBJECT

local MODEL_EXPLOSION, MODEL_BLACK_BOBOMB, MODEL_SMOKE = MODEL.EXPLOSION, MODEL.BLACK_BOBOMB, MODEL.SMOKE
-- import { OBJ_COL_FLAG_GROUNDED } from "../ObjBehaviors"
-- everything from obj bhvs
local set_object_visibility,obj_check_if_facing_toward_angle,create_respawner,spawn_orange_number,obj_find_wall_displacement,obj_lava_death,obj_check_floor_death,OBJ_COL_FLAG_HIT_WALL,is_point_within_radius_of_mario,OBJ_COL_FLAG_NO_Y_VEL,trigger_obj_dialog_when_facing,OBJ_COL_FLAG_GROUNDED,current_mario_room_check,is_point_close_to_object,obj_flicker_and_disappear,turn_obj_away_from_surface,obj_spawn_yellow_coins,curr_obj_random_blink,obj_find_wall,OBJ_COL_FLAGS_LANDED,obj_return_and_displace_home,obj_return_home_if_safe,obj_orient_graph,turn_obj_away_from_steep_floor,calc_obj_friction,obj_move_xyz_using_fvel_and_yaw,object_step,OBJ_COL_FLAG_UNDERWATER,obj_splash,set_yoshi_as_not_dead=ObjBehaviors.set_object_visibility,ObjBehaviors.obj_check_if_facing_toward_angle,ObjBehaviors.create_respawner,ObjBehaviors.spawn_orange_number,ObjBehaviors.obj_find_wall_displacement,ObjBehaviors.obj_lava_death,ObjBehaviors.obj_check_floor_death,ObjBehaviors.OBJ_COL_FLAG_HIT_WALL,ObjBehaviors.is_point_within_radius_of_mario,ObjBehaviors.OBJ_COL_FLAG_NO_Y_VEL,ObjBehaviors.trigger_obj_dialog_when_facing,ObjBehaviors.OBJ_COL_FLAG_GROUNDED,ObjBehaviors.current_mario_room_check,ObjBehaviors.is_point_close_to_object,ObjBehaviors.obj_flicker_and_disappear,ObjBehaviors.turn_obj_away_from_surface,ObjBehaviors.obj_spawn_yellow_coins,ObjBehaviors.curr_obj_random_blink,ObjBehaviors.obj_find_wall,ObjBehaviors.OBJ_COL_FLAGS_LANDED,ObjBehaviors.obj_return_and_displace_home,ObjBehaviors.obj_return_home_if_safe,ObjBehaviors.obj_orient_graph,ObjBehaviors.turn_obj_away_from_steep_floor,ObjBehaviors.calc_obj_friction,ObjBehaviors.obj_move_xyz_using_fvel_and_yaw,ObjBehaviors.object_step,ObjBehaviors.OBJ_COL_FLAG_UNDERWATER,ObjBehaviors.obj_splash,ObjBehaviors.set_yoshi_as_not_dead

local GRAPH_RENDER_INVISIBLE = GraphNodeConstats.GRAPH_RENDER_INVISIBLE
local SOUND_OBJ_BOBOMB_WALK, SOUND_ACTION_READ_SIGN, SOUND_AIR_BOBOMB_LIT_FUSE = Sounds.OBJ_BOBOMB_WALK, Sounds.ACTION_READ_SIGN, Sounds.AIR_BOBOMB_LIT_FUSE

--[[ Bob-omb Buddy ]]
--[[ oBhvParams2ndByte ]]
local BOBOMB_BUDDY_BP_STYPE_GENERIC = 0
local BOBOMB_BUDDY_BP_STYPE_BOB_GRASS_KBB = 1
local BOBOMB_BUDDY_BP_STYPE_BOB_CANNON_KBB = 2
local BOBOMB_BUDDY_BP_STYPE_BOB_GRASS = 3
--[[ oAction ]]
local BOBOMB_BUDDY_ACT_IDLE = 0
local BOBOMB_BUDDY_ACT_TURN_TO_TALK = 2
local BOBOMB_BUDDY_ACT_TALK = 3
--[[ oBobombBuddyRole ]]
local BOBOMB_BUDDY_ROLE_ADVICE = 0
local BOBOMB_BUDDY_ROLE_CANNON = 1
--[[ oBobombBuddyCannonStatus ]]
local BOBOMB_BUDDY_CANNON_UNOPENED = 0
local BOBOMB_BUDDY_CANNON_OPENING = 1
local BOBOMB_BUDDY_CANNON_OPENED = 2
local BOBOMB_BUDDY_CANNON_STOP_TALKING = 3
--[[ oBobombBuddyHasTalkedToMario ]]
local BOBOMB_BUDDY_HAS_NOT_TALKED = 0
local BOBOMB_BUDDY_HAS_TALKED = 2


local sBobombHitbox = {
	InteractType =       INTERACT_GRABBABLE,
	downOffset =         0,
	DamageOrCoinValue =  0,
	health =             0,
	numLootCoins =       0,
	radius =             65,
	height =             113,
	HurtboxRadius =      0,
	HurtboxHeight =      0
}

local function bhv_bobomb_init(o)
	-- local o = ObjectListProcessor.gCurrentObject

	o.Gravity = 2.5
	o.Friction = 0.8
	o.Buoyancy = 1.3
	o.InteractionSubtype = INT_SUBTYPE_KICKABLE
end

local function bobomb_act_patrol(o)
	-- local o = ObjectListProcessor.gCurrentObject

	o.ForwardVel = 5.0

	local collisionFlags = object_step()
	if (obj_return_home_if_safe(o, o.HomeX, o.HomeY, o.HomeZ, 400) == 1)
		and (obj_check_if_facing_toward_angle(o.MoveAngleYaw, o.AngleToMario, 0x2000) == 1) then
		o.BobombFuseLit = 1
		o.Action = BOBOMB_ACT_CHASE_MARIO
	end
	obj_check_floor_death(collisionFlags, ObjBehaviors.sObjFloor)
end


local function bobomb_act_chase_mario(o)
	--local o = ObjectListProcessor.gCurrentObject

	local gMarioObject = ObjectListProcessor.gMarioObject

	o.AnimFrame += 1
	local sp1a = o.AnimFrame
	o.ForwardVel = 20.0

	local collisionFlags = object_step()

	if sp1a == 5 or sp1a == 16 then
		cur_obj_play_sound_2(o, SOUND_OBJ_BOBOMB_WALK)
	end

	obj_turn_toward_object(o, gMarioObject, 16, 0x800)
	obj_check_floor_death(collisionFlags, ObjBehaviors.sObjFloor)
end

local function bobomb_spawn_coin(o)
	--local o = ObjectListProcessor.gCurrentObject

	--  if ((o.BhvParams >> 8) & 0x1) == 0 then
	if bit32.band(bit32.rshift(o.BhvParams, 8), 0x1) == 0 then
		obj_spawn_yellow_coins(o, 1)
		o.BhvParams = 0x100
		ObjectListProcessor.set_object_respawn_info_bits(o, 1)
	end
end

local function bobomb_act_explode(o)
	--    local o = ObjectListProcessor.gCurrentObject

	if o.Timer < 5 then
		cur_obj_scale(o, 1.0 + o.Timer / 5.0)
	else
		local explosion = spawn_object(o, MODEL_EXPLOSION, 'bhvExplosion')
		explosion.GraphYOffset += 100.0

		bobomb_spawn_coin()
		create_respawner(MODEL_BLACK_BOBOMB, 'bhvBobomb', 3000)
		o.activeFlags = ACTIVE_FLAGS_DEACTIVATED --/ unload object
	end

end

local function bobomb_act_launched()
	--local o = ObjectListProcessor.gCurrentObject

	local collisionFlags = object_step()
	if bit32.band(collisionFlags, OBJ_COL_FLAG_GROUNDED) == OBJ_COL_FLAG_GROUNDED then
		-- if (collisionFlags & OBJ_COL_FLAG_GROUNDED) == OBJ_COL_FLAG_GROUNDED then
		o.Action = BOBOMB_ACT_EXPLODE
	end
end

local function bobomb_check_interactions(o)
	--local o = ObjectListProcessor.gCurrentObject
	local gMarioObject = ObjectListProcessor.gMarioObject

	obj_set_hitbox(o, sBobombHitbox)

	--if ((o.InteractStatus & INT_STATUS_INTERACTED) ~= 0) {
	if o.InteractStatus:Has(INT_STATUS_INTERACTED) then
		if o.InteractStatus:Has(INT_STATUS_MARIO_UNK1) then
			--      if ((o.InteractStatus & INT_STATUS_MARIO_UNK1) ~= 0) {
			warn('TODO: SET MOVE ANGLE')
			--o.MoveAngleYaw = gMarioObject.gfx.angle[1]
			o.ForwardVel = 25.0
			o.VelY = 30.0
			o.Action = BOBOMB_ACT_LAUNCHED
		end

		--if (o.InteractStatus & INT_STATUS_TOUCHED_BOB_OMB) ~= 0) then
		if o.InteractStatus:Has(INT_STATUS_TOUCHED_BOB_OMB) then
			o.Action = BOBOMB_ACT_EXPLODE
		end

		o.InteractStatus:Clear()
	end

	if obj_attack_collided_from_other_object(o) == 1 then
		o.Action = BOBOMB_ACT_EXPLODE
	end
end 


local function generic_bobomb_free_loop(o)
	--local o = ObjectListProcessor.gCurrentObject


	Util.Switch(o.Action, {
		[BOBOMB_ACT_PATROL] = function()
			bobomb_act_patrol(o)
		end,
		[BOBOMB_ACT_CHASE_MARIO] = function()
			bobomb_act_chase_mario(o)
		end,
		[BOBOMB_ACT_LAUNCHED] = function()
			bobomb_act_launched(o)
		end,
		[BOBOMB_ACT_EXPLODE] = function()
			bobomb_act_explode(o)
		end,
		none = function()
			error('unimplemented bobomb action - generic_bobomb_free_loop')
		end,
	})

	bobomb_check_interactions(o)

	if o.BobombFuseTimer >= 151 then
		o.Action = 3
	end
end

local function stationary_bobomb_free_loop(o)
	--local o = ObjectListProcessor.gCurrentObject

	Util.Switch (o.Action, {
		[BOBOMB_ACT_LAUNCHED] = function()
			bobomb_act_launched(o)
		end;

		[BOBOMB_ACT_EXPLODE] = function()
			bobomb_act_explode(o)
		end;

		[BOBOMB_ACT_LAVA_DEATH] = function()
			warn('BOBOMB_ACT_LAVA_DEATH')
			--/ if (obj_lava_death() == 1)
			--/     create_respawner(MODEL_BLACK_BOBOMB, bhvBobomb, 3000);
		end;

		[BOBOMB_ACT_DEATH_PLANE_DEATH] = function()
			warn('BOBOMB_ACT_DEATH_PLANE_DEATH')
			--/ o->activeFlags = ACTIVE_FLAG_DEACTIVATED;
			--/ create_respawner(MODEL_BLACK_BOBOMB, bhvBobomb, 3000);
		end;
	})

	bobomb_check_interactionso()

	if o.BobombFuseTimer >= 151 then
		o.Action = 3
	end
end


local function bobomb_free_loop(o)
	--local o = ObjectListProcessor.gCurrentObject

	if o.BhvParams2ndByte == BOBOMB_BP_STYPE_GENERIC then
		generic_bobomb_free_loop(o)

	else
		stationary_bobomb_free_loop(o)
	end
end

local function bobomb_held_loop(o)
	-- local o = ObjectListProcessor.gCurrentObject
	local gMarioObject = ObjectListProcessor.gMarioObject

	o.GfxFlags:Add(GRAPH_RENDER_INVISIBLE)
	cur_obj_init_animation(o, 1)
	cur_obj_set_pos_relative(o, gMarioObject, 0, 60.0, 100.0)

	o.BobombFuseLit = 1
	if o.BobombFuseTimer >= 151 then
		--/! Although the Bob-omb's action is set to explode when the fuse timer expires,
		--/  bobomb_act_explode() will not execute until the bob-omb's held state changes.
		--/  This allows the Bob-omb to be regrabbed indefinitely.
		gMarioObject.InteractStatus:Add(INT_STATUS_MARIO_DROP_OBJECT)
		o.Action = BOBOMB_ACT_EXPLODE
	end
end

local function bobomb_dropped_loop(o)
	-- local o = ObjectListProcessor.gCurrentObject
	cur_obj_get_dropped(o)

	o.GfxFlags:Remove(GRAPH_RENDER_INVISIBLE)
	cur_obj_init_animation(o, 0)

	o.HeldState = 0
	o.Action = BOBOMB_ACT_PATROL
end

local function bobomb_thrown_loop(o)
	-- local o = ObjectListProcessor.gCurrentObject
	cur_obj_enable_rendering(o)

	o.GfxFlags:Remove(GRAPH_RENDER_INVISIBLE)
	o.HeldState = 0
	o.Flags:Remove(0x8) --[[ bit 3 ]]
	o.ForwardVel = 25.0
	o.Velocity = Util.SetY(o.Velocity, 20.0)
	-- o.VelY = 20.0
	o.Action = BOBOMB_ACT_LAUNCHED
end

local function bhv_bobomb_loop(o)
	-- local o = ObjectListProcessor.gCurrentObject

	if is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 4000) ~= 0 then

		Util.Switch(o.HeldState, {
			[HELD_FREE] = function()
				bobomb_free_loop(o)
			end,

			[HELD_HELD] = function()
				bobomb_held_loop(o)
			end,

			[HELD_THROWN] = function()
				bobomb_thrown_loop(o)
			end,

			[HELD_DROPPED] = function()
				bobomb_dropped_loop(o)
			end,
		})

		curr_obj_random_blink(oBobombBlinkTimer)

		if o.BobombFuseLit == 1 then
			local dustPeriodMinus1
			if o.BobombFuseTimer >= 121 then
				dustPeriodMinus1 = 1
			else 
				dustPeriodMinus1 = 7
			end
				
			if bit32.band(dustPeriodMinus1, o.BobombFuseTimer) == 0 then
			--if (dustPeriodMinus1 & o.BobombFuseTimer) == 0 then
				spawn_object(o, MODEL_SMOKE, 'bhvBobombFuseSmoke')
			end

			cur_obj_play_sound_1(o, SOUND_AIR_BOBOMB_LIT_FUSE)

			o.BobombFuseTimer += 1
		end
	end
end

local function bhv_bobomb_fuse_smoke_init(o)
	-- local o = ObjectListProcessor.gCurrentObject

	o.Position.X += int32(math.random() * 80) - 40
	o.Position.Y += int32(math.random() * 80) + 60
	o.Position.Z += int32(math.random() * 80) - 40
	cur_obj_scale(o, 1.2)
end

local function bhv_dust_smoke_loop(o)
	--local o = ObjectListProcessor.gCurrentObject

	o.Position.X += o.VelX
	o.Position.Y += o.VelY
	o.Position.Z += o.VelZ

	if o.SmokeTimer == 10 then
		obj_mark_for_deletion(o)
	end

	o.SmokeTimer += 1
end

--/-= 1--= 1--= 1--= 1--= 1--= 1--= 1--= 1--= 1

local function bhv_bobomb_buddy_init(o)
	-- local o = ObjectListProcessor.gCurrentObject
	o.Gravity = 2.5
	o.Friction = 0.8
	o.Buoyancy = 1.3
	o.InteractionSubtype = INT_SUBTYPE_NPC
end

local function bobomb_buddy_act_idle(o)
	--local o = ObjectListProcessor.gCurrentObject
	local sp1a = o.AnimFrame

	o.BobombBuddyPosXCopy = o.Position.X
	o.BobombBuddyPosYCopy = o.Position.Y
	o.BobombBuddyPosZCopy = o.Position.Z

	object_step()

	if sp1a == 5 or sp1a == 16 then
		cur_obj_play_sound_2(o, SOUND_OBJ_BOBOMB_WALK)
	end

	if o.DistanceToMario < 1000.0 then
		o.MoveAngleYaw = approach_s16_symmetric(o.MoveAngleYaw, o.AngleToMario, 0x140)
	end

	if o.InteractStatus == INT_STATUS_INTERACTED then
		o.Action = BOBOMB_BUDDY_ACT_TURN_TO_TALK
	end		
end

--[[*
 * Function for the Bob-omb Buddy cannon guy.
 * dialogFirstText is the first dialogID called when Bob-omb Buddy
 * starts to talk to Mario to prepare the cannon(s) for him.
 * Then the camera goes to the nearest cannon, to play the "prepare cannon" cutscene
 * dialogSecondText is called after Bob-omb Buddy has the cannon(s) ready and
 * then tells Mario that is "Ready for blastoff".
 ]]
local function bobomb_buddy_cannon_dialog(dialogFirstText, dialogSecondText)
	--/ local o = ObjectListProc.gCurrentObject
	--/ local cannonClosed
	--/ local --[[s16]] buddyText, cutscene

	--/ switch (o.BobombBuddyCannonStatus) {
	--/     case BOBOMB_BUDDY_CANNON_UNOPENED =
	--/         buddyText = cutscene_object_with_dialog(CUTSCENE_DIALOG, o, dialogFirstText)
	--/         if (buddyText ~= 0) {
	--/             save_file_set_cannon_unlocked()
	--/             cannonClosed = cur_obj_nearest_object_with_behavior(bhvCannonClosed)
	--/             if (cannonClosed ~= 0)
	--/                 o.BobombBuddyCannonStatus = BOBOMB_BUDDY_CANNON_OPENING
	--/             else
	--/                 o.BobombBuddyCannonStatus = BOBOMB_BUDDY_CANNON_STOP_TALKING
	--/         }
	--/         break

	--/     case BOBOMB_BUDDY_CANNON_OPENING =
	--/         cannonClosed = cur_obj_nearest_object_with_behavior(bhvCannonClosed)
	--/         cutscene = cutscene_object(CUTSCENE_PREPARE_CANNON, cannonClosed)
	--/         if (cutscene == -1)
	--/             o.BobombBuddyCannonStatus = BOBOMB_BUDDY_CANNON_OPENED
	--/         break

	--/     case BOBOMB_BUDDY_CANNON_OPENED =
	--/         buddyText = cutscene_object_with_dialog(CUTSCENE_DIALOG, o, dialogSecondText)
	--/         if (buddyText ~= 0)
	--/             o.BobombBuddyCannonStatus = BOBOMB_BUDDY_CANNON_STOP_TALKING
	--/         break

	--/     case BOBOMB_BUDDY_CANNON_STOP_TALKING =
	--/         set_mario_npc_dialog(0)

	--/         o.activeFlags &= ~ACTIVE_FLAG_INITIATED_TIME_STOP
	--/         o.BobombBuddyHasTalkedToMario = BOBOMB_BUDDY_HAS_TALKED
	--/         o.InteractStatus = 0
	--/         o.Action = BOBOMB_BUDDY_ACT_IDLE
	--/         o.BobombBuddyCannonStatus = BOBOMB_BUDDY_CANNON_OPENED
	--/         break
	--/ }
end

local function bobomb_buddy_act_talk(o)
	-- local o = ObjectListProcessor.gCurrentObject

	--/ DEBUG
	o.BobombBuddyHasTalkedToMario = BOBOMB_BUDDY_HAS_TALKED
	o.InteractStatus = 0
	o.Action = BOBOMB_BUDDY_ACT_IDLE

	--/ if (set_mario_npc_dialog(1) == 2) {
	--/     o.activeFlags |= ACTIVE_FLAG_INITIATED_TIME_STOP

	--/     switch (o.BobombBuddyRole) {
	--/         case BOBOMB_BUDDY_ROLE_ADVICE =
	--/             if (cutscene_object_with_dialog(CUTSCENE_DIALOG, o, o.BhvParams2ndByte)
	--/                 ~= BOBOMB_BUDDY_BP_STYPE_GENERIC) {
	--/                 set_mario_npc_dialog(0)

	--/                 o.activeFlags &= ~ACTIVE_FLAG_INITIATED_TIME_STOP
	--/                 o.BobombBuddyHasTalkedToMario = BOBOMB_BUDDY_HAS_TALKED
	--/                 o.InteractStatus = 0
	--/                 o.Action = BOBOMB_BUDDY_ACT_IDLE
	--/             }
	--/             break

	--/         case BOBOMB_BUDDY_ROLE_CANNON =
	--/             if (gCurrCourseNum == COURSE_BOB)
	--/                 bobomb_buddy_cannon_dialog(DIALOG_004, DIALOG_105)
	--/             else
	--/                 bobomb_buddy_cannon_dialog(DIALOG_047, DIALOG_106)
	--/             break
	--/     }
	--/ }
end

local function bobomb_buddy_act_turn_to_talk(o)
	--local o = ObjectListProcessor.gCurrentObject
	local --[[s16]] sp1e = o.AnimFrame
	if (sp1e == 5) or (sp1e == 16) then
		cur_obj_play_sound_2(o, SOUND_OBJ_BOBOMB_WALK)
	end

	o.MoveAngleYaw = approach_s16_symmetric(o.MoveAngleYaw, o.AngleToMario, 0x1000)
	if math.floor(o.MoveAngleYaw) == math.floor(o.AngleToMario) then
		o.Action = BOBOMB_BUDDY_ACT_TALK
	end

	cur_obj_play_sound_2(o, SOUND_ACTION_READ_SIGN)
end

local function bobomb_buddy_actions()
	local o = ObjectListProcessor.gCurrentObject
	Util.Switch(o.Action, {
		[BOBOMB_BUDDY_ACT_IDLE] = function()
			bobomb_buddy_act_idle(0)
		end,

		[BOBOMB_BUDDY_ACT_TURN_TO_TALK] = function()
			bobomb_buddy_act_turn_to_talk(0)
		end,

		[BOBOMB_BUDDY_ACT_TALK] = function()
			bobomb_buddy_act_talk(0)
		end,
	})

	set_object_visibility(o, 3000)
end

local function bhv_bobomb_buddy_loop(o)
	-- local o = ObjectListProcessor.gCurrentObject
	bobomb_buddy_actions(o)

	curr_obj_random_blink(oBobombBuddyBlinkTimer)

	o.InteractStatus = 0
end

Behavior.bhv_bobomb_init = bhv_bobomb_init
Behavior.bhv_bobomb_loop = bhv_bobomb_loop
Behavior.bhv_bobomb_fuse_smoke_init = bhv_bobomb_fuse_smoke_init
Behavior.bhv_bobomb_buddy_init = bhv_bobomb_buddy_init
Behavior.bhv_bobomb_buddy_loop = bhv_bobomb_buddy_loop
Behavior.bhv_dust_smoke_loop = bhv_dust_smoke_loop

require(script.Parent).Register(Behavior)