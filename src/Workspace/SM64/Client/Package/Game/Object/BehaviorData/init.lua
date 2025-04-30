-- i think this is kinda outdated now
-- GO TO LINE 102 FOR THE BEGINNING OF THIS SCRIPT

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

local BehaviorScripts = require(script.BehaviorScripts) -- {} :: { [any]: {any} }

local BehaviorData = {
	BehaviorScripts = BehaviorScripts,
	--
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
}
--
BehaviorData.Register = BehaviorScripts.Register


local Package = script.Parent.Parent.Parent
local Types = require(Package.Types)
local Enums = require(Package.Enums)
local Flags = Types.Flags
local Model = require(Package.Custom.Model)
local Util = require(Package.Util)
local ObjectConstants = require(script.Parent.ObjectConstants)
local GraphNodeConstats = require(script.Parent.GraphNodeConstats)

local ObjectListProcessor = require(Package.Game.Object.ObjectListProcessor)
local behaviors = require(Package.Game.Object.behaviors)
local objList = ObjectListProcessor.objList

local function getBehaviorNative(key)
	local func = behaviors[key]
	if not func then
		warn('nothing found for')
		print(key)
		return
	end
	return func
end

BehaviorData.getBehaviorNative = getBehaviorNative


local CallBehaviorScript = BehaviorScripts.CallBehaviorScript


return BehaviorData


