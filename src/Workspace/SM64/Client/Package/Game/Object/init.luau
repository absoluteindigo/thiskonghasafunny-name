local function band(...)
	return bit32.band(...) ~= 0
end

local Package = script.Parent.Parent

local Types = require(Package.Types)
local Util = require(Package.Util)
local Enums = require(Package.Enums)

local ObjectListProcessor = require(script.ObjectListProcessor)
local ObjectHelpers = require(script.ObjectHelpers)
local ObjectConstants = require(script.ObjectConstants)
local Behaviors = require(script.behaviors)
local BehaviorData = require(script.BehaviorData)
local ObjBehaviors = require(script.ObjBehaviors)
local ObjBehaviors2 = require(script.ObjBehaviors2)
local BehaviorCommands = require(script.BehaviorCommands)
local ObjectCollisions = require(script.ObjectCollisions)
local SpawnObject = require(script.SpawnObject)
local SpawnSound = require(script.SpawnSound)
local Models = require(script.Models)
local GraphNodeConstats = require(script.GraphNodeConstats)

local Model = require(script.Parent.Parent.Custom.Model)

local cur_obj_update = BehaviorCommands.cur_obj_update

local ObjectClass = {
	ObjectListProcessor = ObjectListProcessor,
	ObjectHelpers = ObjectHelpers,
	ObjectConstants = ObjectConstants,
	GraphNodeConstats = GraphNodeConstats,
	Behaviors = Behaviors,
	BehaviorData = BehaviorData,
	ObjBehaviors = ObjBehaviors,
	ObjBehaviors2 = ObjBehaviors2,
	BehaviorCommands = BehaviorCommands,
	ObjectCollisions = ObjectCollisions,
	SpawnObject = SpawnObject,
	SpawnSound = SpawnSound,
	Models = Models,

	-- custom stuff does in the custom table
	Custom = {
		Model,
	},
}

local mario = {} :: Types.MarioState

function ObjectClass.initalize(Mario: Types.MarioState)
	mario = Mario
	for k, v in pairs(ObjectClass) do
		if v == Models then continue end
		if type(v) == 'table' and v.setMario then
			v.setMario(Mario)
		end
	end
	require(script.gMarioObject).m = Mario
end

local Entities = ObjectListProcessor.objList
ObjectClass.Entities = Entities


local ObjectLists = {}

local TIME_STOP_UNKNOWN_0 = ObjectListProcessor.TIME_STOP_UNKNOWN_0
local TIME_STOP_ENABLED = ObjectListProcessor.TIME_STOP_ENABLED
local TIME_STOP_DIALOG = ObjectListProcessor.TIME_STOP_DIALOG
local TIME_STOP_MARIO_AND_DOORS = ObjectListProcessor.TIME_STOP_MARIO_AND_DOORS
local TIME_STOP_ALL_OBJECTS = ObjectListProcessor.TIME_STOP_ALL_OBJECTS
local TIME_STOP_MARIO_OPENED_DOOR = ObjectListProcessor.TIME_STOP_MARIO_OPENED_DOOR
local TIME_STOP_ACTIVE = ObjectListProcessor.TIME_STOP_ACTIVE

local OBJ_LIST_PLAYER = ObjectListProcessor.OBJ_LIST_PLAYER
local OBJ_LIST_UNUSED_1 = ObjectListProcessor.OBJ_LIST_UNUSED_1
local OBJ_LIST_DESTRUCTIVE = ObjectListProcessor.OBJ_LIST_DESTRUCTIVE
local OBJ_LIST_UNUSED_3 = ObjectListProcessor.OBJ_LIST_UNUSED_3
local OBJ_LIST_GENACTOR = ObjectListProcessor.OBJ_LIST_GENACTOR
local OBJ_LIST_PUSHABLE = ObjectListProcessor.OBJ_LIST_PUSHABLE
local OBJ_LIST_LEVEL = ObjectListProcessor.OBJ_LIST_LEVEL
local OBJ_LIST_UNUSED_7 = ObjectListProcessor.OBJ_LIST_UNUSED_7
local OBJ_LIST_DEFAULT = ObjectListProcessor.OBJ_LIST_DEFAULT
local OBJ_LIST_SURFACE = ObjectListProcessor.OBJ_LIST_SURFACE
local OBJ_LIST_POLELIKE = ObjectListProcessor.OBJ_LIST_POLELIKE
local OBJ_LIST_SPAWNER = ObjectListProcessor.OBJ_LIST_SPAWNER
local OBJ_LIST_UNIMPORTANT = ObjectListProcessor.OBJ_LIST_UNIMPORTANT
local NUM_OBJ_LISTS = ObjectListProcessor.NUM_OBJ_LISTS
local GRAPH_RENDER_INVISIBLE = GraphNodeConstats.GRAPH_RENDER_INVISIBLE

-- CUSTOM
function ObjectClass.Custom.SpawnObject(behavior, model, pos, yaw, properties)
	local object = SpawnObject.create_object(behavior) -- ObjectHelpers.spawn_object_at_origin(nil, model, behavior)

	if model then
		object.Model:SetModel(model)
	end

	if properties then
		for k, v in pairs(properties) do
			object[k] = v
		end
	end
	if pos then
		object.Position = pos
		object.Home = pos
		-- object.HomeX, object.HomeY, object.HomeZ = pos.X, pos.Y, pos.Z
	end
	if yaw then
		object.FaceAngleYaw = yaw
		object.MoveAngleYaw = yaw
	end

	--
	if object.BhvUpdate then
		object:BhvUpdate()
	end

	return object
end

-- we are definately NOT in order yikes
--[[function update_objects()

        --gLinker.SurfaceLoad.clear_dynamic_surfaces()
        this.update_terrain_objects()

        gLinker.PlatformDisplacement.apply_mario_platform_displacement()

        ObjectCollisions.detect_object_collisions()
        this.update_non_terrain_objects()

        this.unload_deactivated_objects()

        --gLinker.PlatformDisplacement.update_mario_platform()

       -- if (this.gTimeStopState & TIME_STOP_ENABLED) this.gTimeStopState |= TIME_STOP_ACTIVE;
        --else this.gTimeStopState &= ~TIME_STOP_ACTIVE;
    end]]
local ACTIVE_FLAGS_DEACTIVATED = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED

local removalQueue = {}

-- im getting worse at these names
local function checkDeletion(entity)
	--if entity.markForDeletion then
	if entity.ActiveFlags.Value == ACTIVE_FLAGS_DEACTIVATED then
		-- if entity.MarkedForDeletion or entity.ActiveFlags.Value == ACTIVE_FLAGS_DEACTIVATED then
		table.insert(removalQueue, entity)
		return true
	end
	return false
end
local function rawUpdate(entity)
	entity.MODEL_FROZEN = nil

	entity.GfxFlags:Remove(GRAPH_RENDER_INVISIBLE)

	--> ANIMATION
	local animLooped = if entity.AnimCurrent then (not not entity.AnimCurrent:GetAttribute("Loop")) else false

	-- DELTA IS CUSTO<MMM
	local delta = 1 + (entity.AnimAccel / 0x10000) -- 1

	if animLooped then
		entity.AnimFrame += delta
		entity.AnimFrame %= (entity.AnimFrameCount + 1)
	elseif entity.AnimFrame < entity.AnimFrameCount then
		entity.AnimFrame += delta
	end

	if entity.AnimAccel > 0 then
		entity.AnimAccelAssist += entity.AnimAccel
		entity.AnimAccelAssist %= bit32.lshift(entity.AnimFrameCount + 1, 0x10)
	end

	entity.AnimDirty = true
	entity.ThrowMatrix = nil
	entity.AnimSkipInterp = math.max(0, entity.AnimSkipInterp - 1)

	--> DELAY TIMER (CUSTOM IMPLEMENTATION)
	if entity.DELAY_TIMER then
		if entity.DELAY_TIMER == 0 then
			entity.DELAY_TIMER = nil
		else
			entity.DELAY_TIMER -= 1

			--> SURFACE COLLISSIONS (CUSTOM IMPLEMENTATION)
			if entity.OBJ_COL then
				entity.OBJ_COL:Update()
			end

			--> MODEL
			if entity.Model then
				entity.Model:Update()
			end
			return
		end
	end

	--> BEHAVIOR
	cur_obj_update(entity)

	--> SURFACE COLLISSIONS (CUSTOM IMPLEMENTATION)
	if entity.OBJ_COL then
		entity.OBJ_COL:Update()
	end

	--> ANIMATION 2
	if entity.AnimReset then
		-- Previously it was (entity.AnimFrame = 0), which would
		-- just ignore StartFrame. SetAnimation takes care of
		-- StartFrame stuff as intended, but also applies
		-- AnimReset (previously only setting to 0), which
		-- then effectively ditches that process of using
		-- StartFrame in the first place. Yikes!
		entity.AnimFrame = if entity.AnimCurrent then (entity.AnimCurrent:GetAttribute("StartFrame") or 0) else 0
	end

	--> MODEL
	if entity.Model then
		entity.Model:Update()
	end
	
	--> AUDIO
	if entity.Audio then
		entity.Audio:Update()
	end

	-- entity:BhvUpdate()
	--> EXTRA (custom,?)

	entity.GfxPos = Vector3.zero
	entity.GfxAngle = Vector3.zero -- Vector3int16.new()
end
local function updateObject(entity)
	if checkDeletion(entity) then return end
	-- if entity.BhvUpdate then
	rawUpdate(entity)
	-- end
end

local INTERACT_DOOR = Enums.Interaction.Method.DOOR
local INTERACT_WARP_DOOR = Enums.Interaction.Method.WARP_DOOR
local ACTIVE_FLAG_UNIMPORTANT = ObjectConstants.ACTIVE_FLAG_UNIMPORTANT
local ACTIVE_FLAG_INITIATED_TIME_STOP = ObjectConstants.ACTIVE_FLAG_INITIATED_TIME_STOP

local function updateObjectDuringTimeStop(entity)
	if checkDeletion(entity) then return end
	if entity.BhvUpdate then
		local unfrozen = false

		-- Selectively unfreeze certain objects
		if not band(ObjectListProcessor.gTimeStopState, TIME_STOP_ALL_OBJECTS) then
			-- gMarioObject
			if entity == mario and not band(ObjectListProcessor.gTimeStopState, TIME_STOP_MARIO_AND_DOORS) then
				unfrozen = true
			elseif band(entity.InteractType, bit32.bor(INTERACT_DOOR, INTERACT_WARP_DOOR))
				and not band(ObjectListProcessor.gTimeStopState, TIME_STOP_MARIO_AND_DOORS) then
				--if entity.rawData[oInteractType] & (INTERACT_DOOR | INTERACT_WARP_DOOR) && !(this.gTimeStopState & TIME_STOP_MARIO_AND_DOORS))
				unfrozen = true;
			elseif band(entity.ActiveFlags(), bit32.bor(ACTIVE_FLAG_UNIMPORTANT, ACTIVE_FLAG_INITIATED_TIME_STOP)) then
				--if entity.ActiveFlags & (ACTIVE_FLAG_UNIMPORTANT | ACTIVE_FLAG_INITIATED_TIME_STOP))
				unfrozen = true
			end
		end

		-- Only update if unfrozen
		if unfrozen then
			rawUpdate(entity)
		else
			entity.MODEL_FROZEN = true
			--[[ freeze animation
			local Model = entity.Model
			if Model then

				if Model.activeTrack then
					Model.activeTrack:AdjustSpeed(0)
				end
			end]]
			-- this.gCurrentObject.gfx.flags &= ~GraphNode.GRAPH_RENDER_HAS_ANIMATION;
		end
	end
end

local function destroyObject(entity)
	if entity.Model then
		entity.Model:Destroy()
	end

	if entity.OBJ_COL then
		entity.OBJ_COL:Destroy()
	end

	entity.BhvUpdate = nil
	entity.Model = nil
	entity.OBJ_COL = nil

	table.remove(Entities, table.find(Entities, entity))
end

local function updateObjectsInList(list)
	for i, object in ipairs(list) do
		if not band(ObjectListProcessor.gTimeStopState, TIME_STOP_ACTIVE) then
			updateObject(object)
		else
			updateObjectDuringTimeStop(object)
		end
	end
end

local function updateTerrainObjects()
	updateObjectsInList(ObjectLists[OBJ_LIST_SPAWNER])
	updateObjectsInList(ObjectLists[OBJ_LIST_SURFACE])
end
local function updateNonTerrainObjects()
	for i = 2, #ObjectListProcessor.sObjectListUpdateOrder do
		local listIndex = ObjectListProcessor.sObjectListUpdateOrder[i]
		updateObjectsInList(ObjectLists[listIndex])
	end

end

-- runs on every game tick
function ObjectClass.tick()
	-- CUSTOM
	ObjectLists = ObjectCollisions.categorizeObjectList()

	-- SurfaceLoad.clear_dynamic_surfaces
	updateTerrainObjects()

	-- apply_mario_platform_displacement

	ObjectCollisions.detect_object_collisions()
	updateNonTerrainObjects()

	--[[for i, object in ipairs(Entities) do
		updateObject(object)
	end]]
	-- unload_deactivated_objects
	for i, object in pairs(removalQueue) do
		destroyObject(object)
	end

	-- PlatformDisplacement.update_mario_platform

	if band(ObjectListProcessor.gTimeStopState, TIME_STOP_ENABLED) then
		ObjectListProcessor.gTimeStopState = bit32.bor(ObjectListProcessor.gTimeStopState, TIME_STOP_ACTIVE)
	else
		ObjectListProcessor.gTimeStopState = bit32.band(ObjectListProcessor.gTimeStopState, bit32.bnot(TIME_STOP_ACTIVE))
		-- ObjectListProcessor.gTimeStopState &= ~TIME_STOP_ACTIVE
	end

	--  this.gPrevFrameObjectCount = this.gObjectCounter

	removalQueue = {}
end

function ObjectClass.update(dt: number, subframe: number)
	-- rendering
	local paused = Util.Paused

	for i, entity in ipairs(Entities) do
		local Model = entity.Model
		if Model then
			if entity.MODEL_FROZEN or paused then
				if Model.activeTrack then
					Model.activeTrack:AdjustSpeed(0)
				end
			else	
				Model:Render(subframe)
			end	
		end
	end

	--[[local heldObj = mario.HeldObj
	if heldObj then
		if heldObj.Model then

		end
	end]]
end

return ObjectClass