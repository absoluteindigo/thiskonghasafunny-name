local Behavior = {}

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
local GraphNodeConstats = require(Object.GraphNodeConstats)
local SurfaceLoad = require(Object.SurfaceLoad)

local MODEL = require(Object.Models)

--[[/ door.c.inc
import * as _Linker from "../../game/Linker"

import {
    oAction, oMoveAngleYaw,  oPosX, oPosY,  oPosZ, oTimer,
} from "../../include/object_constants"

import { CAM_EVENT_DOOR, CAM_EVENT_DOOR_WARP } from "../Camera"
import { TIME_STOP_MARIO_OPENED_DOOR } from "../ObjectListProcessor"]]
local TIME_STOP_MARIO_OPENED_DOOR = ObjectListProcessor.TIME_STOP_MARIO_OPENED_DOOR

local cur_obj_play_sound_2 = SpawnSound.cur_obj_play_sound_2
local GRAPH_RENDER_ACTIVE = GraphNodeConstats.GRAPH_RENDER_ACTIVE
local cur_obj_init_animation_with_sound, cur_obj_check_if_near_animation_end, cur_obj_has_model, cur_obj_clear_interact_status_flag, cur_obj_change_action = Helpers.cur_obj_init_animation_with_sound, Helpers.cur_obj_check_if_near_animation_end, Helpers.cur_obj_has_model, Helpers.cur_obj_clear_interact_status_flag, Helpers.cur_obj_change_action

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
	
	if cur_obj_check_if_near_animation_end(o) then
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

	local type = cur_obj_has_model(o, MODEL.HMC_METAL_DOOR)
	if o.Timer == 0 then
		cur_obj_play_sound_2(o, open_noises[type])
		warn('gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_MARIO_OPENED_DOOR')
		-- gLinker.ObjectListProcessor.gTimeStopState |= TIME_STOP_MARIO_OPENED_DOOR
		ObjectListProcessor.gTimeStopState = bit32.bor(ObjectListProcessor.gTimeStopState, TIME_STOP_MARIO_OPENED_DOOR)
	end
	if o.Timer == 70 then
		cur_obj_play_sound_2(o, close_noises[type])
	end
end

local function play_warp_door_open_noise(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local type = cur_obj_has_model(o, MODEL.HMC_METAL_DOOR)
	if o.Timer == 30 then
		cur_obj_play_sound_2(o, close_noises[type])
	end
end


local loopCase = {
	[0] = function(o)
		cur_obj_init_animation_with_sound(o, 0)
	end,
	[1] = function(o)
		door_animation_and_reset(o, 1)
		play_door_open_noise(o)
	end,
	[2] = function(o)
		door_animation_and_reset(o, 2)
		play_door_open_noise(o)
	end,
	[3] = function(o)
		door_animation_and_reset(o, 3)
		play_warp_door_open_noise(o)
	end,
	[4] = function(o)
		door_animation_and_reset(o, 4)
		play_warp_door_open_noise(o)
	end,
}

function Behavior.bhv_door_loop(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local action = 0

    while door_actions[action].flag ~= -1 do
        if cur_obj_clear_interact_status_flag(o, door_actions[action].flag) then
            set_door_camera_event(o)
            cur_obj_change_action(o, door_actions[action].action)
        end
        action += 1
    end

	Util.Switch(o.Action, loopCase, o)
	if o.Action == 0 then
		SurfaceLoad.load_object_collision_model(o)
	end
	Behavior.bhv_star_door_loop_2(o)
end

function Behavior.bhv_door_init(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local gDoorAdjacentRooms = ObjectListProcessor.gDoorAdjacentRooms
	local x = o.Position.X
	local z = o.Position.Z
	local floorGeo = {}

	local _, floor = Util.FindFloor(Vector3.new(x, o.Position.Y, z))
	if floor then
		o.DoorUnkF8 = floor.room
	end

	x = o.Position.X + Util.Sins(o.MoveAngleYaw) * 200.0
	z = o.Position.Z + Util.Coss(o.MoveAngleYaw) * 200.0
	local _, floor = Util.FindFloor(Vector3.new(x, o.Position.Y, z))
	if floor then
		o.DoorUnkFC = floor.room
	end

	x = o.Position.X + Util.Sins(o.MoveAngleYaw) * -200.0
	z = o.Position.Z + Util.Coss(o.MoveAngleYaw) * -200.0
	local _, floor = Util.FindFloor(Vector3.new(x, o.Position.Y, z))
	if floor then
		o.DoorUnk100 = floor.room
	end

	if o.DoorUnkF8 > 0 and o.DoorUnkF8 < 60 then
		gDoorAdjacentRooms[o.DoorUnkF8][0] = o.DoorUnkFC
		gDoorAdjacentRooms[o.DoorUnkF8][1] = o.DoorUnk100
	end
end

function Behavior.bhv_star_door_loop_2(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local gMarioCurrentRoom = ObjectListProcessor.gMarioCurrentRoom
	local gDoorAdjacentRooms = ObjectListProcessor.gDoorAdjacentRooms
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
	if sp4 == 1 then
		o.GfxFlags:Add(GRAPH_RENDER_ACTIVE)
		--/ D_8035FEE4 += 1
	end
	if sp4 == 0 then
		o.GfxFlags:Remove(GRAPH_RENDER_ACTIVE)
	end
	o.DoorUnk88 = sp4
end

require(script.Parent).Register(Behavior)