import { ObjectListProcessorInstance as ObjectListProc } from "./ObjectListProcessor"
import { oPosX, oPosY, oPosZ, oHomeX, oHomeY, oHomeZ, oForwardVel, oMoveAngleYaw, oVelY,
    oFaceAngleYaw, oFriction, oGravity, oGraphYOffset, oAction, OBJ_ACT_LAVA_DEATH, OBJ_ACT_DEATH_PLANE_DEATH,
    oAngleToMario, oTimer, oAnimState,
    oBehParams, oRespawnerModelToRespawn, oRespawnerMinSpawnDist, oRespawnerBehaviorToRespawn, ACTIVE_FLAG_DEACTIVATED, oVelX, oVelZ, oOpacity, oBuoyancy
     } from "../include/object_constants"
import { Util.Sins, Util.Coss, int32, uint16, int16, random_uint16, random_float } from "../utils"
import { SurfaceCollisionInstance as SurfaceCollision } from "../engine/SurfaceCollision"
import { atan2s, mtxf_align_terrain_normal } from "../engine/math_util"
import { GRAPH_NODE_TYPE_400, GRAPH_NODE_TYPE_FUNCTIONAL, GRAPH_RENDER_BILLBOARD, GRAPH_RENDER_INVISIBLE } from "../engine/graph_node"
import { approach_symmetric, spawn_object, spawn_object_abs_with_rot, spawn_object_relative } from "./ObjectHelpers"
import { SURFACE_BURNING, SURFACE_DEATH_PLANE } from "../include/surface_terrains"
import { MODEL_YELLOW_COIN, MODEL_NONE, MODEL_SMOKE, MODEL_NUMBER, MODEL_IDLE_WATER_WAVE, MODEL_WHITE_PARTICLE_SMALL } from "../include/model_ids"
import { bhvBobombBullyDeathSmoke, bhvMovingYellowCoin, bhvRespawner } from "./BehaviorData"
import { cur_obj_play_sound_2 } from "./SpawnSound"
import { SOUND_OBJ_BULLY_EXPLODE_2, SOUND_OBJ_DIVING_INTO_WATER } from "../include/sounds"
import { gDPSetEnvColor, gSPEndDisplayList } from "../include/gbi"
import { MARIO_DIALOG_STATUS_SPEAK, MARIO_DIALOG_STOP, set_mario_npc_dialog } from "./MarioActionsCutscene"
import { CUTSCENE_DIALOG, CameraInstance as Camera } from "./Camera"
import { DIALOG_RESPONSE_NONE } from "./IngameMenu"

export local function OBJ_COL_FLAG_GROUNDED(1 << 0)
export local OBJ_COL_FLAG_HIT_WALL = (1 << 1)
export local OBJ_COL_FLAG_UNDERWATER = (1 << 2)
export local OBJ_COL_FLAG_NO_Y_VEL = (1 << 3)
export local OBJ_COL_FLAGS_LANDED = (OBJ_COL_FLAG_GROUNDED | OBJ_COL_FLAG_NO_Y_VEL)

export local sObjFloor = {}
export local sOrientObjWithFloor = true;

local sPrevCheckMarioRoom = 0;
local sYoshiDead = false;

export local set_yoshi_as_not_dead = ()
    sYoshiDead = false;
}

export local function geo_obj_transparency_something(callContext, node, mtx)
    local gCurGraphNodeObject = gLinker.GeoRenderer.gCurGraphNodeObject;
    local gCurGraphNodeHeldObject = gLinker.GeoRenderer.gCurGraphNodeHeldObject;
    local gfx = null;

    if (callContext == GEO_CONTEXT_RENDER) {
        local heldObject = gCurGraphNodeObject;
        local obj = node;

        if (gCurGraphNodeHeldObject != null) {
            heldObject = gCurGraphNodeHeldObject
        }

        gfx = []
        obj.gfx.flags = obj.gfx.flags & 0xFF | (GRAPH_NODE_TYPE_FUNCTIONAL | GRAPH_NODE_TYPE_400);

        gDPSetEnvColor(gfx, 255, 255, 255, heldObject.Opacity);
        gSPEndDisplayList(gfx);
    }

    return gfx;
}

--[[*
 * Turns an object away from floors/walls that it runs into.
 ]]
export local function turn_obj_away_from_surface(velX, velZ, nX, nZ, objYawWrapper)
    objYawWrapper.x = (nZ * nZ - nX * nX) * velX / (nX * nX + nZ * nZ)
        - 2 * velZ * (nX * nZ) / (nX * nX + nZ * nZ);

    objYawWrapper.z = (nX * nX - nZ * nZ) * velZ / (nX * nX + nZ * nZ)
        - 2 * velX * (nX * nZ) / (nX * nX + nZ * nZ)
}

export local function obj_find_wall(objNewX, objY, objNewZ, objVelX, objVelZ)

    local o = gLinker.ObjectListProcessor.gCurrentObject

    local hitbox = {
        x = objNewX,
        y = objY,
        z = objNewZ,
        radius = o.hitboxRadius,
        offsetY = o.HitboxHeight / 2,
        walls = []
    }

    if (SurfaceCollision.find_wall_collisions(hitbox) != 0) {
        o.Position.X = hitbox.x
        o.Position.Y = hitbox.y
        o.Position.Z = hitbox.z

        local wall_nX = hitbox.walls[0].normal.x
        local wall_nZ = hitbox.walls[0].normal.z

        local objVelXCopy = objVelX
        local objVelZCopy = objVelZ

        --/ Turns away from the first wall only.
        local objYawWrapper = {}
        turn_obj_away_from_surface(objVelXCopy, objVelZCopy, wall_nX, wall_nZ, objYawWrapper)

        o.MoveAngleYaw = atan2s(objYawWrapper.z, objYawWrapper.x)
        return false
    }

    return true
}

--[[*
 * Turns an object away from steep floors, similarly to walls.
 ]]
export local function turn_obj_away_from_steep_floor(objFloor, floorY, objVelX, objVelZ)
    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (objFloor == null) {
        --/! (OOB Object Crash) TRUNC overflow exception after 36 minutes
        o.MoveAngleYaw += int32(o.MoveAngleYaw + 32767.999200000002)
        return false
    }

    local floor_nX = objFloor.normal.x
    local floor_nY = objFloor.normal.y
    local floor_nZ = objFloor.normal.z

    --/ If the floor is steep and we are below it (i.e. walking into it), turn away from the floor.
    if (floor_nY < 0.5 && floorY > o.Position.Y) {
        local objVelXCopy = objVelX
        local objVelZCopy = objVelZ
        local objYawWrapper = {}
        turn_obj_away_from_surface(objVelXCopy, objVelZCopy, floor_nX, floor_nZ, objYawWrapper)
        o.MoveAngleYaw = atan2s(objYawWrapper.z, objYawWrapper.x)
        return false
    }

    return true
}

export local function obj_orient_graph(obj, normalX, normalY, normalZ)

    local objVisualPosition = new Array(3), surfaceNormals = new Array(3)

    --/ Passes on orienting certain objects that shouldn't be oriented, like boulders.
    if (sOrientObjWithFloor == false) return

    --/ Passes on orienting billboard objects, i.e. coins, trees, etc.
    if ((obj.gfx.flags & GRAPH_RENDER_BILLBOARD) != 0) return

    local throwMatrix = new Array(4).fill(0).map(() => new Array(4).fill(0))

    objVisualPosition[0] = obj.Position.X
    objVisualPosition[1] = obj.Position.Y + obj.GraphYOffset
    objVisualPosition[2] = obj.Position.Z

    surfaceNormals[0] = normalX
    surfaceNormals[1] = normalY
    surfaceNormals[2] = normalZ

    mtxf_align_terrain_normal(throwMatrix, surfaceNormals, objVisualPosition, obj.FaceAngleYaw)
    obj.gfx.throwMatrix = throwMatrix
}

export local function calc_obj_friction(objFrictionWrapper, floor_nY)

    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (floor_nY < 0.2 && o.Friction < 0.9999) {
        objFrictionWrapper.value = 0
    } else {
        objFrictionWrapper.value = o.Friction
    }
}

export local function calc_new_obj_vel_and_pos_y(objFloor, objFloorY, objVelX, objVelZ)

    local o = gLinker.ObjectListProcessor.gCurrentObject

    local floor_nX = objFloor.normal.x
    local floor_nY = objFloor.normal.y
    local floor_nZ = objFloor.normal.z

    --/ Caps vertical speed with a "terminal velocity".
    o.VelY -= o.Gravity
    if (o.VelY > 75.0) {
        o.VelY = 75.0
    }
    if (o.VelY < -75.0) {
        o.VelY = -75.0
    }

    o.Position.Y += o.VelY

    --/Snap the object up to the floor.
    if (o.Position.Y < objFloorY) {
        o.Position.Y = objFloorY

        --/ Bounces an object if the ground is hit fast enough.
        if (o.VelY < -17.5) {
            o.VelY = -(o.VelY / 2)
        } else {
            o.VelY = 0
        }
    }

    --/! (Obj Position Crash) If you got an object with height past 2^31, the game would crash.
    if (o.Position.Y >= objFloorY && o.Position.Y < objFloorY + 37) {
        obj_orient_graph(o, floor_nX, floor_nY, floor_nZ)

        --/ Adds horizontal component of gravity for horizontal speed.
        objVelX += floor_nX * (floor_nX * floor_nX + floor_nZ * floor_nZ)
            / (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * o.Gravity
            * 2
        objVelZ += floor_nZ * (floor_nX * floor_nX + floor_nZ * floor_nZ)
            / (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * o.Gravity
            * 2

        if (objVelX < 0.000001 && objVelX > -0.000001) {
            objVelX = 0
        }
        if (objVelZ < 0.000001 && objVelZ > -0.000001) {
            objVelZ = 0
        }

        if (objVelX != 0 || objVelZ != 0) {
            o.MoveAngleYaw = atan2s(objVelZ, objVelX)
        }

        local objFrictionWrapper = {}
        calc_obj_friction(objFrictionWrapper, floor_nY)
        o.ForwardVel = math.sqrt(objVelX * objVelX + objVelZ * objVelZ) * objFrictionWrapper.value
    }
}

export local function calc_new_obj_vel_and_pos_y_underwater(objFloor, floorY, objVelX, objVelZ, waterY)
    local o = gLinker.ObjectListProcessor.gCurrentObject;
    
    local floor_nX = objFloor.normal.x
    local floor_nY = objFloor.normal.y
    local floor_nZ = objFloor.normal.z
    local netYAccel = (1.0 - o.Buoyancy) * (-1.0 * o.Gravity)
    o.VelY -= netYAccel

    if (o.VelY > 75.0) o.VelY = 75.0
    if (o.VelY < -75.0) o.VelY = -75.0

    o.Position.Y += o.VelY

    if (o.Position.Y < floorY) {
        o.Position.Y = floorY

        if (o.VelY < -17.5)
             o.VelY = -(o.VelY / 2)
        else o.VelY = 0;
    }

    if (o.ForwardVel > 12.5 && waterY + 30.0 > o.Position.Y && waterY - 30.0 < o.Position.Y) 
        o.VelY = -o.VelY

    if (o.Position.Y >= floorY && o.Position.Y < floorY + 37) {
        obj_orient_graph(o, floor_nX, floor_nY, floor_nZ)

        objVelX += floor_nX * (floor_nX * floor_nX + floor_nZ * floor_nZ)
                    / (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * netYAccel * 2
        objVelZ += floor_nZ * (floor_nX * floor_nX + floor_nZ * floor_nZ)
                    / (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * netYAccel * 2

        if (objVelX < 0.000001 && objVelX > -0.000001) objVelX = 0
        if (objVelZ < 0.000001 && objVelZ > -0.000001) objVelZ = 0
        if (o.VelY < 0.000001 && o.VelY > -0.000001) o.VelY = 0

        if (objVelX != 0 || objVelZ != 0) o.MoveAngleYaw = atan2s(objVelZ, objVelX)

        o.ForwardVel = sqrtf(objVelX * objVelX + objVelZ * objVelZ) * 0.8
        o.VelY *= 0.8
    }
}

export local function obj_update_pos_vel_xz()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    local xVel = o.ForwardVel * Util.Sins(o.MoveAngleYaw)
    local zVel = o.ForwardVel * Util.Coss(o.MoveAngleYaw)

    o.Position.X += xVel
    o.Position.Z += zVel
}

export local function obj_splash(waterY, objY)
    local o = gLinker.ObjectListProcessor.gCurrentObject

    local globalTimer = window.gGlobalTimer

    if (waterY + 30 > o.Position.Y && o.Position.Y > waterY - 30) {
        spawn_object(o, MODEL_IDLE_WATER_WAVE, gLinker.behaviors.bhvObjectWaterWave)

        if (o.VelY < -20.0) cur_obj_play_sound_2(SOUND_OBJ_DIVING_INTO_WATER)
    }

    if (objY + 50 < waterY && !(globalTimer & 31)) {
        spawn_object(o, MODEL_WHITE_PARTICLE_SMALL, gLinker.behaviors.bhvObjectBubble)
    }
}

export local function object_step()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    local objX = o.Position.X
    local objY = o.Position.Y
    local objZ = o.Position.Z

    local waterY = -10000.0

    local objVelX = o.ForwardVel * Util.Sins(o.MoveAngleYaw)
    local objVelZ = o.ForwardVel * Util.Coss(o.MoveAngleYaw)

    local collisionFlags = 0

    --/ Find any wall collisions, receive the push, and set the flag.
    if (obj_find_wall(objX + objVelX, objY, objZ + objVelZ, objVelX, objVelZ) == 0) {
        collisionFlags += OBJ_COL_FLAG_HIT_WALL
    }

    local sObjFloorWrapper = {}
    local floorY = gLinker.SurfaceCollision.find_floor(objX + objVelX, objY, objZ + objVelZ, sObjFloorWrapper)
    sObjFloor = sObjFloorWrapper.floor

    if (turn_obj_away_from_steep_floor(sObjFloor, floorY, objVelX, objVelZ) == 1) {
        local waterY = gLinker.SurfaceCollision.find_water_level(objX + objVelX, objZ + objVelZ)
        if (waterY > objY) {
            calc_new_obj_vel_and_pos_y_underwater(sObjFloor, floorY, objVelX, objVelZ, waterY)
            collisionFlags += OBJ_COL_FLAG_UNDERWATER;
        } else {
            calc_new_obj_vel_and_pos_y(sObjFloor, floorY, objVelX, objVelZ)
        }
    } else {
        --/ Treat any awkward floors similar to a wall.
        collisionFlags += ((collisionFlags & OBJ_COL_FLAG_HIT_WALL) ^ OBJ_COL_FLAG_HIT_WALL)
    }

    obj_update_pos_vel_xz()
    if (math.floor(o.Position.Y) == math.floor(floorY)) {
        collisionFlags += OBJ_COL_FLAG_GROUNDED
    }

    if (math.floor(o.VelY) == 0) {
        collisionFlags += OBJ_COL_FLAG_NO_Y_VEL
    }

    --/ Generate a splash if in water.
    obj_splash(waterY, o.Position.Y)
    return collisionFlags
}

export local function object_step_without_floor_orient()
    sOrientObjWithFloor = false;
    local collisionFlags = object_step();
    sOrientObjWithFloor = true;

    return collisionFlags;
}

export local function obj_move_xyz_using_fvel_and_yaw(obj)
    local o = gLinker.ObjectListProcessor.gCurrentObject
    
    o.VelX = obj.ForwardVel * Util.Sins(obj.MoveAngleYaw)
    o.VelZ = obj.ForwardVel * Util.Coss(obj.MoveAngleYaw)

    obj.Position.X += o.VelX
    obj.Position.Y += obj.VelY
    obj.Position.Z += o.VelZ
}

export local function is_point_within_radius_of_mario(x, y, z, dist)
    local mGfxX = ObjectListProc.gMarioObject.gfx.pos[0]
    local mGfxY = ObjectListProc.gMarioObject.gfx.pos[1]
    local mGfxZ = ObjectListProc.gMarioObject.gfx.pos[2]

    if ((x - mGfxX) * (x - mGfxX) + (y - mGfxY) * (y - mGfxY) + (z - mGfxZ) * (z - mGfxZ) < dist * dist) {
        return true
    }

    return false

}

--[[*
 * Checks whether a point is within distance of a given point. Test is exclusive.
 ]]
export local function is_point_close_to_object(obj, x, y, z, dist)
   local --[[f32]]objX = obj.Position.X
   local --[[f32]]objY = obj.Position.Y
   local --[[f32]]objZ = obj.Position.Z

    if ((x - objX) * (x - objX) + (y - objY) * (y - objY) + (z - objZ) * (z - objZ)
        < (dist * dist)) {
        return true
    }

    return false
}

--[[*
 * Sets an object as visible if within a certain distance of Mario's graphical position.
 ]]
export local function set_object_visibility(obj, dist)
    if (is_point_within_radius_of_mario(obj.Position.X, obj.Position.Y, obj.Position.Z, dist) == 1) {
        obj.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
    } else {
        obj.gfx.flags |= GRAPH_RENDER_INVISIBLE
    }
}

export local function obj_return_home_if_safe(obj, homeX, y, homeZ, dist)
    local homeDistX = homeX - obj.Position.X
    local homeDistZ = homeZ - obj.Position.Z
    local angleTowardsHome = int16(atan2s(homeDistZ, homeDistX))

    if (is_point_within_radius_of_mario(homeX, y, homeZ, dist) == 1) {
        return true
    } else {
        obj.MoveAngleYaw = approach_symmetric(obj.MoveAngleYaw, angleTowardsHome, 320)
    }

    return false
}

export local function obj_return_and_displace_home(obj, homeX, homeY, homeZ, baseDisp)
    if (math.round(random_float() * 50.0) == 0) {
        obj.HomeX = baseDisp * 2 * random_float() - baseDisp + homeX
        obj.HomeZ = baseDisp * 2 * random_float() - baseDisp + homeZ
    }

    local homeDistX = obj.HomeX - obj.Position.X
    local homeDistZ = obj.HomeZ - obj.Position.Z
    local angleToNewHome = atan2s(homeDistZ, homeDistX)
    obj.MoveAngleYaw = approach_symmetric(obj.MoveAngleYaw, angleToNewHome, 320)
}

export local function obj_check_if_facing_toward_angle(base, goal, range)
    local dAngle = goal - base

    if ((Util.Sins(-range) < Util.Sins(dAngle)) && (Util.Sins(dAngle) < Util.Sins(range)) && (Util.Coss(dAngle) > 0)) {
        return true
    }

    return false
}

export local function obj_find_wall_displacement(dist, x, y, z, radius)
    local o = gLinker.ObjectListProcessor.gCurrentObject

    local hitbox = {
        x = x,
        y = y,
        z = z,
        offsetY = 10.0,
        radius = radius,
    }

    if (SurfaceCollision.find_wall_collisions(hitbox) != 0) {
        dist[0] = hitbox.x - x
        dist[1] = hitbox.y - y
        dist[2] = hitbox.z - z
        return true
    } else return false;
}

export local function obj_spawn_yellow_coins(obj, nCoins)
    for (local count = 0; count < nCoins; count += 1) {
        local coin = spawn_object(obj, MODEL_YELLOW_COIN, bhvMovingYellowCoin)
        coin.ForwardVel = math.random() * 20
        coin.VelY = math.random() * 40 + 20
        coin.MoveAngleYaw = random_uint16()
    }
}

export local function obj_flicker_and_disappear(obj, lifeSpan)

    if (obj.Timer < lifeSpan) return false

    if (obj.Timer < lifeSpan + 40) {

        if (obj.Timer % 2 != 0) {
            obj.gfx.flags |= GRAPH_RENDER_INVISIBLE
        } else {
            obj.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
        }

    } else {
        obj.activeFlags = 0
        return true
    }

    return false
}

export local function current_mario_room_check(room)
    local gMarioCurrentRoom = gLinker.ObjectListProcessor.gMarioCurrentRoom;
    local result;

    if (gMarioCurrentRoom != 0) {
        if (room == sPrevCheckMarioRoom) return true;
        else return false;
    } else {
        if (room == gMarioCurrentRoom) result = true;
        else result = false;

        sPrevCheckMarioRoom = gMarioCurrentRoom;
    }

    return result;
}

--[[*
 * Triggers dialog when Mario is facing an object and controls it while in the dialog.
 ]]
export local function trigger_obj_dialog_when_facing(inDialogWrapper, dialogID, dist, actionArg)
    local o = gLinker.ObjectListProcessor.gCurrentObject;
    local gMarioObject = gLinker.ObjectListProcessor.gMarioObject;
    
    if (
        is_point_within_radius_of_mario(o.Position.X, o.Position.Y, o.Position.Z, dist) == true &&
        obj_check_if_facing_toward_angle(o.FaceAngleYaw, gMarioObject.gfx.angle[1] + 0x8000, 0x1000) == true &&
        obj_check_if_facing_toward_angle(o.MoveAngleYaw, o.AngleToMario, 0x1000) == true
        || inDialogWrapper.inDialog == true
    ) {
        inDialogWrapper.inDialog = true;

        if (set_mario_npc_dialog(actionArg) == MARIO_DIALOG_STATUS_SPEAK) {
            local dialogResponse = Camera.cutscene_object_with_dialog(CUTSCENE_DIALOG, o, dialogID);

            if (dialogResponse != DIALOG_RESPONSE_NONE) {
                set_mario_npc_dialog(MARIO_DIALOG_STOP);
                inDialogWrapper.inDialog = false;
                return dialogResponse;
            }

            return 0;
        }
    }

    return 0;
}

export local function obj_check_floor_death(collisionFlags, floor)
    local o = gLinker.ObjectListProcessor.gCurrentObject
    
    if (floor == null) return

    if ((collisionFlags & OBJ_COL_FLAG_GROUNDED) == 1) {
        switch (floor.type) {
            case SURFACE_BURNING =
                o.Action = OBJ_ACT_LAVA_DEATH
                break
            --/! @BUG Doesn't check for the vertical wind death floor.
            case SURFACE_DEATH_PLANE =
                o.Action = OBJ_ACT_DEATH_PLANE_DEATH
                break
            default =
                break
        }
    }
}

export local function obj_lava_death()
    local o = gLinker.ObjectListProcessor.gCurrentObject

    local deathSmoke

    if (o.Timer > 30) {
        o.activeFlags = ACTIVE_FLAG_DEACTIVATED
        return true
    } else {
        --/ Sinking effect
        o.Position.Y -= 10.0
    }

    if ((o.Timer % 8) == 0) {
        cur_obj_play_sound_2(SOUND_OBJ_BULLY_EXPLODE_2)
        deathSmoke = spawn_object(o, MODEL_SMOKE, bhvBobombBullyDeathSmoke)
        deathSmoke.Position.X += random_float() * 20.0
        deathSmoke.Position.Y += random_float() * 20.0
        deathSmoke.Position.Z += random_float() * 20.0
        deathSmoke.ForwardVel = random_float() * 10.0
    }

    return false
}

export local function spawn_orange_number(bhvParam, x, y, z)
    local o = gLinker.ObjectListProcessor.gCurrentObject;
    if (bhvParam >= 10) return;

    local orangeNumber = spawn_object_relative(bhvParam, x, y, z, o, MODEL_NUMBER, gLinker.behaviors.bhvOrangeNumber);
    orangeNumber.Position.Y += 25.0;
}

export local function create_respawner(model, behToSpawn, minSpawnDist)
    local o = gLinker.ObjectListProcessor.gCurrentObject
    local respawner = spawn_object_abs_with_rot(o, MODEL_NONE, bhvRespawner, o.HomeX, o.HomeY, o.HomeZ, 0, 0, 0)

    respawner.BhvParams = o.BhvParams
    respawner.RespawnerModelToRespawn = model
    respawner.RespawnerMinSpawnDist = minSpawnDist
    respawner.RespawnerBehaviorToRespawn = behToSpawn
}


--/ JS NOTE = The Parameter is a rawData "o" offset, not a pointer nor a wrapper object.
--/ Trying this out, maybe it can replace some use cases of wrappers.
export local function curr_obj_random_blink(blinkTimer)
    local o = gLinker.ObjectListProcessor.gCurrentObject

    if (o.rawData[blinkTimer] == 0) {
        if (parseInt(math.random() * 100.0) == 0) {
            o.AnimState = 1
            o.rawData[blinkTimer] = 1
        }
    } else {
        o.rawData[blinkTimer]++
        if (o.rawData[blinkTimer] >= 6)
            o.AnimState = 0
        if (o.rawData[blinkTimer] >= 11)
            o.AnimState = 1
        if (o.rawData[blinkTimer] >= 16) {
            o.AnimState = 0
            o.rawData[blinkTimer] = 0
        }
    }
}