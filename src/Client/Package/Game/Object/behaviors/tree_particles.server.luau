--[[import { MODEL.LEAVES, MODEL.WHITE_PARTICLE_DL } from "../../include/model_ids";
import { ACTIVE_PARTICLE_LEAF, oActiveParticleFlags, oAngleVelPitch, oAngleVelRoll, oFaceAnglePitch, oFaceAngleRoll, oFaceAngleYaw, oFloorHeight, oForwardVel, oMoveAngleYaw, oPosition.X, oPosition.Y, oPosition.Z, oTimer, oTreeSnowOrLeafUnkF4, oTreeSnowOrLeafUnkF8, oTreeSnowOrLeafUnkFC, oVelocity.Y } from "../../include/object_constants";
import {  } from "../../include/surface_terrains";
import { LEVEL_CCM, LEVEL_SL } from "../../levels/level_defines_constants";
import { , , ,  } from "../../utils";
import { AreaInstance as Area } from "../Area";
import { , , ,  } from "../ObjectHelpers"
]]

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local FFlags = require(Package.FFlags)
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
local behaviors = require(Object.BehaviorData).BehaviorScripts
local SpawnObject = require(Object.SpawnObject)
local MODEL = require(Object.Models)

local obj_mark_for_deletion = Helpers.obj_mark_for_deletion
local obj_scale_xyz = Helpers.obj_scale_xyz
local spawn_object = Helpers.spawn_object

local random_u16 = Util.random_u16
local random_float = Util.random_float

function bhv_tree_snow_or_leaf_loop(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;

	Helpers.cur_obj_update_floor_height(o);

	if o.Timer == 0 then
		o.AngleVelPitch = (random_float() - 0.5) * 0x1000;
		o.AngleVelRoll = (random_float() - 0.5) * 0x1000;
		o.TreeSnowOrLeafUnkF8 = 4;
		o.TreeSnowOrLeafUnkFC = random_float() * 0x400 + 0x400;
	end

	if o.Position.Y < o.FloorHeight then
		obj_mark_for_deletion(o);
	end
	if o.FloorHeight < FFlags.FLOOR_LOWER_LIMIT then
		obj_mark_for_deletion(o);
	end
	if o.Timer > 100 then
		obj_mark_for_deletion(o);
	end

	o.FaceAnglePitch += o.AngleVelPitch;
	o.FaceAngleRoll += o.AngleVelRoll;
	o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y + -3.0)

	if o.Velocity.Y < -8.0 then
		o.Velocity = Util.SetY(o.Velocity, -8.0)
	end

	if o.ForwardVel > 0 then
		o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y - 0.3)
	else
		o.ForwardVel = 0
	end
	
	o.Position = Vector3.new(
		o.Position.X + Util.Sins(o.MoveAngleYaw) * Util.Sins(o.TreeSnowOrLeafUnkF4) * o.TreeSnowOrLeafUnkF8,
		o.Position.Y + o.Velocity.Y,
		o.Position.Z + Util.Coss(o.MoveAngleYaw) * Util.Sins(o.TreeSnowOrLeafUnkF4) * o.TreeSnowOrLeafUnkF8
	)
	-- o.Position.X += Util.Sins(o.MoveAngleYaw) * Util.Sins(o.TreeSnowOrLeafUnkF4) * o.TreeSnowOrLeafUnkF8;
	-- o.Position.Z += Util.Coss(o.MoveAngleYaw) * Util.Sins(o.TreeSnowOrLeafUnkF4) * o.TreeSnowOrLeafUnkF8;
	o.TreeSnowOrLeafUnkF4 += o.TreeSnowOrLeafUnkFC;
	-- o.Position.Y += o.Velocity.Y;
end

warn('TODO: Area')
function bhv_snow_leaf_particle_spawn_init(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	-- const gMarioObject = gLinker.ObjectListProcessor.gMarioObject;
	local gMarioObject = ObjectListProcessor.gMarioObject

	local isSnow;

	gMarioObject.ActiveParticleFlags:Remove(Constants.ACTIVE_PARTICLE_LEAF)

	--[[if Area.gCurrLevelNum == LEVEL_CCM or Area.gCurrLevelNum == LEVEL_SL then
		isSnow = true;
	else
		isSnow = false;
	end]]

	if isSnow then
		if random_float() < 0.5 then
			local obj = spawn_object(o, MODEL.WHITE_PARTICLE_DL, 'bhvTreeSnow');
			obj_scale_xyz(obj, random_float(), random_float(), random_float());
			obj.MoveAngleYaw = random_u16();
			obj.ForwardVel = random_float() * 5.0;
			o.Velocity = Util.SetY(o.Velocity, random_float() * 15.0)
		end
	else
		if random_float() < 0.3 then
			local obj = spawn_object(o, MODEL.LEAVES, 'bhvTreeLeaf');
			local scale = random_float() * 3.0;
			obj_scale_xyz(obj, scale, scale, scale)
			obj.MoveAngleYaw = random_u16();
			obj.ForwardVel = random_float() * 5.0 + 5.0;
			o.Velocity = Util.SetY(o.Velocity, random_float() * 15.0)
			obj.FaceAnglePitch = random_u16();
			obj.FaceAngleRoll = random_u16();
			obj.FaceAngleYaw = random_u16();
		end
	end
end

require(script.Parent).Register {
	bhv_tree_snow_or_leaf_loop = bhv_tree_snow_or_leaf_loop,
	bhv_snow_leaf_particle_spawn_init = bhv_snow_leaf_particle_spawn_init,
}