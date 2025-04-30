local Behavior = {}
--[[/ door.c.inc
import * as _Linker from "../../game/Linker"

import {
cur_obj_init_animation_with_sound, cur_obj_check_if_near_animation_end, cur_obj_has_model,
cur_obj_clear_interact_status_flag, cur_obj_change_action, 
 } from "../ObjectHelpers"

import { Util.Sins, Util.Coss } from "../../utils"
import { cur_obj_play_sound_2 } from "../SpawnSound"

import {
    oAction, oMoveAngleYaw,  oPosX, oPosY,  oPosZ, oTimer,
} from "../../include/object_constants"

import { MODEL_HMC_METAL_DOOR } from "../../include/model_ids"
import { CAM_EVENT_DOOR, CAM_EVENT_DOOR_WARP } from "../Camera"
import { GENERAL_OPEN_WOOD_DOOR, GENERAL_OPEN_IRON_DOOR, GENERAL_CLOSE_WOOD_DOOR,
GENERAL_CLOSE_IRON_DOOR } from "../../include/sounds"

import { GRAPH_RENDER_ACTIVE } from "../../engine/graph_node"

import { TIME_STOP_MARIO_OPENED_DOOR } from "../ObjectListProcessor"]]
local Package = script.Parent.Parent.Parent.Parent
local Object = script.Parent.Parent

local FFlags = require(Package.FFlags)
local Util = require(Package.Util)
local Enums = require(Package.Enums)
local Interaction = require(Package.Game.Interaction)
local Types = require(Package.Types)
local Sounds = require(Package.Sounds)

local ObjectListProcessor = require(Object.ObjectListProcessor)
local Helpers = require(Object.ObjectHelpers)
local ObjBhvs2 =  require(Object.ObjBehaviors2)
local Constants = require(Object.ObjectConstants)
local SpawnSound = require(Object.SpawnSound)
local behaviors = require(Object.BehaviorData).BehaviorScripts
local SpawnObject = require(Object.SpawnObject)
local MODEL = require(Object.Models)

--[[ Door ]]
local oDoorUnk88   = 0x00
local oDoorUnkF8   = 0x1C
local oDoorUnkFC   = 0x1D
local oDoorUnk100  = 0x1E


--/ struct DoorAction
--/ {
--/     local u32 flag
--/     local --[[s32]] action
--/ }

local door_actions = { [0] =
	{ flag = 0x40000, action = 3 },
	{ flag = 0x80000, action = 4 },
	{ flag = 0x10000, action = 1 },
	{ flag = 0x20000, action = 2 },
	{ flag = -1, action = 0 }
}

local open_noises  = { [0] = 'GENERAL_OPEN_WOOD_DOOR', 'GENERAL_OPEN_IRON_DOOR' }
local close_noises = { [0] = 'GENERAL_CLOSE_WOOD_DOOR', 'GENERAL_CLOSE_IRON_DOOR' }

local function door_animation_and_reset(o, anim)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	cur_obj_init_animation_with_sound(o, anim)
	if cur_obj_check_if_near_animation_end() then
		o.Action = 0
	end
end

local function set_door_camera_event(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	warn('set_door_camera_event')
    --[[local gPlayerCameraState = gLinker.Camera.gPlayerCameraState

    if (gLinker.behaviors.bhvDoor == o.behavior)
        gPlayerCameraState.cameraEvent = CAM_EVENT_DOOR
    else
        gPlayerCameraState.cameraEvent = CAM_EVENT_DOOR_WARP
    gPlayerCameraState.usedObj = o]]
end

local function play_door_open_noise(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	local type = cur_obj_has_model(MODEL_HMC_METAL_DOOR)
	if o.Timer == 0 then
		cur_obj_play_sound_2(open_noises[type])
		warn('gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_MARIO_OPENED_DOOR')
		-- gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_MARIO_OPENED_DOOR
	end
	if o.Timer == 70 then
		cur_obj_play_sound_2(close_noises[type])
	end
end

local function play_warp_door_open_noise(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local type = cur_obj_has_model(MODEL_HMC_METAL_DOOR)
	if o.Timer == 30 then
		cur_obj_play_sound_2(close_noises[type])
	end
end

function Behavior.bhv_door_loop(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local action = 0

	print('what')
    --[[while (door_actions[action].flag != -1) {
        if (cur_obj_clear_interact_status_flag(door_actions[action].flag)) {
            set_door_camera_event(o)
            cur_obj_change_action(door_actions[action].action)
        }
        action += 1
    }]]

	Util.Switch(o.Action, {
		[0] = function()
			cur_obj_init_animation_with_sound(0)
		end,
		[1]] = function()
	door_animation_and_reset(o, 1)
	play_door_open_noise(o)
end,
[2] = function()
	door_animation_and_reset(o, 2)
	play_door_open_noise(o)
end,
[3] = function()
	door_animation_and_reset(o, 3)
	play_warp_door_open_noise(o)
end,
[4] = function()
	door_animation_and_reset(o, 4)
	play_warp_door_open_noise(o)
end,
}
if o.Action == 0 then
	warn(' WHAT doe sthis do')
	-- gLinker.SurfaceLoad.load_object_collision_model()
end
Behavior.bhv_star_door_loop_2(o)
end

function Behavior.bhv_door_init(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local gDoorAdjacentRooms = gLinker.ObjectListProcessor.gDoorAdjacentRooms
	local x = o.Position.X
	local z = o.Position.Z
	local floorGeo = {}

	gLinker.SurfaceCollision.find_floor(x, o.Position.Y, z, floorGeo)
	if floorGeo.floor then
		o.DoorUnkF8 = floorGeo.floor.room
	end

	x = o.Position.X + Util.Sins(o.MoveAngleYaw) * 200.0
	z = o.Position.Z + Util.Coss(o.MoveAngleYaw) * 200.0
	gLinker.SurfaceCollision.find_floor(x, o.Position.Y, z, floorGeo)
	if floorGeo.floor then
		o.DoorUnkFC = floorGeo.floor.room
	end

	x = o.Position.X + Util.Sins(o.MoveAngleYaw) * -200.0
	z = o.Position.Z + Util.Coss(o.MoveAngleYaw) * -200.0
	gLinker.SurfaceCollision.find_floor(x, o.Position.Y, z, floorGeo)
	if floorGeo.floor then
		o.DoorUnk100 = floorGeo.floor.room
	end

	if o.DoorUnkF8 > 0 and o.DoorUnkF8 < 60 then
		gDoorAdjacentRooms[o.DoorUnkF8][0] = o.DoorUnkFC
		gDoorAdjacentRooms[o.DoorUnkF8][1] = o.DoorUnk100
	end
end

function Behavior.bhv_star_door_loop_2(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local gMarioCurrentRoom = gLinker.ObjectListProcessor.gMarioCurrentRoom
	local gDoorAdjacentRooms = gLinker.ObjectListProcessor.gDoorAdjacentRooms
	local sp4 = 0

	if gMarioCurrentRoom ~= 0 then
		if (o.DoorUnkF8 == gMarioCurrentRoom) then
			sp4 = 1
		elseif (gMarioCurrentRoom == o.DoorUnkFC) then
			sp4 = 1
		elseif (gMarioCurrentRoom == o.DoorUnk100) then
			sp4 = 1
		elseif (gDoorAdjacentRooms[gMarioCurrentRoom][0] == o.DoorUnkFC) then
			sp4 = 1
		elseif (gDoorAdjacentRooms[gMarioCurrentRoom][0] == o.DoorUnk100) then
			sp4 = 1
		elseif (gDoorAdjacentRooms[gMarioCurrentRoom][1] == o.DoorUnkFC) then
			sp4 = 1
		elseif (gDoorAdjacentRooms[gMarioCurrentRoom][1] == o.DoorUnk100) then
			sp4 = 1
		end
	else
		sp4 = 1
	end
	if (sp4 == 1) then
		o.gfx.flags |= GRAPH_RENDER_ACTIVE
		--/ D_8035FEE4 += 1
	end
	if (sp4 == 0) then
		o.gfx.flags &= ~GRAPH_RENDER_ACTIVE
	end
	o.DoorUnk88 = sp4
end

require(script.Parent).Register {
	bhv_door_loop = bhv_door_loop,
	bhv_door_init = bhv_door_init,
	bhv_star_door_loop_2 = bhv_star_door_loop_2,
}