

--[[import * as _Linker from "../../game/Linker"
import { ObjectListProcessorInstance as ObjectListProc } from "../ObjectListProcessor"
import { oPosY, oPosX, oPosZ, oTimer, oBehParams} from "../../include/object_constants"
import { MODEL_YELLOW_SPHERE } from "../../include/model_ids"
import { spawn_object, obj_set_pos } from "../ObjectHelpers"
import { bhv_pole_base_loop } from "./pole_base.inc"]]

local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local Util = require(Package.Util)
local Enums = require(Package.Enums)
local Interaction = require(Package.Game.Interaction)
local Types = require(Package.Types)
local Sounds = require(Package.Sounds)

local Action = Enums.Action

local ObjectListProcessor = require(Object.ObjectListProcessor)
local Helpers = require(Object.ObjectHelpers)
local Models = require(Object.Models)

local function bhv_pole_init(o)
	-- local o = ObjectListProc.gCurrentObject
	local tenthHitboxHeight = bit32.band(bit32.rshift(o.BhvParams, 0x10), 0xFF) -- o.BhvParams >> 0x10 & 0xFF
	o.HitboxHeight = tenthHitboxHeight * 10
end

-- from pole_base.inc.js
local function bhv_pole_base_loop(o)
	local gMarioObject = ObjectListProcessor.gMarioObject
	-- local o = ObjectListProc.gCurrentObject
	if o.Position.Y - 10.0 < gMarioObject.Position.Y and
		gMarioObject.Position.Y < o.Position.Y + o.HitboxHeight + 30.0 then
		if o.Timer > 10 then
			if not (gMarioObject.Action() ==  Action.PUNCHING) then
				Helpers.cur_obj_push_mario_away(o, 70.0)
			end
		end
	end
end

local function bhv_giant_pole_loop(o)
	-- local o = ObjectListProc.gCurrentObject
	local topBall -- = null;
	if o.Timer == 0 then
		topBall = Helpers.spawn_object(o, Models.YELLOW_SPHERE, 'bhvYellowBall') 
		topBall.Position.Y += o.HitboxHeight + 50.0
	end
	bhv_pole_base_loop(o)
end


require(script.Parent).Register({
	bhv_pole_init = bhv_pole_init,
	bhv_giant_pole_loop = bhv_giant_pole_loop,
	bhv_pole_base_loop = bhv_pole_base_loop,
})