local Behavior = {} -- this

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
local behaviors = require(Object.BehaviorData).BehaviorScripts
local SpawnObject = require(Object.SpawnObject)
local MODEL = require(Object.Models)

type Object = Types.ObjectState

local parseInt = math.floor

local INT_STATUS_INTERACTED = Enums.Interaction.Status.INTERACTED
local INT_STATUS_TOUCHED_BOB_OMB = Enums.Interaction.Status.TOUCHED_BOB_OMB

--[[import { ObjectListProcessorInstance as ObjectListProc } from "../ObjectListProcessor"
import { oCoinCollectedFlags, oBehParams, oAction, oDistanceToMario, oBehParams2ndByte, oTimer, oCoinOnGround, oVelX, oPosY, oVelZ, oFloorHeight, oAnimState, oInteractStatus, oPosX, oPosZ, oVelY, oCoinBaseVelY, oForwardVel, oMoveAngleYaw, oFloor, oMoveFlags, OBJ_MOVE_ON_GROUND, oSubAction, oBounciness, oDamageOrCoinValue, oBooDeathStatus, OBJ_MOVE_LANDED, OBJ_MOVE_ABOVE_DEATH_BARRIER, OBJ_MOVE_ABOVE_LAVA, OBJ_MOVE_BOUNCE, COIN_FORMATION_BP_FLAG_MASK, COIN_FORMATION_BP_LINE_HORIZONTAL, COIN_FORMATION_BP_LINE_VERTICAL, COIN_FORMATION_BP_RING_HORIZONTAL, COIN_FORMATION_BP_RING_VERTICAL, COIN_FORMATION_BP_ARROW } from "../../include/object_constants"
import {
    spawn_object_relative, cur_obj_set_behavior, cur_obj_update_floor_height, obj_mark_for_deletion,
    cur_obj_set_model, spawn_object, cur_obj_scale, cur_obj_become_intangible,
    cur_obj_update_floor_and_walls, cur_obj_if_hit_wall_bounce_away, cur_obj_move_standard,
    cur_obj_rotate_yaw_toward, cur_obj_become_tangible, cur_obj_wait_then_blink,
    cur_obj_call_action_function, obj_copy_pos, cur_obj_has_model, obj_set_hitbox
} from "../ObjectHelpers"
import { MODEL_YELLOW_COIN, MODEL_YELLOW_COIN_NO_SHADOW, MODEL_SPARKLES, MODEL_BLUE_COIN } from "../../include/model_ids"
import { INTERACT_COIN, INT_STATUS_INTERACTED, INT_STATUS_TOUCHED_BOB_OMB } from "../Interaction"
import { Util.Sins, Util.Coss, random_uint16 } from "../../utils"
import { atan2s } from "../../engine/math_util"
import { SOUND_GENERAL_COIN_DROP } from "../../include/sounds"
import { LEVEL_BBH } from "../../levels/level_defines_constants"
import { BOO_DEATH_STATUS_DYING } from "./boo.inc"
import { cur_obj_play_sound_2 } from "../SpawnSound"
]]
local sYellowCoinHitbox = {
	-- InteractType = INTERACT_COIN,
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

function bhv_coin_sparkles_init(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	--warn(INT_STATUS_INTERACTED)
	if o.InteractStatus:Has(INT_STATUS_INTERACTED) and not o.InteractStatus:Has(INT_STATUS_TOUCHED_BOB_OMB) then
		Helpers.spawn_object(o, MODEL.SPARKLES, behaviors.bhvGoldenCoinSparkles)
-- 		warn('SPAWN SPARKLEZZZ')
		Helpers.obj_mark_for_deletion(o)
		return true
	end

	o.InteractStatus:Clear()
	-- o.InteractStatus = 0
	return false
end

local function bhv_yellow_coin_init(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	Helpers.cur_obj_set_behavior(o, behaviors.bhvYellowCoin)
	Helpers.obj_set_hitbox(o, sYellowCoinHitbox)
	--/bhv_init_room()  TODO assign coin to specific room?
	Helpers.cur_obj_update_floor_height(o)
	if 500.0 < math.abs(o.Position.Y - o.FloorHeight) then
		Helpers.cur_obj_set_model(o, MODEL.YELLOW_COIN_NO_SHADOW)
		if (o.FloorHeight < -10000.0) then
			warn('why did it delete?!')
			Helpers.obj_mark_for_deletion(o)
		end
	end
end

local function bhv_yellow_coin_loop(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	bhv_coin_sparkles_init(o)
	o.AnimState += 1
end

--[[const bhv_temp_coin_loop()
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.AnimState += 1
    if (cur_obj_wait_then_blink(200, 20))
        obj_mark_for_deletion(o);
    bhv_coin_sparkles_init();
}]]

function bhv_coin_init(o)
	--const o = gLinker.ObjectListProcessor.gCurrentObject

	o.Velocity = Util.SetY(o.Velocity, math.random() * 10.0 + 30 + o.CoinBaseVelY)
	-- o.Velocity.Y = math.random() * 10.0 + 30 + o.CoinBaseVelY
	o.ForwardVel = math.random() * 10.0
	o.MoveAngleYaw = Util.random_uint16()
	Helpers.cur_obj_set_behavior(o, behaviors.bhvYellowCoin)
	Helpers.obj_set_hitbox(o, sYellowCoinHitbox)
	Helpers.cur_obj_become_intangible(o)
end

function bhv_coin_loop(o)
	--const o = gLinker.ObjectListProcessor.gCurrentObject

	Helpers.cur_obj_update_floor_and_walls(o)
	Helpers.cur_obj_if_hit_wall_bounce_away(o)
	Helpers.cur_obj_move_standard(o, -62)

	local sp1C = o.Floor
	if sp1C then
		if o.MoveFlags:Has(Constants.OBJ_MOVE_ON_GROUND) then

			o.SubAction = 1
		end

		if o.SubAction == 1 then
			o.Bounciness = 0

			if sp1C.normal.y < 0.9 then
				local sp1A = Util.Atan2s(sp1C.normal.z, sp1C.normal.x)
				Helpers.cur_obj_rotate_yaw_toward(o, sp1A, 0x400)
			end
		end
	end

	if o.Timer == 0 then
		SpawnSound.cur_obj_play_sound_2(o, Sounds.GENERAL_COIN_SPURT)
	end

	--/if (o.Timer == 0) play_sound()

	if o.Velocity.Y < 0 then

		Helpers.cur_obj_become_tangible(o)
	end

	if o.MoveFlags:Has(Constants.OBJ_MOVE_LANDED) then
		if o.MoveFlags:Has(Constants.OBJ_MOVE_ABOVE_DEATH_BARRIER, Constants.OBJ_MOVE_ABOVE_LAVA) then
			Helpers.obj_mark_for_deletion(o)
		end
	end

	if o.MoveFlags:Has(Constants.OBJ_MOVE_BOUNCE) then
		o.CoinNumBounceSoundPlayed = o.CoinNumBounceSoundPlayed or 0
		--#ifndef VERSION_JP
		if o.CoinNumBounceSoundPlayed < 5 then
			--#endif
			SpawnSound.cur_obj_play_sound_2(o, Sounds.GENERAL_COIN_DROP)
			--#ifndef VERSION_JP
		end
		o.CoinNumBounceSoundPlayed += 1
		--#endif
	end

	if Helpers.cur_obj_wait_then_blink(o, 400, 20) then

		Helpers.obj_mark_for_deletion(o)
	end

	bhv_coin_sparkles_init(o)
end

--[[const bhv_coin_formation_spawn_loop()
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.Timer == 0) {
        cur_obj_set_behavior(gLinker.behaviors.bhvYellowCoin)
        obj_set_hitbox(o, sYellowCoinHitbox)
        --/bhv_init_room()  TODO assign coin to specific room?
        if (o.CoinOnGround) {
            o.Position.Y += 300
            cur_obj_update_floor_height()
            if (o.Position.Y < o.FloorHeight || o.FloorHeight < -10000.0)
                obj_mark_for_deletion(o)
            else
                o.Position.Y = o.FloorHeight
        } else {
            cur_obj_update_floor_height()
            if (math.abs(o.Position.Y - o.FloorHeight) > 250)
                cur_obj_set_model(MODEL_YELLOW_COIN_NO_SHADOW)
        }
    } else {
        if (bhv_coin_sparkles_init())
            o.parentObj.CoinCollectedFlags |= 1 << o.BehParams2ndByte
        o.AnimState += 1
    }

    if (o.parentObj.Action == 2)
        obj_mark_for_deletion(o)
}]]

--[[local sCoinArrowPositions = [
    [ 0, -150 ],
    [ 0, -50 ],
    [ 0, 50 ],
    [ 0, 150 ],
    [ -50, 100 ],
    [ -100, 50 ],
    [ 50, 100 ],
    [ 100, 50 ],
] ]]

--[[const spawn_coin_in_formation = (coinIndex, coinFormationFlags) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const pos = [0, 0, 0]
    let setSpawner = true, onGround = true

    switch (coinFormationFlags & COIN_FORMATION_BP_FLAG_MASK) {
        case COIN_FORMATION_BP_LINE_HORIZONTAL:
            pos[2] = 160 * (coinIndex - 2)
            if (coinIndex > 4) setSpawner = false
            break
        case COIN_FORMATION_BP_LINE_VERTICAL:
            onGround = false;
            pos[1] = 160 * coinIndex * 0.8
            if (coinIndex > 4) setSpawner = false
            break
        case COIN_FORMATION_BP_RING_HORIZONTAL:
            pos[0] = Util.Sins(coinIndex << 13) * 300.0
            pos[2] = Util.Coss(coinIndex << 13) * 300.0
            break
        case COIN_FORMATION_BP_RING_VERTICAL:
            onGround = false;
            pos[0] = Util.Sins(coinIndex << 13) * 200.0
            pos[1] = Util.Coss(coinIndex << 13) * 200.0 + 200.0
            break
        case COIN_FORMATION_BP_ARROW:
            pos[0] = sCoinArrowPositions[coinIndex][0]
            pos[2] = sCoinArrowPositions[coinIndex][1]
            break
    }
    if (coinFormationFlags & 0x10) onGround = false;

    if (setSpawner) {
        const coinSpawner = spawn_object_relative(coinIndex, pos[0], pos[1], pos[2], o, MODEL_YELLOW_COIN, gLinker.behaviors.bhvCoinFormationSpawn)

        coinSpawner.CoinOnGround = onGround
    }
}]]

--[[const bhv_coin_formation_init()
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.CoinCollectedFlags = (o.BehParams >> 8) & 0xFF
}]]

--[[const bhv_coin_formation_loop()
    const o = gLinker.ObjectListProcessor.gCurrentObject

    switch (o.Action) {
        case 0:
            if (o.DistanceToMario < 2000) {
                for (let bitIndex = 0; bitIndex < 8; bitIndex += 1) {
                    if (!(o.CoinCollectedFlags & (1 << bitIndex)))
                        spawn_coin_in_formation(bitIndex, o.BehParams2ndByte)
                }
                o.Action += 1
            }
            break

        case 1:
            if (o.DistanceToMario > 2100) o.Action += 1
            break

        case 2:
            o.Action = 0
            break
    }

    ObjectListProc.set_object_respawn_info_bits(o, o.CoinCollectedFlags & 0xFF)
}]]

--[[const coin_inside_boo_act_1()
    const o = gLinker.ObjectListProcessor.gCurrentObject
    cur_obj_update_floor_and_walls()
    cur_obj_if_hit_wall_bounce_away()
    if (o.MoveFlags & OBJ_MOVE_BOUNCE)
        cur_obj_play_sound_2(SOUND_GENERAL_COIN_DROP)
    if (o.Timer > 90 || (o.MoveFlags & OBJ_MOVE_LANDED)) {
        obj_set_hitbox(o, sYellowCoinHitbox)
        cur_obj_become_tangible()
        cur_obj_set_behavior(gLinker.behaviors.bhvYellowCoin)
    }
    cur_obj_move_standard(-30)
    bhv_coin_sparkles_init()
    if (cur_obj_has_model(MODEL_BLUE_COIN))
        o.DamageOrCoinValue = 5
    if (cur_obj_wait_then_blink(400, 20))
        obj_mark_for_deletion(o);
}]]

--[[const coin_inside_boo_act_0()
    const o = gLinker.ObjectListProcessor.gCurrentObject
    let parent = o.parentObj
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    cur_obj_become_intangible();
    if (o.Timer == 0 && gLinker.Area.gCurrLevelNum == LEVEL_BBH) {
        cur_obj_set_model(MODEL_BLUE_COIN);
        cur_obj_scale(0.7);
    }
    obj_copy_pos(o, parent);
    if (parent.BooDeathStatus == BOO_DEATH_STATUS_DYING) {
        o.Action = 1;
        let sp26 = gMarioObject.MoveAngleYaw;
        let sp20 = 3.0;
        o.Velocity.X = Util.Sins(sp26) * sp20
        o.Velocity.Z = Util.Coss(sp26) * sp20
        o.Velocity.Y = 35.0
    }
}]]

-- const sCoinInsideBooActions = [ coin_inside_boo_act_0, coin_inside_boo_act_1 ]

--[[export const bhv_coin_inside_boo_loop()
    cur_obj_call_action_function(sCoinInsideBooActions);
}]]

local function bhv_coin_sparkles_loop(o)
	Helpers.cur_obj_scale(o, 0.6)
end

local function bhv_golden_coin_sparkles_loop(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	local sp24 = 30.0
	local sp2C = Helpers.spawn_object(o, MODEL.SPARKLES, behaviors.bhvCoinSparkles)
	--[[sp2C.Position.X += (math.random() * sp24) - (sp24 / 2)
	sp2C.Position.Z += (math.random() * sp24) - (sp24 / 2)]]
	sp2C.Position = Vector3.new(
		sp2C.Position.X + (math.random() * sp24) - (sp24 / 2),
		sp2C.Position.Y,
		sp2C.Position.Z + (math.random() * sp24) - (sp24 / 2)
	)
end

Behavior.bhv_coin_loop = bhv_coin_loop
Behavior.bhv_coin_formation_init = bhv_coin_formation_init
Behavior.bhv_coin_formation_loop = bhv_coin_formation_loop
Behavior.bhv_coin_formation_spawn_loop = bhv_coin_formation_spawn_loop
Behavior.bhv_yellow_coin_init = bhv_yellow_coin_init
Behavior.bhv_yellow_coin_loop = bhv_yellow_coin_loop
Behavior.bhv_golden_coin_sparkles_loop = bhv_golden_coin_sparkles_loop
Behavior.bhv_coin_sparkles_loop = bhv_coin_sparkles_loop
Behavior.bhv_coin_init = bhv_coin_init
Behavior.bhv_coin_inside_boo_loop = bhv_coin_inside_boo_loop

require(script.Parent).Register(Behavior)