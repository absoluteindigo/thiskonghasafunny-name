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
local obj_turn_toward_object, obj_attack_collided_from_other_object, cur_obj_scale, spawn_object, obj_mark_for_deletion, obj_set_hitbox, cur_obj_nearest_object_with_behavior, approach_s16_symmetric, cur_obj_init_animation, cur_obj_set_pos_relative, cur_obj_enable_rendering, cur_obj_get_dropped = Helpers.obj_turn_toward_object, Helpers.obj_attack_collided_from_other_object, Helpers.cur_obj_scale, Helpers.spawn_object, Helpers.obj_mark_for_deletion, Helpers.obj_set_hitbox, Helpers.cur_obj_nearest_object_with_behavior, Helpers.approach_s16_symmetric, Helpers.cur_obj_init_animation, Helpers.cur_obj_set_pos_relative, Helpers.cur_obj_enable_rendering, Helpers.cur_obj_get_dropped
local int32 = Util.int32
warn('int32')
-- import { int32 } from "../../utils"
warn('create_respawner MISSING')
function create_respawner(...) warn(...) end
-- import { create_respawner } from "./corkbox.inc"
local cur_obj_play_sound_1, cur_obj_play_sound_2 = SpawnSound.cur_obj_play_sound_1, SpawnSound.cur_obj_play_sound_2
local BOBOMB_ACT_LAUNCHED, ACTIVE_FLAGS_DEACTIVATED, BOBOMB_BP_STYPE_GENERIC, HELD_HELD, HELD_FREE, HELD_THROWN, HELD_DROPPED, BOBOMB_ACT_PATROL, BOBOMB_ACT_CHASE_MARIO, BOBOMB_ACT_EXPLODE, BOBOMB_ACT_LAVA_DEATH, BOBOMB_ACT_DEATH_PLANE_DEATH = Constants.BOBOMB_ACT_LAUNCHED, Constants.ACTIVE_FLAGS_DEACTIVATED, Constants.BOBOMB_BP_STYPE_GENERIC, Constants.HELD_HELD, Constants.HELD_FREE, Constants.HELD_THROWN, Constants.HELD_DROPPED, Constants.BOBOMB_ACT_PATROL, Constants.BOBOMB_ACT_CHASE_MARIO, Constants.BOBOMB_ACT_EXPLODE, Constants.BOBOMB_ACT_LAVA_DEATH, Constants.BOBOMB_ACT_DEATH_PLANE_DEATH
--import { INT_SUBTYPE_NPC, INT_SUBTYPE_KICKABLE, INTERACT_GRABBABLE, INT_STATUS_INTERACTED,
--INT_STATUS_MARIO_UNK1, INT_STATUS_TOUCHED_BOB_OMB, INT_STATUS_MARIO_DROP_OBJECT } from "../Interaction"
local MODEL_EXPLOSION, MODEL_BLACK_BOBOMB, MODEL_SMOKE = MODEL.EXPLOSION, MODEL.BLACK_BOBOMB, MODEL.SMOKE
-- import { OBJ_COL_FLAG_GROUNDED } from "../ObjBehaviors"
local GRAPH_RENDER_INVISIBLE = GraphNodeConstats.GRAPH_RENDER_INVISIBLE
local SOUND_OBJ_BOBOMB_WALK, SOUND_ACTION_READ_SIGN, SOUND_AIR_BOBOMB_LIT_FUSE = Sounds.OBJ_BOBOMB_WALK, Sounds.ACTION_READ_SIGN, Sounds.AIR_BOBOMB_LIT_FUSE

--[[ Bob-omb Buddy ]]
    --[[ oBehParams2ndByte ]]
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

export local function bhv_bobomb_init()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    o.Gravity = 2.5
    o.Friction = 0.8
    o.Buoyancy = 1.3
    o.InteractionSubtype = INT_SUBTYPE_KICKABLE
}

local function bobomb_act_patrol()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    o.ForwardVel = 5.0

    local collisionFlags = object_step()
    if ((obj_return_home_if_safe(o, o.HomeX, o.HomeY, o.HomeZ, 400) == 1)
        && (obj_check_if_facing_toward_angle(o.MoveAngleYaw, o.AngleToMario, 0x2000) == 1)) {
        o.BobombFuseLit = 1
        o.Action = BOBOMB_ACT_CHASE_MARIO
    }
    obj_check_floor_death(collisionFlags, sObjFloor)
}

local function bobomb_act_chase_mario()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    local gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    local sp1a = ++o.gfx.animInfo.animFrame
    o.ForwardVel = 20.0

    local collisionFlags = object_step()

    if (sp1a == 5 || sp1a == 16) {
       cur_obj_play_sound_2(SOUND_OBJ_BOBOMB_WALK)
    }

    obj_turn_toward_object(o, gMarioObject, 16, 0x800)
    obj_check_floor_death(collisionFlags, sObjFloor)
}

local function bobomb_spawn_coin()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (((o.BhvParams >> 8) & 0x1) == 0) {
        obj_spawn_yellow_coins(o, 1)
        o.BhvParams = 0x100
        gLinker.ObjectListProcessor.set_object_respawn_info_bits(o, 1)
    }
}

local function bobomb_act_explode()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.Timer < 5) {
        cur_obj_scale(1.0 + o.Timer / 5.0)
    } else {
        local explosion = spawn_object(o, MODEL_EXPLOSION, 'bhvExplosion')
        explosion.GraphYOffset += 100.0

        bobomb_spawn_coin()
        create_respawner(MODEL_BLACK_BOBOMB, 'bhvBobomb', 3000)
        o.activeFlags = ACTIVE_FLAGS_DEACTIVATED --/ unload object
    }

}

local function bobomb_act_launched()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    local collisionFlags = object_step()
    if ((collisionFlags & OBJ_COL_FLAG_GROUNDED) == OBJ_COL_FLAG_GROUNDED) {
        o.Action = BOBOMB_ACT_EXPLODE
    }
}

local function bobomb_check_interactions()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    local gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    obj_set_hitbox(o, sBobombHitbox)

    if ((o.InteractStatus & INT_STATUS_INTERACTED) != 0) {
        if ((o.InteractStatus & INT_STATUS_MARIO_UNK1) != 0) {
            o.MoveAngleYaw = gMarioObject.gfx.angle[1]
            o.ForwardVel = 25.0
            o.VelY = 30.0
            o.Action = BOBOMB_ACT_LAUNCHED
        }

        if ((o.InteractStatus & INT_STATUS_TOUCHED_BOB_OMB) != 0) {
            o.Action = BOBOMB_ACT_EXPLODE
        }

        o.InteractStatus = 0
    }

    if (obj_attack_collided_from_other_object(o) == 1) {
        o.Action = BOBOMB_ACT_EXPLODE
    }
}

local function generic_bobomb_free_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    switch (o.Action) {
        case BOBOMB_ACT_PATROL =
            bobomb_act_patrol()
            break
        case BOBOMB_ACT_CHASE_MARIO =
            bobomb_act_chase_mario()
            break
        case BOBOMB_ACT_LAUNCHED =
            bobomb_act_launched()
            break
        case BOBOMB_ACT_EXPLODE =
            bobomb_act_explode()
            break
        default = throw "unimplemented bobomb action - generic_bobomb_free_loop"
    }

    bobomb_check_interactions()

    if (o.BobombFuseTimer >= 151)
        o.Action = 3
}

local function stationary_bobomb_free_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    switch (o.Action) {
        case BOBOMB_ACT_LAUNCHED =
            bobomb_act_launched()
            break;

        case BOBOMB_ACT_EXPLODE =
            bobomb_act_explode()
            break;

        case BOBOMB_ACT_LAVA_DEATH =
            --/ if (obj_lava_death() == 1)
            --/     create_respawner(MODEL_BLACK_BOBOMB, bhvBobomb, 3000);
            break;

        case BOBOMB_ACT_DEATH_PLANE_DEATH =
            --/ o->activeFlags = ACTIVE_FLAG_DEACTIVATED;
            --/ create_respawner(MODEL_BLACK_BOBOMB, bhvBobomb, 3000);
            break;
    }

    bobomb_check_interactions()

    if (o.BobombFuseTimer >= 151)
        o.Action = 3
}

local function bobomb_free_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.BehParams2ndByte == BOBOMB_BP_STYPE_GENERIC) {
        generic_bobomb_free_loop()
    }
    else {
        stationary_bobomb_free_loop()
    }
}

local function bobomb_held_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    local gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    o.gfx.flags |= GRAPH_RENDER_INVISIBLE
    cur_obj_init_animation(1)
    cur_obj_set_pos_relative(gMarioObject, 0, 60.0, 100.0)

    o.BobombFuseLit = 1
    if (o.BobombFuseTimer >= 151) {
          --/! Although the Bob-omb's action is set to explode when the fuse timer expires,
          --/  bobomb_act_explode() will not execute until the bob-omb's held state changes.
          --/  This allows the Bob-omb to be regrabbed indefinitely.
        gMarioObject.InteractStatus |= INT_STATUS_MARIO_DROP_OBJECT
        o.Action = BOBOMB_ACT_EXPLODE
    }
}

local function bobomb_dropped_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    cur_obj_get_dropped()

    o.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
    cur_obj_init_animation(0)

    o.HeldState = 0
    o.Action = BOBOMB_ACT_PATROL
}

local function bobomb_thrown_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    cur_obj_enable_rendering()

    o.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
    o.HeldState = 0
    o.Flags &= ~0x8; --[[ bit 3 ]]
    o.ForwardVel = 25.0
    o.VelY = 20.0
    o.Action = BOBOMB_ACT_LAUNCHED
}

export local function bhv_bobomb_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, 4000) != 0) {

        switch (o.HeldState) {
            case HELD_FREE =
                bobomb_free_loop()
                break

            case HELD_HELD =
                bobomb_held_loop()
                break

            case HELD_THROWN =
                bobomb_thrown_loop()
                break

            case HELD_DROPPED =
                bobomb_dropped_loop()
                break
        }

        curr_obj_random_blink(oBobombBlinkTimer)

        if (o.BobombFuseLit == 1) {
            local dustPeriodMinus1
            if (o.BobombFuseTimer >= 121)
                dustPeriodMinus1 = 1
            else 
                dustPeriodMinus1 = 7

            if ((dustPeriodMinus1 & o.BobombFuseTimer) == 0) {
                spawn_object(o, MODEL_SMOKE, 'bhvBobombFuseSmoke')
            }

            cur_obj_play_sound_1(SOUND_AIR_BOBOMB_LIT_FUSE)

            o.BobombFuseTimer += 1
        }
    }
}

export local function bhv_bobomb_fuse_smoke_init()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    o.Position.X += int32(math.random() * 80) - 40
    o.Position.Y += int32(math.random() * 80) + 60
    o.Position.Z += int32(math.random() * 80) - 40
    cur_obj_scale(1.2)
}

export local function bhv_dust_smoke_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    o.Position.X += o.VelX
    o.Position.Y += o.VelY
    o.Position.Z += o.VelZ

    if (o.SmokeTimer == 10) {
        obj_mark_for_deletion(o)
    }

    o.SmokeTimer += 1
}

--/-= 1--= 1--= 1--= 1--= 1--= 1--= 1--= 1--= 1

local function bhv_bobomb_buddy_init()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    o.Gravity = 2.5
    o.Friction = 0.8
    o.Buoyancy = 1.3
    o.InteractionSubtype = INT_SUBTYPE_NPC
}

local function bobomb_buddy_act_idle()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    local sp1a = o.gfx.animInfo.animFrame

    o.BobombBuddyPosXCopy = o.Position.X
    o.BobombBuddyPosYCopy = o.Position.Y
    o.BobombBuddyPosZCopy = o.Position.Z

    object_step()

    if (sp1a == 5 || sp1a == 16) {
        cur_obj_play_sound_2(SOUND_OBJ_BOBOMB_WALK)
    }

    if (o.DistanceToMario < 1000.0)
        o.MoveAngleYaw = approach_s16_symmetric(o.MoveAngleYaw, o.AngleToMario, 0x140)

    if (o.InteractStatus == INT_STATUS_INTERACTED)
        o.Action = BOBOMB_BUDDY_ACT_TURN_TO_TALK
}

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
    --/         if (buddyText != 0) {
    --/             save_file_set_cannon_unlocked()
    --/             cannonClosed = cur_obj_nearest_object_with_behavior(bhvCannonClosed)
    --/             if (cannonClosed != 0)
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
    --/         if (buddyText != 0)
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
}

local function bobomb_buddy_act_talk()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    --/ DEBUG
    o.BobombBuddyHasTalkedToMario = BOBOMB_BUDDY_HAS_TALKED
    o.InteractStatus = 0
    o.Action = BOBOMB_BUDDY_ACT_IDLE

    --/ if (set_mario_npc_dialog(1) == 2) {
    --/     o.activeFlags |= ACTIVE_FLAG_INITIATED_TIME_STOP

    --/     switch (o.BobombBuddyRole) {
    --/         case BOBOMB_BUDDY_ROLE_ADVICE =
    --/             if (cutscene_object_with_dialog(CUTSCENE_DIALOG, o, o.BehParams2ndByte)
    --/                 != BOBOMB_BUDDY_BP_STYPE_GENERIC) {
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
}

local function bobomb_buddy_act_turn_to_talk()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    local --[[s16]] sp1e = o.gfx.animInfo.animFrame
    if ((sp1e == 5) || (sp1e == 16)) {
        cur_obj_play_sound_2(SOUND_OBJ_BOBOMB_WALK)
    }

    o.MoveAngleYaw = approach_s16_symmetric(o.MoveAngleYaw, o.AngleToMario, 0x1000)
    if (math.floor(o.MoveAngleYaw) == math.floor(o.AngleToMario)) {
        o.Action = BOBOMB_BUDDY_ACT_TALK
    }

    cur_obj_play_sound_2(SOUND_ACTION_READ_SIGN)
}

local function bobomb_buddy_actions()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    switch (o.Action) {
        case BOBOMB_BUDDY_ACT_IDLE =
            bobomb_buddy_act_idle()
            break

        case BOBOMB_BUDDY_ACT_TURN_TO_TALK =
            bobomb_buddy_act_turn_to_talk()
            break

        case BOBOMB_BUDDY_ACT_TALK =
            bobomb_buddy_act_talk()
            break
    }

    set_object_visibility(o, 3000)
}

local function bhv_bobomb_buddy_loop()
    local o = gLinker.ObjectListProcessor.gCurrentObject
    bobomb_buddy_actions()

    curr_obj_random_blink(oBobombBuddyBlinkTimer)

    o.InteractStatus = 0
}

gLinker.bhv_bobomb_init = bhv_bobomb_init
gLinker.bhv_bobomb_loop = bhv_bobomb_loop
gLinker.bhv_bobomb_fuse_smoke_init = bhv_bobomb_fuse_smoke_init
gLinker.bhv_bobomb_buddy_init = bhv_bobomb_buddy_init
gLinker.bhv_bobomb_buddy_loop = bhv_bobomb_buddy_loop
gLinker.bhv_dust_smoke_loop = bhv_dust_smoke_loop