local Behavior = {}

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)
local Enums = require(Package.Enums)

local ObjectHelpers = require(Object.ObjectHelpers)
local SpawnObject = require(Object.SpawnObject)
local MODEL = require(Object.Models)
local ObjectConstants = require(Object.ObjectConstants)
local ObjectListProcessor = require(Object.ObjectListProcessor)
local GraphNodeConstats = require(Object.GraphNodeConstats)
local ObjBehaviors = require(Object.ObjBehaviors)
local BehaviorScripts = require(Object.BehaviorData.BehaviorScripts)

--[[] ]
import * as _Linker from "../../game/Linker"
import { ObjectListProcessorInstance as ObjectListProc } from "../ObjectListProcessor"
import { spawn_object, cur_obj_become_intangible, cur_obj_become_tangible, obj_set_hitbox } from "../ObjectHelpers"
import { MODEL_SPARKLES } from "../../include/model_ids"
import { oGravity, oFriction, oBuoyancy, oAction, MOV_YCOIN_ACT_IDLE, oTimer, MOV_YCOIN_ACT_BLINKING, MOV_YCOIN_ACT_LAVA_DEATH, MOV_YCOIN_ACT_DEATH_PLANE_DEATH, oInteractStatus } from "../../include/object_constants"
import { INTERACT_COIN, INT_STATUS_INTERACTED } from "../Interaction"
import { object_step, obj_check_floor_death, sObjFloor, obj_flicker_and_disappear } from "../ObjBehaviors"
--[[]]
local sMovingYellowCoinHitbox = {
	InteractType = Enums.Interaction.Method.COIN,
	downOffset = 0,
	DamageOrCoinValue = 1,
	health = 0,
	numLootCoins = 0,
	radius = 100,
	height = 64,
	HurtboxRadius = 0,
	HurtboxHeight = 0
}


local function coin_collected(o)
	-- local o = ObjectListProc.gCurrentObject
	ObjectHelpers.spawn_object(o, MODEL.SPARKLES, BehaviorScripts.bhvGoldenCoinSparkles)
	o.ActiveFlags:Clear()
end

local function bhv_moving_yellow_coin_init(o)
	-- local o = ObjectListProc.gCurrentObject

	o.Gravity = 3.0
	o.Friction = 1.0
	o.Buoyancy = 1.5

	ObjectHelpers.obj_set_hitbox(o, sMovingYellowCoinHitbox)
end

local function coin_step(o, collisionFlagsPtr)
	collisionFlagsPtr.value = ObjBehaviors.object_step(o)

	ObjBehaviors.obj_check_floor_death(o, collisionFlagsPtr.value, ObjBehaviors.sObjFloor)

	if bit32.band(collisionFlagsPtr.value, 0x1) ~= 0 and bit32.band(collisionFlagsPtr.value, 0x8) == 0 then
		-- if ((collisionFlagsPtr.value & 0x1) != 0 && (collisionFlagsPtr.value & 0x8) == 0) {
		--//cur_obj_play_sound_2(SOUND_GENERAL_COIN_DROP)
		return true
	end

	return false
end

local function moving_coin_flicker(o)
	-- local o = ObjectListProc.gCurrentObject
	coin_step(o, { value = 0 })
	ObjBehaviors.obj_flicker_and_disappear(o, 0)
end

local function bhv_moving_yellow_coin_loop(o)

	--local o = ObjectListProc.gCurrentObject

	Util.Switch(o.Action, {
		[ObjectConstants.MOV_YCOIN_ACT_IDLE] = function()
			coin_step(o, { value = 0 })

			if o.Timer < 10 then
				ObjectHelpers.cur_obj_become_intangible(o)
			else
				ObjectHelpers.cur_obj_become_tangible(o)
			end
			if o.Timer >= 301 then
				o.Action = 1
			end
		end,
		[ObjectConstants.MOV_YCOIN_ACT_BLINKING] = function()
			moving_coin_flicker(o)
		end,

		[ObjectConstants.MOV_YCOIN_ACT_LAVA_DEATH] = function()
			o.ActiveFlags.Value = 0
		end,

		[ObjectConstants.MOV_YCOIN_ACT_DEATH_PLANE_DEATH] = function()
			o.ActiveFlags.Value = 0
		end,

		none = function ()
			error("unimplemented case in bhv_moving_yellow_coin_loop ", o.Action)
		end,
	})
	
	if o.InteractStatus:Has(Enums.Interaction.Status.INTERACTED) then
	-- if bit32.band(o.InteractStatus, Enums.Interaction.Status.INTERACTED) ~= 0 then
		coin_collected(o)
		o.InteractStatus:Clear()
		-- o.InteractStatus = 0
	end

end

Behavior.bhv_moving_yellow_coin_init = bhv_moving_yellow_coin_init
Behavior.bhv_moving_yellow_coin_loop = bhv_moving_yellow_coin_loop

require(script.Parent).Register(Behavior)