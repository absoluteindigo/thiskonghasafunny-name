-- mushroom_1up.c.inc
local Behavior = {} -- this

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)

local ObjBehaviors = require(Object.ObjBehaviors)
local ObjBehaviors2 = require(Object.ObjBehaviors2)
local Constants = require(Object.ObjectConstants)
local Helpers = require(Object.ObjectHelpers)
local Models = require(Object.Models)
local BehaviorScripts = require(Object.BehaviorData.BehaviorScripts)

local sqr = Util.sqr
local sqrtf = Helpers.sqrtf

local oMoveAnglePitch, oGravity, oFriction, oBuoyancy = Constants.oMoveAnglePitch, Constants.oGravity, Constants.oFriction, Constants.oBuoyancy

local set_object_visibility, is_point_within_radius_of_mario, object_step = ObjBehaviors.set_object_visibility, ObjBehaviors.is_point_within_radius_of_mario, ObjBehaviors.object_step

local obj_turn_toward_object, approach_s16_symmetric = Helpers.obj_turn_toward_object, Helpers.approach_s16_symmetric

--[[ void bhv_1up_interact(void) {
     UNUSED s32 sp1C;

     if (obj_check_if_collided_with_object(o, gMarioObject) == 1) {
         play_sound(SOUND_GENERAL_COLLECT_1UP, gGlobalSoundSource);
         gMarioState.numLives += 1;
         o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
 #ifdef VERSION_SH
         queue_rumble_data(5, 80);
 #endif
     end
 end]]

function bhv_1up_common_init(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	o.MoveAnglePitch = -0x4000
	o.Gravity  = 3.0
	o.Friction = 1.0
	o.Buoyancy = 1.0
end

function bhv_1up_init(o)
	bhv_1up_common_init(o)
	     if o.BehParams2ndByte == 1 then
	         if not bit32.band(save_file_get_flags(), bit32.bor(SAVE_FLAG_HAVE_KEY_1, SAVE_FLAG_UNLOCKED_BASEMENT_DOOR)) ~= 0  then
	             o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
	         end
	     elseif o.BhvParams2ndByte == 2 then
	         if not (bit32.band(save_file_get_flags(), bit32.bor(SAVE_FLAG_HAVE_KEY_2, SAVE_FLAG_UNLOCKED_UPSTAIRS_DOOR)) ~= 0) then
	             o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
	         end
	     end
end

-- void
function one_up_loop_in_air(o)
	if o.Timer < 5 then
		o.Velocity = Util.SetY(o.Velocity, 40)
	else
		o.AngleVelPitch = -0x1000;
		o.MoveAnglePitch += o.AngleVelPitch;
		o.Velocity = Util.SetY(o.Velocity, Util.Coss(o.MoveAnglePitch) * 30 + 2)
		o.ForwardVel = -Util.Sins(o.MoveAnglePitch) * 30;
	end
end

-- void
warn('USING POSITION, is this accurate to gfx.pos?')
function pole_1up_move_towards_mario(o)
     --[[f32]] local sp34 = gMarioObject.Position.X - o.Position.X;
	--[[f32]] local sp30 = gMarioObject.Position.Y + 120 - o.Position.Y;
	--[[f32]] local sp2C = gMarioObject.Position.Z - o.Position.Z;
	--[[s16]] local sp2A = Util.Atan2s(sqrtf(sqr(sp34) + sqr(sp2C)), sp30);

     obj_turn_toward_object(o, gMarioObject, 16, 0x1000);
     o.MoveAnglePitch = approach_s16_symmetric(o.MoveAnglePitch, sp2A, 0x1000);
     o.VelY = Util.Sins(o.MoveAnglePitch) * 30;
     o.ForwardVel = Util.Coss(o.MoveAnglePitch) * 30;
     bhv_1up_interact(o);
 end

-- void
function one_up_move_away_from_mario(o, --[[s16]] sp1A)
     o.ForwardVel = 8;
     o.MoveAngleYaw = o.AngleToMario + 0x8000;
     bhv_1up_interact(o);
     if bit32.band(sp1A, 0x02) ~= 0 then
         o.Action = 2;
	end
	
     if not is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 3000) then
		o.Action = 2;
	end
 end

function bhv_1up_walking_loop(o)
	     object_step(o);

	Util.Switch(o.Action, {
		[0] = function(o)
			if o.Timer >= 17 then
				spawn_object(o, Models.NONE, BehaviorScripts.bhvSparkleSpawn);
			end

			if o.Timer == 0 then
				play_sound(SOUND_GENERAL2_1UP_APPEAR, gGlobalSoundSource);
			end
			one_up_loop_in_air(o);

			if o.Timer == 37 then
				cur_obj_become_tangible(o);
				o.Action = 1;
				o.ForwardVel = 2;
			end
		end,

		[1] = function(o)
			if o.Timer > 300 then
				o.Action = 2
			end

			bhv_1up_interact(o);
		end;

		[2] = function(o)
			obj_flicker_and_disappear(o, 30);
			bhv_1up_interact(o);
		end;
	})

	set_object_visibility(o, 3000);
end

function bhv_1up_running_away_loop(o)
	     --[[s16]] local sp26;

	     sp26 = object_step(o);
	Util.Switch(o.Action, {
		[0] = function(o)
			if o.Timer >= 18 then
				spawn_object(o, MODEL_NONE, bhvSparkleSpawn);
			end

			if o.Timer == 0 then
				play_sound(SOUND_GENERAL2_1UP_APPEAR, gGlobalSoundSource);
			end

			one_up_loop_in_air(o);

			if o.Timer == 37 then
				cur_obj_become_tangible(o);
				o.Action = 1;
				o.ForwardVel = 8;
			end
		end;

		[1] = function(o)
			spawn_object(o, MODEL_NONE, bhvSparkleSpawn);
			one_up_move_away_from_mario(o, sp26);
		end;

		[2] = function(o)
			obj_flicker_and_disappear(o, 30);
			bhv_1up_interact(o);
		end;
	})

	set_object_visibility(o, 3000);
end

function sliding_1up_move(o, void)
     --[[s16]] local sp1E;

     sp1E = object_step(o);
     if bit32.band(sp1E, 0x01) then
         o.ForwardVel += 25;
		o.Velocity = Util.SetY(o.Velocity, 0)
     else
         o.ForwardVel *= 0.98;
     end

     if o.ForwardVel > 40.0 then
		o.ForwardVel = 40
	end

     if not is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 5000) then
		o.Action = 2;
	end
 end

function bhv_1up_sliding_loop(o)
	    Util.Switch(o.Action, {
		[0] = function(o)
			set_object_visibility(o, 3000);
			if is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 1000) then
				o.Action = 1;
			end
		end;

		[1] = function(o)
			sliding_1up_move(o);
		end;

		[2] = function(o)
			obj_flicker_and_disappear(o, 30);
			bhv_1up_interact(o);
		end;
	}, o)

	     bhv_1up_interact(o);
	     spawn_object(o, MODEL_NONE, bhvSparkleSpawn);
end

function bhv_1up_loop(o)
	     bhv_1up_interact(o);
	     set_object_visibility(o, 3000)
end

function bhv_1up_jump_on_approach_loop(o)
	     --[[s16]] local sp26;

	Util.Switch(o.Action, {
		[0] = function()
			if is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 1000) then
				o.VelY = 40;
				o.Action = 1;
			end
		end;

		[1] = function()
			sp26 = object_step(o);
			one_up_move_away_from_mario(sp26);
			spawn_object(o, MODEL_NONE, bhvSparkleSpawn);
		end;

		[2] = function()
			sp26 = object_step(o);
			bhv_1up_interact(o);
			obj_flicker_and_disappear(o, 30);
		end;
	})

	set_object_visibility(o, 3000);
end

function bhv_1up_hidden_loop(o)
	--[[s16]] local sp26;
	Util.Switch(o.Action, {
		[0] = function()
			o.GfxFlags:Add(GRAPH_RENDER_INVISIBLE)
			if o['1UpHiddenUnkF4'] == o.BhvParams2ndByte then
				o.VelY = 40;
				o.Action = 3;
				o.GfxFlags:Remove(GRAPH_RENDER_INVISIBLE)
				play_sound(SOUND_GENERAL2_1UP_APPEAR, gGlobalSoundSource);
			end
		end;
		[1] = function()
			sp26 = object_step(o);
			one_up_move_away_from_mario(sp26);
			spawn_object(o, MODEL_NONE, bhvSparkleSpawn);
		end;
		[2] = function()
			sp26 = object_step(o);
			bhv_1up_interact(o);
			obj_flicker_and_disappear(o, 30);
		end;
		[3] = function()
			sp26 = object_step(o);
			if o.Timer >= 18 then
				spawn_object(o, MODEL_NONE, bhvSparkleSpawn);
			end

			one_up_loop_in_air(o);

			if o.Timer == 37 then
				cur_obj_become_tangible(o);
				o.Action = 1;
				o.ForwardVel = 8;
			end
		end,
	})
end

function bhv_1up_hidden_trigger_loop(o)
	if obj_check_if_collided_with_object(o, gMarioObject) == true then
        local hidden1Up = cur_obj_nearest_object_with_behavior(bhvHidden1Up)
        if hidden1Up ~= nil then
            hidden1Up.Hidden1UpNumTouchedTriggers += 1
        end

        o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
    end
end

function bhv_1up_hidden_in_pole_loop(o)
	-- UNUSED --[[s16]] sp26;
	warn('eh forget about it')
	     --[[Util.Switch(o.Action, {
	         [0] = function()
	             o.gfx.flags |= GRAPH_RENDER_INVISIBLE;
	             if (o['1UpHiddenUnkF4'] == o.BhvParams2ndByte) {
	                 o.VelY = 40;
	                 o.Action = 3;
	                 o.gfx.flags &= ~GRAPH_RENDER_INVISIBLE;
	                 play_sound(SOUND_GENERAL2_1UP_APPEAR, gGlobalSoundSource);
	             end
	            end;

	         [1] = function()
	             pole_1up_move_towards_mario();
	             sp26 = object_step(o);
	           e;

	         [3] = function()
	             sp26 = object_step(o);
	             if (o.Timer >= 18)
	                 spawn_object(o, MODEL_NONE, bhvSparkleSpawn);

	             one_up_loop_in_air();

	             if (o.Timer == 37) {
	                 cur_obj_become_tangible();
	                 o.Action = 1;
	                 o.ForwardVel = 10;
	             end
	             break;
	     end]]
end

--[[function bhv_1up_hidden_in_pole_trigger_loop()
	     struct Object *sp1C;

	     if (obj_check_if_collided_with_object(o, gMarioObject) == 1) {
	         sp1C = cur_obj_nearest_object_with_behavior(bhvHidden1upInPole);
	         if (sp1C != NULL) {
	             sp1C['1UpHiddenUnkF4'] += 1;
	         end

	         o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
	     end
end

function bhv_1up_hidden_in_pole_spawner_loop()
	     s8 sp2F;

	     if (is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 700)) {
	         spawn_object_relative(2, 0, 50, 0, o, MODEL_1UP, bhvHidden1upInPole);
	         for (sp2F = 0; sp2F < 2; sp2F += 1) {
	             spawn_object_relative(0, 0, sp2F * -200, 0, o, MODEL_NONE, bhvHidden1upInPoleTrigger);
	         end

	         o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
	     end
end]]

Behavior.bhv_1up_common_init = bhv_1up_common_init
Behavior.bhv_1up_hidden_in_pole_loop = bhv_1up_hidden_in_pole_loop
Behavior.bhv_1up_hidden_in_pole_spawner_loop = bhv_1up_hidden_in_pole_spawner_loop
Behavior.bhv_1up_hidden_in_pole_trigger_loop = bhv_1up_hidden_in_pole_trigger_loop
Behavior.bhv_1up_hidden_loop = bhv_1up_hidden_loop
Behavior.bhv_1up_hidden_trigger_loop = bhv_1up_hidden_trigger_loop
Behavior.bhv_1up_init = bhv_1up_init
Behavior.bhv_1up_jump_on_approach_loop = bhv_1up_jump_on_approach_loop
Behavior.bhv_1up_loop = bhv_1up_loop
Behavior.bhv_1up_running_away_loop = bhv_1up_running_away_loop
Behavior.bhv_1up_sliding_loop = bhv_1up_sliding_loop
Behavior.bhv_1up_walking_loop = bhv_1up_walking_loop

require(script.Parent).Register(Behavior)