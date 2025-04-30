local Behavior = {}

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local SOUND = require(Package.Sounds)
local Util = require(Package.Util)

local ObjectHelpers = require(Object.ObjectHelpers)
local SpawnObject = require(Object.SpawnObject)
local SpawnSound = require(Object.SpawnSound)
local MODEL = require(Object.Models)
local ObjectConstants = require(Object.ObjectConstants)
local GraphNodeConstats = require(Object.GraphNodeConstats)

local spawn_object = ObjectHelpers.spawn_object

--[[import { oTimer, oOpacity, oPosX, oPosZ, ACTIVE_FLAGS_DEACTIVATED, oPosY } from "../../include/object_constants"
import { cur_obj_scale, spawn_object } from "../ObjectHelpers"
import { MODEL_SMOKE } from "../../include/model_ids"
import { bhvBobombBullyDeathSmoke } from "../BehaviorData"
import { CameraInstance as Camera } from "../Camera"
import * as CAMERA from "../Camera"  --/ for constants]]

warn('TODO: camera shake')
local function bhv_explosion_init(o)

	--/TODO Sound Explosion
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	-- Camera.set_environmental_camera_shake(CAMERA.SHAKE_ENV_EXPLOSION)

	SpawnSound.create_sound_spawner(o, SOUND.GENERAL2_BOBOMB_EXPLOSION);
	o.Opacity = 255
end

local function bhv_explosion_loop(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	if o.Timer == 9 then
		--if (gLinker.SurfaceCollision.find_water_level(o.Position.X, o.Position.Z) > o.Position.Y) then
		if Util.GetWaterLevel(o.Position) > o.Position.Y then
			--/ TODO make bubbles
			for i = 0, 40 do -- (i = 0; i < 40; i++) {
				spawn_object(o, MODEL.WHITE_PARTICLE_SMALL, 'bhvBobombExplosionBubble');
			end
		else
			spawn_object(o, MODEL.SMOKE, 'bhvBobombBullyDeathSmoke')
		end

		o.ActiveFlags:Set(ObjectConstants.ACTIVE_FLAGS_DEACTIVATED)
	end

	o.Opacity -= 14

	ObjectHelpers.cur_obj_scale(o, o.Timer / 9.0  + 1.0)
end

Behavior.bhv_explosion_init = bhv_explosion_init
Behavior.bhv_explosion_loop = bhv_explosion_loop

require(script.Parent).Register(Behavior)