-- i think i messed something up here🙁🙁🙁🙁🙁
local Enums = require(script.Parent.Parent.Parent.Enums)
local Util = require(script.Parent.Parent.Parent.Util)
local FFlags = require(script.Parent.Parent.Parent.FFlags)
local Types = require(script.Parent.Parent.Parent.Types)

local ObjectConstants = require(script.Parent.ObjectConstants)
local GraphNodeConstats = require(script.Parent.GraphNodeConstats)
local ObjectHelpers = require(script.Parent.ObjectHelpers)
local Models = require(script.Parent.Models)

local int16 = Util.SignedShort
local int32 = Util.SignedInt
local parseInt = ObjectHelpers.parseInt
local sqrtf = ObjectHelpers.sqrtf

local SURFACE_BURNING, SURFACE_DEATH_PLANE = Enums.SurfaceClass.BURNING, Enums.SurfaceClass.DEATH_PLANE
--[[import { ObjectListProcessorInstance as ObjectListProc } from "./ObjectListProcessor"
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
import { DIALOG_RESPONSE_NONE } from "./IngameMenu"]]

OBJ_COL_FLAG_GROUNDED   = bit32.lshift(1, 0)
OBJ_COL_FLAG_HIT_WALL   = bit32.lshift(1, 1)
OBJ_COL_FLAG_UNDERWATER = bit32.lshift(1, 2)
OBJ_COL_FLAG_NO_Y_VEL   = bit32.lshift(1, 3)
OBJ_COL_FLAGS_LANDED    = bit32.bor(OBJ_COL_FLAG_GROUNDED, OBJ_COL_FLAG_NO_Y_VEL)

local ObjBehaviors = {
	OBJ_COL_FLAG_GROUNDED = OBJ_COL_FLAG_GROUNDED,
	OBJ_COL_FLAG_HIT_WALL = OBJ_COL_FLAG_HIT_WALL,
	OBJ_COL_FLAG_UNDERWATER = OBJ_COL_FLAG_UNDERWATER,
	OBJ_COL_FLAG_NO_Y_VEL = OBJ_COL_FLAG_NO_Y_VEL,
	OBJ_COL_FLAGS_LANDED = OBJ_COL_FLAGS_LANDED,
}

--[[
 Finds any wall collisions, applies them, and turns away from the surface.
 ]]


type Object = Types.ObjectState

gMarioObject = nil :: Types.MarioState

function ObjBehaviors.setMario(Mario: Types.MarioState)
	gMarioObject = Mario
end

ObjBehaviors.sObjFloor = {}
local sOrientObjWithFloor = true;

local sPrevCheckMarioRoom = 0;
local sYoshiDead = false;

function ObjBehaviors.set_yoshi_as_not_dead()
	sYoshiDead = false;
end

--[[function ObjBehaviors.geo_obj_transparency_something(callContext, node, mtx)
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
}]]

	--[[*
	* Turns an object away from floors/walls that it runs into.
	]]
function ObjBehaviors.turn_obj_away_from_surface(velX, velZ, nX, nZ, objYawWrapper)
	objYawWrapper.x = (nZ * nZ - nX * nX) * velX / (nX * nX + nZ * nZ)
	- 2 * velZ * (nX * nZ) / (nX * nX + nZ * nZ);

	objYawWrapper.z = (nX * nX - nZ * nZ) * velZ / (nX * nX + nZ * nZ)
	- 2 * velX * (nX * nZ) / (nX * nX + nZ * nZ)
end
turn_obj_away_from_surface = ObjBehaviors.turn_obj_away_from_surface

function ObjBehaviors.obj_find_wall(o,
	objNewX, objY, objNewZ, objVelX, objVelZ)--(o: {any}, oPos: {x:number, y:number, z:number}, oVel: {x:number, y:number, z:number})}, objNewX, objY, objNewZ, objVelX, objVelZ)

	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	--[[local hitbox = {
		x = objNewX,
		y = objY,
		z = objNewZ,
		radius = o.HitboxRadius,
		offsetY = o.HitboxHeight / 2,
		walls = []
	}

	if (SurfaceCollision.find_wall_collisions(hitbox) != 0) {]]
	local newPos, lastWall, walls = Util.FindWallCollisions(
		Vector3.new(objNewX, objY, objNewZ), -- position
		o.HitboxHeight / 2, -- offset y
		o.HitboxRadius -- radius
	)
	if lastWall then
		o.Position = newPos
		--[[o.Position.X = hitbox.x
		o.Position.Y = hitbox.y
		o.Position.Z = hitbox.z]]

		local wall_nX = walls[1].Normal.X
		local wall_nZ = walls[1].Normal.Z
		--[[local wall_nX = hitbox.walls[0].normal.x
		local wall_nZ = hitbox.walls[0].normal.z]]

		local objVelXCopy = objVelX
		local objVelZCopy = objVelZ

		--/ Turns away from the first wall only.
		local objYawWrapper = {} :: {z: number, x: number}
		turn_obj_away_from_surface(objVelXCopy, objVelZCopy, wall_nX, wall_nZ, objYawWrapper)

		o.MoveAngleYaw = Util.Atan2s(objYawWrapper.z, objYawWrapper.x)
		return false
	end

	return true
end

	--[[*
	* Turns an object away from steep floors, similarly to walls.
	]]
function ObjBehaviors.turn_obj_away_from_steep_floor(o,
	objFloor, floorY, objVelX, objVelZ)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	if objFloor == nil then
		-- if (objFloor == null) {
		--/! (OOB Object Crash) TRUNC overflow exception after 36 minutes
		o.MoveAngleYaw += int32(o.MoveAngleYaw + 32767.999200000002)
		return false
	end
	--[[
	local floor_nX = objFloor.normal.x
	local floor_nY = objFloor.normal.y
	local floor_nZ = objFloor.normal.z]]
	local floor_nX = objFloor.Normal.X
	local floor_nY = objFloor.Normal.Y
	local floor_nZ = objFloor.Normal.Z

	--/ If the floor is steep and we are below it (i.e. walking into it), turn away from the floor.
	if floor_nY < 0.5 and floorY > o.Position.Y then
		local objVelXCopy = objVelX
		local objVelZCopy = objVelZ
		local objYawWrapper = {}
		ObjBehaviors.turn_obj_away_from_surface(objVelXCopy, objVelZCopy, floor_nX, floor_nZ, objYawWrapper)
		o.MoveAngleYaw = Util.Atan2s(objYawWrapper.z, objYawWrapper.x)
		return false
	end

	return true
end
turn_obj_away_from_steep_floor = ObjBehaviors.turn_obj_away_from_steep_floor

local throwmatodo = true

function ObjBehaviors.obj_orient_graph(obj, normalX, normalY, normalZ)
	local objVisualPosition = Vector3.zero
	local surfaceNormals = Vector3.zero

	--/ Passes on orienting certain objects that shouldn't be oriented, like boulders.
	if sOrientObjWithFloor == false then return end

	--/ Passes on orienting billboard objects, i.e. coins, trees, etc.
	if obj.GfxFlags:Has(GraphNodeConstats.GRAPH_RENDER_BILLBOARD) then
		return
	end
	-- if ((obj.gfx.flags & GRAPH_RENDER_BILLBOARD) != 0) return
	if throwmatodo then
		warn('TODO:')
	end
			--[[local throwMatrix = new Array(4).fill(0).map(() => new Array(4).fill(0))

			objVisualPosition[0] = obj.Position.X
			objVisualPosition[1] = obj.Position.Y + obj.GraphYOffset
			objVisualPosition[2] = obj.Position.Z

			surfaceNormals[0] = normalX
			surfaceNormals[1] = normalY
			surfaceNormals[2] = normalZ

			mtxf_align_terrain_normal(throwMatrix, surfaceNormals, objVisualPosition, obj.FaceAngleYaw)
			obj.gfx.throwMatrix = throwMatrix]]
	if throwmatodo then
		print('the rest of this throwMatrix stuff')	
		throwmatodo = false	
	end
--[[
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
			obj.gfx.throwMatrix = throwMatrix]]
end

function ObjBehaviors.calc_obj_friction(o, objFrictionWrapper, floor_nY)
	--local o = gLinker.ObjectListProcessor.gCurrentObject

	if floor_nY < 0.2 and o.Friction < 0.9999 then
		objFrictionWrapper.value = 0
	else
		objFrictionWrapper.value = o.Friction
	end
end

function ObjBehaviors.calc_new_obj_vel_and_pos_y(o,
	objFloor, objFloorY, objVelX, objVelZ)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	local floor_nX = objFloor.Normal.X
	local floor_nY = objFloor.Normal.Y
	local floor_nZ = objFloor.Normal.Z

	--/ Caps vertical speed with a "terminal velocity".
	o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y - o.Gravity)
	-- o.Velocity.Y -= o.Gravity
	if o.Velocity.Y > 75.0 then
		-- o.Velocity.Y = 75.0
		o.Velocity = Util.SetY(o.Velocity, 75)
	end
	if o.Velocity.Y < -75.0 then
		o.Velocity = Util.SetY(o.Velocity, -75)
		-- o.Velocity.Y = -75.0
	end

	-- o.Position.Y += o.Velocity.Y
	o.Position = Util.SetY(o.Position, o.Position.Y + o.Velocity.Y)	

	--/Snap the object up to the floor.
	if o.Position.Y < objFloorY then
		o.Position = Util.SetY(o.Position, objFloorY)
		-- o.Position.Y = objFloorY

		--/ Bounces an object if the ground is hit fast enough.
		if o.Velocity.Y < -17.5 then
			o.Velocity = Util.SetY(o.Velocity, -(o.Velocity.Y / 2))
			--o.Velocity.Y = -(o.Velocity.Y / 2)
		else
			o.Velocity = Util.SetY(o.Velocity, 0)			
			-- o.Velocity.Y = 0
		end
	end

	--/! (Obj Position Crash) If you got an object with height past 2^31, the game would crash.
	if o.Position.Y >= objFloorY and o.Position.Y < objFloorY + 37 then
		ObjBehaviors.obj_orient_graph(o, floor_nX, floor_nY, floor_nZ)

		--/ Adds horizontal component of gravity for horizontal speed.
		objVelX += floor_nX * (floor_nX * floor_nX + floor_nZ * floor_nZ)
			/ (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * o.Gravity
			* 2
		objVelZ += floor_nZ * (floor_nX * floor_nX + floor_nZ * floor_nZ)
			/ (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * o.Gravity
			* 2

		if objVelX < 0.000001 and objVelX > -0.000001 then
			objVelX = 0
		end
		if objVelZ < 0.000001 and objVelZ > -0.000001 then
			objVelZ = 0
		end

		if objVelX ~= 0 or objVelZ ~= 0 then
			o.MoveAngleYaw = Util.Atan2s(objVelZ, objVelX)
		end

		local objFrictionWrapper = {}
		ObjBehaviors.calc_obj_friction(o, objFrictionWrapper, floor_nY)
		o.ForwardVel = math.sqrt(objVelX * objVelX + objVelZ * objVelZ) * objFrictionWrapper.value
	end
end
calc_new_obj_vel_and_pos_y = ObjBehaviors.calc_new_obj_vel_and_pos_y

function ObjBehaviors.calc_new_obj_vel_and_pos_y_underwater(o, objFloor, floorY, objVelX, objVelZ, waterY)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject;

	local floor_nX = objFloor.Normal.X
	local floor_nY = objFloor.Normal.Y
	local floor_nZ = objFloor.Normal.Z
	local netYAccel = (1.0 - o.Buoyancy) * (-1.0 * o.Gravity)
	o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y - netYAccel)
	-- o.Velocity.Y -= netYAccel

	if o.Velocity.Y > 75.0 then
		o.Velocity = Util.SetY(o.Velocity, 75.0)
		-- o.Velocity.Y = 75.0
	end
	if o.Velocity.Y < -75.0 then
		o.Velocity = Util.SetY(o.Velocity, -75.0)
		-- o.Velocity.Y = -75.0
	end

	o.Position = Util.SetY(o.Position, o.Position.Y + o.Velocity.Y)
	-- o.Position.Y += o.Velocity.Y

	if o.Position.Y < floorY then
		o.Position = Util.SetY(o.Position, floorY)
		--o.Position.Y = floorY

		if o.Velocity.Y < -17.5 then
			o.Velocity = Util.SetY(o.Velocity, -(o.Velocity.Y / 2))
			-- o.Velocity.Y = -(o.Velocity.Y / 2)
		else o.Velocity = Util.SetY(o.Velocity, 0) end
	end

	if o.ForwardVel > 12.5 and waterY + 30.0 > o.Position.Y and waterY - 30.0 < o.Position.Y then 
		o.Velocity = Util.SetY(o.Velocity, -o.Velocity.Y)
	end
	-- o.Velocity.Y = -o.Velocity.Y

	if o.Position.Y >= floorY and o.Position.Y < floorY + 37 then
		ObjBehaviors.obj_orient_graph(o, floor_nX, floor_nY, floor_nZ)

		objVelX += floor_nX * (floor_nX * floor_nX + floor_nZ * floor_nZ)
			/ (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * netYAccel * 2
		objVelZ += floor_nZ * (floor_nX * floor_nX + floor_nZ * floor_nZ)
			/ (floor_nX * floor_nX + floor_nY * floor_nY + floor_nZ * floor_nZ) * netYAccel * 2

		if objVelX < 0.000001 and objVelX > -0.000001 then objVelX = 0 end
		if objVelZ < 0.000001 and objVelZ > -0.000001 then objVelZ = 0 end
		if o.Velocity.Y < 0.000001 and o.Velocity.Y > -0.000001 then o.Velocity = Util.SetY(o.Velocity, 0) end

		if objVelX ~= 0 or objVelZ ~= 0 then o.MoveAngleYaw = Util.Atan2s(objVelZ, objVelX) end

		o.ForwardVel = sqrtf(objVelX * objVelX + objVelZ * objVelZ) * 0.8
		o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y * 0.8)
		-- o.Velocity.Y *= 0.8
	end
end

function ObjBehaviors.obj_update_pos_vel_xz(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	local xVel = o.ForwardVel * Util.Sins(o.MoveAngleYaw)
	local zVel = o.ForwardVel * Util.Coss(o.MoveAngleYaw)

	o.Position = Vector3.new(
		o.Position.X + xVel,
		o.Position.Y,
		o.Position.Z + zVel
	)
	-- o.Position.X += xVel
	-- o.Position.Z += zVel
end
obj_update_pos_vel_xz = ObjBehaviors.obj_update_pos_vel_xz

local obstodo = true
function ObjBehaviors.obj_splash(o, waterY, objY)
	if obstodo then
		obstodo = false
		warn('obj_splash')
	end
	if true then return 0 end
	--[[local o = gLinker.ObjectListProcessor.gCurrentObject

	local globalTimer = window.gGlobalTimer

	if (waterY + 30 > o.Position.Y && o.Position.Y > waterY - 30) {
		spawn_object(o, MODEL_IDLE_WATER_WAVE, gLinker.behaviors.bhvObjectWaterWave)

		if (o.Velocity.Y < -20.0) cur_obj_play_sound_2(SOUND_OBJ_DIVING_INTO_WATER)
			}

		if (objY + 50 < waterY && !(globalTimer & 31)) {
			spawn_object(o, MODEL_WHITE_PARTICLE_SMALL, gLinker.behaviors.bhvObjectBubble)
			}]]
end

function ObjBehaviors.object_step(o: Object)
	--local o = gLinker.ObjectListProcessor.gCurrentObject

	local objX = o.Position.X
	local objY = o.Position.Y
	local objZ = o.Position.Z

	local waterY = -10000.0

	local objVelX = o.ForwardVel * Util.Sins(o.MoveAngleYaw)
	local objVelZ = o.ForwardVel * Util.Coss(o.MoveAngleYaw)

	local collisionFlags = 0

	--/ Find any wall collisions, receive the push, and set the flag.
	if ObjBehaviors.obj_find_wall(o,
		objX + objVelX, objY, objZ + objVelZ, objVelX, objVelZ) == false then
		collisionFlags += OBJ_COL_FLAG_HIT_WALL
	end

	--local ObjBehaviors.sObjFloorWrapper = {}
	-- local floorY = gLinker.SurfaceCollision.find_floor(objX + objVelX, objY, objZ + objVelZ, ObjBehaviors.sObjFloorWrapper)
	local floorY, floor = Util.FindFloor(Vector3.new(objX + objVelX, objY, objZ + objVelZ))
	
	o.Floor = floor -- um um?
	ObjBehaviors.sObjFloor = floor -- ObjBehaviors.sObjFloorWrapper.floor

	if ObjBehaviors.turn_obj_away_from_steep_floor(o,
		ObjBehaviors.sObjFloor, floorY, objVelX, objVelZ) == true then
		-- local waterY = gLinker.SurfaceCollision.find_water_level(objX + objVelX, objZ + objVelZ)
		local waterY = Util.GetWaterLevel(Vector3.new(objX + objVelX, 0, objZ + objVelZ))-- 0, doest matterrj ljkdaslasdn
		if waterY > objY then
			ObjBehaviors.calc_new_obj_vel_and_pos_y_underwater(o,
				ObjBehaviors.sObjFloor, floorY, objVelX, objVelZ, waterY)
			collisionFlags += OBJ_COL_FLAG_UNDERWATER;
		else
			ObjBehaviors.calc_new_obj_vel_and_pos_y(o,
				ObjBehaviors.sObjFloor, floorY, objVelX, objVelZ)
		end
	else
		--/ Treat any awkward floors similar to a wall.
		-- collisionFlags += ((collisionFlags & OBJ_COL_FLAG_HIT_WALL) ^ OBJ_COL_FLAG_HIT_WALL)
		collisionFlags += bit32.bxor(bit32.band(collisionFlags, OBJ_COL_FLAG_HIT_WALL), OBJ_COL_FLAG_HIT_WALL)
	end

	ObjBehaviors.obj_update_pos_vel_xz(o)
	if math.floor(o.Position.Y) == math.floor(floorY) then
		collisionFlags += OBJ_COL_FLAG_GROUNDED
	end

	if math.floor(o.Velocity.Y) == 0 then
		collisionFlags += OBJ_COL_FLAG_NO_Y_VEL
	end
	
	--/ Generate a splash if in water.
	ObjBehaviors.obj_splash(o, waterY, o.Position.Y)
	return collisionFlags
end

function ObjBehaviors.object_step_without_floor_orient(o)
	sOrientObjWithFloor = false;
	local collisionFlags = ObjBehaviors.object_step(o);
	sOrientObjWithFloor = true;

	return collisionFlags;
end

function ObjBehaviors.obj_move_xyz_using_fvel_and_yaw(obj)
	warn('obj_move_xyz_using_fvel_and_yaw') if true then return 0 end
	--[[local o = gLinker.ObjectListProcessor.gCurrentObject

	o.Velocity.X = obj.ForwardVel * Util.Sins(obj.MoveAngleYaw)
	o.Velocity.Z = obj.ForwardVel * Util.Coss(obj.MoveAngleYaw)

	obj.Position.X += o.Velocity.X
	obj.Position.Y += obj.Velocity.Y
	obj.Position.Z += o.Velocity.Z]]
end

local warned = true

function ObjBehaviors.is_point_within_radius_of_mario(x, y, z, dist)
	if warned then
		warned = false
		warn('TODO: verify is_point_within_radius_of_mario accuracy')
	end
	--[[local mGfxX = gMarioObject.gfx.pos[0]
	local mGfxY = gMarioObject.gfx.pos[1]
	local mGfxZ = gMarioObject.gfx.pos[2] ]]
	--[[local mGfxX = gMarioObject.GfxPos.X
	local mGfxY = gMarioObject.GfxPos.Y
	local mGfxZ = gMarioObject.GfxPos.Z]]
	local mGfxX = gMarioObject.Position.X
	local mGfxY = gMarioObject.Position.Y
	local mGfxZ = gMarioObject.Position.Z

	if (x - mGfxX) * (x - mGfxX) + (y - mGfxY) * (y - mGfxY) + (z - mGfxZ) * (z - mGfxZ) < dist * dist then
		return true
	end

	return false
end

	--[[*
	* Checks whether a point is within distance of a given point. Test is exclusive.
	]]
function ObjBehaviors.is_point_close_to_object(obj, x, y, z, dist)
	warn('is_point_close_to_object') if true then return 0 end
	--[[local objX = obj.Position.X -- f32
	local objY = obj.Position.Y -- f32
	local objZ = obj.Position.Z -- f32

	if ((x - objX) * (x - objX) + (y - objY) * (y - objY) + (z - objZ) * (z - objZ)
		< (dist * dist)) {
			return true
		}

		return false]]
end

	--[[*
	* Sets an object as visible if within a certain distance of Mario's graphical position.
		]]
function ObjBehaviors.set_object_visibility(obj, dist)
	warn('set_object_visibility') if true then return 0 end
			--[[if (is_point_within_radius_of_mario(obj.Position.X, obj.Position.Y, obj.Position.Z, dist) == true) {
				obj.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
			} else {
	obj.gfx.flags |= GRAPH_RENDER_INVISIBLE
	}]]
end

function ObjBehaviors.obj_return_home_if_safe(obj, homeX, y, homeZ, dist)
	local homeDistX = homeX - obj.Position.X
	local homeDistZ = homeZ - obj.Position.Z
	local angleTowardsHome = int16(Util.Atan2s(homeDistZ, homeDistX))

	if ObjBehaviors.is_point_within_radius_of_mario(homeX, y, homeZ, dist) == true then
		return true
	else
		obj.MoveAngleYaw = ObjectHelpers.approach_symmetric(obj.MoveAngleYaw, angleTowardsHome, 320)
	end

	return false
end

function ObjBehaviors.obj_return_and_displace_home(obj, homeX, homeY, homeZ, baseDisp)
	warn('obj_return_and_displace_home') if true then return 0 end
		--[[if (math.round(random_float() * 50.0) == false) {
			obj.Home.X = baseDisp * 2 * random_float() - baseDisp + homeX
			obj.Home.Z = baseDisp * 2 * random_float() - baseDisp + homeZ
		}

		local homeDistX = obj.Home.X - obj.Position.X
		local homeDistZ = obj.Home.Z - obj.Position.Z
		local angleToNewHome = atan2s(homeDistZ, homeDistX)
		obj.MoveAngleYaw = ObjectHelpers.approach_symmetric(obj.MoveAngleYaw, angleToNewHome, 320)]]
end

function ObjBehaviors.obj_check_if_facing_toward_angle(base, goal, range)
	local dAngle = goal - base

	if (Util.Sins(-range) < Util.Sins(dAngle)) and (Util.Sins(dAngle) < Util.Sins(range)) and (Util.Coss(dAngle) > 0) then
		return true
	end

	return false
end

function ObjBehaviors.obj_find_wall_displacement(dist, x, y, z, radius)
	warn('obj_find_wall_displacement') if true then return 0 end
		--[[local o = gLinker.ObjectListProcessor.gCurrentObject

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
			} else return false;]]
end

function ObjBehaviors.obj_spawn_yellow_coins(obj, nCoins)
	for count = 0, nCoins - 1 do
		-- for (local count = 0; count < nCoins; count += 1) {
		local coin = ObjectHelpers.spawn_object(obj, Models.YELLOW_COIN, 'bhvMovingYellowCoin')
		coin.ForwardVel = math.random() * 20
		coin.Velocity = Util.SetY(coin.Velocity,
			--[[coin.Velocity.Y =]] math.random() * 40 + 20)
		coin.MoveAngleYaw = Util.random_uint16()
	end
end

function ObjBehaviors.obj_flicker_and_disappear(obj, lifeSpan)
	if obj.Timer < lifeSpan then return false end

	if obj.Timer < lifeSpan + 40 then

		if obj.Timer % 2 ~= 0 then
			obj.GfxFlags:Add(GraphNodeConstats.GRAPH_RENDER_INVISIBLE)
			-- obj.gfx.flags |= GRAPH_RENDER_INVISIBLE
		else
			obj.GfxFlags:Remove(GraphNodeConstats.GRAPH_RENDER_INVISIBLE)
			-- obj.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
		end

	else
		obj.ActiveFlags:Clear()
		return true
	end

	return false
end

function ObjBehaviors.current_mario_room_check(room)
	warn('current_mario_room_check') if true then return 0 end
		--[[local gMarioCurrentRoom = gLinker.ObjectListProcessor.gMarioCurrentRoom;
		local result;

		if (gMarioCurrentRoom != 0) {
			if (room == sPrevCheckMarioRoom) return true;
			else return false;
	} else {
	if (room == gMarioCurrentRoom) result = true;
	else result = false;

	sPrevCheckMarioRoom = gMarioCurrentRoom;
	}

	return result;]]
end

	--[[*
	* Triggers dialog when Mario is facing an object and controls it while in the dialog.
		]]
function ObjBehaviors.trigger_obj_dialog_when_facing(inDialogWrapper, dialogID, dist, actionArg)
	warn('trigger_obj_dialog_when_facing') if true then return 0 end
			--[[local o = gLinker.ObjectListProcessor.gCurrentObject;
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

				return 0;]]
end

function ObjBehaviors.obj_check_floor_death(o, collisionFlags, floor)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	if floor == nil then  -- UR A BULLYYYYYYY
		--warn('nil flooor')
		return end

	if bit32.band(collisionFlags, OBJ_COL_FLAG_GROUNDED) == 1 then
		--if ((collisionFlags & OBJ_COL_FLAG_GROUNDED) == true) {
		Util.Switch(floor.type, {
			[SURFACE_BURNING] = function()
				o.Action = ObjectConstants.OBJ_ACT_LAVA_DEATH
			end,
			--/! @BUG Doesn't check for the vertical wind death floor.
			[SURFACE_DEATH_PLANE] = function()
				o.Action = ObjectConstants.OBJ_ACT_DEATH_PLANE_DEATH
			end,
		})
	end
end

function ObjBehaviors.obj_lava_death()
	warn('obj_lava_death') if true then return 0 end
			--[[local o = gLinker.ObjectListProcessor.gCurrentObject

			local deathSmoke

			if (o.Timer > 30) {
				o.activeFlags = ACTIVE_FLAG_DEACTIVATED
				return true
				} else {
	--/ Sinking effect
	o.Position.Y -= 10.0
	}

	if ((o.Timer % 8) == false) {
		cur_obj_play_sound_2(SOUND_OBJ_BULLY_EXPLODE_2)
		deathSmoke = spawn_object(o, MODEL_SMOKE, bhvBobombBullyDeathSmoke)
		deathSmoke.Position.X += random_float() * 20.0
		deathSmoke.Position.Y += random_float() * 20.0
		deathSmoke.Position.Z += random_float() * 20.0
		deathSmoke.ForwardVel = random_float() * 10.0
		}

		return false]]
end

function ObjBehaviors.spawn_orange_number(bhvParam, x, y, z)
	warn('spawn_orange_number') if true then return 0 end
		--[[local o = gLinker.ObjectListProcessor.gCurrentObject;
		if (bhvParam >= 10) return;

			local orangeNumber = spawn_object_relative(bhvParam, x, y, z, o, MODEL_NUMBER, gLinker.behaviors.bhvOrangeNumber);
			orangeNumber.Position.Y += 25.0;]]
end

function ObjBehaviors.create_respawner(model, behToSpawn, minSpawnDist)
	warn('create_respawner') if true then return 0 end
		--[[local o = gLinker.ObjectListProcessor.gCurrentObject
		local respawner = spawn_object_abs_with_rot(o, MODEL_NONE, bhvRespawner, o.Home.X, o.Home.Y, o.Home.Z, 0, 0, 0)

		respawner.BehParams = o.BehParams
		respawner.RespawnerModelToRespawn = model
		respawner.RespawnerMinSpawnDist = minSpawnDist
		respawner.RespawnerBehaviorToRespawn = behToSpawn]]
end


--/ JS NOTE = The Parameter is a rawData "o" offset, not a pointer nor a wrapper object.
--/ Trying this out, maybe it can replace some use cases of wrappers.
function ObjBehaviors.curr_obj_random_blink(o, blinkTimer)
	--local o = gLinker.ObjectListProcessor.gCurrentObject

	-- lua note: js's falsey cases are  different than lua's. 0 is not falsey, it's just 0.
	-- so in this case, if o[blinkTimer] is 0, then it should be interpreted as false.
	if (not o[blinkTimer]) or o[blinkTimer] == 0 then
		-- if o[blinkTimer] == false then
		if parseInt(math.random() * 100.0) == false then
			o.AnimState = 1
			o[blinkTimer] = 1
		end
	else
		o[blinkTimer] += 1
		if o[blinkTimer] >= 6 then
			o.AnimState = 0
		end
		if o[blinkTimer] >= 11 then
			o.AnimState = 1
		end
		if o[blinkTimer] >= 16 then
			o.AnimState = 0
			o[blinkTimer] = 0
		end
	end
end

return ObjBehaviors