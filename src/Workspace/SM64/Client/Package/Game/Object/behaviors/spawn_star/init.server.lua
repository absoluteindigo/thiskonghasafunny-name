local Behavior = {} --/ 1 this

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)
local Enums = require(Package.Enums)
local Interaction = require(Package.Game.Interaction)
local Types = require(Package.Types)
local Sounds = require(Package.Sounds)

local ObjectListProcessor = require(Object.ObjectListProcessor)
local Helpers = require(Object.ObjectHelpers)
local ObjBehaviors =  require(Object.ObjBehaviors)
local ObjBhvs2 =  require(Object.ObjBehaviors2)
local Constants = require(Object.ObjectConstants)
local SpawnSound = require(Object.SpawnSound)
local behaviors = require(Object.BehaviorData).BehaviorScripts
local SpawnObject = require(Object.SpawnObject)
local SpawnSound = require(Object.SpawnSound)
local MODEL = require(Object.Models)
local GraphNodeConstats = require(Object.GraphNodeConstats)

type Object = Types.ObjectState

local parseInt = math.floor
local sqrtf = Helpers.sqrtf

local INT_STATUS_INTERACTED = Enums.Interaction.Status.INTERACTED
local INT_SUBTYPE_NO_EXIT = Enums.Interaction.Subtype.NO_EXIT
local INTERACT_STAR_OR_KEY = Enums.Interaction.Method.STAR_OR_KEY

local TIME_STOP_ENABLED, TIME_STOP_MARIO_AND_DOORS = ObjectListProcessor.TIME_STOP_ENABLED, ObjectListProcessor.TIME_STOP_MARIO_AND_DOORS

local oFaceAngleYaw, oInteractStatus, oBehParams, oBehParams2ndByte, oPosX, oPosY, oPosZ, oHomeX, oHomeZ, oHomeY, oFaceAnglePitch, oFaceAngleRoll, oMoveAngleYaw, oStarSpawnDisFromHome, oVelY, oForwardVel, oStarSpawnUnkFC, ACTIVE_FLAG_INITIATED_TIME_STOP, oAction, oTimer, oInteractionSubtype, ACTIVE_FLAG_DEACTIVATED, oHiddenStarTriggerCounter = Constants.oFaceAngleYaw, Constants.oInteractStatus, Constants.oBehParams, Constants.oBehParams2ndByte, Constants.oPosX, Constants.oPosY, Constants.oPosZ, Constants.oHomeX, Constants.oHomeZ, Constants.oHomeY, Constants.oFaceAnglePitch, Constants.oFaceAngleRoll, Constants.oMoveAngleYaw, Constants.oStarSpawnDisFromHome, Constants.oVelY, Constants.oForwardVel, Constants.oStarSpawnUnkFC, Constants.ACTIVE_FLAG_INITIATED_TIME_STOP, Constants.oAction, Constants.oTimer, Constants.oInteractionSubtype, Constants.ACTIVE_FLAG_DEACTIVATED, Constants.oHiddenStarTriggerCounter

function save_file_get_star_flags()
	warn('OH NOOO')
end
-- import { save_file_get_star_flags, } from "../SaveFile"
-- import { AreaInstance as Area } from "../Area"
local clear_time_stop_flags, cur_obj_become_intangible, cur_obj_become_tangible, obj_mark_for_deletion, set_time_stop_flags, spawn_object, spawn_object_abs_with_rot, obj_set_hitbox, count_objects_with_behavior, spawn_mist_particles = Helpers.clear_time_stop_flags, Helpers.cur_obj_become_intangible, Helpers.cur_obj_become_tangible, Helpers.obj_mark_for_deletion, Helpers.set_time_stop_flags, Helpers.spawn_object, Helpers.spawn_object_abs_with_rot, Helpers.obj_set_hitbox, Helpers.count_objects_with_behavior, Helpers.spawn_mist_particles
local atan2s, sqrtf = Util.Atan2s, Helpers.sqrtf

-- import { COURSE_BBH } from "../../include/course_table"
-- import { CUTSCENE_RED_COIN_STAR_SPAWN, CUTSCENE_STAR_SPAWN } from "../Camera"
-- import { CameraInstance as Camera } from "../Camera"
local obj_move_xyz_using_fvel_and_yaw = ObjBehaviors.obj_move_xyz_using_fvel_and_yaw
local cur_obj_play_sound_1, cur_obj_play_sound_2 = SpawnSound.cur_obj_play_sound_1, SpawnSound.cur_obj_play_sound_2

--import { COURSE_JRB } from "../../levels/course_defines"
-- import { IngameMenuInstance as IngameMenu } from "../IngameMenu"

local sCollectStarHitbox = {
	InteractType =      INTERACT_STAR_OR_KEY,
	downOffset =        0,
	DamageOrCoinValue = 0,
	health =            0,
	numLootCoins =      0,
	radius =            80,
	height =            50,
	HurtboxRadius =     0,
	HurtboxHeight =     0
}

local function bhv_collect_star_init(o)
	-- local o = ObjectListProc.gCurrentObject

	local starId
	local currentLevelStarFlags

	starId = bit32.band(bit32.rshift(o.BhvParams(), 24), 0xFF)
	
	warn('currentLevelStarFlags')
	local currentLevelStarFlags = 0
	-- currentLevelStarFlags = save_file_get_star_flags(gLinker.Area.gCurrSaveFileNum - 1, gLinker.gCurrCourseNum - 1)
	if bit32.band(currentLevelStarFlags, bit32.lshift(1, starId)) ~= 0 then
		o.Model:SetModel(MODEL.TRANSPARENT_STAR)
		-- o.gfx.sharedChild = Area.gLoadedGraphNodes[MODEL.TRANSPARENT_STAR]
	else
		o.Model:SetModel(MODEL.STAR)
		-- o.gfx.sharedChild = Area.gLoadedGraphNodes[MODEL.STAR]
	end

	obj_set_hitbox(o, sCollectStarHitbox)
end

local function bhv_collect_star_loop(o)
	-- local o = ObjectListProc.gCurrentObject
	o.FaceAngleYaw += 0x800

	if o.InteractStatus:Has(INT_STATUS_INTERACTED) then
		SpawnObject.mark_obj_for_deletion(o)
		o.InteractStatus:Clear()
	end
end

local function bhv_star_spawn_init(o)
	-- local o = ObjectListProc.gCurrentObject

	o.MoveAngleYaw = atan2s(o.Home.Z - o.Position.Z, o.Home.X - o.Position.X)
	o.StarSpawnDisFromHome = sqrtf((o.Home.X - o.Position.X) ^ 2 + (o.Home.Z - o.Position.Z) ^ 2)
	o.Velocity.Y = (o.Home.Y - o.Position.Y) / 30.0
	o.ForwardVel = o.StarSpawnDisFromHome / 30.0
	o.StarSpawnUnkFC = o.Position.Y
	
	print('TODO')
	--[[if o.BhvParams2ndByte == 0 or Area.gCurrCourseNum == COURSE_BBH then
		Camera.cutscene_object(CUTSCENE_STAR_SPAWN, o)
	else
		Camera.cutscene_object(CUTSCENE_RED_COIN_STAR_SPAWN, o)
	end]]

	set_time_stop_flags(bit32.bor(TIME_STOP_ENABLED, TIME_STOP_MARIO_AND_DOORS))
	o.ActiveFlags:Has(ACTIVE_FLAG_INITIATED_TIME_STOP)
	cur_obj_become_intangible(o)
end

local function bhv_star_spawn_loop(o)
	-- local o = ObjectListProc.gCurrentObject

	Util.Switch(o.Action, {

		[0] = function()
			o.FaceAngleYaw += 0x1000
			if o.Timer > 20 then
				o.Action = 1
			end
		end,

		[1] = function()
			obj_move_xyz_using_fvel_and_yaw(o)
			o.StarSpawnUnkFC += o.Velocity.Y
			o.Position.Y = o.StarSpawnUnkFC + Util.Sins((o.Timer * 0x8000) / 30) * 400.0
			o.FaceAngleYaw += 0x1000
			spawn_object(o, MODEL.NONE, 'bhvSparkleSpawn')
			cur_obj_play_sound_1(o, 'SOUND_ENV_STAR')
			if o.Timer == 30 then
				o.Action = 2
				o.ForwardVel = 0
				print('play power star jingle')
				--/ play_power_star_jingle(true)
			end
		end,

		[2] = function()
			if o.Timer < 20 then
				o.Velocity = Util.SetY(o.Velocity, 20 - o.Timer)
			else
				o.Velocity = Util.SetY(o.Velocity, -10)
			end

			spawn_object(o, MODEL.NONE, 'bhvSparkleSpawn')
			obj_move_xyz_using_fvel_and_yaw(o)
			o.FaceAngleYaw = o.FaceAngleYaw - o.Timer * 0x10 + 0x1000
			cur_obj_play_sound_1(o, 'SOUND_ENV_STAR')

			if o.Position.Y < o.Home.Y then
				cur_obj_play_sound_2(o, 'SOUND_GENERAL_STAR_APPEARS')
				cur_obj_become_tangible(o)
				o.Position.Y = o.Home.Y
				o.Action = 3
			end
		end,

		[3] = function()
			o.FaceAngleYaw += 0x800
			if o.Timer == 20 then
				-- Camera.gObjCutsceneDone = true
				clear_time_stop_flags(bit32.bor(TIME_STOP_ENABLED, TIME_STOP_MARIO_AND_DOORS))
				o.ActiveFlags:Remove(ACTIVE_FLAG_INITIATED_TIME_STOP)
			end

			if o.InteractStatus:Has(INT_STATUS_INTERACTED) then
				obj_mark_for_deletion(o)
				o.InteractStatus:Clear()
			end
		end,

	})
end

local function spawn_star(o, sp30, sp34, sp38, sp3C)
	-- local o = ObjectListProc.gCurrentObject

	sp30 = spawn_object_abs_with_rot(o, MODEL.STAR, 'bhvStarSpawnCoordinates', o.Position.X, o.Position.Y, o.Position.Z, 0, 0, 0)
	-- sp30.BhvParams = o.BhvParams
	sp30.BhvParams = Types.Flags.new()
	sp30.BhvParams.Value = o.BhvParams.Value
	
	sp30.Home.X = sp34
	sp30.Home.Y = sp38
	sp30.Home.Z = sp3C
	sp30.FaceAnglePitch = 0
	sp30.FaceAngleRoll = 0
	return sp30
end

local function spawn_default_star(homeX, homeY, homeZ)
	local star;
	star = spawn_star(star, homeX, homeY, homeZ)
	star.BhvParams2ndByte = 0
end

local function spawn_red_coin_cutscene_star(homeX, homeY, homeZ)
	local star;
	star = spawn_star(star, homeX, homeY, homeZ)
	star.BhvParams2ndByte = 1
end

local function spawn_no_exit_star(homeX, homeY, homeZ)
	local star;
	star = spawn_star(star, homeX, homeY, homeZ)
	star.BhvParams2ndByte = 1;
	star.InteractionSubtype:Add(INT_SUBTYPE_NO_EXIT);
	-- star.InteractionSubtype |= INT_SUBTYPE_NO_EXIT;
end

local function bhv_hidden_red_coin_star_init(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject;
	warn('bhvRedCoinStarMarker')
	--[[if Area.gCurrCourseNum ~= COURSE_JRB then
		spawn_object(o, MODEL.TRANSPARENT_STAR, 'bhvRedCoinStarMarker')
	end]]

	local count = count_objects_with_behavior('bhvRedCoin')

	if count == 0 then
		local star = spawn_object_abs_with_rot(o, 0, MODEL.STAR, 'bhvStar', o.Position.X, o.Position.Y, o.Position.Z, 0, 0, 0)

		-- star.BhvParams = o.BhvParams
		star.BhvParams = Types.Flags.new()
		star.BhvParams.Value = o.BhvParams.Value
		
		o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
	end

	o.HiddenStarTriggerCounter = 8 - count;
end

local function bhv_hidden_red_coin_star_loop(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject;
	
	warn('IngameMenu')
	-- IngameMenu.gRedCoinsCollected = o.HiddenStarTriggerCounter;

	Util.Switch(o.Action, {
		[0] = function()
			if o.HiddenStarTriggerCounter == 8 then
				o.Action = 1;
			end
		end;

		[1] = function()
			if o.Timer > 2 then
				spawn_red_coin_cutscene_star(o.Position.X, o.Position.Y, o.Position.Z)
				spawn_mist_particles(o);
				o.ActiveFlags.Value = ACTIVE_FLAG_DEACTIVATED;
			end
		end
	})
end

require(script.Parent).Register({
	bhv_collect_star_init = bhv_collect_star_init,
	bhv_collect_star_loop = bhv_collect_star_loop,
	bhv_star_spawn_init = bhv_star_spawn_init,
	bhv_star_spawn_loop = bhv_star_spawn_loop,
	bhv_hidden_red_coin_star_init = bhv_hidden_red_coin_star_init,
	bhv_hidden_red_coin_star_loop = bhv_hidden_red_coin_star_loop,
})