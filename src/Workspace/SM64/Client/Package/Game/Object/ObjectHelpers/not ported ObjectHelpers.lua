local Package = script.Parent.Parent.Parent

if false then do

import {
    oAction, oPrevAction, oSubAction, oTimer, oFlags,
    oBhvParams, oBhvParams2ndByte,
    oAnimations, oAnimState, oActiveParticleFlags,
    oIntangibleTimer, oInteractionSubtype, oInteractStatus, oInteractType,
    oHealth, oHeldState,

    oPosX, oPosY, oPosZ,
    oHomeX, oHomeY, oHomeZ, oAngleToHome,
    oVelX, oVelY, oVelZ,
    oParentRelativePosX, oParentRelativePosY, oParentRelativePosZ,
    oGraphYOffset,

    oAngleVelPitch, oAngleVelRoll, oAngleVelYaw,
    oForwardVel, oForwardVelS32,
    oFaceAnglePitch, oFaceAngleRoll, oFaceAngleYaw,
    oDrawingDistance, oOpacity,

    oBounciness, oBuoyancy, oDragStrength, oFriction, oGravity,
    oCollisionDistance, oDamageOrCoinValue, oNumLootCoins,
    oMoveAnglePitch, oMoveAngleRoll, oMoveAngleYaw, oMoveFlags,
    oWallAngle, oWallHitboxRadius,

    oFloor, oFloorHeight, oFloorRoom, oFloorType, oRoom,
    oAngleToMario, oDistanceToMario,

    oDeathSound, oSoundStateID,
    oDialogResponse, oDialogState,

    oUnk1A8, oUnk94, oUnkBC, oUnkC0,

    oCoinBaseVelY,

    oPathedStartWaypoint, oPathedPrevWaypoint, oPathedPrevWaypointFlags, oPathedTargetPitch,
    oPathedTargetYaw,

    ACTIVE_FLAGS_DEACTIVATED, ACTIVE_FLAG_FAR_AWAY, ACTIVE_FLAG_IN_DIFFERENT_ROOM,
    ACTIVE_FLAG_UNK10, ACTIVE_FLAG_DITHERED_ALPHA, ACTIVE_FLAG_DEACTIVATED,

    OBJ_MOVE_ABOVE_DEATH_BARRIER, OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER, OBJ_MOVE_IN_AIR,
    OBJ_MOVE_ABOVE_LAVA, OBJ_MOVE_HIT_WALL, OBJ_MOVE_HIT_EDGE, OBJ_MOVE_ON_GROUND,
    OBJ_MOVE_AT_WATER_SURFACE, OBJ_MOVE_MASK_IN_WATER, OBJ_MOVE_LEAVING_WATER,
    OBJ_MOVE_ENTERED_WATER, OBJ_MOVE_MASK_ON_GROUND, OBJ_MOVE_UNDERWATER_ON_GROUND,
    OBJ_MOVE_LEFT_GROUND, OBJ_MOVE_UNDERWATER_OFF_GROUND, OBJ_MOVE_MASK_33,
    OBJ_MOVE_LANDED, O_PARENT_RELATIVE_POS_INDEX, O_MOVE_ANGLE_INDEX, OBJ_FLAG_HOLDABLE,

    HELD_FREE, HELD_HELD, HELD_THROWN, HELD_DROPPED, OBJ_MOVE_BOUNCE, DIALOG_STATUS_ENABLE_TIME_STOP, ACTIVE_FLAG_INITIATED_TIME_STOP, DIALOG_FLAG_TURN_TO_MARIO, DIALOG_STATUS_START_DIALOG, DIALOG_STATUS_STOP_DIALOG, DIALOG_FLAG_TIME_STOP_ENABLED, oKingBobombUnk88, DIALOG_STATUS_INTERRUPT, OBJ_FLAG_0020, OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM, O_FACE_ANGLE_INDEX, OBJ_FLAG_TRANSFORM_RELATIVE_TO_PARENT, OBJ_FLAG_30, oSmokeTimer, oToxBoxActionTable, oToxBoxActionStep, TOX_BOX_ACT_TABLE_END, oSparkleSpawnUnk1B0, DIALOG_FLAG_TEXT_RESPONSE, DIALOG_FLAG_TEXT_DEFAULT, DIALOG_STATUS_DISABLE_TIME_STOP
 } from "../include/ObjectConstants"

export const WATER_DROPLET_FLAG_RAND_ANGLE                = 0x02
export const WATER_DROPLET_FLAG_RAND_OFFSET_XZ            = 0x04 // Unused
export const WATER_DROPLET_FLAG_RAND_OFFSET_XYZ           = 0x08 // Unused
export const WATER_DROPLET_FLAG_SET_Y_TO_WATER_LEVEL      = 0x20
export const WATER_DROPLET_FLAG_RAND_ANGLE_INCR_PLUS_8000 = 0x40
export const WATER_DROPLET_FLAG_RAND_ANGLE_INCR           = 0x80 // Unused

const sBBHStairJiggleOffsets = [ -8, 8, -4, 4 ]
const sLevelsWithRooms = [LEVEL_BBH, LEVEL_CASTLE, LEVEL_HMC]

export const DebugPage = {
    DEBUG_PAGE_OBJECTINFO:       0,
    DEBUG_PAGE_CHECKSURFACEINFO: 1,
    DEBUG_PAGE_MAPINFO:          2,
    DEBUG_PAGE_STAGEINFO:        3,
    DEBUG_PAGE_EFFECTINFO:       4,
    DEBUG_PAGE_ENEMYINFO:        5,
}

export const WAYPOINT_FLAGS_END = -1
export const WAYPOINT_FLAGS_INITIALIZED = 0x8000
export const WAYPOINT_MASK_00FF = 0x00FF
export const WAYPOINT_FLAGS_PLATFORM_ON_TRACK_PAUSE = 3

export const PATH_NONE = 0
export const PATH_REACHED_END = -1
export const PATH_REACHED_WAYPOINT = 1

function Helpers.geo_update_projectile_pos_from_parent = (callContext, node, mtx) => {
    
    if (callContext == GEO_CONTEXT_RENDER) {
        local sp20 = new Array(4).fill(0).map(() => new Array(4).fill(0));
        local obj = GeoRenderer.gCurGraphNodeObject;

        if (obj.prevObj) {
            create_transformation_from_matrices(sp20, mtx, GeoRenderer.gCurGraphNodeCamera.matrixPtr);
            obj_update_pos_from_parent_transformation(sp20, obj.prevObj);
            obj_set_gfx_pos_from_pos(obj.prevObj);
        }
    }

    return nil;
}

function Helpers.geo_update_layer_transparency = (callerContext, node) => {
    const dl = []

    if (callerContext == GEO_CONTEXT_RENDER) {
        local obj = GeoRenderer.gCurGraphNodeObject.object

        if (GeoRenderer.gCurGraphNodeHeldObject) {
            obj = GeoRenderer.gCurGraphNodeHeldObject.object
        }

        const opacity = obj.Opacity

        if (opacity == 0xFF) {
            if (node.parameter == 20) {
                node.flags = 0x600 | (node.flags & 0xFF)
            } else {
                node.flags = 0x100 | (node.flags & 0xFF)
            }

            obj.AnimState = 0
        } else {
            if (node.parameter == 20) {
                node.flags = 0x600 | (node.flags & 0xFF)
            } else {
                node.flags = 0x500 | (node.flags & 0xFF)
            }

            obj.AnimState = 1

            if (opacity == 0 && gLinker.behaviors.bhvBowser == obj.behavior) {
                obj.AnimState = 2
            }

            if (node.parameter != 10) {
                if (obj.ActiveFlags & ACTIVE_FLAG_DITHERED_ALPHA) {
                    Gbi.gDPSetAlphaCompare(dl, G_AC_DITHER)
                }
            }
            // temp fix for vanish cap
            if (obj.behavior == gLinker.behaviors.bhvVanishCap) {
                Gbi.gDPSetAlphaCompare(dl, G_AC_DITHER)
            }
        }

        Gbi.gDPSetEnvColor(dl, 255, 255, 255, opacity)
        Gbi.gSPEndDisplayList(dl)
    }

    return dl
}

function Helpers.geo_switch_anim_state = (callerContext, node) => {
    if (callerContext == GEO_CONTEXT_RENDER) {
        local obj = GeoRenderer.gCurGraphNodeObject.object

        if (GeoRenderer.gCurGraphNodeHeldObject) {
            obj = GeoRenderer.gCurGraphNodeHeldObject.object
        }

        // if the case is greater than the number of cases, set to 0 to afunction Helpers.ove = rin=> g
        // the switch.
        if (obj.AnimState >= node.numCases) {
            obj.AnimState = 0
        }

        node.selectedCase = obj.AnimState
    }

    return nil
}

function Helpers.geo_switch_area = (callerContext, node) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject;

    if (callerContext == GEO_CONTEXT_RENDER) {
        if (gMarioObject == undefined) {
            node.selectedCase = 0
        } else {
            gLinker.ObjectListProcessor.gFindFloorIncludeSurfaceIntangible = true;

            const marioObj = gMarioObject

            const floorWrapper = {}
            const height = gLinker.SurfaceCollision.find_floor(marioObj.Position.X, marioObj.Position.Y, marioObj.Position.Z, floorWrapper)

            if (floorWrapper.floor) {
                gLinker.ObjectListProcessor.gMarioCurrentRoom = floorWrapper.floor.room
                local selectedRoom = floorWrapper.floor.room - 1

                if (selectedRoom >= 0) {
                    node.selectedCase = selectedRoom
                }
            }

        }
    } else {
        node.selectedCase = 0
    }

    return nil;
}

function Helpers.obj_update_pos_from_parent_transformation = (a0, a1) => {
    const spC = a1.ParentRelativePosX
    const sp8 = a1.ParentRelativePosY
    const sp4 = a1.ParentRelativePosZ

    a1.Position.X = spC * a0[0][0] + sp8 * a0[1][0] + sp4 * a0[2][0] + a0[3][0]
    a1.Position.Y = spC * a0[0][1] + sp8 * a0[1][1] + sp4 * a0[2][1] + a0[3][1]
    a1.Position.Z = spC * a0[0][2] + sp8 * a0[1][2] + sp4 * a0[2][2] + a0[3][2]
}

function Helpers.obj_apply_scale_to_matrix = (obj, dst, src) => {
    dst[0][0] = src[0][0] * obj.gfx.scale[0]
    dst[1][0] = src[1][0] * obj.gfx.scale[1]
    dst[2][0] = src[2][0] * obj.gfx.scale[2]
    dst[3][0] = src[3][0]

    dst[0][1] = src[0][1] * obj.gfx.scale[0]
    dst[1][1] = src[1][1] * obj.gfx.scale[1]
    dst[2][1] = src[2][1] * obj.gfx.scale[2]
    dst[3][1] = src[3][1]

    dst[0][2] = src[0][2] * obj.gfx.scale[0]
    dst[1][2] = src[1][2] * obj.gfx.scale[1]
    dst[2][2] = src[2][2] * obj.gfx.scale[2]
    dst[3][2] = src[3][2]

    dst[0][3] = src[0][3]
    dst[1][3] = src[1][3]
    dst[2][3] = src[2][3]
    dst[3][3] = src[3][3]
}


function Helpers.create_transformation_from_matrices = (a0, a1, a2) => {
    local spC, sp8, sp4

    spC = a2[3][0] * a2[0][0] + a2[3][1] * a2[0][1] + a2[3][2] * a2[0][2]
    sp8 = a2[3][0] * a2[1][0] + a2[3][1] * a2[1][1] + a2[3][2] * a2[1][2]
    sp4 = a2[3][0] * a2[2][0] + a2[3][1] * a2[2][1] + a2[3][2] * a2[2][2]

    a0[0][0] = a1[0][0] * a2[0][0] + a1[0][1] * a2[0][1] + a1[0][2] * a2[0][2]
    a0[0][1] = a1[0][0] * a2[1][0] + a1[0][1] * a2[1][1] + a1[0][2] * a2[1][2]
    a0[0][2] = a1[0][0] * a2[2][0] + a1[0][1] * a2[2][1] + a1[0][2] * a2[2][2]

    a0[1][0] = a1[1][0] * a2[0][0] + a1[1][1] * a2[0][1] + a1[1][2] * a2[0][2]
    a0[1][1] = a1[1][0] * a2[1][0] + a1[1][1] * a2[1][1] + a1[1][2] * a2[1][2]
    a0[1][2] = a1[1][0] * a2[2][0] + a1[1][1] * a2[2][1] + a1[1][2] * a2[2][2]

    a0[2][0] = a1[2][0] * a2[0][0] + a1[2][1] * a2[0][1] + a1[2][2] * a2[0][2]
    a0[2][1] = a1[2][0] * a2[1][0] + a1[2][1] * a2[1][1] + a1[2][2] * a2[1][2]
    a0[2][2] = a1[2][0] * a2[2][0] + a1[2][1] * a2[2][1] + a1[2][2] * a2[2][2]

    a0[3][0] = a1[3][0] * a2[0][0] + a1[3][1] * a2[0][1] + a1[3][2] * a2[0][2] - spC
    a0[3][1] = a1[3][0] * a2[1][0] + a1[3][1] * a2[1][1] + a1[3][2] * a2[1][2] - sp8
    a0[3][2] = a1[3][0] * a2[2][0] + a1[3][1] * a2[2][1] + a1[3][2] * a2[2][2] - sp4

    a0[0][3] = 0
    a0[1][3] = 0
    a0[2][3] = 0
    a0[3][3] = 1.0
}

function Helpers.obj_set_held_state = (obj, heldBehavior) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    obj.parentObj = o

    heldBehavior = gLinker.Spawn.get_bhv_script(heldBehavior)
    if (obj.Flags & OBJ_FLAG_HOLDABLE) {
        if (heldBehavior == gLinker.behaviors.bhvCarrySomething3) {
            obj.HeldState = HELD_HELD
        }

        if (heldBehavior == gLinker.behaviors.bhvCarrySomething5) {
            obj.HeldState = HELD_THROWN
        }

        if (heldBehavior == gLinker.behaviors.bhvCarrySomething4) {
            obj.HeldState = HELD_DROPPED
        }
    } else {
        obj.curBhvCommand = heldBehavior
        obj.bhvStackIndex = 0
    }
}

function Helpers.lateral_dist_between_objects(obj1: Object, obj2: Object)
    const dx = obj1.Position.X - obj2.Position.X
    const dz = obj1.Position.Z - obj2.Position.Z
    return math.sqrt(dx * dx + dz * dz)
}
function Helpers.dist_between_objects(obj1: Object, obj2: Object)
    const dx = obj1.Position.X - obj2.Position.X
    const dy = obj1.Position.Y - obj2.Position.Y
    const dz = obj1.Position.Z - obj2.Position.Z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
}

function Helpers.cur_obj_forward_vel_approach_upward = (target, increment) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    if (o.ForwardVel >= target) {
        o.ForwardVel = target
    } else {
        o.ForwardVel += increment
    }
}

function Helpers.approach_f32_signed = (valueWrapper, target, increment) => {
    local reachedTarget = false;

    valueWrapper.value += increment;

    if (increment >= 0.0) {
        if (valueWrapper.value > target) {
            valueWrapper.value = target;
            reachedTarget = true;
        }
    } else {
        if (valueWrapper.value < target) {
            valueWrapper.value = target;
            reachedTarget = true;
        }
    }

    return reachedTarget;
}

function Helpers.approach_f32_symmetric = (value, target, increment) => {
    local dist = target - value;

    if (dist >= 0.0) {
        if (dist > increment) value += increment;
        else value = target;
    } else {
        if (dist < -increment) value -= increment;
        else value = target;
    }
}

function Helpers.approach_s16_symmetric = (value, target, increment) =>{
    local dist = s16(target - value)

    if (dist >= 0) {
        if (dist > increment) value = s16(value + increment)
        else value = target
    } else {
        if (dist < -increment) value = s16(value - increment)
        else value = target
    }
}

function Helpers.Helpers.approach_symmetric = (value, target, increment) => {
    const dist = target - value

    if (dist >= 0) {
        if (dist > increment) {
            value += increment
        } else {
            value = target
        }
    } else {
        if (dist < -increment) {
            value -= increment
        } else {
            value = target
        }
    }

    return value
}

function Helpers.cur_obj_rotate_yaw_toward = (target, increment) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    const startYaw = parseInt(o.MoveAngleYaw)
    o.MoveAngleYaw = Helpers.approach_symmetric(o.MoveAngleYaw, target, increment)

    o.AngleVelYaw = parseInt(o.MoveAngleYaw - startYaw)
    if ((o.AngleVelYaw) == 0) {
        return true
    } else {
        return false
    }
}

function Helpers.obj_angle_to_object(obj1: Object, obj2: Object)
    const x1 = obj1.Position.X, z1 = obj1.Position.Z
    const x2 = obj2.Position.X, z2 = obj2.Position.Z

    return Util.Atan2s(z2 - z1, x2 - x1)
}

function Helpers.obj_turn_toward_object = (obj, target, angleIndex, turnAmount) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    local targetAngle, a, b, c, d
    switch (angleIndex) {
        case oMoveAnglePitch:
        case oFaceAnglePitch:
            a = target.Position.X - obj.Position.X
            c = target.Position.Z - obj.Position.Z
            a = math.sqrt(a * a + c * c)

            b = -obj.Position.Y
            d = -target.Position.Y

            targetAngle = Util.Atan2s(a, d - b)
            break

        case oMoveAngleYaw:
        case oFaceAngleYaw:
            a = obj.Position.Z
            c = target.Position.Z
            b = obj.Position.X
            d = target.Position.X
        
            targetAngle = Util.Atan2s(c - a, d - b)
            break
    }

    const startAngle = s16(o.rawData[angleIndex])
    o.rawData[angleIndex] = Helpers.approach_symmetric(startAngle, targetAngle, turnAmount)
    return targetAngle
}

function Helpers.obj_set_parent_relative_pos = (obj, relX, relY, relZ) => {
    obj.ParentRelativePosX = relX
    obj.ParentRelativePosY = relY
    obj.ParentRelativePosZ = relZ
}

function Helpers.obj_set_pos = (obj, x, y, z) => {
    obj.Position.X = x
    obj.Position.Y = y
    obj.Position.Z = z
}

function Helpers.obj_set_angle = (obj, pitch, yaw, roll) => {
    obj.FaceAnglePitch = pitch
    obj.FaceAngleYaw = yaw
    obj.FaceAngleRoll = roll

    obj.MoveAnglePitch = pitch
    obj.MoveAngleYaw = yaw
    obj.MoveAngleRoll = roll
}

function Helpers.spawn_object_abs_with_rot = (parent, model, behavior, x, y, z, rx, ry, rz) => {
    const newObj = spawn_object_at_origin(parent, model, behavior)
    obj_set_pos(newObj, x, y, z)
    obj_set_angle(newObj, rx, ry, rz)
    return newObj
}

function Helpers.spawn_object_rel_with_rot = (parent, model, behavior, x, y, z, p, w, r) => {
    local newObj = spawn_object_at_origin(parent, model, behavior);
    newObj.Flags |= OBJ_FLAG_TRANSFORM_RELATIVE_TO_PARENT;
    obj_set_parent_relative_pos(newObj, x, y, z);
    obj_set_angle(newObj, p, w, z);

    return newObj;
}

function Helpers.spawn_obj_with_transform_flags = (obj, model, behavior) => {
    local newObj = spawn_object_at_origin(obj, model, behavior);
    newObj.Flags |= OBJ_FLAG_0020 | OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM;

    return newObj;
}

function Helpers.spawn_water_droplet = (parent, params) => {
    local randomScale
    // allow getters
    if (params.call) {
        params = params()
    }
    const newObj = spawn_object(parent, params.model, params.behavior);

    if (params.flags & WATER_DROPLET_FLAG_RAND_ANGLE)
        newObj.MoveAngleYaw = random_int16()

    if (params.flags & WATER_DROPLET_FLAG_RAND_ANGLE_INCR_PLUS_8000)
        newObj.MoveAngleYaw = (int16)(newObj.MoveAngleYaw + 0x8000
                                + random_f32_around_zero(params.moveAngleRange))

    if (params.flags & WATER_DROPLET_FLAG_RAND_ANGLE_INCR)
        newObj.MoveAngleYaw =
            s16(newObj.MoveAngleYaw + random_f32_around_zero(params.moveAngleRange))

    if (params.flags & WATER_DROPLET_FLAG_SET_Y_TO_WATER_LEVEL)
        newObj.Position.Y = gLinker.SurfaceCollision.find_water_level(newObj.Position.X, newObj.Position.Z)

    if (params.flags & WATER_DROPLET_FLAG_RAND_OFFSET_XZ)
        obj_translate_xz_random(newObj, params.moveRange)

    if (params.flags & WATER_DROPLET_FLAG_RAND_OFFSET_XYZ)
        obj_translate_xyz_random(newObj, params.moveRange)

    newObj.ForwardVel = random_float() * params.randForwardVel[1] + params.randForwardVel[0]
    newObj.VelY = random_float() * params.randYVel[1] + params.randYVel[0]

    randomScale = random_float() * params.randSize[1] + params.randSize[0]
    obj_scale(newObj, randomScale)

    return newObj
}

function Helpers.spawn_object_at_origin = (parent, model, behavior) => {
    const obj = gLinker.Spawn.create_object(behavior)
    obj.parentObj = parent
    obj.gfx.areaIndex = parent.gfx.areaIndex
    obj.gfx.activeAreaIndex = parent.gfx.areaIndex

    geo_obj_init(obj.gfx, gLinker.Area.gLoadedGraphNodes[model], [0,0,0], [0,0,0])

    return obj
}

function Helpers.spawn_object = (parent, model, behavior) => {
    const obj = spawn_object_at_origin(parent, model, behavior)
    obj_copy_pos_and_angle(obj, parent)
    return obj
}

function Helpers.try_to_spawn_object = (offsetY, scale, parent, model, behavior) => {
    const obj = spawn_object(parent, model, behavior)
    obj.Position.Y += offsetY
    obj_scale(obj, scale)
    return obj
}

function Helpers.spawn_object_with_scale = (parent, model, behavior, scale) => {
    local obj = spawn_object_at_origin(parent, 0, model, behavior)

    obj_copy_pos_and_angle(obj, parent)
    obj_scale(obj, scale)

    return obj
}

const obj_build_relative_transform = (obj) => {
    obj_build_transform_from_pos_and_angle(obj, oParentRelativePosX /* Takes all XYZ */, oFaceAnglePitch, /* Takes all roll, pitch, yaw */)
    obj_translate_local(obj, oPosX, oParentRelativePosX)
}

function Helpers.spawn_object_relative = (behaviorParam, relativePosX, relativePosY, relativePosZ, parent, model, behavior) => {

    const obj = spawn_object_at_origin(parent, model, behavior)

    obj_copy_pos_and_angle(obj, parent)
    obj_set_parent_relative_pos(obj, relativePosX, relativePosY, relativePosZ)
    obj_build_relative_transform(obj)

    obj.BhvParams2ndByte = behaviorParam
    obj.BhvParams = (behaviorParam & 0xFF) << 16

    return obj
}


function Helpers.spawn_object_relative_with_scale = (behaviorParam, relativePosX, relativePosY, relativePosZ,
                                              scale, parent, model, behavior) => {
    const obj = spawn_object_relative(behaviorParam, relativePosX, relativePosY, relativePosZ,
                                               parent, model, behavior)
    obj_scale(obj, scale)
    return obj
}

function Helpers.cur_obj_move_using_vel = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.Position.X += o.VelX
    o.Position.Y += o.VelY
    o.Position.Z += o.VelZ
}

function Helpers.obj_copy_graph_y_offset = (dst, src) => {
    dst.GraphYOffset = src.GraphYOffset
}

function Helpers.obj_copy_pos_and_angle = (dst, src) => {
    obj_copy_pos(dst, src)
    obj_copy_angle(dst, src)
}

function Helpers.obj_copy_pos = (dst, src) => {
    dst.Position.X = src.Position.X
    dst.Position.Y = src.Position.Y
    dst.Position.Z = src.Position.Z
}

function Helpers.obj_copy_angle = (dst, src) => {
    dst.FaceAnglePitch = src.FaceAnglePitch
    dst.FaceAngleYaw = src.FaceAngleYaw
    dst.FaceAngleRoll = src.FaceAngleRoll

    dst.MoveAnglePitch = src.MoveAnglePitch
    dst.MoveAngleYaw = src.MoveAngleYaw
    dst.MoveAngleRoll = src.MoveAngleRoll
}

function Helpers.obj_set_gfx_pos_from_pos = (obj) => {
    obj.gfx.pos[0] = obj.Position.X
    obj.gfx.pos[1] = obj.Position.Y
    obj.gfx.pos[2] = obj.Position.Z
}

function Helpers.obj_init_animation = (obj, animIndex) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local anims = o.Animations;
    geo_obj_init_animation(obj.gfx, anims[animIndex])
}

function Helpers.linear_mtxf_mul_vec3f = (m, dst, v) => {
    for (local i = 0; i < 3; i++) {
        dst[i] = m[0][i] * v[0] + m[1][i] * v[1] + m[2][i] * v[2]
    }
}

function Helpers.linear_mtxf_transpose_mul_vec3f = (m, dst, v) => {
    for (local i = 0; i < 3; i++) {
        dst[i] = m[i][0] * v[0] + m[i][1] * v[1] + m[i][2] * v[2]
    }
}

function Helpers.obj_apply_scale_to_transform = (obj) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local scaleX = obj.gfx.scale[0]
    local scaleY = obj.gfx.scale[1]
    local scaleZ = obj.gfx.scale[2]

    obj.transform[0][0] *= scaleX
    obj.transform[0][1] *= scaleX
    obj.transform[0][2] *= scaleX

    obj.transform[1][0] *= scaleY
    obj.transform[1][1] *= scaleY
    obj.transform[1][2] *= scaleY

    obj.transform[2][0] *= scaleZ
    obj.transform[2][1] *= scaleZ
    obj.transform[2][2] *= scaleZ
}

function Helpers.obj_copy_scale = (dst, src) => {
    dst.gfx.scale[0] = src.gfx.scale[0]
    dst.gfx.scale[1] = src.gfx.scale[1]
    dst.gfx.scale[2] = src.gfx.scale[2]
}

function Helpers.obj_scale_xyz = (obj, xScale, yScale, zScale) => {
    obj.gfx.scale[0] = xScale
    obj.gfx.scale[1] = yScale
    obj.gfx.scale[2] = zScale
}

function Helpers.obj_scale = (obj, scale) => {
    obj.gfx.scale[0] = scale
    obj.gfx.scale[1] = scale
    obj.gfx.scale[2] = scale
}

function Helpers.cur_obj_scale = (scale) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.gfx.scale[0] = scale
    o.gfx.scale[1] = scale
    o.gfx.scale[2] = scale
}

function Helpers.cur_obj_init_animation = (animIndex) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const anims = o.Animations
    geo_obj_init_animation(o.gfx, anims[animIndex]);
}

function Helpers.cur_obj_init_animation_with_sound = (animIndex) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const anims = o.Animations
    geo_obj_init_animation(o.gfx, anims[animIndex])
    o.SoundStateID = animIndex
}

function Helpers.cur_obj_init_animation_with_accel_and_sound = (animIndex, accel) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const anims = o.Animations
    const animAccel = parseInt(accel * 65536.0)
    geo_obj_init_animation_accel(o.gfx, anims[animIndex], animAccel)
}

function Helpers.obj_init_animation_with_sound = (obj, animations, animIndex) => {
    obj.Animations = animations
    geo_obj_init_animation(obj.gfx, animations[animIndex])
    obj.SoundStateID = animIndex
}

function Helpers.cur_obj_enable_rendering_and_become_tangible = (obj) => {
    obj.gfx.flags |= GRAPH_RENDER_ACTIVE;
    obj.IntangibleTimer = 0;
}

function Helpers.cur_obj_enable_rendering = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.gfx.flags |= GRAPH_RENDER_ACTIVE
}

function Helpers.cur_obj_disable_rendering_and_become_intangible = (obj) => {
    obj.gfx.flags &= ~GRAPH_RENDER_ACTIVE;
    obj.IntangibleTimer = -1;
}

function Helpers.cur_obj_disable_rendering = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.gfx.flags &= ~GRAPH_RENDER_ACTIVE
}

function Helpers.cur_obj_unhide = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
}

function Helpers.cur_obj_hide = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.gfx.flags |= GRAPH_RENDER_INVISIBLE
}

function Helpers.cur_obj_set_pos_relative = (other, dleft, dy, dforward) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    const facingZ = coss(other.MoveAngleYaw)
    const facingX = sins(other.MoveAngleYaw)

    const dz = dforward * facingZ - dleft * facingX
    const dx = dforward * facingX + dleft * facingZ

    o.MoveAngleYaw = other.MoveAngleYaw

    o.Position.X = other.Position.X + dx
    o.Position.Y = other.Position.Y + dy
    o.Position.Z = other.Position.Z + dz
}

function Helpers.cur_obj_set_pos_relative_to_parent = (dleft, dy, dforward) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    cur_obj_set_pos_relative(o.parentObj, dleft, dy, dforward);
}

function Helpers.obj_set_face_angle_to_move_angle = (obj) => {
    obj.FaceAnglePitch = obj.MoveAnglePitch
    obj.FaceAngleYaw = obj.MoveAngleYaw
    obj.FaceAngleRoll = obj.MoveAngleRoll
}

function Helpers.get_object_list_from_behavior = (behavior) => {
    behavior = gLinker.Spawn.get_bhv_script(behavior)
    return gLinker.Spawn.get_bhv_object_list(behavior)
}

function Helpers.cur_obj_nearest_object_with_behavior = (o, behavior) => {
    return cur_obj_find_nearest_object_with_behavior(o, behavior)
}

function Helpers.cur_obj_dist_to_nearest_object_with_behavior = (behavior) => {
    local dist = {}
    local obj = cur_obj_find_nearest_object_with_behavior(behavior, dist)
    if (!obj) {
        dist.dist = 15000.0
    }

    return dist.dist
}

function Helpers.cur_obj_find_nearest_object_with_behavior = (o, behavior, dist) => {
    local closestObj = nil
    local listHead = gLinker.ObjectListProcessor.gObjectLists[get_object_list_from_behavior(behavior)]
    local minDist = 0x20000
    local obj

    obj = listHead.next

    while (obj != listHead) {
        if (obj.behavior == behavior) {
            if (obj.ActiveFlags != ACTIVE_FLAG_DEACTIVATED && obj != o) {
                local objDist = dist_between_objects(o, obj)
                if (objDist < minDist) {
                    closestObj = obj
                    minDist = objDist
                }
            }
        }
        obj = obj.next
    }

    if (dist) {
        dist.dist = minDist
    }
    return closestObj
}

function Helpers.find_unimportant_object = () => {
    local listHead = gLinker.ObjectListProcessor.gObjectLists[OBJ_LIST_UNIMPORTANT]
    local obj = listHead.next

    if (listHead == obj) {
        obj = nil
    }

    return obj
}

function Helpers.count_unimportant_objects = () => {
    local listHead = gLinker.ObjectListProcessor.gObjectLists[OBJ_LIST_UNIMPORTANT]
    local obj = listHead.next
    local count = 0

    while (listHead != obj) {
        count++
        obj = obj.next
    }

    return count
}

function Helpers.count_objects_with_behavior = (behavior) => {
    local listHead = gLinker.ObjectListProcessor.gObjectLists[get_object_list_from_behavior(behavior)]
    local obj = listHead.next
    local count = 0

    while (listHead != obj) {
        if (obj.behavior == behavior) {
            count++
        }

        obj = obj.next
    }

    return count
}

function Helpers.cur_obj_find_nearby_held_actor = (behavior, maxDist) => {
    local listHead
    local obj
    local foundObj

    listHead = gLinker.ObjectListProcessor.gObjectLists[OBJ_LIST_GENACTOR]
    obj = listHead.next
    foundObj = nil

    while (listHead != obj) {
        if (obj.behavior == behavior) {
            if (obj.ActiveFlags != ACTIVE_FLAG_DEACTIVATED) {
                  // This includes the dropped and thrown states. By combining instant
                  // release, this allows us to activate mama penguin remotely
                if (obj.HeldState != HELD_FREE) {
                    if (dist_between_objects(o, obj) < maxDist) {
                        foundObj = obj
                        break
                    }
                }
            }
        }

        obj = obj.next
    }

    return foundObj
}

const cur_obj_reset_timer_and_subaction = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.Timer = 0
    o.SubAction = 0
}

function Helpers.cur_obj_change_action = (action) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    o.Action = action
    o.PrevAction = action
    cur_obj_reset_timer_and_subaction()
}

function Helpers.cur_obj_set_vel_from_mario_vel = (objBaseForwardVel, multiplier) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject
    local /*f32*/ marioForwardVel = gMarioObject.ForwardVel
    local /*f32*/ objForwardVel = objBaseForwardVel * multiplier

    if (marioForwardVel < objForwardVel) {
        o.ForwardVel = objForwardVel
    } else {
        o.ForwardVel = marioForwardVel * multiplier
    }
}

function Helpers.cur_obj_reverse_animation = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    if (o.gfx.animInfo.animFrame >= 0) {
        o.gfx.animInfo.animFrame--
    }
}

function Helpers.cur_obj_extend_animation_if_at_end = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    const sp4 = o.gfx.animInfo.animFrame
    const sp0 = o.gfx.animInfo.curAnim.unk08 - 2

    if (sp4 == sp0) {
        o.gfx.animInfo.animFrame--
    }
}


function Helpers.cur_obj_check_if_near_animation_end = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    local animFlags = o.gfx.animInfo.curAnim.flags
    local animFrame = o.gfx.animInfo.animFrame
    local nearLoopEnd = o.gfx.animInfo.curAnim.unk08 - 2
    local isNearEnd = 0

    if (animFlags & ANIM_FLAG_NOLOOP && nearLoopEnd + 1 == animFrame) {
        isNearEnd = 1
    }

    if (animFrame == nearLoopEnd) {
        isNearEnd = 1
    }

    return isNearEnd
}

function Helpers.cur_obj_check_if_at_animation_end = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    local animFrame = o.gfx.animInfo.animFrame
    local lastFrame = o.gfx.animInfo.curAnim.unk08 - 1

    if (animFrame == lastFrame) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_check_anim_frame = (frame) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    const animFrame = o.gfx.animInfo.animFrame
    if (animFrame == frame) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_check_anim_frame_in_range = (startFrame, rangeLength) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    local /*s32*/ animFrame = o.gfx.animInfo.animFrame

    if (animFrame >= startFrame && animFrame < startFrame + rangeLength) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_check_frame_prior_current_frame = (wrapper) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    local animFrame = o.gfx.animInfo.animFrame

    while (wrapper.current != -1) {
        if (wrapper.current == animFrame) {
            return true
        }

        wrapper.current++;
    }

    return false;
}

function Helpers.mario_is_in_air_action = () => {
    const gMarioStates = [ gLinker.LevelUpdate.gMarioState ]
    if (gMarioStates[0].action & ACT_FLAG_AIR) {
        return true;
    } else {
        return false;
    }
}

function Helpers.mario_is_dive_sliding = () => {
    if (gLinker.LevelUpdate.gMarioState.action == ACT_DIVE_SLIDE) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_set_y_vel_and_animation = (velY, animIndex) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.VelY = velY
    cur_obj_init_animation_with_sound(animIndex)
}

function Helpers.cur_obj_unrender_set_action_and_anim = (animIndex, action) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    cur_obj_become_intangible();
    cur_obj_disable_rendering();

    // only set animation if non-negative value
    if (animIndex >= 0) {
        cur_obj_init_animation_with_sound(animIndex);
    }

    o.Action = action;
}

const cur_obj_move_after_thrown_or_dropped = (forwardVel, velY) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    o.MoveFlags = 0
    o.FloorHeight = gLinker.SurfaceCollision.find_floor_height(o.Position.X, o.Position.Y + 160.0, o.Position.Z)

    if (o.FloorHeight > o.Position.Y) {
        o.Position.Y = o.FloorHeight
    } else if (o.FloorHeight < -10000.0) {
        //! OoB failsafe
        obj_copy_pos(o, gMarioObject)
        o.FloorHeight = gLinker.SurfaceCollision.find_floor_height(o.Position.X, o.Position.Y, o.Position.Z)
    }

    o.ForwardVel = forwardVel
    o.VelY = velY

    if (o.ForwardVel != 0) {
        cur_obj_move_y(/*gravity*/ -4.0, /*bounciness*/ -0.1, /*buoyancy*/ 2.0)
    }
}

function Helpers.cur_obj_get_thrown_or_placed = (forwardVel, velY, thrownAction) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.behavior == gLinker.behaviors.bhvBowser) {
          // Interestingly, when bowser is thrown, he is offset slightly to
          // Mario's right
        cur_obj_set_pos_relative_to_parent(-41.684, 85.859, 321.577)
    }

    cur_obj_become_tangible()
    cur_obj_enable_rendering()

    o.HeldState = HELD_FREE

    if ((o.InteractionSubtype & INT_SUBTYPE_HOLDABLE_NPC) || forwardVel == 0.0) {
        cur_obj_move_after_thrown_or_dropped(0.0, 0.0)
    } else {
        o.Action = thrownAction
        cur_obj_move_after_thrown_or_dropped(forwardVel, velY)
    }
}

function Helpers.cur_obj_get_dropped = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    cur_obj_become_tangible()
    cur_obj_enable_rendering()

    o.HeldState = HELD_FREE
    cur_obj_move_after_thrown_or_dropped(0.0, 0.0)
}

function Helpers.cur_obj_set_model = (modelID) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.gfx.sharedChild = gLinker.Area.gLoadedGraphNodes[modelID]
}

function Helpers.mario_set_flag = (flag) => {
    const gMarioStates = [ gLinker.LevelUpdate.gMarioState ]

    gMarioStates[0].flags |= flag;
}

function Helpers.cur_obj_clear_interact_status_flag = (flag) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    if (o.InteractStatus & flag) {
        o.InteractStatus &= flag ^ ~(0)
        return true
    }
    return false
}

function Helpers.obj_mark_for_deletion = (obj) => {
    obj.ActiveFlags = ACTIVE_FLAGS_DEACTIVATED
}

function Helpers.cur_obj_disable = () => {
    cur_obj_disable_rendering();
    cur_obj_hide();
    cur_obj_become_intangible();
}

function Helpers.cur_obj_become_intangible = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.IntangibleTimer = -1
}

function Helpers.cur_obj_become_tangible = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.IntangibleTimer = 0
}

function Helpers.obj_become_tangible = (obj) => {
    obj.IntangibleTimer = 0
}

function Helpers.cur_obj_update_floor_height = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.FloorHeight = gLinker.SurfaceCollision.find_floor(o.Position.X, o.Position.Y, o.Position.Z, {})
}

function Helpers.cur_obj_update_floor_height_and_get_floor = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    const floorWrapper = {}
    o.FloorHeight = gLinker.SurfaceCollision.find_floor(o.Position.X, o.Position.Y, o.Position.Z, floorWrapper)
    return floorWrapper.floor
}

function Helpers.apply_drag_to_value = (ptr, dragStrength) => {

    if (ptr.value != 0) {
        //! Can overshoot if |*value| > 1/(dragStrength * 0.0001)
        const decel = (ptr.value) * (ptr.value) * (dragStrength * 0.0001)

        if (ptr.value > 0) {
            ptr.value -= decel
            if (ptr.value < 0.001) {
                ptr.value = 0
            }
        } else {
            ptr.value += decel
            if (ptr.value > -0.001) {
                ptr.value = 0
            }
        }
    }
}

function Helpers.cur_obj_apply_drag_xz = (dragStrength) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    const wrapper = { value: o.VelX }
    apply_drag_to_value(wrapper, dragStrength)
    o.VelX = wrapper.value

    wrapper.value = o.VelZ
    apply_drag_to_value(wrapper, dragStrength)
    o.VelZ = wrapper.value
}

function Helpers.cur_obj_move_xz = (steepSlopeNormalY, careAboutEdgesAndSteepSlopes) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    const intendedX = o.Position.X + o.VelX
    const intendedZ = o.Position.Z + o.VelZ

    const intendedFloorWrapper = {}
    const intendedFloorHeight = gLinker.SurfaceCollision.find_floor(intendedX, o.Position.Y, intendedZ, intendedFloorWrapper)
    const deltaFloorHeight = intendedFloorHeight - o.FloorHeight


    o.MoveFlags &= ~OBJ_MOVE_HIT_EDGE

    if (o.Room != -1 && intendedFloorWrapper.floor) {
        if (intendedFloorWrapper.floor.room != 0 && o.Room != intendedFloorWrapper.floor.room && intendedFloorWrapper.floor.room != 18) {
            // Don't leave native room
            return false
        }
    }

    if (intendedFloorHeight < -10000.0) {
        // Don't move into OoB
        o.MoveFlags |= OBJ_MOVE_HIT_EDGE
        return false
    } else if (deltaFloorHeight < 5.0) {
        if (!careAboutEdgesAndSteepSlopes) {
            // If we don't care about edges or steep slopes, okay to move
            o.Position.X = intendedX
            o.Position.Z = intendedZ
            return true
        } else if (deltaFloorHeight < -50.0 && (o.MoveFlags & OBJ_MOVE_ON_GROUND)) {
            // Don't walk off an edge
            o.MoveFlags |= OBJ_MOVE_HIT_EDGE
            return false
        } else if (intendedFloorWrapper.floor.normal.y > steepSlopeNormalY) {
            // Allow movement onto a slope, provided it's not too steep
            o.Position.X = intendedX
            o.Position.Z = intendedZ
            return true
        } else {
            // We are likely trying to move onto a steep downward slope
            o.MoveFlags |= OBJ_MOVE_HIT_EDGE
            return false
        }
    } else if ((intendedFloorWrapper.floor.normal.y) > steepSlopeNormalY || o.Position.Y > intendedFloorHeight) {
        // Allow movement upward, provided either:
        // - The target floor is flat enough (e.g. walking up stairs)
        // - We are above the target floor (most likely in the air)
        o.Position.X = intendedX
        o.Position.Z = intendedZ
        //! Returning FALSE but moving anyway (not exploitable; return value is
        //  never used)
    }

    // We are likely trying to move onto a steep upward slope
    return false
}

function Helpers.cur_obj_move_update_underwater_flags = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local decelY = sqrtf(o.VelY * o.VelY) * (o.DragStrength * 7.0) / 100.0

    if (o.VelY > 0) {
        o.VelY -= decelY
    } else {
        o.VelY += decelY
    }

    if (o.Position.Y < o.FloorHeight) {
        o.Position.Y = o.FloorHeight
        o.MoveFlags |= OBJ_MOVE_UNDERWATER_ON_GROUND
    } else {
        o.MoveFlags |= OBJ_MOVE_UNDERWATER_OFF_GROUND
    }
}

function Helpers.cur_obj_move_update_ground_air_flags = (gravity, bounciness) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.MoveFlags &= ~OBJ_MOVE_BOUNCE

    if (o.Position.Y < o.FloorHeight) {
        // On the first frame that we touch the ground, set OBJ_MOVE_LANDED.
        // On subsequent frames, set OBJ_MOVE_ON_GROUND
        if (!(o.MoveFlags & OBJ_MOVE_ON_GROUND)) {

            const { result, newBitSet } = clear_move_flag(o.MoveFlags, OBJ_MOVE_LANDED)
            o.MoveFlags = newBitSet
            if (result) {
                o.MoveFlags |= OBJ_MOVE_ON_GROUND
            } else {
                o.MoveFlags |= OBJ_MOVE_LANDED
            }
        }

        o.Position.Y = o.FloorHeight

        if (o.VelY < 0.0) {
            o.VelY *= bounciness
        }

        if (o.VelY > 5.0) {
            //! If OBJ_MOVE_13 tracks bouncing, it overestimates, since velY
            // could be > 5 here without bounce (e.g. jump into misa)
            o.MoveFlags |= OBJ_MOVE_BOUNCE
        }
    } else {
        o.MoveFlags &= ~OBJ_MOVE_LANDED
        const { result, newBitSet } = clear_move_flag(o.MoveFlags, OBJ_MOVE_ON_GROUND)
        o.MoveFlags = newBitSet
        if (result) {
            o.MoveFlags |= OBJ_MOVE_LEFT_GROUND
        }
    }

    o.MoveFlags &= ~OBJ_MOVE_MASK_IN_WATER
}

function Helpers.cur_obj_move_y_and_get_water_level = (gravity, buoyancy) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local waterLevel

    o.VelY += gravity + buoyancy
    if (o.VelY < -78.0) {
        o.VelY = -78.0
    }

    o.Position.Y += o.VelY
    if (o.ActiveFlags & ACTIVE_FLAG_UNK10) {
        waterLevel = -11000.0
    } else {
        waterLevel = gLinker.SurfaceCollision.find_water_level(o.Position.X, o.Position.Z)
    }

    return waterLevel
}

function Helpers.cur_obj_move_y = (gravity, bounciness, buoyancy) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.MoveFlags &= ~OBJ_MOVE_LEFT_GROUND

    if (o.MoveFlags & OBJ_MOVE_AT_WATER_SURFACE) {
        if (o.VelY > 5.0) {
            o.MoveFlags &= ~OBJ_MOVE_MASK_IN_WATER
            o.MoveFlags |= OBJ_MOVE_LEAVING_WATER
        }
    }

    if (!(o.MoveFlags & OBJ_MOVE_MASK_IN_WATER)) {
        local waterLevel = cur_obj_move_y_and_get_water_level(gravity, 0.0)
        if (o.Position.Y > waterLevel) {
            //! We only handle floor collision if the object does not enter
            //  water. This allows e.g. coins to clip through floors if they
            //  enter water on the same frame.
            cur_obj_move_update_ground_air_flags(gravity, bounciness)
        } else {
            o.MoveFlags |= OBJ_MOVE_ENTERED_WATER
            o.MoveFlags &= ~OBJ_MOVE_MASK_ON_GROUND
        }
    } else {
        o.MoveFlags &= ~OBJ_MOVE_ENTERED_WATER

        const waterLevel = cur_obj_move_y_and_get_water_level(gravity, buoyancy)
        if (o.Position.Y < waterLevel) {
            cur_obj_move_update_underwater_flags()
        } else {
            if (o.Position.Y < o.FloorHeight) {
                o.Position.Y = o.FloorHeight
                o.MoveFlags &= ~OBJ_MOVE_MASK_IN_WATER
            } else {
                o.Position.Y = waterLevel
                o.VelY = 0.0
                o.MoveFlags &= ~(OBJ_MOVE_UNDERWATER_OFF_GROUND | OBJ_MOVE_UNDERWATER_ON_GROUND)
                o.MoveFlags |= OBJ_MOVE_AT_WATER_SURFACE
            }
        }
    }

    if (o.MoveFlags & OBJ_MOVE_MASK_33) {
        o.MoveFlags &= ~OBJ_MOVE_IN_AIR
    } else {
        o.MoveFlags |= OBJ_MOVE_IN_AIR
    }
}

function Helpers.clear_move_flag = (bitSet, flag) => {
    if (bitSet & flag) {
        bitSet &= flag ^ 0xFFFFFFFF
        return { result: 1, bitSet }
    } else {
        return { result: 0, bitSet }
    }
}

function Helpers.abs_angle_diff = (x0, x1) => {
    local diff = x1 - x0

    if (diff == -0x8000) {
        diff = -0x7FFF
    }

    if (diff < 0) {
        diff = -diff
    }

    return diff
}

function Helpers.cur_obj_move_xz_using_fvel_and_yaw = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.VelX = o.ForwardVel * sins(o.MoveAngleYaw)
    o.VelZ = o.ForwardVel * coss(o.MoveAngleYaw)

    o.Position.X += o.VelX
    o.Position.Z += o.VelZ
}

function Helpers.cur_obj_move_y_with_terminal_vel = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.VelY < -70.0) o.VelY = -70.0

    o.Position.Y += o.VelY
}

function Helpers.cur_obj_compute_vel_xz = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.VelX = o.ForwardVel * sins(o.MoveAngleYaw)
    o.VelZ = o.ForwardVel * coss(o.MoveAngleYaw)
}

function Helpers.increment_velocity_toward_range = (value, center, zeroThreshold, increment) => {
    local relative = value - center;
    if (relative > 0) {
        if (relative < zeroThreshold) {
            return 0
        } else {
            return -increment;
        }
    } else {
        if (relative > -zeroThreshold) {
            return 0
        } else {
            return increment;
        }
    }
}

function Helpers.obj_check_if_collided_with_object(obj1: Object, obj2: Object)
    for (local i = 0; i < obj1.NumCollidedObjs; i++) {
        if (obj1.CollidedObjs[i] == obj2) {
            return true;
        }
    }

    return false;
}

function Helpers.cur_obj_set_behavior = (behavior) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.behavior = behavior
}

function Helpers.obj_set_behavior = (obj, behavior) => {
    obj.behavior = behavior
}

function Helpers.cur_obj_has_behavior = (behavior) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    if (o.behavior == behavior) {
        return true
    } else {
        return false
    }
}

function Helpers.obj_has_behavior = (obj, behavior) => {
    if (obj.behavior == behavior) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_lateral_dist_from_mario_to_home = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    local dx = o.HomeX - gMarioObject.Position.X;
    local dz = o.HomeZ - gMarioObject.Position.Z;

    local dist = sqrtf(dx * dx + dz * dz);
    return dist;
}

function Helpers.cur_obj_lateral_dist_to_home = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local dist;
    local dx = o.HomeX - o.Position.X;
    local dz = o.HomeZ - o.Position.Z;

    dist = math.sqrt(dx * dx + dz * dz);
    return dist;
}

function Helpers.cur_obj_outside_home_square = (halfLength) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (
        o.HomeX - halfLength > o.Position.X ||
        o.HomeX + halfLength < o.Position.X ||
        o.HomeZ - halfLength > o.Position.Z ||
        o.HomeZ + halfLength < o.Position.Z
    ) return true;

    return false;
}

function Helpers.cur_obj_outside_home_rectangle = (minX, maxX, minZ, maxZ) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (
        o.HomeX + minX > o.Position.X ||
        o.HomeX + maxX < o.Position.X ||
        o.HomeZ + minZ > o.Position.Z ||
        o.HomeZ + maxZ < o.Position.Z
    ) return true;

    return false;
}

function Helpers.cur_obj_set_pos_to_home = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    o.Position.X = o.HomeX;
    o.Position.Y = o.HomeY;
    o.Position.Z = o.HomeZ;
}

function Helpers.cur_obj_set_pos_to_home_and_stop = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    cur_obj_angle_to_home();
    o.ForwardVel = 0.0;
    o.VelY = 0.0;
}

function Helpers.cur_obj_shake_y = (amount) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.Timer % 2 == 0 ? o.Position.Y += amount : o.Position.Y -= amount;
}

function Helpers.cur_obj_start_cam_event = (cameraEvent) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    Camera.gPlayerCameraState.cameraEvent = cameraEvent
    Camera.gSecondCameraFocus = o
}

function Helpers.set_mario_interact_true_if_in_range = (range) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    if (o.DistanceToMario < range) gMarioObject.InteractStatus = true;
}

function Helpers.obj_set_billboard = (obj) => {
    obj.gfx.flags |= GRAPH_RENDER_BILLBOARD
}

function Helpers.cur_obj_set_hitbox_radius_and_height = (radius, height) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.HitboxRadius = radius
    o.HitboxHeight = height
}

function Helpers.cur_obj_set_hurtbox_radius_and_height = (radius, height) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.HurtboxRadius = radius
    o.HurtboxHeight = height
}

const obj_spawn_loot_coins = (obj, numCoins, sp30, coinsBehavior, posJitter, model) => {

    const floorWrapper = {}
    local spawnHeight = gLinker.SurfaceCollision.find_floor(obj.Position.X, obj.Position.Y, obj.Position.Z, floorWrapper)

    if (obj.Position.Y - spawnHeight > 100) {
        spawnHeight = obj.Position.Y
    }

    for (local i = 0; i < numCoins; i++) {
        if (obj.NumLootCoins <= 0) break

        obj.NumLootCoins--

        const coin = spawn_object(obj, model, coinsBehavior)
        obj_translate_xz_random(coin, posJitter)
        coin.Position.Y = spawnHeight
        coin.CoinBaseVelY = sp30
    }
}

function Helpers.obj_spawn_loot_blue_coins = (obj, numCoins, sp28, posJitter) => {
    obj_spawn_loot_coins(obj, numCoins, sp28, gLinker.behaviors.bhvBlueCoinJumping, posJitter, MODEL_BLUE_COIN)
}

function Helpers.obj_spawn_loot_yellow_coins = (obj, numCoins, sp28) => {
    obj_spawn_loot_coins(obj, numCoins, sp28, gLinker.behaviors.bhvSingleCoinGetsSpawned, 0, MODEL_YELLOW_COIN)
}

function Helpers.cur_obj_spawn_loot_coin_at_mario_pos = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    
    local coin;

    if (o.NumLootCoins <= 0) return;

    o.NumLootCoins--

    coin = spawn_object(o, MODEL_YELLOW_COIN, gLinker.behaviors.bhvSingleCoinGetsSpawned);
    coin.VelY = 30.0;
  
    obj_copy_pos(coin, gLinker.ObjectListProcessor.gMarioObject);
}

function Helpers.cur_obj_abs_y_dist_to_home = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;

    return math.abs(o.HomeY - o.Position.Y);
}

function Helpers.cur_obj_advance_looping_anim = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local animFrame = o.gfx.animInfo.animFrame;
    local unk08 = o.gfx.animInfo.curAnim.unk08;

    if (animFrame < 0) animFrame = 0;
    else if (unk08 - 1 == animFrame) animFrame = 0;
    else animFrame++;

    return (animFrame << 16) / unk08;
}

function Helpers.cur_obj_detect_steep_floor = (steepAngleDegrees) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const steepNormalY = coss(parseInt(steepAngleDegrees * (0x10000 / 360)))

    if (o.ForwardVel != 0) {
        const intendedX = o.Position.X + o.VelX
        const intendedZ = o.Position.Z + o.VelZ
        const intendedFloorWrapper = {}
        const intendedFloorHeight = gLinker.SurfaceCollision.find_floor(intendedX, o.Position.Y, intendedZ, intendedFloorWrapper)
        const intendedFloor = intendedFloorWrapper.floor
        const deltaFloorHeight = intendedFloorHeight - o.FloorHeight

        if (intendedFloorHeight < -10000.0) {
            o.WallAngle = o.MoveAngleYaw + 0x8000
            return 2
        } else if (intendedFloor.normal.y < steepNormalY && deltaFloorHeight > 0 && intendedFloorHeight > o.Position.Y) {
            o.WallAngle = Util.Atan2s(intendedFloor.normal.z, intendedFloor.normal.x)
            return true
        } else {
            return false
        }
    }

    return false
}

function Helpers.cur_obj_resolve_wall_collisions = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    const offsetY = 10.0
    const radius = o.WallHitboxRadius

    if (radius > 0.1) {
        const collisionData = {
            offsetY,
            radius,
            x: parseInt(o.Position.X),
            y: parseInt(o.Position.Y),
            z: parseInt(o.Position.Z),
            walls: []
        }

        const numCollisions = gLinker.SurfaceCollision.find_wall_collisions(collisionData)
        if (numCollisions != 0) {
            o.Position.X = collisionData.x
            o.Position.Y = collisionData.y
            o.Position.Z = collisionData.z

            const wall = collisionData.walls[collisionData.numWalls - 1]

            o.WallAngle = Util.Atan2s(wall.normal.z, wall.normal.x)
            if (abs_angle_diff(o.WallAngle, o.MoveAngleYaw) > 0x4000) {
                return true
            } else {
                return false
            }

        }
    }

    return false
}

function Helpers.cur_obj_update_floor = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const floor = cur_obj_update_floor_height_and_get_floor()
    o.Floor = floor

    if (floor) {
        if (floor.type == SURFACE_BURNING) o.MoveFlags |= OBJ_MOVE_ABOVE_LAVA
        else if (floor.type == SURFACE_DEATH_PLANE) o.MoveFlags |= OBJ_MOVE_ABOVE_DEATH_BARRIER

        o.FloorType = floor.type
        o.FloorRoom = floor.room
    } else {
        o.FloorType = 0
        o.FloorRoom = 0
    }

}

const cur_obj_update_floor_and_resolve_wall_collisions = (steepSlopeDegrees) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.MoveFlags &= ~(OBJ_MOVE_ABOVE_LAVA | OBJ_MOVE_ABOVE_DEATH_BARRIER)

    if (o.ActiveFlags & (ACTIVE_FLAG_FAR_AWAY | ACTIVE_FLAG_IN_DIFFERENT_ROOM)) {
        cur_obj_update_floor()
        o.MoveFlags &= ~OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER

        if (o.Position.Y > o.FloorHeight) {
            o.MoveFlags |= OBJ_MOVE_IN_AIR
        }
    } else {
        o.MoveFlags &= ~OBJ_MOVE_HIT_WALL
        if (cur_obj_resolve_wall_collisions()) {
            o.MoveFlags |= OBJ_MOVE_HIT_WALL
        }

        cur_obj_update_floor()

        if (o.Position.Y > o.FloorHeight) {
            o.MoveFlags |= OBJ_MOVE_IN_AIR
        }

        if (cur_obj_detect_steep_floor(steepSlopeDegrees)) {
            o.MoveFlags |= OBJ_MOVE_HIT_WALL
        }

    }
}

function Helpers.cur_obj_update_floor_and_walls = () => {
    cur_obj_update_floor_and_resolve_wall_collisions(60)
}

function Helpers.cur_obj_move_standard = (steepSlopeAngleDegrees) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gravity = o.Gravity
    const bounciness = o.Bounciness
    const bouyancy = o.Buoyancy
    const dragStrength = o.DragStrength
    local steepSlopeNormalY
    local careAboutEdgesAndSteepSlopes = false
    local negativeSpeed = false

    //! Because some objects allow these active flags to be set but don't
    //  afunction Helpers.updating when they are, we end up with "partial" update = ser=> e
    //  an object's internal state will be updated, but it doesn't move.
    //  This allows numerous glitches and is typically referred to as
    //  deactivation (though this term has a different meaning in the code).
    //  Objects that do this will be marked with //PARTIAL_UPDATE.

    if (!(o.ActiveFlags & (ACTIVE_FLAG_FAR_AWAY | ACTIVE_FLAG_IN_DIFFERENT_ROOM))) {
        if (steepSlopeAngleDegrees < 0) {
            careAboutEdgesAndSteepSlopes = 1
            steepSlopeAngleDegrees = -steepSlopeAngleDegrees
        }

        steepSlopeNormalY = coss(steepSlopeAngleDegrees * (0x10000 / 360))

        cur_obj_compute_vel_xz()
        cur_obj_apply_drag_xz(dragStrength)

        cur_obj_move_xz(steepSlopeNormalY, careAboutEdgesAndSteepSlopes)
        cur_obj_move_y(gravity, bounciness, bouyancy)

        if (o.ForwardVel < 0) {
            negativeSpeed = 1
        }

        o.ForwardVel = math.sqrt(math.pow(o.VelX, 2) + math.pow(o.VelZ, 2))
        if (negativeSpeed) {
            o.ForwardVel = -o.ForwardVel
        }
    }
}

const cur_obj_within_12k_bounds = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.Position.X < -12000 || 12000 < o.Position.X) return false
    if (o.Position.Y < -12000 || 12000 < o.Position.Y) return false
    if (o.Position.Z < -12000 || 12000 < o.Position.Z) return false

    return true
}

function Helpers.cur_obj_move_using_vel_and_gravity = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    if (cur_obj_within_12k_bounds()) {
        o.Position.X += o.VelX;
        o.Position.Z += o.VelZ;
        o.VelY += o.Gravity;
        o.Position.Y += o.VelY;
    }
}

function Helpers.cur_obj_move_using_fvel_and_gravity = () => {
    cur_obj_compute_vel_xz();
    cur_obj_move_using_vel_and_gravity();
}

function Helpers.obj_set_pos_relative = (obj, other, dleft, dy, dforward) => {
    local facingX = coss(other.MoveAngleYaw);
    local facingZ = sins(other.MoveAngleYaw);
    local dz = dforward * facingZ - dleft * facingX;
    local dx = dforward * facingX + dleft * facingZ;

    obj.MoveAngleYaw = other.MoveAngleYaw;
    obj.Position.X = other.Position.X + dx;
    obj.Position.Y = other.Position.Y + dy;
    obj.Position.Z = other.Position.Z + dz;
}

function Helpers.cur_obj_angle_to_home = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    
    local angle;

    local dx = o.HomeX - o.Position.X;
    local dz = o.HomeZ - o.Position.Z;

    angle = Util.Atan2s(dz, dx);
    return angle;
}

function Helpers.obj_set_gfx_pos_at_obj_pos(obj1: Object, obj2: Object)
    obj1.gfx.pos[0] = obj2.Position.X
    obj1.gfx.pos[1] = obj2.Position.Y + obj2.GraphYOffset
    obj1.gfx.pos[2] = obj2.Position.Z

    obj1.gfx.angle[0] = obj2.MoveAnglePitch & 0xFFFF
    obj1.gfx.angle[1] = obj2.MoveAngleYaw & 0xFFFF
    obj1.gfx.angle[2] = obj2.MoveAngleRoll & 0xFFFF
}

function Helpers.obj_translate_local = (obj, posIndex, localTranslateIndex) => {
    const dx = obj.rawData[localTranslateIndex + 0]
    const dy = obj.rawData[localTranslateIndex + 1]
    const dz = obj.rawData[localTranslateIndex + 2]

    obj.rawData[posIndex + 0] += obj.transform[0][0] * dx + obj.transform[1][0] * dy + obj.transform[2][0] * dz
    obj.rawData[posIndex + 1] += obj.transform[0][1] * dx + obj.transform[1][1] * dy + obj.transform[2][1] * dz
    obj.rawData[posIndex + 2] += obj.transform[0][2] * dx + obj.transform[1][2] * dy + obj.transform[2][2] * dz
}

function Helpers.obj_build_transform_from_pos_and_angle = (obj, posIndex, angleIndex) => {
    const translate = []
    const rotation = []

    translate[0] = obj.rawData[posIndex + 0]
    translate[1] = obj.rawData[posIndex + 1]
    translate[2] = obj.rawData[posIndex + 2]

    rotation[0] = obj.rawData[angleIndex + 0]
    rotation[1] = obj.rawData[angleIndex + 1]
    rotation[2] = obj.rawData[angleIndex + 2]

    mtxf_rotate_zxy_and_translate(obj.transform, translate, rotation)
}

function Helpers.obj_set_throw_matrix_from_transform = (obj) => {
    if (obj.Flags & OBJ_FLAG_0020) {
        obj_build_transform_from_pos_and_angle(obj, O_FACE_ANGLE_INDEX, O_MOVE_ANGLE_INDEX);
        obj_apply_scale_to_transform(obj);
    }

    obj.gfx.throwMatrix = obj.transform;

    cur_obj_scale(1.0);
}

function Helpers.obj_build_transform_relative_to_parent = (obj) => {
    local parent = obj.parentObj;

    obj_build_transform_from_pos_and_angle(obj, O_PARENT_RELATIVE_POS_INDEX, O_FACE_ANGLE_INDEX);
    obj_apply_scale_to_transform(obj);
    mtxf_mul(obj.transform, obj.transform, parent.transform);

    obj.Position.X = obj.transform[3][0];
    obj.Position.Y = obj.transform[3][1];
    obj.Position.Z = obj.transform[3][2];

    obj.gfx.throwMatrix = obj.transform;

    cur_obj_scale(1.0);
}

function Helpers.obj_create_transform_from_self = (obj) => {
    obj.Flags &= ~OBJ_FLAG_TRANSFORM_RELATIVE_TO_PARENT;
    obj.Flags |= OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM;

    obj.transform[3][0] = obj.Position.X;
    obj.transform[3][1] = obj.Position.Y;
    obj.transform[3][2] = obj.Position.Z;
}

function Helpers.cur_obj_rotate_move_angle_using_vel = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.MoveAnglePitch = s16(o.MoveAnglePitch + o.AngleVelPitch)
    o.MoveAngleYaw   = s16(o.MoveAngleYaw   + o.AngleVelYaw)
    o.MoveAngleRoll  = s16(o.MoveAngleRoll  + o.AngleVelRoll)
}

function Helpers.cur_obj_rotate_face_angle_using_vel = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.FaceAnglePitch = s16(o.FaceAnglePitch + o.AngleVelPitch)
    o.FaceAngleYaw   = s16(o.FaceAngleYaw   + o.AngleVelYaw)
    o.FaceAngleRoll  = s16(o.FaceAngleRoll  + o.AngleVelRoll)
}

function Helpers.cur_obj_set_face_angle_to_move_angle = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    o.FaceAnglePitch = o.MoveAnglePitch
    o.FaceAngleYaw   = o.MoveAngleYaw
    o.FaceAngleRoll  = o.MoveAngleRoll
}

function Helpers.cur_obj_follow_path = (unusedArg) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    local trajectory
    local lastIndex, lastWaypoint
    local targetIndex, targetWaypoint
    local prevToNextX, prevToNextY, prevToNextZ
    local objToNextXZ
    local objToNextX, objToNextY, objToNextZ

    if (o.PathedPrevWaypointFlags == 0) {
        o.PathedPrevWaypoint = 0
        o.PathedPrevWaypointFlags = WAYPOINT_FLAGS_INITIALIZED
    }

    trajectory = o.PathedStartWaypoint
    lastIndex  = o.PathedPrevWaypoint

    if (trajectory[lastIndex + 1].flags != WAYPOINT_FLAGS_END) {
        targetIndex = lastIndex + 1
    } else {
        targetIndex = 0
    }

    lastWaypoint   = trajectory[lastIndex]
    targetWaypoint = trajectory[targetIndex]

    o.PathedPrevWaypointFlags = lastWaypoint.flags | WAYPOINT_FLAGS_INITIALIZED

    prevToNextX = targetWaypoint.pos[0] - lastWaypoint.pos[0]
    prevToNextY = targetWaypoint.pos[1] - lastWaypoint.pos[1]
    prevToNextZ = targetWaypoint.pos[2] - lastWaypoint.pos[2]

    objToNextX = targetWaypoint.pos[0] - o.Position.X
    objToNextY = targetWaypoint.pos[1] - o.Position.Y
    objToNextZ = targetWaypoint.pos[2] - o.Position.Z
    objToNextXZ = math.sqrt(objToNextX * objToNextX + objToNextZ * objToNextZ)

    o.PathedTargetYaw = Util.Atan2s(objToNextZ, objToNextX)
    o.PathedTargetPitch = Util.Atan2s(objToNextXZ, -objToNextY)

      // If dot(prevToNext, objToNext) <= 0 (i.e. reached other side of target waypoint)
    if (prevToNextX * objToNextX + prevToNextY * objToNextY + prevToNextZ * objToNextZ <= 0.0) {
        o.PathedPrevWaypoint = targetIndex
        if (trajectory[targetIndex + 1].flags == WAYPOINT_FLAGS_END) {
            return PATH_REACHED_END
        } else {
            return PATH_REACHED_WAYPOINT
        }
    }

    return PATH_NONE
}

function Helpers.chain_segment_init = (segment) => {
    segment.posX = 0;
    segment.posY = 0;
    segment.posZ = 0;
    segment.pitch = 0;
    segment.yaw = 0;
    segment.roll = 0;
}

function Helpers.random_f32_around_zero = (diameter) => {
    return random_float() * diameter - diameter / 2
}

function Helpers.obj_scale_random = (obj, rangeLength, minScale) => {
    const scale = random_float() * rangeLength + minScale
    obj_scale_xyz(obj, scale, scale, scale)
}

function Helpers.obj_translate_xyz_random = (obj, rangeLength) => {
    obj.Position.X += random_float() * rangeLength - rangeLength * 0.5
    obj.Position.Y += random_float() * rangeLength - rangeLength * 0.5
    obj.Position.Z += random_float() * rangeLength - rangeLength * 0.5
}

function Helpers.obj_translate_xz_random = (obj, rangeLength) => {
    obj.Position.X += math.random() * rangeLength - rangeLength * 0.5
    obj.Position.Z += math.random() * rangeLength - rangeLength * 0.5
}

const obj_build_vel_from_transform = (a0) => {
    local spC = a0.UnkC0
    local sp8 = a0.UnkBC
    local sp4 = a0.ForwardVel

    a0.VelX = a0.transform[0][0] * spC + a0.transform[1][0] * sp8 + a0.transform[2][0] * sp4
    a0.VelY = a0.transform[0][1] * spC + a0.transform[1][1] * sp8 + a0.transform[2][1] * sp4
    a0.VelZ = a0.transform[0][2] * spC + a0.transform[1][2] * sp8 + a0.transform[2][2] * sp4
}

function Helpers.cur_obj_set_pos_via_transform = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    obj_build_transform_from_pos_and_angle(o, O_PARENT_RELATIVE_POS_INDEX, O_MOVE_ANGLE_INDEX)
    obj_build_vel_from_transform(o)
    o.Position.X += o.VelX
    o.Position.Y += o.VelY
    o.Position.Z += o.VelZ
}

function Helpers.cur_obj_reflect_move_angle_off_wall = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    return s16(o.WallAngle - (s16(o.MoveAngleYaw) - s16(o.WallAngle)) + 0x8000)
}

function Helpers.cur_obj_spawn_particles = (info) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local numParticles = info.count

    // If there are a lot of objects already, limit the number of particles
    if (gLinker.ObjectListProcessor.gPrevFrameObjectCount > 150 && numParticles > 10) {
        numParticles = 10
    }

    // We're close to running out of object slots, so don't spawn particles at all
    if (gLinker.ObjectListProcessor.gPrevFrameObjectCount > 210) {
        numParticles = 0
    }

    for (local i = 0; i < numParticles; i++) {
        const scale = math.random() * (info.sizeRange * 0.1) + (info.sizeBase * 0.1)

        const particle = spawn_object(o, info.model, gLinker.behaviors.bhvWhitePuffExplosion)

        particle.BhvParams2ndByte = info.behParam
        particle.MoveAngleYaw = random_int16()
        particle.Gravity = info.gravity
        particle.DragStrength = info.dragStrength

        particle.Position.Y += info.offsetY
        particle.ForwardVel = math.random() * info.forwardVelRange + info.forwardVelBase
        particle.VelY = math.random() * info.velYRange + info.velYBase

        obj_scale_xyz(particle, scale, scale, scale)

    }

}

function Helpers.obj_set_hitbox = (obj, hitbox) => {
    if (!(obj.Flags & OBJ_FLAG_30)) {
        obj.Flags |= OBJ_FLAG_30

        obj.InteractType = hitbox.InteractType
        obj.DamageOrCoinValue = hitbox.DamageOrCoinValue
        obj.Health = hitbox.health
        obj.NumLootCoins = hitbox.numLootCoins

        cur_obj_become_tangible();
    }

    obj.HitboxRadius = obj.gfx.scale[0] * hitbox.radius;
    obj.HitboxHeight = obj.gfx.scale[1] * hitbox.height;
    obj.HurtboxRadius = obj.gfx.scale[0] * hitbox.HurtboxRadius;
    obj.HurtboxHeight = obj.gfx.scale[1] * hitbox.HurtboxHeight;
    obj.HitboxDownOffset = obj.gfx.scale[1] * hitbox.downOffset;
}

function Helpers.signum_positive = (x) => {
    if (x >= 0) return 1
    else return -1
}

function Helpers.absf = (x) => {
    if (x >= 0) {
        return x
    } else {
        return -x
    }
}

function Helpers.cur_obj_wait_then_blink = (timeUntilBlinking, numBlinks) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local done = 0
    local timeBlinking = 0

    if (o.Timer >= timeUntilBlinking) {
        timeBlinking = o.Timer - timeUntilBlinking
        if (timeBlinking % 2 != 0) {
            o.gfx.flags |= GRAPH_RENDER_INVISIBLE

            if (timeBlinking / 2 > numBlinks) {
                done = 1
            }
        } else {
            o.gfx.flags &= ~ GRAPH_RENDER_INVISIBLE
        }
    }

    return done
}

function Helpers.cur_obj_is_mario_ground_pounding_platform = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    if (gMarioObject.platform == o) {
        if (gLinker.LevelUpdate.gMarioState.action == ACT_GROUND_POUND_LAND) {
            return true
        }
    }

    return false
}

function Helpers.spawn_mist_particles = () => {
    spawn_mist_particles_variable(0, 0, 46.0)
}

function Helpers.spawn_mist_particles_with_sound = (sp18) => {
    spawn_mist_particles_variable(0, 0, 46.0)
    create_sound_spawner(sp18)
}

function Helpers.cur_obj_push_mario_away = (radius) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    const marioRelX = gMarioObject.Position.X - o.Position.X
    const marioRelZ = gMarioObject.Position.Z - o.Position.Z
    const marioDist = math.sqrt(math.pow(marioRelX, 2) + math.pow(marioRelZ, 2))

    if (marioDist < radius) {
        gLinker.LevelUpdate.gMarioState.pos[0] += (radius - marioDist) / radius * marioRelX
        gLinker.LevelUpdate.gMarioState.pos[2] += (radius - marioDist) / radius * marioRelZ
    }
}

function Helpers.cur_obj_push_mario_away_from_cylinder = (radius, extentY) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    local marioRelY = gMarioObject.Position.Y - o.Position.Y

    if (marioRelY < 0.0) {
        marioRelY = -marioRelY
    }

    if (marioRelY < extentY) {
        cur_obj_push_mario_away(radius)
    }
}

function Helpers.bhv_dust_smoke_loop = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    
    o.Position.X += o.VelX;
    o.Position.Y += o.VelY;
    o.Position.Z += o.VelZ;

    if (o.SmokeTimer == 10) {
        obj_mark_for_deletion(o);
    }

    o.SmokeTimer++;
}

function Helpers.cur_obj_set_action_table = (actionTable) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.ToxBoxActionTable = actionTable;
    o.ToxBoxActionStep = 0;

    return o.ToxBoxActionTable;
}

function Helpers.cur_obj_progress_action_table = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    local nextAction;
    local actionTable = o.ToxBoxActionTable;
    local nextActionIndex = o.ToxBoxActionStep + 1;

    if (actionTable[nextActionIndex] != TOX_BOX_ACT_TABLE_END) {
        nextAction = actionTable[nextActionIndex];
        o.ToxBoxActionStep++;
    } else {
        nextAction = actionTable[0];
        o.ToxBoxActionStep = 0;
    }
  
    return nextAction;
}

function Helpers.cur_obj_scale_over_time = (a0, a1, sp10, sp14) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    
    local sp4 = sp14 - sp10
    local sp0 = o.Timer / a1

    if (a0 & 0x01) {
        o.gfx.scale[0] = sp4 * sp0 + sp10
    }

    if (a0 & 0x02) {
        o.gfx.scale[1] = sp4 * sp0 + sp10
    }

    if (a0 & 0x04) {
        o.gfx.scale[2] = sp4 * sp0 + sp10
    }
}

function Helpers.cur_obj_set_pos_to_home_with_debug = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.Position.X = o.HomeX + gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][0];
    o.Position.Y = o.HomeZ + gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][1];
    o.Position.Z = o.HomeZ + gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][2];
    cur_obj_scale(gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][3] / 100.0 + 1.0);
}

function Helpers.cur_obj_is_mario_on_platform = () => {
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject
    const o = gLinker.ObjectListProcessor.gCurrentObject
    
    if (gMarioObject.platform == o) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_shake_y_until = (cycles, amount) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.Timer % 2 != 0) o.Position.Y -= amount
    else o.Position.Y += amount

    if (o.Timer == cycles * 2) return true;
    else return false;
}

function Helpers.jiggle_bbh_stair = (a0) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    if (a0 >= 4 || a0 < 0) return true;

     o.Position.Y += sBBHStairJiggleOffsets[a0];
    return false;
}

function Helpers.cur_obj_call_action_function = (actionFunctions) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    actionFunctions[o.Action]()
}

const spawn_star_with_no_lvl_exit = (params, sp24) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    local newStar = spawn_object(o, MODEL_STAR, gLinker.behaviors.bhvSpawnedStarNoLevelExit);
    sp1C.SparkleSpawnUnk1B0 = sp24;
    sp1C.BhvParams = o.BhvParams;
    sp1C.BhvParams2ndByte = params;

    return newStar;
}

function Helpers.spawn_base_star_with_no_lvl_exit = () => {
    spawn_star_with_no_lvl_exit(0, 0);
}

function Helpers.cur_obj_mario_far_away = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject;

    local dx = o.HomeX - gMarioObject.Position.X;
    local dy = o.HomeY - gMarioObject.Position.Y;
    local dz = o.HomeZ - gMarioObject.Position.Z;
    local marioDistToHome = sqrtf(dx * dx + dy * dy + dz * dz);

    if (o.DistanceToMario > 2000.0 && marioDistToHome > 2000.0) return true;
    else return false;
}

function Helpers.is_mario_moving_fast_or_in_air = (speedThreshold) => {
    const gMarioStates = [ gLinker.LevelUpdate.gMarioState ];

    if (gMarioStates[0].forwardVel > speedThreshold ||
        gMarioStates[0].action & ACT_FLAG_AIR
    ) return true;
    
    return false;
}

function Helpers.bhv_init_room = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    local floor
    local /*f32*/ floorHeight

    if (sLevelsWithRooms.includes(gLinker.Area.gCurrLevelNum)) {
        const floorWrapper = {}
        floorHeight = gLinker.SurfaceCollision.find_floor(o.Position.X, o.Position.Y, o.Position.Z, floorWrapper)
        floor = floorWrapper.floor

        if (floor != nil) {
            if (floor.room != 0) {
                o.Room = floor.room
            } else {
                  // Floor probably belongs to a platform object. Try looking
                  // underneath it
                const floorWrapper = {}
                gLinker.SurfaceCollision.find_floor(o.Position.X, floorHeight - 100.0, o.Position.Z, floorWrapper)
                floor = floorWrapper.floor
                if (floor != nil) {
                      //! Technically possible that the room could still be 0 here
                    o.Room = floor.room
                }
            }
        }
    } else {
        o.Room = -1
    }
}

function Helpers.cur_obj_enable_rendering_if_mario_in_room = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const gMarioCurrentRoom = gLinker.ObjectListProcessor.gMarioCurrentRoom;
    const gDoorAdjacentRooms = gLinker.ObjectListProcessor.gDoorAdjacentRooms;

    local marioInRoom;

    if (o.Room != -1 && gMarioCurrentRoom != 0) {
        if (gMarioCurrentRoom == o.Room) marioInRoom = true;
        else if (gDoorAdjacentRooms[gMarioCurrentRoom][0] == o.Room) marioInRoom = true;
        else if (gDoorAdjacentRooms[gMarioCurrentRoom][1] == o.Room) marioInRoom = true;
        else marioInRoom = false;

        if (marioInRoom) {
            cur_obj_enable_rendering();
            o.ActiveFlags &= ~ACTIVE_FLAG_IN_DIFFERENT_ROOM;
            gLinker.ObjectListProcessor.gNumRoomedObjectsInMarioRoom++;
        } else {
            cur_obj_disable_rendering();
            o.ActiveFlags |= ACTIVE_FLAG_IN_DIFFERENT_ROOM;
            gLinker.ObjectListProcessor.gNumRoomedObjectsNotInMarioRoom++;
        }
    }
}

function Helpers.cur_obj_set_hitbox_and_die_if_attacked = (hitbox, deathSound, noLootCoins) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    
    local interacted = false;

    obj_set_hitbox(o, hitbox);

    if (noLootCoins) o.NumLootCoins = 0;

    if (o.InteractStatus & INT_STATUS_INTERACTED) {
        if (o.InteractStatus & INT_STATUS_WAS_ATTACKED) {
            spawn_mist_particles();
            obj_spawn_loot_yellow_coins(o, o.NumLootCoins, 20.0);
            obj_mark_for_deletion(o);
            create_sound_spawner(deathSound);
        } else interacted = true;
    }

    o.InteractStatus = 0;
    return interacted;
}

function Helpers.obj_explode_and_spawn_coins = (sp18, sp1C) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    spawn_mist_particles_variable(0, 0, sp18)
    spawn_triangle_break_particles(30, 138, 3.0, 4)
    obj_mark_for_deletion(o)

    if (sp1C == 1) {
        obj_spawn_loot_yellow_coins(o, o.NumLootCoins, 20.0)
    } else if (sp1C == 2) {
        obj_spawn_loot_blue_coins(o, o.NumLootCoins, 20.0, 150)
    }
}

function Helpers.obj_set_collision_data = (obj, segAddr) => {
    obj.collisionData = segAddr;
}

function Helpers.cur_obj_if_hit_wall_bounce_away = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.MoveFlags & OBJ_MOVE_HIT_WALL) {
        o.MoveAngleYaw = o.WallAngle
    }
}

function Helpers.cur_obj_hide_if_mario_far_away_y = (distY) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject;

    if (math.abs(o.Position.Y - gMarioObject.Position.Y) < distY) {
        cur_obj_unhide();
        return false;
    } else {
        cur_obj_hide();
        return true;
    }
}

function Helpers.geo_offset_klepto_held_object = (callContext, node, mtx) => {
    if (callContext == GEO_CONTEXT_RENDER) {
        node.next.translation[0] = 300;
        node.next.translation[1] = 300;
        node.next.translation[2] = 0;
    }

    return nil;
}

function Helpers.geo_offset_klepto_debug = (callContext, node, mtx) => {
    if (callContext == GEO_CONTEXT_RENDER) {
        node.next.translation[0] = gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][0];
        node.next.translation[1] = gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][1];
        node.next.translation[2] = gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][2];
        node.next.rotation[0]    = gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][3];
        node.next.rotation[1]    = gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][4];
        node.next.rotation[2]    = gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][5];
    }

    return nil;
}

function Helpers.obj_is_hidden = (obj) => {
    if (obj.gfx.flags & GRAPH_RENDER_INVISIBLE) {
        return true;
    } else {
        return false;
    }
}

function Helpers.enable_time_stop = () => {
    gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_ENABLED
}

function Helpers.disable_time_stop = () => {
    gLinker.ObjectListProcessor.gTimeStopState &= ~TIME_STOP_ENABLED
}

function Helpers.set_time_stop_flags = (flags) => {
    gLinker.ObjectListProcessor.gTimeStopState |= flags
}

function Helpers.clear_time_stop_flags = (flags) => {
    gLinker.ObjectListProcessor.gTimeStopState = gLinker.ObjectListProcessor.gTimeStopState & (flags ^ 0xFFFFFFFF)
}

function Helpers.cur_obj_can_mario_activate_textbox = (radius, height, unused) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioStates = [ gLinker.LevelUpdate.gMarioState ]
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

    if (o.DistanceToMario < 1500.0) {
        local latDistToMario = lateral_dist_between_objects(o, gMarioObject)

        if (latDistToMario < radius && o.Position.Y < gMarioObject.Position.Y + 160.0 &&
            gMarioObject.Position.Y < o.Position.Y + height && !(gMarioStates[0].action & ACT_FLAG_AIR) && mario_ready_to_speak()) {
                return true
        }
    }

    return false
}

function Helpers.cur_obj_can_mario_activate_textbox_2 = (radius, height) => {
    // The last argument here is unused. When this function is called directly the argument is always set to 0x7FFF.
    return cur_obj_can_mario_activate_textbox(radius, height, 0x1000)
}

function Helpers.cur_obj_end_dialog = (dialogFlags, dialogResult) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    o.DialogResponse = dialogResult;
    o.DialogState++;

    if (!(dialogFlags & DIALOG_FLAG_TIME_STOP_ENABLED)) {
        set_mario_npc_dialog(MARIO_DIALOG_STOP);
    }
}

function Helpers.cur_obj_update_dialog = (actionArg, dialogFlags, dialogID) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioState = gLinker.LevelUpdate.gMarioState

    local dialogResponse = DIALOG_RESPONSE_NONE;

    switch (o.DialogState) {
        case DIALOG_STATUS_ENABLE_TIME_STOP:
            if (gMarioState.health >= 0x100) {
                gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_ENABLED;
                o.ActiveFlags |= ACTIVE_FLAG_INITIATED_TIME_STOP;
                o.DialogState++;
            }
            break;

        case DIALOG_STATUS_INTERRUPT:
            if (set_mario_npc_dialog(actionArg) == MARIO_DIALOG_STATUS_SPEAK)
                o.DialogState++;
            break;

        case DIALOG_STATUS_START_DIALOG:
            if (dialogFlags & DIALOG_FLAG_TEXT_RESPONSE) IngameMenu.create_dialog_box_with_response(dialogID);
            else if (dialogFlags & DIALOG_FLAG_TIME_STOP_ENABLED) IngameMenu.create_dialog_box(dialogID);

            o.DialogState++;
            break;

        case DIALOG_STATUS_STOP_DIALOG:
            if (dialogFlags & DIALOG_FLAG_TEXT_RESPONSE) {
                if (IngameMenu.gDialogResponse != DIALOG_RESPONSE_NONE)
                    cur_obj_end_dialog(dialogFlags, IngameMenu.gDialogResponse);
            } else if (dialogFlags & DIALOG_FLAG_TEXT_DEFAULT) {
                if (IngameMenu.get_dialog_id() == DIALOG_NONE.id)
                    cur_obj_end_dialog(dialogFlags, DIALOG_RESPONSE_NOT_DEFINED);
            } else cur_obj_end_dialog(dialogFlags, DIALOG_RESPONSE_NOT_DEFINED);
            break;

        case DIALOG_STATUS_DISABLE_TIME_STOP:
            if (gMarioState.action != ACT_READING_NPC_DIALOG || (dialogFlags & DIALOG_FLAG_TIME_STOP_ENABLED)) {
                gLinker.ObjectListProcessor.gTimeStopState &= ~TIME_STOP_ENABLED;
                o.ActiveFlags &= ~ACTIVE_FLAG_INITIATED_TIME_STOP;
                dialogResponse = o.DialogResponse;
                o.DialogState = DIALOG_STATUS_START_DIALOG;
            }
            break;

        default:
            o.DialogState = DIALOG_STATUS_ENABLE_TIME_STOP;
            break;
    }

    return dialogResponse;
}

function Helpers.cur_obj_update_dialog_with_cutscene = (actionArg, dialogFlags, cutsceneTable, dialogID) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    const gMarioState = gLinker.LevelUpdate.gMarioState
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject
    
    local dialogResponse = DIALOG_RESPONSE_NONE
    local doneTurning = true

    switch (o.DialogState) {
        case DIALOG_STATUS_ENABLE_TIME_STOP:
            // Wait for Mario to be ready to speak, and then enable time stop
            if (mario_ready_to_speak() || gMarioState.action == ACT_READING_NPC_DIALOG) {
                gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_ENABLED
                o.ActiveFlags |= ACTIVE_FLAG_INITIATED_TIME_STOP
                o.DialogState++
                o.DialogResponse = DIALOG_RESPONSE_NONE
            } else {
                break
            }
            // Fall through so that Mario's action is interrupted immediately
            // after time is stopped
        case DIALOG_STATUS_INTERRUPT:
            // Additional flag that makes the NPC rotate towards to Mario
            if (dialogFlags & DIALOG_FLAG_TURN_TO_MARIO) {
                doneTurning = cur_obj_rotate_yaw_toward(obj_angle_to_object(o, gMarioObject), 0x800)
                // Failsafe just in case it takes more than 33 frames somehow
                if (o.DialogResponse >= 33) {
                    doneTurning = true
                }
            }
            // Interrupt status until Mario is actually speaking with the NPC and if the
            // object is done turning to Mario
            if (set_mario_npc_dialog(actionArg) == MARIO_DIALOG_STATUS_SPEAK && doneTurning) {
                o.DialogResponse = 0
                o.DialogState++
            } else {
                o.DialogResponse++ // treated as a timer for the failsafe
            }
            break
        case DIALOG_STATUS_START_DIALOG:
            // Special check for Cap Switch cutscene since the cutscene itself
            // handles what dialog should used
            if (cutsceneTable == CUTSCENE_CAP_SWITCH_PRESS) {
                o.DialogResponse = Camera.cutscene_object_without_dialog(cutsceneTable, o)
                if (o.DialogResponse) {
                    o.DialogState++
                }
            } else {
                // General dialog cutscene function, most of the time
                // the "CUTSCENE_DIALOG" cutscene is called
                o.DialogResponse = Camera.cutscene_object_with_dialog(cutsceneTable, o, dialogID)
                if (o.DialogResponse) {
                    o.DialogState++
                }
            }
            break
        case DIALOG_STATUS_STOP_DIALOG:
            // If flag defined, keep time stop enabled until the object
            // decided to disable it independently
            if (dialogFlags & DIALOG_FLAG_TIME_STOP_ENABLED) {
                dialogResponse = o.DialogResponse
                o.DialogState = DIALOG_STATUS_ENABLE_TIME_STOP
            } else if (gMarioState.action != ACT_READING_NPC_DIALOG) {
                // Disable time stop, then enable time stop for a frame
                // until the set_mario_npc_dialog function disables it
                gLinker.ObjectListProcessor.gTimeStopState &= ~TIME_STOP_ENABLED
                o.ActiveFlags &= ~ACTIVE_FLAG_INITIATED_TIME_STOP
                dialogResponse = o.DialogResponse
                o.DialogState = DIALOG_STATUS_ENABLE_TIME_STOP
            } else {
                // And finally stop Mario dialog status
                set_mario_npc_dialog(MARIO_DIALOG_STOP)
            }
            break
    }

    return dialogResponse
}

function Helpers.cur_obj_has_model = (modelID) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.gfx.sharedChild == gLinker.Area.gLoadedGraphNodes[modelID]) {
        return true
    } else {
        return false
    }
}

function Helpers.cur_obj_align_gfx_with_floor = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local floor = {};
    local floorNormal = [0, 0, 0];
    local pos = [o.Position.X, o.Position.Y, o.Position.Z];

    gLinker.SurfaceCollision.find_floor(position[0], position[1], position[2], floor);

    if (floor != nil) {
        floorNormal[0] = floor.normal.x;
        floorNormal[1] = floor.normal.y;
        floorNormal[2] = floor.normal.z;

        mtxf_align_terrain_normal(o.transform, floorNormal, pos, o.FaceAngleYaw);
        o.gfx.throwMatrix(o.transform);
    }
}

function Helpers.mario_is_within_rectangle = (minX, maxX, minZ, maxZ) => {
    const gMarioObject = gLinker.ObjectListProcessor.gMarioObject;

    if (gMarioObject.Position.X < minX || gMarioObject.Position.X > maxX) {
        return false;
    }

    if (gMarioObject.Position.Z < minZ || gMarioObject.Position.Z > maxZ) {
        return false;
    }

    return true
}

function Helpers.cur_obj_shake_screen = (shake) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    Camera.set_camera_shake_from_point(shake, o.Position.X, o.Position.Y, o.Position.Z);
}

function Helpers.obj_attack_collided_from_other_object = (obj) => {
    if (obj.NumCollidedObjs != 0) {
        const other = obj.CollidedObjs[0]

        if (other != gLinker.ObjectListProcessor.gMarioObject) {
            other.InteractStatus |= ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED | INT_STATUS_TOUCHED_BOB_OMB
            return true
        }
    }

    return false
}

function Helpers.cur_obj_was_attacked_or_ground_pounded = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    local attacked = 0

    if ((o.InteractStatus & INT_STATUS_INTERACTED)
        && (o.InteractStatus & INT_STATUS_WAS_ATTACKED)) {
        attacked = 1
    }

    if (cur_obj_is_mario_ground_pounding_platform()) {
        attacked = 1
    }

    o.InteractStatus = 0
    return attacked
}

function Helpers.obj_copy_behavior_params = (dst, src) => {
    dst.BhvParams = src.BhvParams
    dst.BhvParams2ndByte = src.BhvParams2ndByte
}

function Helpers.cur_obj_init_animation_and_anim_frame = (animIndex, animFrame) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject
    
    cur_obj_init_animation_with_sound(animIndex)
    o.gfx.animInfo.animFrame = animFrame
}

function Helpers.cur_obj_init_animation_and_check_if_near_end = (animIndex) => {
    cur_obj_init_animation_with_sound(animIndex)
    return cur_obj_check_if_near_animation_end()
}

function Helpers.cur_obj_init_animation_and_extend_if_at_end = (animIndex) => {
    cur_obj_init_animation_with_sound(animIndex)
    cur_obj_extend_animation_if_at_end()
}

function Helpers.cur_obj_check_grabbed_mario = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.InteractStatus & INT_STATUS_GRABBED_MARIO) {
        o.KingBobombUnk88 = 1
        cur_obj_become_intangible()
        return true
    }

    return false
}

function Helpers.player_performed_grab_escape_action = () => {
    local grabReleaseState
    local result = false

    if (window.playerInput.stickMag > 40.0) {
        grabReleaseState = 0
    }

    if (grabReleaseState == 0 && window.playerInput.stickMag > 40.0) {
        grabReleaseState = 1
        result = true
    }

    if (window.playerInput.buttonPressedA) {
        result = true
    }

    return result
}

function Helpers.cur_obj_unused_play_footstep_sound = (animFrame1, animFrame2, sound) => {
    if (cur_obj_check_anim_frame(animFrame1) || cur_obj_check_anim_frame(animFrame2)) 
        cur_obj_play_sound_2(sound);
}

function Helpers.enable_time_stop_including_mario = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_ENABLED | TIME_STOP_MARIO_AND_DOORS;
    o.ActiveFlags |= ACTIVE_FLAG_INITIATED_TIME_STOP;
}

function Helpers.disable_time_stop_including_mario = () => {
    gLinker.ObjectListProcessor.gTimeStopState &= ~(TIME_STOP_ENABLED | TIME_STOP_MARIO_AND_DOORS);
    o.ActiveFlags &= ~ACTIVE_FLAG_INITIATED_TIME_STOP;
}

function Helpers.cur_obj_check_interacted = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.InteractStatus & INT_STATUS_INTERACTED) {
        o.InteractStatus = 0
        return true
    } else return false;
}

function Helpers.cur_obj_spawn_loot_blue_coin = () => {
    const o = gLinker.ObjectListProcessor.gCurrentObject;
    if (o.NumLootCoins >= 5) {
        spawn_object(o, MODEL_BLUE_COIN, gLinker.behaviors.bhvSpawnedBlueCoin);
        o.NumLootCoins -= 5;
    }
}

function Helpers.cur_obj_spawn_star_at_y_offset = (targetX, targetY, targetZ, offsetY) => {
    const o = gLinker.ObjectListProcessor.gCurrentObject

    local objectPosY = o.Position.Y
    o.Position.Y += offsetY + gDebugInfo[DebugPage.DEBUG_PAGE_ENEMYINFO][0]
    spawn_default_star(targetX, targetY, targetZ)
    o.Position.Y = objectPosY
}

gLinker.bhv_init_room = bhv_init_room
gLinker.bhv_dust_smoke_loop = bhv_dust_smoke_loop

gLinker.cur_obj_rotate_face_angle_using_vel = cur_obj_rotate_face_angle_using_vel
gLinker.cur_obj_move_using_fvel_and_gravity = cur_obj_move_using_fvel_and_gravity
end