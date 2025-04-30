--!strict


local ObjectConstants = require(script.Parent.ObjectConstants)
local RESPAWN_INFO_DONT_RESPAWN, ACTIVE_FLAGS_DEACTIVATED, RESPAWN_INFO_TYPE_32, oPosX, oPosY, oPosZ, oFaceAnglePitch, oFaceAngleRoll, oFaceAngleYaw, oMoveAnglePitch, oMoveAngleRoll, oMoveAngleYaw, oVelX, oVelY, oVelZ, oAngleVelPitch, oAngleVelYaw, oAngleVelRoll, oBhvParams, oBhvParams2ndByte, ACTIVE_FLAG_ACTIVE, RESPAWN_INFO_TYPE_16, oFlags, OBJ_FLAG_PERSISTENT_RESPAWN, oMarioParticleFlags, oActiveParticleFlags, ACTIVE_PARTICLE_DUST, ACTIVE_PARTICLE_V_STAR, ACTIVE_PARTICLE_H_STAR, ACTIVE_PARTICLE_SPARKLES, ACTIVE_PARTICLE_BUBBLE, ACTIVE_PARTICLE_WATER_SPLASH, ACTIVE_PARTICLE_IDLE_WATER_WAVE, ACTIVE_PARTICLE_PLUNGE_BUBBLE, ACTIVE_PARTICLE_WAVE_TRAIL, ACTIVE_PARTICLE_FIRE, ACTIVE_PARTICLE_SHALLOW_WATER_WAVE, ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH, ACTIVE_PARTICLE_LEAF, ACTIVE_PARTICLE_SNOW, ACTIVE_PARTICLE_BREATH, ACTIVE_PARTICLE_DIRT, ACTIVE_PARTICLE_MIST_CIRCLE, ACTIVE_PARTICLE_TRIANGLE, oInteractType, ACTIVE_FLAG_UNIMPORTANT, ACTIVE_FLAG_INITIATED_TIME_STOP =
	ObjectConstants.RESPAWN_INFO_DONT_RESPAWN, ObjectConstants.ACTIVE_FLAGS_DEACTIVATED, ObjectConstants.RESPAWN_INFO_TYPE_32, ObjectConstants.oPosX, ObjectConstants.oPosY, ObjectConstants.oPosZ, ObjectConstants.oFaceAnglePitch, ObjectConstants.oFaceAngleRoll, ObjectConstants.oFaceAngleYaw, ObjectConstants.oMoveAnglePitch, ObjectConstants.oMoveAngleRoll, ObjectConstants.oMoveAngleYaw, ObjectConstants.oVelX, ObjectConstants.oVelY, ObjectConstants.oVelZ, ObjectConstants.oAngleVelPitch, ObjectConstants.oAngleVelYaw, ObjectConstants.oAngleVelRoll, ObjectConstants.oBhvParams, ObjectConstants.oBhvParams2ndByte, ObjectConstants.ACTIVE_FLAG_ACTIVE, ObjectConstants.RESPAWN_INFO_TYPE_16, ObjectConstants.oFlags, ObjectConstants.OBJ_FLAG_PERSISTENT_RESPAWN, ObjectConstants.oMarioParticleFlags, ObjectConstants.oActiveParticleFlags, ObjectConstants.ACTIVE_PARTICLE_DUST, ObjectConstants.ACTIVE_PARTICLE_V_STAR, ObjectConstants.ACTIVE_PARTICLE_H_STAR, ObjectConstants.ACTIVE_PARTICLE_SPARKLES, ObjectConstants.ACTIVE_PARTICLE_BUBBLE, ObjectConstants.ACTIVE_PARTICLE_WATER_SPLASH, ObjectConstants.ACTIVE_PARTICLE_IDLE_WATER_WAVE, ObjectConstants.ACTIVE_PARTICLE_PLUNGE_BUBBLE, ObjectConstants.ACTIVE_PARTICLE_WAVE_TRAIL, ObjectConstants.ACTIVE_PARTICLE_FIRE, ObjectConstants.ACTIVE_PARTICLE_SHALLOW_WATER_WAVE, ObjectConstants.ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH, ObjectConstants.ACTIVE_PARTICLE_LEAF, ObjectConstants.ACTIVE_PARTICLE_SNOW, ObjectConstants.ACTIVE_PARTICLE_BREATH, ObjectConstants.ACTIVE_PARTICLE_DIRT, ObjectConstants.ACTIVE_PARTICLE_MIST_CIRCLE, ObjectConstants.ACTIVE_PARTICLE_TRIANGLE, ObjectConstants.oInteractType, ObjectConstants.ACTIVE_FLAG_UNIMPORTANT, ObjectConstants.ACTIVE_FLAG_INITIATED_TIME_STOP

local SM64 = script.Parent.Parent.Parent
local Root = SM64.Parent.Parent

local Types = require(SM64.Types)
local Mario = require(SM64.Mario)
local Enums = require(SM64.Enums)
local Util = require(SM64.Util)

local Object = script.Parent
local ObjectConstants = require(Object.ObjectConstants)
local BehaviorCommands = require(Object.BehaviorCommands)

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
local ObjectListProcessor = {
	gMarioObject = gMarioObject,

	objList = {}, -- CUSTOM AHHHH
	gMarioCurrentRoom = -1, -- WHATEVER
	gDoorAdjacentRooms = {[-1] = {}}, -- ok..
	gTimeStopState = 0, -- ok ok ok ok ok!!

	gCurrentObject = nil :: Types.ObjectState,

	TIME_STOP_UNKNOWN_0 = bit32.lshift(1, 0),
	TIME_STOP_ENABLED = bit32.lshift(1, 1),
	TIME_STOP_DIALOG = bit32.lshift(1, 2),
	TIME_STOP_MARIO_AND_DOORS = bit32.lshift(1, 3),
	TIME_STOP_ALL_OBJECTS = bit32.lshift(1, 4),
	TIME_STOP_MARIO_OPENED_DOOR = bit32.lshift(1, 5),
	TIME_STOP_ACTIVE = bit32.lshift(1, 6),

	OBJ_LIST_PLAYER = 0,        --  (0) mario
	OBJ_LIST_UNUSED_1 = 1,      --  bit32.lshift(1) (unused)
	OBJ_LIST_DESTRUCTIVE = 2,   --  (2) things that can be used to destroy other objects, like
	--      bob-ombs and corkboxes
	OBJ_LIST_UNUSED_3 = 3,      --  (3) (unused)
	OBJ_LIST_GENACTOR = 4,      --  (4) general actors. most normal 'enemies' or actors are
	--      on this list. (MIPS, bullet bill, bully, etc)
	OBJ_LIST_PUSHABLE = 5,      --  (5) pushable actors. This is a group of objects which
	--      can push each other around as well as their parent
	--      objects. (goombas, koopas, spinies)
	OBJ_LIST_LEVEL = 6,         --  (6) level objects. general level objects such as heart, star
	OBJ_LIST_UNUSED_7 = 7,      --  (7) (unused)
	OBJ_LIST_DEFAULT = 8,       --  (8) default objects. objects that didnt start with a 00
	--      command are put here, so this is treated as a default.
	OBJ_LIST_SURFACE = 9,       --  (9) surface objects. objects that specifically have surface
	--      collision and not object collision. (thwomp, whomp, etc)
	OBJ_LIST_POLELIKE = 10,     -- (10) polelike objects. objects that attract or otherwise
	--      "cling" mario similar to a pole action. (hoot,
	--      whirlpool, trees/poles, etc)
	OBJ_LIST_SPAWNER = 11,      -- (11) spawners
	OBJ_LIST_UNIMPORTANT = 12,  -- (12) unimportant objects. objects that will not load
	--      if there are not enough object slots: they will also
	--      be manually unloaded to make room for slots if the list
	--      gets exhausted.
	NUM_OBJ_LISTS = 13,

} -- :: {[any]: any}

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

ObjectListProcessor.sObjectListUpdateOrder = { [0] =
	ObjectListProcessor.OBJ_LIST_SPAWNER,
	ObjectListProcessor.OBJ_LIST_SURFACE,
	ObjectListProcessor.OBJ_LIST_POLELIKE,
	ObjectListProcessor.OBJ_LIST_PLAYER,
	ObjectListProcessor.OBJ_LIST_PUSHABLE,
	ObjectListProcessor.OBJ_LIST_GENACTOR,
	ObjectListProcessor.OBJ_LIST_DESTRUCTIVE,
	ObjectListProcessor.OBJ_LIST_LEVEL,
	ObjectListProcessor.OBJ_LIST_DEFAULT,
	ObjectListProcessor.OBJ_LIST_UNIMPORTANT,
}

function ObjectListProcessor.setMario(Mario: Types.MarioState)
	gMarioObject = Mario
	warn('TODO: remove nobonet\'s MarioObj thing')
	gMarioObject.MarioObj = gMarioObject
	
	ObjectListProcessor.gMarioObject = gMarioObject

	-- CUSTOM (LIST)
	gMarioObject.LIST = ObjectListProcessor.OBJ_LIST_PLAYER
	table.insert(ObjectListProcessor.objList, 1, gMarioObject)
end

--[[] ]
function ObjectListProcessor.sParticleTypesInit()
	ObjectListProcessor.sParticleTypes = {}
	for _, p in ipairs({
		{PARTICLE_DUST,                 ObjectConstants.ACTIVE_PARTICLE_DUST,                 MODEL_MIST,                 'bhvMistParticleSpawner'},
		{PARTICLE_VERTICAL_STAR,        ObjectConstants.ACTIVE_PARTICLE_V_STAR,               MODEL_NONE,                 'bhvVertStarParticleSpawner'},
		{PARTICLE_HORIZONTAL_STAR,      ObjectConstants.ACTIVE_PARTICLE_H_STAR,               MODEL_NONE,                 'bhvHorStarParticleSpawner'},
		{PARTICLE_SPARKLES,             ObjectConstants.ACTIVE_PARTICLE_SPARKLES,             MODEL_SPARKLES,             'bhvSparkleParticleSpawner'},
		{PARTICLE_BUBBLE,               ObjectConstants.ACTIVE_PARTICLE_BUBBLE,               MODEL_BUBBLE,               'bhvBubbleParticleSpawner'},
		{PARTICLE_WATER_SPLASH,         ObjectConstants.ACTIVE_PARTICLE_WATER_SPLASH,         MODEL_WATER_SPLASH,         'bhvWaterSplash'},
		{PARTICLE_IDLE_WATER_WAVE,      ObjectConstants.ACTIVE_PARTICLE_IDLE_WATER_WAVE,      MODEL_IDLE_WATER_WAVE,      'bhvIdleWaterWave'},
		{PARTICLE_PLUNGE_BUBBLE,        ObjectConstants.ACTIVE_PARTICLE_PLUNGE_BUBBLE,        MODEL_WHITE_PARTICLE_SMALL, 'bhvPlungeBubble'},
		{PARTICLE_WAVE_TRAIL,           ObjectConstants.ACTIVE_PARTICLE_WAVE_TRAIL,           MODEL_WAVE_TRAIL,           'bhvWaveTrail'},
		{PARTICLE_FIRE,                 ObjectConstants.ACTIVE_PARTICLE_FIRE,                 MODEL_RED_FLAME,            'bhvFireParticleSpawner'},
		{PARTICLE_SHALLOW_WATER_WAVE,   ObjectConstants.ACTIVE_PARTICLE_SHALLOW_WATER_WAVE,   MODEL_NONE,                 'bhvShallowWaterWave'},
		{PARTICLE_SHALLOW_WATER_SPLASH, ObjectConstants.ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH, MODEL_NONE,                 'bhvShallowWaterSplash'},
		{PARTICLE_LEAF,                 ObjectConstants.ACTIVE_PARTICLE_LEAF,                 MODEL_NONE,                 'bhvLeafParticleSpawner'},
		{PARTICLE_SNOW,                 ObjectConstants.ACTIVE_PARTICLE_SNOW,                 MODEL_NONE,                 'bhvSnowParticleSpawner'},
		{PARTICLE_BREATH,               ObjectConstants.ACTIVE_PARTICLE_BREATH,               MODEL_NONE,                 'bhvBreathParticleSpawner'},
		{PARTICLE_DIRT,                 ObjectConstants.ACTIVE_PARTICLE_DIRT,                 MODEL_NONE,                 'bhvDirtParticleSpawner'},
		{PARTICLE_MIST_CIRCLE,          ObjectConstants.ACTIVE_PARTICLE_MIST_CIRCLE,          MODEL_NONE,                 'bhvMistCircParticleSpawner'},
		{PARTICLE_TRIANGLE,             ObjectConstants.ACTIVE_PARTICLE_TRIANGLE,             MODEL_NONE,                 'bhvTriangleParticleSpawner'}
		}) do
		table.insert(self.sParticleTypes, {
			particleFlag = p[1],
			activeParticleFlag = p[2],
			model = p[3],
			behavior = gLinker.behaviors[ p[4] ]
		})
	end
end
--[[]]

-- from the mario module but with a differnet name
function ObjectListProcessor.copy_mario_state_to_object(m: Mario, o: Types.ObjectState)
	o = o or ObjectListProcessor.gCurrentObject
	o.Velocity = m.Velocity
	o.Position = m.Position

	o.MoveAnglePitch = m.GfxAngle.X
	o.MoveAngleYaw = m.FaceAngle.Y
	o.MoveAngleRoll = m.GfxAngle.Z

	o.FaceAnglePitch = m.GfxAngle.X
	o.FaceAngleYaw = m.FaceAngle.Y
	o.FaceAngleRoll = m.GfxAngle.Z

	o.AngleVelPitch = m.AngleVel.X
	o.AngleVelYaw = m.AngleVel.Y
	o.AngleVelRoll = m.AngleVel.Z

	o.HitboxHeight = m.HitboxHeight
	o.HitboxRadius = m.HitboxRadius
end
--[[
    copy_mario_state_to_object() {
        const gMarioState = gLinker.LevelUpdate.gMarioState
        o.rawData[oPosX] = gMarioState.pos[0]
        o.rawData[oPosY] = gMarioState.pos[1]
        o.rawData[oPosZ] = gMarioState.pos[2]

        o.rawData[oFaceAnglePitch] = o.gfx.angle[0]
        o.rawData[oFaceAngleYaw]   = o.gfx.angle[1]
        o.rawData[oFaceAngleRoll]  = o.gfx.angle[2]

        o.rawData[oMoveAnglePitch] = o.gfx.angle[0]
        o.rawData[oMoveAngleYaw]   = o.gfx.angle[1]
        o.rawData[oMoveAngleRoll]  = o.gfx.angle[2]

        o.rawData[oVelX] = gMarioState.vel[0]
        o.rawData[oVelY] = gMarioState.vel[1]
        o.rawData[oVelZ] = gMarioState.vel[2]

        o.rawData[oAngleVelPitch] = gMarioState.angleVel[0]
        o.rawData[oAngleVelYaw]   = gMarioState.angleVel[1]
        o.rawData[oAngleVelRoll]  = gMarioState.angleVel[2]
    }
]]
-- TODO:
function ObjectListProcessor.spawn_particle(o: Types.ObjectState, activeParticleFlag, model, behavior)
	o = o or ObjectListProcessor.gCurrentObject
	print('spawn something particle or something')
      --[[  if (!(o.rawData[oActiveParticleFlags] & activeParticleFlag))
            o.rawData[oActiveParticleFlags] |= activeParticleFlag
            local particle = spawn_object_at_origin(o, model, behavior)
            obj_copy_pos_and_angle(particle, o)
        end]]
end

function ObjectListProcessor.bhv_mario_update(m: Mario, o: Types.ObjectState)
	o = o or ObjectListProcessor.gCurrentObject

	local particleFlags = m:ExecuteAction() -- Mario.execute_mario_action()
	o.RawData.
		o.rawData[oMarioParticleFlags] = particleFlags
	ObjectListProcessor.copy_mario_state_to_object(m, o)

	if ObjectListProcessor.sParticleTypes == nil then
		ObjectListProcessor.sParticleTypesInit()
	end
	for _, particleType in ipairs(ObjectListProcessor.sParticleTypes) do
		if bit32.band(particleFlags, particleType.particleFlag) ~= 0 then
			ObjectListProcessor.spawn_particle(particleType.activeParticleFlag, particleType.model, particleType.behavior)
		end
	end
end

--[[function ObjectListProcessor.update_objects_starting_at(objList, firstObj)
	local count = 0
	while (objList ~= firstObj) do
		ObjectListProcessor.gCurrentObject = firstObj
		ObjectListProcessor.gCurrentObject.gfx.flags |= GraphNode.GRAPH_RENDER_HAS_ANIMATION
		gLinker.BehaviorCommands.cur_obj_update()
		firstObj = firstObj.next
		count += 1
	end
	return count
end]]

local RespawnInfoCase = {
	[RESPAWN_INFO_TYPE_32] = function(obj, bits)
		local info32 = bit32.band(obj.RespawnInfo, 0xFFFFFFFF)
		obj.RespawnInfo = bit32.bor(info32, bit32.lshift(bits, 8))
	end,
	[RESPAWN_INFO_TYPE_16] = function(obj, bits)
		local info16 = bit32.band(obj.RespawnInfo, 0xFFFF)
		obj.RespawnInfo = bit32.bor(info16, bit32.lshift(bits, 8))
	end,
}
function ObjectListProcessor.set_object_respawn_info_bits(obj, bits)
	Util.Switch(obj.RespawnInfoType, RespawnInfoCase, obj, bits)
	--[[switch (obj.RespawnInfoType) {
		case RESPAWN_INFO_TYPE_32:
			let info32 = uint32(obj.RespawnInfo)
		info32 |= bits << 8
		obj.RespawnInfo = info32
		break
		case RESPAWN_INFO_TYPE_16:
			let info16 = uint16(obj.RespawnInfo)
		info16 |= bits << 8
		obj.RespawnInfo = info16
		break
	end]]
end


return ObjectListProcessor