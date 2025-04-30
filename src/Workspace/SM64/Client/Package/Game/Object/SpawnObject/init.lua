-- code here is 90% custom
--[[

something to take note of this while porting this is that rawdata
if initalized like this


		rawData: new Array(0x50).fill(0),

maximumadhd just completely scraped rawdata
there is seriously something wrong with how this port works it
makes me mad

]]

local Util = require(script.Parent.Parent.Parent.Util)
local Enums = require(script.Parent.Parent.Parent.Enums)
local Types = require(script.Parent.Parent.Parent.Types)
local Model = require(script.Parent.Parent.Parent.Custom.Model)
local Audio = require(script.Parent.Parent.Parent.Custom.Audio)
local GraphNodeConstats = require(script.Parent.GraphNodeConstats)

local Flags = Types.Flags

local ObjectListProcessor = require(script.Parent.ObjectListProcessor) 
local ObjectConstants = require(script.Parent.ObjectConstants)

-- local BehaviorCommands = require(script.Parent.BehaviorCommands)
--[[local BehaviorData = require(script.Parent.BehaviorData)
local BehaviorData = require(script.Parent.behaviors)
local Behaviors = BehaviorData.BehaviorScripts]]
local Behaviors = require(script.Parent.BehaviorData.BehaviorScripts)

-- import { init_graph_node, geo_add_child, GRAPH_RENDER_INVISIBLE, GRAPH_NODE_TYPE_OBJECT, geo_remove_child, GRAPH_RENDER_BILLBOARD, GRAPH_RENDER_ACTIVE } from "../engine/graph_node"
-- import { ACTIVE_FLAG_ACTIVE, ACTIVE_FLAG_UNK8, RESPAWN_INFO_TYPE_NULL, ACTIVE_FLAG_UNIMPORTANT, OBJ_MOVE_ON_GROUND, oIntangibleTimer, oDamageOrCoinValue, oHealth, oCollisionDistance, oDrawingDistance, oDistanceToMario, oRoom, FloorHeight, PositionX, Position.Y, PositionZ, ACTIVE_FLAGS_DEACTIVATED, ACTIVE_FLAG_DEACTIVATED } from "../include/ObjectConstants"
-- import { mtxf_identity } from "../engine/math_util"
-- import * as _Linker from "./Linker"

local SpawnObject = {}
function SpawnObject._setObjProc(ObjectListProcessor_)
	ObjectListProcessor = ObjectListProcessor_
end


function SpawnObject.try_allocate_object(destList)
	local destList = destList or ObjectListProcessor.objList

	local obj = {
		gfx = {},
	}

	obj.gfx.object = obj
	obj.OBJLIST = destList -- custom

	table.insert(destList, obj)

	--[[local obj = {
		gfx: {},
		next: nil, prev: nil,
		ActiveFlags: 0,
		rawData: new Array(0x50).fill(0),
		ptrData: new Array(0x50).fill(0)
	end
	init_graph_node(obj.gfx, GRAPH_NODE_TYPE_OBJECT)
	obj.gfx.object = obj
	
	obj.prev = destList.prev
	obj.next = destList
	destList.prev.next = obj
	destList.prev = obj

	geo_add_child(gLinker.GeoLayout.gObjParentGraphNode, obj.gfx)]]
	return obj
end

-- Remove from object list
function SpawnObject.deallocate_object(obj)
	-- pretty kinda custom code lol lol lol
	local list = obj.OBJLIST or ObjectListProcessor.objList
	if list then
		local key = table.find(list, obj)
		if key then
			table.remove(list, key)
		end
	end
	local key = table.find(ObjectListProcessor.objList, obj)
	if key then
		table.remove(ObjectListProcessor.objList, key)
	end
	--[[obj.next.prev = obj.prev
	obj.prev.next = obj.next]]
end

function SpawnObject.clear_object_lists()
	-- ugh this is so BAD i dont know if its actually bad
	warn('MEH')
	table.clear(ObjectListProcessor.objList)
	--[[ local gObjectLists = ObjectListProc.gObjectLists
	for (local i = 0; i < ObjectListProc.NUM_OBJ_LISTS; i++) then
		gObjectLists[i].next = gObjectLists[i]
		gObjectLists[i].prev = gObjectLists[i]
	end]]
end

function SpawnObject.unload_object(obj)
	obj.ActiveFlags:Set(ObjectConstants.ACTIVE_FLAGS_DEACTIVATED)
	-- obj.prevObj = nil

	-- obj.gfx.throwMatrix = nil

	--func_803206F8 TODO
	--geo_remove_child(obj.gfx)

	-- obj.gfx.flags:Remove(ObjectConstants.GRAPH_RENDER_BILLBOARD)
	-- obj.gfx.flags:Remove(ObjectConstants.GRAPH_RENDER_ACTIVE)
	-- obj.gfx.flags &= ~GRAPH_RENDER_BILLBOARD
	-- obj.gfx.flags &= ~GRAPH_RENDER_ACTIVE

	SpawnObject.deallocate_object(obj)
end

-- https://github.com/sm64js/sm64js/blob/04c1a984117ebb8d0e7b0d5d2e3424367f69b92d/src/game/ObjectHelpers.js#L292
function SetHeldState(self, heldBehavior) -- self: object
	local o = self

	o.parentObj = ObjectListProcessor.gMarioObject

	heldBehavior = Behaviors[heldBehavior] -- gLinker.Spawn.get_bhv_script(heldBehavior)
	if o.Flags:Has(ObjectConstants.OBJ_FLAG_HOLDABLE) then
		if heldBehavior == Behaviors.bhvCarrySomething3 then
			o.HeldState = ObjectConstants.HELD_HELD
		end

		if heldBehavior == Behaviors.bhvCarrySomething5 then
			o.HeldState = ObjectConstants.HELD_THROWN
		end

		if heldBehavior == Behaviors.bhvCarrySomething4 then
			o.HeldState = ObjectConstants.HELD_DROPPED
		end
	else
		o.curBhvCommand = heldBehavior
		o.bhvStackIndex = 0
	end
end

function SpawnObject.allocate_object(objList)
	--[[const]] local obj = SpawnObject.try_allocate_object(objList)
	
	-- nobonet
	obj.SetHeldState = SetHeldState

	--[[] ]
	obj.ActiveFlags:Set(ObjectConstants.ACTIVE_FLAG_ACTIVE, ObjectConstants.ACTIVE_FLAG_UNK8)
	obj.parentObj = obj
	-- obj.prevObj = nil
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

	-- obj.platform = nil
	-- obj.collisionData = nil
	obj.IntangibleTimer = -1
	obj.DamageOrCoinValue = 0
	obj.Health = 2048

	obj.CollisionDistance = 1000.0
	obj.DrawingDistance = 4000.0

	-- obj.transform = new Array(4).fill(0).map(() => new Array(4).fill(0))
	-- mtxf_identity(obj.transform)

	obj.respawnInfoType = ObjectConstants.RESPAWN_INFO_TYPE_NULL
	-- obj.respawnInfo = nil

	obj.DistanceToMario = 19000.0
	obj.Room = -1

	-- obj.gfx.flags &= ~GRAPH_RENDER_INVISIBLE
	-- obj.gfx.pos = [ -10000.0, -10000.0, -10000.0 ]
	-- obj.gfx.throwMatrix = nil
	--[[]]

	--> ADD PROPERTIES THAT WOULD BE PRESENT IN RAWDATA
	-- ok this probably  sucks
	-- obj.MarkedForDeletion = false

	obj.ActiveFlags = Flags.new(Enums.Object.ActiveFlag.ACTIVE, Enums.Object.ActiveFlag.UNK8)
	-- obj.ActiveFlags:Set(Enums.Object.ActiveFlag.ACTIVE, Enums.Object.ActiveFlag.UNK8)

	obj.parentObj = obj
	obj.CollidedObjInteractTypes = Flags.new()
	obj.NumCollidedObjs = 0 -- possibly unnecessary
	obj.CollidedObjs = {}

	obj.bhvStackIndex = 0
	obj.bhvDelayTimer = 0

	obj.HitboxRadius = 50
	obj.HitboxHeight = 100
	obj.HitboxDownOffset = 0
	obj.HurtboxRadius = 0
	obj.HurtboxHeight = 0
	obj.HurtboxDownOffset = 0
	-- obj.unused2 = 0 -- lol

	-- should this be here IDK??? yk how raw data works though... ughh
	obj.DeathSound = 0

	-- i think these should be here
	obj.BhvParams = Flags.new()
	obj.BhvParams2ndByte = 0

	obj.Platform = nil
	obj.collisionData = nil

	obj.IntangibleTimer = -1
	obj.DamageOrCoinValue = 0
	obj.Health = 2048

	obj.CollisionDistance = 1000
	obj.DrawingDistance = 4000
	
	obj.transform = { [0] =
		{ [0] = 0, 0, 0, 0 },
		{ [0] = 0, 0, 0, 0 },
		{ [0] = 0, 0, 0, 0 },
		{ [0] = 0, 0, 0, 0 },
	} -- new Array(4).fill(0).map(() => new Array(4).fill(0))
	Util.mtxf_identity(obj.transform)

	obj.Flags = Flags.new()
	obj.Action = 0
	obj.MoveFlags = Flags.new()
	obj.InteractType = 0
	obj.InteractStatus = Flags.new()
	obj.InteractionSubtype = Flags.new()
	-- obj.Transform = CFrame.new() ??

	obj.RespawnInfoType = ObjectConstants.RESPAWN_INFO_TYPE_NULL
	obj.RespawnInfo = nil

	obj.DistanceToMario = 19000
	obj.Room = -1

	obj.GfxPos = Vector3.zero
	obj.GfxAngle = Vector3.zero
	-- obj.GfxPos = Vector3.new(-10000, -10000, -10000)
	obj.GfxFlags = Flags.new(GraphNodeConstats.GRAPH_RENDER_ACTIVE)
	obj.GfxScale = Vector3.new(1, 1, 1)

	obj.AngleToMario = 0

	--[[obj.PosX = 0
	obj.PosY = 0
	obj.PosZ = 0
	obj.VelX = 0
	obj.VelY = 0
	obj.VelZ = 0]]
	obj.Position = Vector3.zero
	obj.Home = Vector3.zero
	--[[obj.HomeX = 0 -- nothing for home for some reason oh nooo 
	obj.HomeY = 0
	obj.HomeZ = 0]]
	obj.Velocity = Vector3.zero

	obj.Timer = 0

	obj.FaceAngleYaw = 0
	obj.FaceAngleRoll = 0
	obj.FaceAnglePitch = 0
	obj.MoveAngleYaw = 0
	obj.MoveAngleRoll = 0
	obj.MoveAnglePitch = 0
	obj.AngleVelYaw = 0
	obj.AngleVelRoll = 0
	obj.AngleVelPitch = 0


	obj.AnimState = 0 -- dont ever CCOMMENt THIS OUT UGHHH
	-- this is probably so wrong
	obj.Animations = {}
	obj.AnimAccel = 0
	obj.AnimFrame = -1
	obj.AnimFrameCount = 0
	obj.AnimSetFrame = -1
	obj.AnimDirty = false
	obj.AnimReset = false
	obj.AnimAccelAssist = 0
	obj.AnimSkipInterp = 0
	-- espexailly this
	obj.AnimCurrent = false

	obj.ForwardVel = 0

	obj.HeldState = ObjectConstants.HELD_FREE
	obj.GraphYOffset = 0

	obj.Model = Model.new(obj) -- custom
	obj.Audio = Audio.new(obj) -- custom
	
	obj.Opacity = 255 -- i dthink this should be here I DONT KNOW
	
	-- and these ig
	obj.ParentRelativePos = Vector3.zero
	--[[obj.ParentRelativePosX = 0
	obj.ParentRelativePosY = 0
	obj.ParentRelativePosZ = 0]]

	return obj
end

function SpawnObject.snap_object_to_floor(obj)
	obj.FloorHeight = Util.FindFloor(obj.Position)

	if obj.FloorHeight + 2.0 > obj.Position.Y and obj.Position.Y > obj.FloorHeight - 10.0 then
		-- obj.Position.Y = obj.FloorHeight
		obj.Position = Util.SetY(obj.Position, obj.FloorHeight)
		obj.MoveFlags:Add(ObjectConstants.OBJ_MOVE_ON_GROUND)
	end


	--[[obj.FloorHeight = gLinker.SurfaceCollision.find_floor(obj.PosX, obj.PosY, obj.PosZ, {})

	if (obj.FloorHeight + 2.0 > obj.Position.Y && obj.Position.Y > obj.FloorHeight - 10.0) then
		obj.Position.Y = obj.FloorHeight
		obj.oMoveFlags |= OBJ_MOVE_ON_GROUND
	end]]
end

local function CUSTOM_no_bhv_object()
	local objList = ObjectListProcessor.objList
	local obj = SpawnObject.allocate_object(objList)

	obj.LIST = ObjectListProcessor.OBJ_LIST_DEFAULT
	obj.bhvScript = {}
	
	return obj
end

function SpawnObject.create_object(bhvScript)
	bhvScript = SpawnObject.get_bhv_script(bhvScript)
	if not bhvScript then
		warn('no bhv script for ', bhvScript)
		return CUSTOM_no_bhv_object()
	end
	local objListIndex = SpawnObject.get_bhv_object_list(bhvScript)
	--[[const]] local objList = ObjectListProcessor.objList
	--[[const]] local obj = SpawnObject.allocate_object(objList)

	obj.LIST = objListIndex -- CUSTOM.. sorry,, ,,

	obj.bhvScript = { commands = bhvScript, index = 0, name = SpawnObject.get_bhv_object_name(bhvScript) }
	obj.behavior = bhvScript

	-- CUSTOM
	obj.curBhvCommand = bhvScript
	obj.behavior_id = bhvScript.behavior_id


	if (objListIndex == ObjectListProcessor.OBJ_LIST_UNIMPORTANT) then
		obj.ActiveFlags:Add(ObjectConstants.ACTIVE_FLAG_UNIMPORTANT)
	end

	if objListIndex == ObjectListProcessor.OBJ_LIST_POLELIKE or
		objListIndex == ObjectListProcessor.OBJ_LIST_GENACTOR or
		objListIndex == ObjectListProcessor.OBJ_LIST_PUSHABLE then
		SpawnObject.snap_object_to_floor(obj)
	end

	-- CUSTOM
	(function()
		function obj.BhvUpdate()
			-- print('init next update')
			obj, bhvScript = Behaviors.CallBehaviorScript(bhvScript, obj, bhvScript.name)
			obj.Timer = -1
		end
	end)()


	return obj
	--[[bhvScript = SpawnObject.get_bhv_script(bhvScript)
	if not bhvScript then
		warn('no bhv script for ', bhvScript)
		return nil
	end
	local objListIndex = SpawnObject.get_bhv_object_list(bhvScript)
	local objList = ObjectListProc.gObjectLists[objListIndex]
	local obj = this.allocate_object(objList)

	obj.bhvScript = { commands: bhvScript, index: 0, name: this.get_bhv_object_name(bhvScript) }
	obj.behavior = bhvScript

	if (objListIndex == ObjectListProc.OBJ_LIST_UNIMPORTANT) then
		obj.ActiveFlags |= ACTIVE_FLAG_UNIMPORTANT
	end

	if (objListIndex == ObjectListProc.OBJ_LIST_POLELIKE || 
		objListIndex == ObjectListProc.OBJ_LIST_GENACTOR ||
		objListIndex == ObjectListProc.OBJ_LIST_PUSHABLE) then
		this.snap_object_to_floor(obj)
	end
	return obj]]
end


-- Some behvior scripts cannot be initialized due to circular dependancies,
-- so are left as functions to be initialized when they are needed
-- nno oope
function SpawnObject.get_bhv_script(behavior) 
	return Behaviors.getBehavior(behavior)
	--[[local bhv = behavior
	if typeof(bhv) == "function"  then
		bhv = bhv()
		elseif typeof(bhv) == "string" then
	bhv = Behaviors[bhv]
	if (!bhv) then
		warn(`Behavior script "{behavior}" was never registered!`)
		bhv = Behaviors.bhvCarrySomething6
	end
end

return bhv]]
end

function SpawnObject.get_bhv_object_list(bhvScript)
	bhvScript = SpawnObject.get_bhv_script(bhvScript)

	-- peek at first command
	if type(bhvScript) == 'table' and bhvScript[1][1] == 'BEGIN' then
		return bhvScript[1][2]
	else
		return ObjectListProcessor.OBJ_LIST_DEFAULT
	end
	--[[
	-- peek at first command
	if (Array.isArray(bhvScript[0]) && bhvScript[0][0] == 'BEGIN') then
		return bhvScript[0][1]
	elseif (bhvScript[0].command == BhvCmds.begin) then
		return bhvScript[0].args.objListIndex
	else
		return ObjectListProc.OBJ_LIST_DEFAULT
	end]]
end

function SpawnObject.get_bhv_object_name(bhvScript)
	bhvScript = SpawnObject.get_bhv_script(bhvScript)

	-- peek at first command
	if type(bhvScript) == 'table' and bhvScript[1][1] == 'BEGIN' then
		return bhvScript[1][3]
	else
		return nil
	end

	--[[ peek at first command
	if (Array.isArray(bhvScript[0]) && bhvScript[0][0] == 'BEGIN') then
		return bhvScript[0][2]
	elseif (bhvScript[0].command == BhvCmds.begin) then
		return bhvScript[0].args.name
	else
		return nil
	end]]
end

-- same as helpers tbh?
function SpawnObject.mark_obj_for_deletion(obj)
	-- obj.MarkedForDeletion = true
	-- obj.ActiveFlags:Set(ObjectConstants.ACTIVE_FLAGS_DEACTIVATED)
	obj.ActiveFlags.Value = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED
	-- obj.ActiveFlags = ACTIVE_FLAG_DEACTIVATED;
end

return SpawnObject

--[[local SpawnObjectInstance = SpawnObject
local Spawn = SpawnObjectInstance

return Spawn]]