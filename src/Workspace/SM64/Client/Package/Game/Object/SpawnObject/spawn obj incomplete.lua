local ObjectListProcessor = require(script.Parent.ObjectListProcessor)
local BehaviorCommands = require(script.Parent.BehaviorCommands)

local ObjectConstants = require(script.Parent.ObjectConstants)

-- import { init_graph_node, geo_add_child, GRAPH_RENDER_INVISIBLE, GRAPH_NODE_TYPE_OBJECT, geo_remove_child, GRAPH_RENDER_BILLBOARD, GRAPH_RENDER_ACTIVE } from "../engine/graph_node"
-- import { ACTIVE_FLAG_ACTIVE, ACTIVE_FLAG_UNK8, RESPAWN_INFO_TYPE_NULL, ACTIVE_FLAG_UNIMPORTANT, OBJ_MOVE_ON_GROUND, oIntangibleTimer, oDamageOrCoinValue, oHealth, oCollisionDistance, oDrawingDistance, oDistanceToMario, oRoom, oFloorHeight, oPosX, oPosY, oPosZ, ACTIVE_FLAGS_DEACTIVATED, ACTIVE_FLAG_DEACTIVATED } from "../include/ObjectConstants"
-- import { mtxf_identity } from "../engine/math_util"
-- import * as _Linker from "./Linker"

local SpawnObject = {}


function SpawnObject.try_allocate_object(destList)
	local obj = {
		gfx: {},
		next: null, prev: null,
		activeFlags: 0,
		rawData: new Array(0x50).fill(0),
		ptrData: new Array(0x50).fill(0)
end
init_graph_node(obj.gfx, GRAPH_NODE_TYPE_OBJECT)
obj.gfx.object = obj

obj.prev = destList.prev
obj.next = destList
destList.prev.next = obj
destList.prev = obj

geo_add_child(gLinker.GeoLayout.gObjParentGraphNode, obj.gfx)
return obj
end

function SpawnObject.deallocate_object(obj)
	-- Remove from object list
	obj.next.prev = obj.prev
	obj.prev.next = obj.next
end

function SpawnObject.clear_object_lists()
	const gObjectLists = ObjectListProc.gObjectLists
	for (let i = 0; i < ObjectListProc.NUM_OBJ_LISTS; i++) {
		gObjectLists[i].next = gObjectLists[i]
		gObjectLists[i].prev = gObjectLists[i]
end
end

function SpawnObject.unload_object(obj)
	obj.activeFlags = ACTIVE_FLAGS_DEACTIVATED
	obj.prevObj = null

	obj.gfx.throwMatrix = null

	--func_803206F8 TODO
	geo_remove_child(obj.gfx)

	obj.gfx.flags &= ~GRAPH_RENDER_BILLBOARD
	obj.gfx.flags &= ~GRAPH_RENDER_ACTIVE

	this.deallocate_object(obj)
end

function SpawnObject.allocate_object(objList)
	const obj = this.try_allocate_object(objList)

	obj.activeFlags = ACTIVE_FLAG_ACTIVE | ACTIVE_FLAG_UNK8
	obj.parentObj = obj
	obj.prevObj = null
	obj.collidedObjInteractTypes = 0
	obj.numCollidedObjs = 0 --/ possibly unnecessary
	obj.collidedObjs = []

	obj.bhvStackIndex = 0
	obj.bhvDelayTimer = 0

	obj.HitboxRadius = 50.0
	obj.HitboxHeight = 100.0
	obj.hurtboxRadius = 0.0
	obj.hurtboxHeight = 0.0
	obj.hitboxDownOffset = 0.0
	obj.unused2 = 0

	obj.platform = null
	obj.collisionData = null
	obj.IntangibleTimer = -1
	obj.DamageOrCoinValue = 0
	obj.Health = 2048

	obj.CollisionDistance = 1000.0
	obj.DrawingDistance = 4000.0

	obj.transform = new Array(4).fill(0).map(() => new Array(4).fill(0))
	mtxf_identity(obj.transform)

	obj.respawnInfoType = RESPAWN_INFO_TYPE_NULL
	obj.respawnInfo = null

	obj.DistanceToMario = 19000.0
	obj.Room = -1

	obj.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
	obj.gfx.pos = [ -10000.0, -10000.0, -10000.0 ]
	obj.gfx.throwMatrix = null

	return obj
end

function SpawnObject.snap_object_to_floor(obj)
	obj.FloorHeight = gLinker.SurfaceCollision.find_floor(obj.PosX, obj.PosY, obj.PosZ, {})

	if (obj.FloorHeight + 2.0 > obj.oPosY && obj.oPosY > obj.oFloorHeight - 10.0) then
		obj.oPosY = obj.oFloorHeight
		obj.oMoveFlags |= OBJ_MOVE_ON_GROUND
	end
end

function SpawnObject.create_object(bhvScript)
	bhvScript = this.get_bhv_script(bhvScript)
	if (!bhvScript) then
		return null
	end
	let objListIndex = this.get_bhv_object_list(bhvScript)
	const objList = ObjectListProc.gObjectLists[objListIndex]
	const obj = this.allocate_object(objList)

	obj.bhvScript = { commands: bhvScript, index: 0, name: this.get_bhv_object_name(bhvScript) }
	obj.behavior = bhvScript

	if (objListIndex == ObjectListProc.OBJ_LIST_UNIMPORTANT) then
		obj.activeFlags |= ACTIVE_FLAG_UNIMPORTANT
	end

	if (objListIndex == ObjectListProc.OBJ_LIST_POLELIKE || 
		objListIndex == ObjectListProc.OBJ_LIST_GENACTOR ||
		objListIndex == ObjectListProc.OBJ_LIST_PUSHABLE) then
		this.snap_object_to_floor(obj)
	end
	return obj
end


-- Some behvior scripts cannot be initialized due to circular dependancies,
-- so are left as functions to be initialized when they are needed
function SpawnObject.get_bhv_script(behavior) 
	let bhv = behavior
	if (typeof bhv == "function") 
		bhv = bhv()
		elseif (typeof bhv == "string") then
	bhv = gLinker.behaviors[bhv]
	if (!bhv) then
		console.log("missing gLinker behavior: " + behavior)
		bhv = gLinker.behaviors.bhvCarrySomething6
	end
end

return bhv
end

function SpawnObject.get_bhv_object_list(bhvScript)
	bhvScript = this.get_bhv_script(bhvScript)

	-- peek at first command
	if (Array.isArray(bhvScript[0]) && bhvScript[0][0] == 'BEGIN') then
		return bhvScript[0][1]
	elseif (bhvScript[0].command == BhvCmds.begin) then
		return bhvScript[0].args.objListIndex
	else
		return ObjectListProc.OBJ_LIST_DEFAULT
	end
end

function SpawnObject.get_bhv_object_name(bhvScript) then
	bhvScript = this.get_bhv_script(bhvScript)

	-- peek at first command
	if (Array.isArray(bhvScript[0]) && bhvScript[0][0] == 'BEGIN') then
		return bhvScript[0][2]
	elseif (bhvScript[0].command == BhvCmds.begin) then
		return bhvScript[0].args.name
	else
		return null
	end
end

function SpawnObject.mark_obj_for_deletion(obj)
	obj.activeFlags = ACTIVE_FLAG_DEACTIVATED;
end

export const SpawnObjectInstance = new SpawnObject()
gLinker.Spawn = SpawnObjectInstance