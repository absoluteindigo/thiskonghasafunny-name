--!strict


local ObjectConstants = require(script.Parent.ObjectConstants)
local GraphNodeConstats = require(script.Parent.GraphNodeConstats)

local RESPAWN_INFO_DONT_RESPAWN, ACTIVE_FLAGS_DEACTIVATED, RESPAWN_INFO_TYPE_32, oPosX, oPosY, oPosZ, oFaceAnglePitch, oFaceAngleRoll, oFaceAngleYaw, oMoveAnglePitch, oMoveAngleRoll, oMoveAngleYaw, oVelX, oVelY, oVelZ, oAngleVelPitch, oAngleVelYaw, oAngleVelRoll, oBhvParams, oBhvParams2ndByte, ACTIVE_FLAG_ACTIVE, RESPAWN_INFO_TYPE_16, oFlags, OBJ_FLAG_PERSISTENT_RESPAWN, oMarioParticleFlags, oActiveParticleFlags, ACTIVE_PARTICLE_DUST, ACTIVE_PARTICLE_V_STAR, ACTIVE_PARTICLE_H_STAR, ACTIVE_PARTICLE_SPARKLES, ACTIVE_PARTICLE_BUBBLE, ACTIVE_PARTICLE_WATER_SPLASH, ACTIVE_PARTICLE_IDLE_WATER_WAVE, ACTIVE_PARTICLE_PLUNGE_BUBBLE, ACTIVE_PARTICLE_WAVE_TRAIL, ACTIVE_PARTICLE_FIRE, ACTIVE_PARTICLE_SHALLOW_WATER_WAVE, ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH, ACTIVE_PARTICLE_LEAF, ACTIVE_PARTICLE_SNOW, ACTIVE_PARTICLE_BREATH, ACTIVE_PARTICLE_DIRT, ACTIVE_PARTICLE_MIST_CIRCLE, ACTIVE_PARTICLE_TRIANGLE, oInteractType, ACTIVE_FLAG_UNIMPORTANT, ACTIVE_FLAG_INITIATED_TIME_STOP =
	ObjectConstants.RESPAWN_INFO_DONT_RESPAWN, ObjectConstants.ACTIVE_FLAGS_DEACTIVATED, ObjectConstants.RESPAWN_INFO_TYPE_32, ObjectConstants.oPosX, ObjectConstants.oPosY, ObjectConstants.oPosZ, ObjectConstants.oFaceAnglePitch, ObjectConstants.oFaceAngleRoll, ObjectConstants.oFaceAngleYaw, ObjectConstants.oMoveAnglePitch, ObjectConstants.oMoveAngleRoll, ObjectConstants.oMoveAngleYaw, ObjectConstants.oVelX, ObjectConstants.oVelY, ObjectConstants.oVelZ, ObjectConstants.oAngleVelPitch, ObjectConstants.oAngleVelYaw, ObjectConstants.oAngleVelRoll, ObjectConstants.oBhvParams, ObjectConstants.oBhvParams2ndByte, ObjectConstants.ACTIVE_FLAG_ACTIVE, ObjectConstants.RESPAWN_INFO_TYPE_16, ObjectConstants.oFlags, ObjectConstants.OBJ_FLAG_PERSISTENT_RESPAWN, ObjectConstants.oMarioParticleFlags, ObjectConstants.oActiveParticleFlags, ObjectConstants.ACTIVE_PARTICLE_DUST, ObjectConstants.ACTIVE_PARTICLE_V_STAR, ObjectConstants.ACTIVE_PARTICLE_H_STAR, ObjectConstants.ACTIVE_PARTICLE_SPARKLES, ObjectConstants.ACTIVE_PARTICLE_BUBBLE, ObjectConstants.ACTIVE_PARTICLE_WATER_SPLASH, ObjectConstants.ACTIVE_PARTICLE_IDLE_WATER_WAVE, ObjectConstants.ACTIVE_PARTICLE_PLUNGE_BUBBLE, ObjectConstants.ACTIVE_PARTICLE_WAVE_TRAIL, ObjectConstants.ACTIVE_PARTICLE_FIRE, ObjectConstants.ACTIVE_PARTICLE_SHALLOW_WATER_WAVE, ObjectConstants.ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH, ObjectConstants.ACTIVE_PARTICLE_LEAF, ObjectConstants.ACTIVE_PARTICLE_SNOW, ObjectConstants.ACTIVE_PARTICLE_BREATH, ObjectConstants.ACTIVE_PARTICLE_DIRT, ObjectConstants.ACTIVE_PARTICLE_MIST_CIRCLE, ObjectConstants.ACTIVE_PARTICLE_TRIANGLE, ObjectConstants.oInteractType, ObjectConstants.ACTIVE_FLAG_UNIMPORTANT, ObjectConstants.ACTIVE_FLAG_INITIATED_TIME_STOP

local SM64 = script.Parent.Parent.Parent
local Root = SM64.Parent.Parent

local Types = require(SM64.Types)
local Mario = require(SM64.Mario)
local Enums = require(SM64.Enums)
local Util = require(SM64.Util)

local Object = script.Parent
local ObjectHelpers = require(Object.ObjectHelpers)
local ObjectConstants = require(Object.ObjectConstants)
local behaviors = require(Object.behaviors)

local SurfaceCollission = require(Object.Parent.Parent.Custom.SurfaceCollission)
local CollissionData = SurfaceCollission.CollissionData

local Sounds = Mario.Sounds

local Action = Enums.Action
local ActionFlags = Enums.ActionFlags
local InputFlags = Enums.InputFlags

local MarioFlags = Enums.MarioFlags
local ParticleFlags = Enums.ParticleFlags

local InteractionType = Enums.Interaction.Type
local AttackType = Enums.Interaction.AttackType
local InteractionStatus = Enums.Interaction.Status
local InteractionMethod = Enums.Interaction.Method
local InteractionSubtype = Enums.Interaction.Subtype

local CameraShake = Enums.Camera.Shake
local gMarioObject = nil :: Types.MarioState

type Mario = Mario.Mario

-- Replace with your own Object type, if any
type Object = Types.ObjectState

-- helpers

-- class
local BehaviorCommands = {
	gCurrentObject = nil :: Types.ObjectState
}-- :: {[any]: any}

function BehaviorCommands.setMario(Mario: Types.MarioState)
	gMarioObject = Mario
end



-- THIS IS MOSTLY CUSTOM STUFFFFFF

local function getBehavior(key)
	return behaviors[key]
end

local commandCase = {
	OR_INT = function(gCurrentObject, args)
		print(args)
		if not args or not args.field or not args.value then
			warn("OR_INT missing field or value")
			return
		end

		local fieldName = args.field
		local value = args.value -- bit32.band(args.value, 0xFFFF)

		local field = gCurrentObject[fieldName]

		if field then
			field:Add(value)
		end
		--[[if field and type(field.Add) == "function" then
			field:Add(value)
		elseif type(field) == "number" then
			-- If it's just a number, do a simple bitwise OR
			gCurrentObject[fieldName] = bit32.bor(field, value)
		else
			warn("OR_INT: Invalid field type for", fieldName)
		end]]
		--[[print(args)
		if not args then return end
		local objectOffset = args.field
		local value = args.value

		value = bit32.band(value, 0xFFFF)
		gCurrentObject.objectOffset = bit32.bor(gCurrentObject.objectOffset, value)]]
	end,
	DROP_TO_FLOOR = function(gCurrentObject)
		local x = gCurrentObject.Position.X
		local y = gCurrentObject.Position.Y :: number -- rlly dude
		local z = gCurrentObject.Position.Z

		-- warn('TODO TODO:: find_floor_height')
		local floorHeight, floor = Util.FindFloor(Vector3.new(x, y + 200.0, z))
		-- local floorHeight = y -- gLinker.SurfaceCollision.find_floor_height(x, y + 200.0, z)

		-- gCurrentObject.Position.Y = floorHeight
		gCurrentObject.Position = Util.SetY(gCurrentObject.Position, floorHeight)
		gCurrentObject.MoveFlags:Add(ObjectConstants.OBJ_MOVE_ON_GROUND)
		-- gCurrentObject.MoveFlags = bit32.bor(gCurrentObject.MoveFlags, OBJ_MOVE_ON_GROUND)
	end,
	SET_HOME = function(gCurrentObject)
		--local gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
		gCurrentObject.Home = gCurrentObject.Position
		--[[gCurrentObject.rawData[oHomeX] = gCurrentObject.rawData[oPosX]
		gCurrentObject.rawData[oHomeY] = gCurrentObject.rawData[oPosY]
		gCurrentObject.rawData[oHomeZ] = gCurrentObject.rawData[oPosZ] ]]
	end,
	SET_OBJ_PHYSICS = function(gCurrentObject, args)
		gCurrentObject.WallHitboxRadius = args.HitboxRadius
		gCurrentObject.Gravity = args.gravity / 100.0
		gCurrentObject.Bounciness = args.bounciness / 100.0
		gCurrentObject.DragStrength = args.dragStrenth / 100.0
		gCurrentObject.Friction = args.friction / 100.0
		gCurrentObject.Buoyancy = args.buoyancy / 100.0
	end,
	CALL_NATIVE = function(gCurrentObject, key)
		-- this is custom code tbh
		local func = getBehavior(key)
		if not func then
			warn('nothing found for')
			print(key)
			return
		end
		return func(gCurrentObject)
	end,

	none = function()
		return 'missing'
	end,
}

local commandArgCase = {
	OR_INT = function(command)
		return {
			field = command[2],
			value = command[3]
		}
	end,
	CALL_NATIVE = function(command)
		return command[2]
	end,
	SET_OBJ_PHYSICS = function(command)
		return {
			HitboxRadius = command[2],
			gravity = command[3],
			bounciness = command[4],
			dragStrenth = command[5],
			friction = command[6],
			buoyancy = command[7],
			wallHitboxRadius = command[8],
			wallHitboxHeight = command[9]
		}
	end,
}

function CallBehaviorScript(behavior, object, name)
	local loop

	for _, command in ipairs(behavior) do
		local commandType = command[1]

		if commandType == 'BEGIN_LOOP' then
			loop = {}
			continue
		end
		if loop and commandType ~= 'END_LOOP' then
			table.insert(loop, command)
			continue
		end

		local args = Util.Switch(commandType, commandArgCase, command) or {}
		if Util.Switch(commandType, commandCase, object, args) == 'missing' then
			warn('UNKNOWN command: ', commandType)
		end
	end

	if loop then
		function object:BhvUpdate()
			CallBehaviorScript(loop, self, name)
		end
	end

	return object, behavior
end













function BehaviorCommands.obj_update_gfx_pos_and_angle(obj)
	--[[obj.GfxPos = Vector3.new(
		obj.Position.X,
		obj.Position.Y + obj.GraphYOffset,
		obj.Position.Z
	)]]obj.GfxPos = Vector3.new(
		0,
		obj.GraphYOffset,
		0
	)
	obj.GfxAngle = Vector3.new(
		bit32.band(obj.FaceAnglePitch, 0xFFFF),
		bit32.band(obj.FaceAngleYaw, 0xFFFF),
		bit32.band(obj.FaceAngleRoll, 0xFFFF)
	)
end

function BehaviorCommands.cur_obj_update(gCurrentObject: Object) 
	-- const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
	-- const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

	local objFlags = gCurrentObject.Flags
	local distanceFromMario = 0.0

	-- Calculate the distance from the object to Mario.
	if objFlags:Has(ObjectConstants.OBJ_FLAG_COMPUTE_DIST_TO_MARIO) then
		gCurrentObject.DistanceToMario = ObjectHelpers.dist_between_objects(gCurrentObject, gMarioObject)
		distanceFromMario = gCurrentObject.DistanceToMario
	end

	-- Calculate the angle from the object to Mario.
	if objFlags:Has(ObjectConstants.OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO) then
		gCurrentObject.AngleToMario = ObjectHelpers.obj_angle_to_object(gCurrentObject, gMarioObject)
	end

	-- If the object's action has changed, reset the action timer.
	if gCurrentObject.Action ~= gCurrentObject.PrevAction then
		gCurrentObject.Timer = 0
		gCurrentObject.SubAction = 0
		gCurrentObject.PrevAction = gCurrentObject.Action
	end

	-- Execute the behavior script.
	-- TODO:
	-- CUSTOM CODE HERE
	local bhvScript = gCurrentObject.bhvScript
	--[[if gCurrentObject.behavior then
		CallBehaviorScript(gCurrentObject.behavior, gCurrentObject)
		gCurrentObject.behavior = nil
	end]]
	
	if bhvScript and gCurrentObject.BhvUpdate then
		gCurrentObject:BhvUpdate()
		
		if gCurrentObject.ActiveFlags.Value == ACTIVE_FLAGS_DEACTIVATED then
			-- dont continue if this has been deactivated (CUSTOM)
			return
		end
		-- CallBehaviorScript(bhvScript)
	end
	--[[this.bhvScript = gCurrentObject.bhvScript
	local bhvProcResult = this.BHV_PROC_CONTINUE

	while (bhvProcResult == this.BHV_PROC_CONTINUE) do
		local bhvFunc = this.bhvScript.commands[this.bhvScript.index]
		bhvProcResult = bhvFunc.command.call(this, bhvFunc.args)
	end]]

	-- Increment the object's timer.
	if gCurrentObject.Timer < 0x3FFFFFFF then
		gCurrentObject.Timer += 1
	end

	if gCurrentObject.Action ~= gCurrentObject.PrevAction then
		gCurrentObject.Timer = 0
		gCurrentObject.SubAction = 0
		gCurrentObject.PrevAction = gCurrentObject.Action
	end

	objFlags = gCurrentObject.Flags

	if objFlags:Has(ObjectConstants.OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW) then
		gCurrentObject.FaceAngleYaw = gCurrentObject.MoveAngleYaw
	end

	if objFlags:Has(ObjectConstants.OBJ_FLAG_MOVE_XZ_USING_FVEL) then
		ObjectHelpers.cur_obj_move_xz_using_fvel_and_yaw(gCurrentObject)
	end

	if objFlags:Has(ObjectConstants.OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE) then
		BehaviorCommands.obj_update_gfx_pos_and_angle(gCurrentObject)
	end
	
	
	
	-- Handle visibility of object
	--[[]]
	if gCurrentObject.Room ~= -1 then
		print('object is in a room')
		-- If the object is in a room, only show it when Mario is in the room.
		--throw "object is in a room - cur_obj_enable_rendering_if_mario_in_room"
	elseif (objFlags:Has(ObjectConstants.OBJ_FLAG_COMPUTE_DIST_TO_MARIO)) and gCurrentObject.collisionData == nil then
		if not (objFlags:Has(ObjectConstants.OBJ_FLAG_ACTIVE_FROM_AFAR)) then
			-- If the object has a render distance, check if it should be shown.
			if distanceFromMario > gCurrentObject.DrawingDistance then
				-- gCurrentObject.gfx.flags = bit32.band(gCurrentObject.gfx.flags, bit32.bnot(GRAPH_RENDER_ACTIVE))
				-- gCurrentObject.ActiveFlags = bit32.bor(gCurrentObject.ActiveFlags, ACTIVE_FLAG_FAR_AWAY)
				gCurrentObject.GfxFlags:Remove(GraphNodeConstats.GRAPH_RENDER_ACTIVE)
				gCurrentObject.ActiveFlags:Add(ObjectConstants.ACTIVE_FLAG_FAR_AWAY)	
			elseif gCurrentObject.HeldState == ObjectConstants.HELD_FREE then
				-- gCurrentObject.gfx.flags = bit32.bor(gCurrentObject.gfx.flags, GRAPH_RENDER_ACTIVE)
				-- gCurrentObject.ActiveFlags = bit32.band(gCurrentObject.ActiveFlags, bit32.bnot(ACTIVE_FLAG_FAR_AWAY))
				gCurrentObject.GfxFlags:Add(GraphNodeConstats.GRAPH_RENDER_ACTIVE)
				gCurrentObject.ActiveFlags:Remove(ObjectConstants.ACTIVE_FLAG_FAR_AWAY)	
			end
		end
	end
	--[[]]
end





return BehaviorCommands