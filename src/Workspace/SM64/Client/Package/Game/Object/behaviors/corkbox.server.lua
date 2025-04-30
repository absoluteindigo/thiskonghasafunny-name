local Behavior = {}

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)

local random_float = Util.random_float

local ObjectHelpers = require(Object.ObjectHelpers)
local SpawnObject = require(Object.SpawnObject)
local MODEL = require(Object.Models)
local ObjectConstants = require(Object.ObjectConstants)
local ObjectListProcessor = require(Object.ObjectListProcessor)
local GraphNodeConstats = require(Object.GraphNodeConstats)
local ObjBehaviors = require(Object.ObjBehaviors)

--[[import * as _Linker from "../../game/Linker"
import { spawn_object_abs_with_rot, spawn_object, cur_obj_scale } from "../ObjectHelpers"
import { ObjectListProcessorInstance as ObjectListProc } from "../ObjectListProcessor"
import { MODEL_NONE } from "../../include/model_ids"
import { oHomeX, oHomeY, oHomeZ, oBehParams, oRespawnerModelToRespawn, oRespawnerMinSpawnDist, oRespawnerBehaviorToRespawn, oPosX, oPosY, oPosZ, ACTIVE_FLAGS_DEACTIVATED } from "../../include/object_constants"
import { is_point_within_radius_of_mario } from "../ObjBehaviors"
import { bhvRespawner } from "../BehaviorData"]]

local function bhv_bobomb_bully_death_smoke_init(o)
    --const o = ObjectListProc.gCurrentObject
	
	o.Position = Util.SetY(o.Position, o.Position.Y - 300)
   --  o.Position.Y -= 300
    ObjectHelpers.cur_obj_scale(o, 10.0)
end

local function bhv_respawner_loop(o)
    -- const o = ObjectListProc.gCurrentObject

	if not ObjBehaviors.is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, o.RespawnerMinSpawnDist) then
        local spawnedObject = ObjectHelpers.spawn_object(o, o.RespawnerModelToRespawn, o.RespawnerBehaviorToRespawn)
        spawnedObject.BhvParams = o.BhvParams
		o.ActiveFlags:Set(ObjectConstants.ACTIVE_FLAGS_DEACTIVATED)
    end
end

local function bhv_bobomb_explosion_bubble_init(o)
    ObjectHelpers.obj_scale_xyz(o, 2.0, 2.0, 1.0);

    o.BobombExpBubGfxExpRateX = (random_float() * 2048.0) + 0x800
    o.BobombExpBubGfxExpRateY = (random_float() * 2048.0) + 0x800
    o.Timer = random_float() * 10.0
    o.VelY = random_float() * 4.0 + 4
end

local function bhv_bobomb_explosion_bubble_loop(o)
	local waterY = ObjectListProcessor.gMarioObject.WaterLevel -- gMarioStates[0].waterLevel;
	
	o.GfxScale = Util.SetX(o.GfxScale, Util.Sins(o.BobombExpBubGfxScaleFacX) * 0.5 + 2.0)
	-- o.GfxScale[0] = Util.Sins(o.BobombExpBubGfxScaleFacX) * 0.5 + 2.0;
	o.BobombExpBubGfxScaleFacX += o.BobombExpBubGfxExpRateX;

	o.GfxScale = Util.SetY(o.GfxScale, Util.Sins(o.BobombExpBubGfxScaleFacY) * 0.5 + 2.0)
	-- o.GfxScale[1] = Util.Sins(o.BobombExpBubGfxScaleFacY) * 0.5 + 2.0;
	o.BobombExpBubGfxScaleFacY += o.BobombExpBubGfxExpRateY;

	if o.Position.Y > waterY then
		o.ActiveFlags.Value = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED
		-- o->activeFlags = ACTIVE_FLAG_DEACTIVATED;
		o.Position = Util.SetY(o.Position, o.Position.Y + 5)
		-- o.PosY += 5.0;
        ObjectHelpers.spawn_object(o, MODEL.SMALL_WATER_SPLASH, 'bhvObjectWaterSplash');
    end

	if o.Timer > 60 then
		o.ActiveFlags.Value = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED
        -- o->activeFlags = ACTIVE_FLAG_DEACTIVATED;
    end
	
	o.Position = Util.SetY(o.Position, o.Position.Y + o.Velocity.Y)
    -- o.PosY += o.VelY;
    o.Timer += 1
end

local function create_respawner(o, model, behToSpawn, minSpawnDist)
    -- const o = ObjectListProc.gCurrentObject
	local respawner = ObjectHelpers.spawn_object_abs_with_rot(o, MODEL.NONE, 'bhvRespawner', o.Home.X, o.Home.Y, o.Home.Z, 0, 0, 0)

	respawner.BhvParams.Value = o.BhvParams.Value
    respawner.RespawnerModelToRespawn = model
    respawner.RespawnerMinSpawnDist = minSpawnDist
    respawner.RespawnerBehaviorToRespawn = behToSpawn
end

Behavior.bhv_bobomb_bully_death_smoke_init = bhv_bobomb_bully_death_smoke_init
Behavior.bhv_respawner_loop = bhv_respawner_loop
Behavior.bhv_bobomb_explosion_bubble_init = bhv_bobomb_explosion_bubble_init
Behavior.bhv_bobomb_explosion_bubble_loop = bhv_bobomb_explosion_bubble_loop

require(script.Parent).Register(Behavior)