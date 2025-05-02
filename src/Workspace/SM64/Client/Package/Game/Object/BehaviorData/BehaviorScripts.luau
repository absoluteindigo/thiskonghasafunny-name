-- HELP
local function CUSTOM_setAnimation(object, anim)
	if anim and typeof(anim) == "Instance" and anim:IsA("Animation") then
		if object.AnimCurrent == anim then
			return object.AnimFrame
		end

		object.AnimFrameCount = anim:GetAttribute("NumFrames") or 0 -- or 0 is important oh my GOD
		object.AnimCurrent = anim
	else
		warn("Invalid animation provided in SetAnimation:", anim, debug.traceback())
		object.AnimFrameCount = 0
		object.AnimCurrent = nil
	end

	local startFrame: number = anim and anim:GetAttribute("StartFrame") or 0
	object.AnimAccelAssist = 0
	object.AnimAccel = 0
	-- object.AnimAccel = 74444

	object.AnimReset = true
	object.AnimDirty = true
	object.AnimFrame = startFrame

	return startFrame
end

local Util = require(script.Parent.Parent.Parent.Parent.Util)
local behaviors = require(script.Parent.Parent.behaviors)
local ObjectConstants = require(script.Parent.Parent.ObjectConstants)
local GraphNodeConstats = require(script.Parent.Parent.GraphNodeConstats)

local SurfaceCollission = require(script.Parent.Parent.Parent.Parent.Custom.SurfaceCollission)
local CollissionData = SurfaceCollission.CollissionData

local random_float = Util.random_float

-- helper
local specialGetFloat = {
	PosX = function(o)
		return o.Position.X
	end,
	PosY = function(o)
		return o.Position.Y
	end,
	PosZ = function(o)
		return o.Position.Z
	end,
}
local function cur_obj_get_float(o, key)
	return Util.Switch(key, specialGetFloat, o) or o[key]
end
-- helper
local specialSetFloat = {
	PosX = function(o, key, new)
		o.Position = Util.SetX(o.Position, new)
	end,
	PosY = function(o, key, new)
		o.Position = Util.SetY(o.Position, new)
	end,
	PosZ = function(o, key, new)
		o.Position = Util.SetZ(o.Position, new)
	end,
	
	none = function(o, key, new)
		o[key] = new
	end,
}
local function cur_obj_set_float(o, key, new)
	return Util.Switch(key, specialSetFloat, o, key, new)
end

--[[const]] local OBJ_LIST_PLAYER = 0     --  (0) mario
--[[const]] local OBJ_LIST_UNUSED_1 = 1    --  (1) (unused)
--[[const]] local OBJ_LIST_DESTRUCTIVE = 2 --  (2) things that can be used to destroy other objects, like
--      bob-ombs and corkboxes
--[[const]] local OBJ_LIST_UNUSED_3 = 3   --  (3) (unused)
--[[const]] local OBJ_LIST_GENACTOR = 4   --  (4) general actors. most normal 'enemies' or actors are
--      on this list. (MIPS, bullet bill, bully, etc)
--[[const]] local OBJ_LIST_PUSHABLE = 5   --  (5) pushable actors. This is a group of objects which
--      can push each other around as well as their parent
--      objects. (goombas, koopas, spinies)
--[[const]] local OBJ_LIST_LEVEL = 6     --  (6) level objects. general level objects such as heart, star
--[[const]] local OBJ_LIST_UNUSED_7 = 7  --  (7) (unused)
--[[const]] local OBJ_LIST_DEFAULT = 8     --  (8) default objects. objects that didnt start with a 00
--      command are put here, so this is treated as a default.
--[[const]] local OBJ_LIST_SURFACE = 9     --  (9) surface objects. objects that specifically have surface
--      collision and not object collision. (thwomp, whomp, etc)
--[[const]] local OBJ_LIST_POLELIKE = 10    -- (10) polelike objects. objects that attract or otherwise
--      "cling" mario similar to a pole action. (hoot,
--      whirlpool, trees/poles, etc)
--[[const]] local OBJ_LIST_SPAWNER = 11     -- (11) spawners
--[[const]] local OBJ_LIST_UNIMPORTANT = 12 -- (12) unimportant objects. objects that will not load
--      if there are not enough object slots: they will also
--      be manually unloaded to make room for slots if the list
--      gets exhausted.
--[[const]] local NUM_OBJ_LISTS = 13

local BehaviorScripts = {
	OBJ_LIST_PLAYER = OBJ_LIST_PLAYER,
	OBJ_LIST_UNUSED_1 = OBJ_LIST_UNUSED_1,
	OBJ_LIST_DESTRUCTIVE = OBJ_LIST_DESTRUCTIVE,
	OBJ_LIST_UNUSED_3 = OBJ_LIST_UNUSED_3,
	OBJ_LIST_GENACTOR = OBJ_LIST_GENACTOR,
	OBJ_LIST_PUSHABLE = OBJ_LIST_PUSHABLE,
	OBJ_LIST_LEVEL = OBJ_LIST_LEVEL,
	OBJ_LIST_UNUSED_7 = OBJ_LIST_UNUSED_7,
	OBJ_LIST_DEFAULT = OBJ_LIST_DEFAULT,
	OBJ_LIST_SURFACE = OBJ_LIST_SURFACE,
	OBJ_LIST_POLELIKE = OBJ_LIST_POLELIKE,
	OBJ_LIST_SPAWNER = OBJ_LIST_SPAWNER,
	OBJ_LIST_UNIMPORTANT = OBJ_LIST_UNIMPORTANT,
	NUM_OBJ_LISTS = NUM_OBJ_LISTS,	
}-- :: { [any]: {any} }
BehaviorScripts.__index = BehaviorScripts

function BehaviorScripts.getBehavior(key)
	if typeof(key) == 'table' then
		return key
	end
	local func = BehaviorScripts[key]
	if not func then
		warn('nothing found for')
		print(key)
		return
	end
	return func
end

function BehaviorScripts.waitForBehavior(key: string)
	local func = BehaviorScripts[key]
	while not func do
		task.wait()
		func = BehaviorScripts[key]
	end
	return func
end

local function command(key, ...)
	return {key, ...}
end
function BehaviorScripts.ADD_INT(...) return command('ADD_INT', ...) end
function BehaviorScripts.ADD_FLOAT(...) return command('ADD_FLOAT', ...) end
function BehaviorScripts.ANIMATE(...) return command('ANIMATE', ...) end
function BehaviorScripts.ANIMATE_TEXTURE(...) return command('ANIMATE_TEXTURE', ...) end
function BehaviorScripts.BEGIN(...) return command('BEGIN', ...) end
function BehaviorScripts.BEGIN_LOOP(...) return command('BEGIN_LOOP', ...) end
function BehaviorScripts.BEGIN_REPEAT(...) return command('BEGIN_REPEAT', ...) end
function BehaviorScripts.BILLBOARD(...) return command('BILLBOARD', ...) end
function BehaviorScripts.BREAK(...) return command('BREAK', ...) end
function BehaviorScripts.CALL(...) return command('CALL', ...) end
function BehaviorScripts.CALL_NATIVE(...) return command('CALL_NATIVE', ...) end
function BehaviorScripts.DEACTIVATE(...) return command('DEACTIVATE', ...) end
function BehaviorScripts.DEBUGGER(...) return command('DEBUGGER', ...) end
function BehaviorScripts.DELAY(...) return command('DELAY', ...) end
function BehaviorScripts.DELAY_VAR(...) return command('DELAY_VAR', ...) end
function BehaviorScripts.DISABLE_RENDERING(...) return command('DISABLE_RENDERING', ...) end
function BehaviorScripts.DROP_TO_FLOOR(...) return command('DROP_TO_FLOOR', ...) end
function BehaviorScripts.END_LOOP(...) return command('END_LOOP', ...) end
function BehaviorScripts.END_REPEAT(...) return command('END_REPEAT', ...) end
function BehaviorScripts.END_REPEAT_CONTINUE(...) return command('END_REPEAT_CONTINUE', ...) end
function BehaviorScripts.GOTO(...) return command('GOTO', ...) end
function BehaviorScripts.HIDE(...) return command('HIDE', ...) end
function BehaviorScripts.LOAD_ANIMATIONS(...) return command('LOAD_ANIMATIONS', ...) end
function BehaviorScripts.LOAD_COLLISION_DATA(...) return command('LOAD_COLLISION_DATA', ...) end
function BehaviorScripts.OR_INT(...) return command('OR_INT', ...) end
function BehaviorScripts.PARENT_BIT_CLEAR(...) return command('PARENT_BIT_CLEAR', ...) end
function BehaviorScripts.RETURN(...) return command('RETURN', ...) end
function BehaviorScripts.SCALE(...) return command('SCALE', ...) end
function BehaviorScripts.SET_FLOAT(...) return command('SET_FLOAT', ...) end
function BehaviorScripts.SET_HITBOX(...) return command('SET_HITBOX', ...) end
function BehaviorScripts.SET_HITBOX_WITH_OFFSET(...) return command('SET_HITBOX_WITH_OFFSET', ...) end
function BehaviorScripts.SET_HURTBOX(...) return command('SET_HURTBOX', ...) end
function BehaviorScripts.SET_HOME(...) return command('SET_HOME', ...) end
function BehaviorScripts.SET_INT(...) return command('SET_INT', ...) end
function BehaviorScripts.SET_INTERACT_TYPE(...) return command('SET_INTERACT_TYPE', ...) end
function BehaviorScripts.SET_MODEL(...) return command('SET_MODEL', ...) end
function BehaviorScripts.SET_OBJ_PHYSICS(...) return command('SET_OBJ_PHYSICS', ...) end
function BehaviorScripts.SET_RANDOM_INT(...) return command('SET_RANDOM_INT', ...) end
function BehaviorScripts.SET_RANDOM_FLOAT(...) return command('SET_RANDOM_FLOAT', ...) end
function BehaviorScripts.SUM_FLOAT(...) return command('SUM_FLOAT', ...) end
function BehaviorScripts.SPAWN_CHILD(...) return command('SPAWN_CHILD', ...) end
function BehaviorScripts.SPAWN_OBJ(...) return command('SPAWN_OBJ', ...) end
function BehaviorScripts.SPAWN_WATER_DROPLET(...) return command('SPAWN_WATER_DROPLET', ...) end
function BehaviorScripts.CYLBOARD(...) return command('CYLBOARD', ...) end
function BehaviorScripts.SPAWN_CHILD_WITH_PARAM(...) return command('SPAWN_CHILD_WITH_PARAM', ...) end
function BehaviorScripts.CLEAR_BIT_PARENT(...) return command('CLEAR_BIT_PARENT', ...) end
function BehaviorScripts.SET_INT_RAND_RSHIFT(...) return command('SET_INT_RAND_RSHIFT', ...) end
function BehaviorScripts.ADD_RANDOM_FLOAT(...) return command('ADD_RANDOM_FLOAT', ...) end

local index = 0 -- cheap stupid id (temporary)
function CreateBehaviorScript(bhv, key)
	index += 1
	local key = key or bhv[1][2] -- behavior -> begin -> key

	bhv.behavior_id = index
	bhv.name = key
	-- BehaviorScripts[key] = arg1

	-- CUSTOM: loop
	local loop = {}
	for _, command in ipairs(bhv) do

		local commandType = command[1]

		if commandType == 'BEGIN_LOOP' then
			loop = {}
			continue
		end
		if loop and commandType ~= 'END_LOOP' then
			table.insert(loop, command)
			continue
		end
	end
	bhv.loop = loop

	return bhv
end

function BehaviorScripts.Register(key, script: {any})
	BehaviorScripts[key] = CreateBehaviorScript(script, key)
end


-- CALLING A BEHAVIOR
local UNK_CACHE = {}
local function getBehaviorNative(key)
	local func = behaviors[key]
	if not func then
		if not UNK_CACHE[key] then
			--UNK_CACHE[key] = true
			warn('nothing found for🔴 ', key)
			--print(key)
		end
		return
	end
	return func
end
-- some behaviors inialize with special keys for their raw data
-- we dont use rawdata, so this case is for specific behavior
-- scripts, that need these properties initalized
--
-- alternatively, i could just put these in the code that
-- inializes objects xp
local specialPropertyCase = {
	bhvGoomba = {
		GoombaRelativeSpeed = 4 / 3,
		GoombaWalkTimer = 0,

		GoombaSize = 1,
		GoombaScale = 1,
		GoombaTurningAwayFromWall = false,
		GoombaTargetYaw = 1,
		
		GoombaBlinkTimer = 0,
	},
	bhvBobomb = {
		BobombFuseTimer = 0,
		BobombBlinkTimer = 0,
	},
	bhvBobombFuseSmoke = {
		SmokeTimer = 0,
	},
	bhvExplosion = {
		SmokeTimer = 0,
	},
	bhvBobombBullyDeathSmoke = {
		SmokeTimer = 0,
	},
	bhvBobombExplosionBubble = {
		BobombExpBubGfxScaleFacX = 0,
		BobombExpBubGfxScaleFacY = 0,
	},
	bhvDoor = {
		DoorUnkF8 = 0,
	},
	bhvSingleCoinGetsSpawned = {
		CoinBaseVelY = 0
	},
}
-- run a command (innacurate)
local commandCase = {
	BEGIN = function(gCurrentObject, name)
		print('BEGIN', name)
		local props = specialPropertyCase[name]-- Util.Switch(name, specialPropertyCase)
		-- warn(gCurrentObject, name)
		if props then
			for k, v in pairs(props) do
				if gCurrentObject[k] == nil then
					gCurrentObject[k] = v
				end
			end
		end
	end,
	OR_INT = function(gCurrentObject, args)
		if not args or not args.field or not args.value then
			warn("OR_INT missing field or value")
			return
		end

		local fieldName = args.field
		local value = args.value -- bit32.band(args.value, 0xFFFF)

		local field = gCurrentObject[fieldName]

		if field then
			field:Add(value)
		else
			warn(fieldName, 'missing!')
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
	BILLBOARD = function(gCurrentObject)
		gCurrentObject.GfxFlags:Add(GraphNodeConstats.GRAPH_RENDER_BILLBOARD)
	end,
	DROP_TO_FLOOR = function(gCurrentObject)
		local x = gCurrentObject.Position.X
		local y = gCurrentObject.Position.Y
		local z = gCurrentObject.Position.Z

		-- warn('TODO TODO:: find_floor_height')
		-- local floorHeight = y -- gLinker.SurfaceCollision.find_floor_height(x, y + 200.0, z)
		local floorHeight, _ = Util.FindFloor(Vector3.new(x, y + 200.0, z))

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
		local func = getBehaviorNative(key)
		--[[if not func then
			warn('no native behavior for', key)
		end]]
		return func and func(gCurrentObject)
	end,
	LOAD_ANIMATIONS = function(gCurrentObject, args)
		if not args.anims then
			warn('no anims to load!')
		end
		gCurrentObject[args.field] = args.anims or {}
	end,
	-- 0x01: Delays the behavior script for a certain number of frames.
	DELAY = function(gCurrentObject, args)
		local num = args.num
		gCurrentObject.DELAY_TIMER = math.floor(num) -- CUSTOM
        	 --[[const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
        const num = args.num

        if (gCurrentObject.bhvDelayTimer < num - 1) {
            gCurrentObject.bhvDelayTimer++
        } else {
            gCurrentObject.bhvDelayTimer = 0
            this.bhvScript.index++
        }

        return this.BHV_PROC_BREAK]]
	end,
	SET_INTERACT_TYPE = function(gCurrentObject, args)
		-- const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
		gCurrentObject.InteractType = args.type
		-- this.bhvScript.index++
		--	return this.BHV_PROC_CONTINUE
	end,
	SET_HITBOX = function(gCurrentObject, args)
		-- const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
		gCurrentObject.HitboxRadius = args.radius
		gCurrentObject.HitboxHeight = args.height
		-- this.bhvScript.index++
		--	return this.BHV_PROC_CONTINUE
	end,
	SET_HITBOX_WITH_OFFSET = function(gCurrentObject, args)
		-- const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
		gCurrentObject.HitboxRadius = args.radius
		gCurrentObject.HitboxHeight = args.height
		gCurrentObject.HitboxDownOffset = args.downOffset
		-- this.bhvScript.index++
		--	return this.BHV_PROC_CONTINUE
	end,
	DEACTIVATE = function(gCurrentObject, args)
		-- const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
		-- gCurrentObject.ActiveFlags:Clear()
		gCurrentObject.ActiveFlags.Value = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED
		-- return this.BHV_PROC_BREAK
	end,
	DISABLE_RENDERING = function(gCurrentObject, args)
		-- const gCurrentObject = gLinker.ObjectListProcessor.gCurrentObject
		--gCurrentObject.gfx.flags &= ~GRAPH_RENDER_ACTIVE
		gCurrentObject.GfxFlags:Remove(GraphNodeConstats.GRAPH_RENDER_ACTIVE)
        --this.bhvScript.index++
        --return this.BHV_PROC_CONTINUE
    	end,
	-- custom
	ADD_INT = function(gCurrentObject, args)
		gCurrentObject[args.field] += args.value
	end,
	SET_INT = function(gCurrentObject, args)
		gCurrentObject[args.field] = args.value
	end,
	SET_FLOAT = function(gCurrentObject, args)
		gCurrentObject[args.field] = args.value
	end,
	ANIMATE = function(gCurrentObject, args)
		local anims = gCurrentObject.Animations
		local animIndex = args.animIndex
		CUSTOM_setAnimation(gCurrentObject, anims[animIndex])
	end,
	CALL = function(gCurrentObject, key)
		local behaviorScript = BehaviorScripts.getBehavior(key)
		return behaviorScript and BehaviorScripts.CallBehaviorScript(behaviorScript, gCurrentObject)
	end,
	BEGIN_REPEAT = function(gCurrentObject, args)
		
	end,
	-- Command 0x16: Adds a random float in the given range to the specified field.
	-- Usage: ADD_RANDOM_FLOAT(field, min, range)
	ADD_RANDOM_FLOAT = function(gCurrentObject, args)
		-- static s32 bhv_cmd_add_random_float(void) {
		--[[local field = args[1]  :: any -- u8
		local min = args[2] :: number -- f32
		local range = args[3] :: number -- f32]]
		local field = args.field  :: any -- u8
		local min = args.min :: number -- f32
		local range = args.range :: number -- f32
		
		local new = cur_obj_get_float(gCurrentObject, field) + min + (range * random_float())
		cur_obj_set_float(gCurrentObject, field, new);

		-- gCurBhvCommand += 2;
		--return BHV_PROC_CONTINUE;
	end,
	LOAD_COLLISION_DATA = function(gCurrentObject, args)
		local key = args.key
		gCurrentObject.OBJ_COL = SurfaceCollission.New(key, gCurrentObject)
	end,
	RETURN = function() end,

	none = function()
		return 'missing'
	end,
}
warn('ADD_INT USES CUSTOM BEHAVIOR')
warn('SET_INT USES CUSTOM BEHAVIOR')
warn('SET_FLOAT USES CUSTOM BEHAVIOR')
warn('BILLBOARD USES CUSTOM BEHAVIOR')
-- set a command's arguments
local commandArgCase = {
	BEGIN = function(command)
		return command[3]
	end,
	OR_INT = function(command)
		return {
			field = command[2],
			value = command[3],
		}
	end,
	CALL_NATIVE = function(command)
		return command[2]
	end,
	LOAD_ANIMATIONS = function(command)
		return {
			field = command[2],
			anims = command[3],
		}
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
			wallHitboxHeight = command[9],
		}
	end,

	DELAY = function(command)
		return {
			num = command[2],
		}
	end,
	SET_INTERACT_TYPE = function(command)
		return {
			type = command[2],
		}
	end,
	SET_HITBOX = function(command)
		return {
			radius = command[2],
			height = command[3]
		}
	end,
	SET_HITBOX_WITH_OFFSET = function(command)
		return {
			radius = command[2],
			height = command[3],
			downOffset = command[4]
		}
	end,
	ANIMATE = function(command)
		return {
			animIndex = command[2],
		}
	end,
	BEGIN_REPEAT = function(command)
		return {
			count = command[2],
		}
	end,
	-- custom
	ADD_INT = function(command)
		return {
			field = command[2],
			value = command[3],
		}
	end,
	SET_FLOAT = function(command)
		return {
			field = command[2],
			value = command[3],
		}
	end,
	SET_INT = function(command)
		return {
			field = command[2],
			value = command[3],
		}
	end,
	CALL = function(command)
		return command[2]
	end,
	ADD_RANDOM_FLOAT = function(command)
		return {
			field = command[2],
			min = command[3],
			range = command[4]
		}
	end,
	LOAD_COLLISION_DATA = function(command)
		return {
			key = command[2],
		}
	end,
	--
	none = function(command)
		return command
	end,
}
function BehaviorScripts.CallBehaviorScript(behavior, object, name, startIndex)
	local loop = nil
	local repeatCount = nil
	local endRepeatIndex = nil

	startIndex = startIndex or 1

	local i = startIndex
	while i <= #behavior do
		local command = behavior[i]
		local commandType = command[1] :: string

		if commandType == 'BEGIN_LOOP' then
			loop = {}
			i += 1
			continue
		elseif commandType == 'BEGIN_REPEAT' then
			loop = {}
			repeatCount = command[2] -- Set repeat count
			endRepeatIndex = nil
			i += 1
			continue
		elseif commandType == 'END_REPEAT' then
			endRepeatIndex = i + 1 -- where to continue
			local count = repeatCount -- capture count
			local startIdx = 1 -- track index within loop

			function object:BhvUpdate()
				if count > 0 then
					BehaviorScripts.CallBehaviorScript(loop, self, name, startIdx)
					count -= 1
				else
					self.BhvUpdate = nil
					BehaviorScripts.CallBehaviorScript(behavior, self, name, endRepeatIndex)
				end
			end

			return object, behavior
		end

		if loop then
			if commandType ~= 'END_LOOP' then
				table.insert(loop, command)
			end
			i += 1
			continue
		end

		local args = Util.Switch(commandType, commandArgCase, command) or command
		if Util.Switch(commandType, commandCase, object, args) == 'missing' then
			warn('UNKNOWN command: ', commandType)
		end

		i += 1
	end

	if loop then
		object.bhvScript = loop
		if #loop == 1 and loop[1][1] == 'CALL_NATIVE' then
			object.BhvUpdate = getBehaviorNative(loop[1][2])
			return object, behavior
		end

		function object:BhvUpdate()
			BehaviorScripts.CallBehaviorScript(loop, self, name)
		end
	end

	return object, behavior
end


return BehaviorScripts