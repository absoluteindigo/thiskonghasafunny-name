local LevelUpdate = {}
--[[import * as _Linker from "./Linker"
import { AreaInstance as Area, MARIO_SPAWN_UNKNOWN_27 } from "./Area"
import { COURSE_NONE, COURSE_STAGES_MAX } from "../levels/course_defines"
import * as Mario from "./Mario"
import { CameraInstance as Camera, CAM_MOVE_PAUSE_SCREEN } from "./Camera"
import * as CourseTable from "../include/course_table"
import { check_if_should_set_warp_checkpoint, check_warp_checkpoint, disable_warp_checkpoint, gCurrCourseStarFlags, gLevelToCourseNumTable, save_file_get_star_flags, set_curr_course_star_flags } from "./SaveFile"
import { s16, Util.Sins, Util.Coss } from "../utils"

import { fadeout_music, play_painting_eject_sound, raise_background_noise } from "./SoundInit"

import {
    ACT_FLAG_INTANGIBLE, ACT_UNINITIALIZED,
    ACT_DEATH_EXIT,
    ACT_EMERGE_FROM_PIPE,
    ACT_EXIT_AIRBORNE,
    ACT_FALLING_DEATH_EXIT,
    ACT_FALLING_EXIT_AIRBORNE,
    ACT_FLYING,
    ACT_HARD_BACKWARD_AIR_KB,
    ACT_IDLE,
    ACT_SPAWN_NO_SPIN_AIRBORNE,
    ACT_SPAWN_SPIN_AIRBORNE,
    ACT_SPECIAL_DEATH_EXIT,
    ACT_SPECIAL_EXIT_AIRBORNE,
    ACT_TELEPORT_FADE_IN,
    ACT_UNUSED_DEATH_EXIT,
    ACT_WARP_DOOR_SPAWN,
    ACT_WATER_IDLE,
    ACT_INTRO_CUTSCENE,
} from "./Mario"

import { GameInstance as Game } from "../game/Game"

import {
    oBehParams, oPosX, oPosY, oPosZ, oMoveAngleYaw
} from "../include/object_constants"

import { LEVEL_BOWSER_1, LEVEL_BOWSER_2, LEVEL_BOWSER_3, LEVEL_CASTLE } from "../levels/level_defines_constants"

import {
    WARP_TRANSITION_FADE_FROM_COLOR,
    WARP_TRANSITION_FADE_INTO_COLOR,
    WARP_TRANSITION_FADE_FROM_STAR,
    WARP_TRANSITION_FADE_INTO_STAR,
    WARP_TRANSITION_FADE_FROM_CIRCLE,
    WARP_TRANSITION_FADE_INTO_CIRCLE,
    WARP_TRANSITION_FADE_INTO_MARIO,
    WARP_TRANSITION_FADE_FROM_BOWSER,
    WARP_TRANSITION_FADE_INTO_BOWSER,
    MARIO_SPAWN_AIRBORNE,
    MARIO_SPAWN_AIRBORNE_DEATH,
    MARIO_SPAWN_AIRBORNE_STAR_COLLECT,
    MARIO_SPAWN_DEATH,
    MARIO_SPAWN_DOOR_WARP,
    MARIO_SPAWN_FLYING,
    MARIO_SPAWN_HARD_AIR_KNOCKBACK,
    MARIO_SPAWN_INSTANT_ACTIVE,
    MARIO_SPAWN_LAUNCH_DEATH,
    MARIO_SPAWN_LAUNCH_STAR_COLLECT,
    MARIO_SPAWN_PAINTING_DEATH,
    MARIO_SPAWN_PAINTING_STAR_COLLECT,
    MARIO_SPAWN_SPIN_AIRBORNE,
    MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE,
    MARIO_SPAWN_SWIMMING,
    MARIO_SPAWN_TELEPORT,
    MARIO_SPAWN_UNKNOWN_02,
    MARIO_SPAWN_UNKNOWN_03
} from "./Area"

import { play_sound, gGlobalSoundSource } from "../audio/external"

import {
    SOUND_ACTION_FLYING_FAST,
    SOUND_ACTION_TERRAIN_LANDING,
    SOUND_GENERAL_COIN,
    SOUND_GENERAL_COIN_WATER,
    SOUND_MENU_BOWSER_LAUGH,
    SOUND_MENU_MARIO_CASTLE_WARP,
    SOUND_MENU_POWER_METER,
    SOUND_MENU_STAR_SOUND,
    SOUND_MOVING_AIM_CANNON,
    SOUND_OBJ_POUNDING_CANNON,
} from "../include/sounds"
import { SET_BACKGROUND_MUSIC } from "../engine/LevelCommands"
import { IngameMenuInstance as IngameMenu, MENU_MODE_RENDER_PAUSE_SCREEN, MENU_OPT_DEFAULT, MENU_OPT_NONE } from "./IngameMenu"
import { SURFACE_PAINTING_WARP_D3 } from "../include/surface_terrains"
import { GRAPH_RENDER_ACTIVE } from "../engine/graph_node"]]


LevelUpdate.TIMER_CONTROL_SHOW  = 0
LevelUpdate.TIMER_CONTROL_START = 1
LevelUpdate.TIMER_CONTROL_STOP  = 2
LevelUpdate.TIMER_CONTROL_HIDE  = 3

LevelUpdate.WARP_OP_NONE          = 0x00
LevelUpdate.WARP_OP_UNKNOWN_01    = 0x01
LevelUpdate.WARP_OP_UNKNOWN_02    = 0x02
LevelUpdate.WARP_OP_WARP_DOOR     = 0x03
LevelUpdate.WARP_OP_WARP_OBJECT   = 0x04
LevelUpdate.WARP_OP_TELEPORT      = 0x05
LevelUpdate.WARP_OP_STAR_EXIT     = 0x11
LevelUpdate.WARP_OP_DEATH         = 0x12
LevelUpdate.WARP_OP_WARP_FLOOR    = 0x13
LevelUpdate.WARP_OP_GAME_OVER     = 0x14
LevelUpdate.WARP_OP_CREDITS_END   = 0x15
LevelUpdate.WARP_OP_DEMO_NEXT     = 0x16
LevelUpdate.WARP_OP_CREDITS_START = 0x17
LevelUpdate.WARP_OP_CREDITS_NEXT  = 0x18
LevelUpdate.WARP_OP_DEMO_END      = 0x19

LevelUpdate.WARP_OP_TRIGGERS_LEVEL_SELECT = 0x10


local PLAY_MODE_NORMAL  =  0
local PLAY_MODE_PAUSED  =  2
local PLAY_MODE_CHANGE_AREA  =  3
local PLAY_MODE_CHANGE_LEVEL  =  4
local PLAY_MODE_FRAME_ADVANCE = 5

local WARP_TYPE_NOT_WARPING = 0
local WARP_TYPE_CHANGE_LEVEL = 1
local WARP_TYPE_CHANGE_AREA = 2
local WARP_TYPE_SAME_AREA = 3

local WARP_NODE_F0 = 0xF0
local WARP_NODE_DEATH = 0xF1
local WARP_NODE_F2 = 0xF2
local WARP_NODE_WARP_FLOOR = 0xF3
local WARP_NODE_CREDITS_START = 0xF8
local WARP_NODE_CREDITS_NEXT = 0xF9
local WARP_NODE_CREDITS_END = 0xFA

local WARP_NODE_CREDITS_MIN = 0xF8

--/ From Surface 0xD3 to 0xFC
local PAINTING_WARP_INDEX_START = 0x00   --/ Value greater than or equal to Surface 0xD3
local PAINTING_WARP_INDEX_FA = 0x2A      --/ THI Huge Painting index left
local PAINTING_WARP_INDEX_END = 0x2D     --/ Value less than Surface 0xFD


HudDisplay =  {
	new = function(lives, coins, stars, wedges, keys, flags, timer)
		return {
			lives = lives,
			coins = coins,
			stars = stars,
			wedges = wedges,
			keys = keys,
			flags = flags,
			timer = timer,
		}
	end,
}


local sProtoWarpBhvSpawnType = { [0] = 
	{ [0] = 'bhvDoorWarp',                MARIO_SPAWN_DOOR_WARP},
	{ [0] = 'bhvStar',                    MARIO_SPAWN_UNKNOWN_02},
	{ [0] = 'bhvExitPodiumWarp',          MARIO_SPAWN_UNKNOWN_03},
	{ [0] = 'bhvWarp',                    MARIO_SPAWN_UNKNOWN_03},
	{ [0] = 'bhvWarpPipe',                MARIO_SPAWN_UNKNOWN_03},
	{ [0] = 'bhvFadingWarp',              MARIO_SPAWN_TELEPORT},
	{ [0] = 'bhvInstantActiveWarp',       MARIO_SPAWN_INSTANT_ACTIVE},
	{ [0] = 'bhvAirborneWarp',            MARIO_SPAWN_AIRBORNE},
	{ [0] = 'bhvHardAirKnockBackWarp',    MARIO_SPAWN_HARD_AIR_KNOCKBACK},
	{ [0] = 'bhvSpinAirborneCircleWarp',  MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE},
	{ [0] = 'bhvDeathWarp',               MARIO_SPAWN_DEATH},
	{ [0] = 'bhvSpinAirborneWarp',        MARIO_SPAWN_SPIN_AIRBORNE},
	{ [0] = 'bhvFlyingWarp',              MARIO_SPAWN_FLYING},
	{ [0] = 'bhvSwimmingWarp',            MARIO_SPAWN_SWIMMING},
	{ [0] = 'bhvPaintingStarCollectWarp', MARIO_SPAWN_PAINTING_STAR_COLLECT},
	{ [0] = 'bhvPaintingDeathWarp',       MARIO_SPAWN_PAINTING_DEATH},
	{ [0] = 'bhvAirborneStarCollectWarp', MARIO_SPAWN_AIRBORNE_STAR_COLLECT},
	{ [0] = 'bhvAirborneDeathWarp',       MARIO_SPAWN_AIRBORNE_DEATH},
	{ [0] = 'bhvLaunchStarCollectWarp',   MARIO_SPAWN_LAUNCH_STAR_COLLECT},
	{ [0] = 'bhvLaunchDeathWarp',         MARIO_SPAWN_LAUNCH_DEATH},
}
--[[]]

LevelUpdate.gMarioState =  {
	unk00 = 0, input = 0, flags = 0, particleFlags = 0, action = 0,
	prevAction = 0, terrainsoundAddend = 0, actionState = 0, actionTimer = 0,
	actionArg = 0, intendedMag = 0, intendedYaw = 0, invincTimer = 0,
	framesSinceA = 0, framesSinceB = 0, wallKickTimer = 0, doubleJumpTimer = 0,
	faceAngle = { [0] = 0, 0, 0},
	angleVel = { [0] = 0, 0, 0},
	slideYaw = 0, twirlYaw = 0,
	pos = { [0] = 0, 0, 0},
	vel = { [0] = 0, 0, 0},
	forwardVel = 0, slideVelX = 0, slideVelY = 0,
	--/--// And a ton more
}

--/ HUDDisplayFlag enum
LevelUpdate.HUD_DISPLAY_FLAG_LIVES = 0x0001
LevelUpdate.HUD_DISPLAY_FLAG_COIN_COUNT = 0x0002
LevelUpdate.HUD_DISPLAY_FLAG_STAR_COUNT = 0x0004
LevelUpdate.HUD_DISPLAY_FLAG_CAMERA_AND_POWER = 0x0008
LevelUpdate.HUD_DISPLAY_FLAG_KEYS = 0x0010
LevelUpdate.HUD_DISPLAY_FLAG_UNKNOWN_0020 = 0x0020
LevelUpdate.HUD_DISPLAY_FLAG_TIMER = 0x0040
LevelUpdate.HUD_DISPLAY_FLAG_EMPHASIZE_POWER = 0x8000
LevelUpdate.HUD_DISPLAY_NONE = 0x0000
LevelUpdate.HUD_DISPLAY_DEFAULT = bit32.bor(LevelUpdate.HUD_DISPLAY_FLAG_LIVES, LevelUpdate.HUD_DISPLAY_FLAG_COIN_COUNT, LevelUpdate.HUD_DISPLAY_FLAG_STAR_COUNT, LevelUpdate.HUD_DISPLAY_FLAG_CAMERA_AND_POWER, LevelUpdate.HUD_DISPLAY_FLAG_KEYS, LevelUpdate.HUD_DISPLAY_FLAG_UNKNOWN_0020)
LevelUpdate.gHudDisplay = HudDisplay.new()

LevelUpdate.sCurrPlayMode = 0
LevelUpdate.sTransitionTimer = 0
LevelUpdate.sTransitionUpdate = nil
LevelUpdate.sWarpDest = {
	type = 0, levelNum = 0, areaIdx = 0, nodeId = 0, arg = 0
}
LevelUpdate.warpSpecialLevel = 0
LevelUpdate.sDelayedWarpOp = 0
LevelUpdate.sDelayedWarpTimer = 0
LevelUpdate.sSourceWarpNodeId = 0
LevelUpdate.sDelayedWarpArg = 0
LevelUpdate.sTimerRunning = 0
LevelUpdate.gNeverEnteredCastle = 0

LevelUpdate.sWarpCheckpointActive = 0

LevelUpdate.sWarpBhvSpawnType = nil

function LevelUpdate.init_mario_warp_spawn_type()
	if not LevelUpdate.sWarpBhvSpawnType then
		LevelUpdate.sWarpBhvSpawnType = { }
		for i = 0, sProtoWarpBhvSpawnType.length do
			LevelUpdate.sWarpBhvSpawnType[i] = { [0] =
				behaviors[sProtoWarpBhvSpawnType[i][0]],
				sProtoWarpBhvSpawnType[i][1]
			}
		end
	end
end

function LevelUpdate.lvl_init_from_save_file(arg0, levelNum)
	LevelUpdate.sWarpDest.type = WARP_TYPE_NOT_WARPING
	LevelUpdate.sDelayedWarpOp = WARP_OP_NONE
	--/ LevelUpdate.gNeverEnteredCastle = !save_file_exists(gCurrSaveFileNum - 1)

	Area.gCurrLevelNum = levelNum
	Area.gCurrCourseNum = COURSE_NONE
	Area.gSavedCourseNum = COURSE_NONE
	Area.gCurrCreditsEntry = nil
	--/ LevelUpdate.gSpecialTripleJump = 0

	Mario.init_mario_from_save_file()
	disable_warp_checkpoint();
	--/ save_file_move_cap_to_default_location();
	Camera.select_mario_cam_mode()
	--/ set_yoshi_as_not_dead();

	return levelNum
end

function LevelUpdate.lvl_set_current_level(arg0, levelNum)
	local warpCheckpointActive = LevelUpdate.sWarpCheckpointActive
	LevelUpdate.sWarpCheckpointActive = 0

	gLinker.Area.gCurrLevelNum = levelNum
	gLinker.Area.gCurrCourseNum = gLevelToCourseNumTable[levelNum - 1]

	--/ if (gCurrDemoInput ~= NULL or gCurrCreditsEntry ~= NULL or gCurrCourseNum == COURSE_NONE) {
	--/     return false;
	--/ }

	if Area.gCurrLevelNum ~= LEVEL_BOWSER_1 and Area.gCurrLevelNum ~= LEVEL_BOWSER_2
		and Area.gCurrLevelNum ~= LEVEL_BOWSER_3 then
		LevelUpdate.gMarioState.numCoins = 0
		LevelUpdate.gHudDisplay.coins = 0
		set_curr_course_star_flags();
	end

	if Area.gSavedCourseNum ~= Area.gCurrCourseNum then
		Area.gSavedCourseNum = Area.gCurrCourseNum
		disable_warp_checkpoint();
	end

	if Area.gCurrCourseNum > COURSE_STAGES_MAX or warpCheckpointActive then
		return false;
	end

	--/ if (gDebugLevelSelect and !gShowProfiler) {
	--/     return false;
	--/ }

	return true
end

function LevelUpdate.lvl_init_or_update(initOrUpdate)
	return initOrUpdate and LevelUpdate.update_level() or LevelUpdate.init_level()
end

--[[function LevelUpdate.init_level()
	local val4 = 0

	LevelUpdate.set_play_mode(PLAY_MODE_NORMAL)

	LevelUpdate.sDelayedWarpOp = WARP_OP_NONE
	LevelUpdate.sTransitionTimer = 0
	LevelUpdate.warpSpecialLevel = 0

	if LevelUpdate.gCurrCreditsEntry == undefined then --/ Compares to NULL in C code
		LevelUpdate.gHudDisplay.flags = LevelUpdate.HUD_DISPLAY_DEFAULT;
	else
		LevelUpdate.gHudDisplay.flags = LevelUpdate.HUD_DISPLAY_NONE;
	end

	LevelUpdate.sTimerRunning = 0

	if LevelUpdate.sWarpDest.type ~= WARP_TYPE_NOT_WARPING then
		if LevelUpdate.sWarpDest.nodeId >= WARP_NODE_CREDITS_MIN else
		LevelUpdate.warp_credits()
		else
	LevelUpdate.warp_level()
end
else
	if Area.gMarioSpawnInfo.areaIndex >= 0 then
		Area.load_mario_area()
		Mario.init_marios()
	end

	if Area.gCurrentArea then
		Camera.reset_camera(Area.gCurrentArea.camera)

		warn('TODO')
		if (false) then --/ gCurrDemoInput ~= nil) {
			Mario.set_mario_action(LevelUpdate.gMarioState, ACT_IDLE, 0)
		elseif (true) then --/ !gDebugLevelSelect) {
			if LevelUpdate.gMarioState.action ~= ACT_UNINITIALIZED then
				--/ CHANGE TO FALSE TO TEST INTRO --/
				if (true) then --/ save_file_exists(gCurrSaveFileNum - 1)) {
					Mario.set_mario_action(LevelUpdate.gMarioState, ACT_IDLE, 0)
				else
					Mario.set_mario_action(LevelUpdate.gMarioState, ACT_INTRO_CUTSCENE, 0)
					val4 = 1
				end
			end
		end
	end 

	if val4 ~= 0 then
		Area.play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 0x5A, 0xFF, 0xFF, 0xFF)
	else
		Area.play_transition(WARP_TRANSITION_FADE_FROM_STAR, 0x10, 0xFF, 0xFF, 0xFF)
	end

	--/ if (gCurrDemoInput == nil) {
	--/     set_background_music(gCurrentArea.musicParam, gCurrentArea.musicParam2, 0)
	--/ }

end

--/ if (gMarioState.action == ACT_INTRO_CUTSCENE) {
--/     sound_banks_disable(SEQ_PLAYER_SFX, SOUND_BANKS_DISABLED_DURING_INTRO_CUTSCENE)
--/ }
return true
end]]


function LevelUpdate.level_control_timer(timerOp)
        --[[switch (timerOp) {
            case TIMER_CONTROL_SHOW =
                LevelUpdate.gHudDisplay.flags |= LevelUpdate.HUD_DISPLAY_FLAG_TIMER
                LevelUpdate.sTimerRunning = 0
                LevelUpdate.gHudDisplay.timer = 0
                break

            case TIMER_CONTROL_START =
                LevelUpdate.sTimerRunning = 1
                break

            case TIMER_CONTROL_STOP =
                LevelUpdate.sTimerRunning = 0
                break

            case TIMER_CONTROL_HIDE =
                LevelUpdate.gHudDisplay.flags &= ~LevelUpdate.HUD_DISPLAY_FLAG_TIMER
                LevelUpdate.sTimerRunning = 0
                LevelUpdate.gHudDisplay.timer = 0
                break
        }]]

	return LevelUpdate.gHudDisplay.timer
end

function LevelUpdate.pressed_pause()
	local --[[u32]] val4 = IngameMenu.get_dialog_id() >= 0
	local --[[u32]] intangible = bit32.band(LevelUpdate.gMarioState.action, ACT_FLAG_INTANGIBLE) ~= 0

	if (!intangible and !val4 and !Area.gWarpTransition.isActive and LevelUpdate.sDelayedWarpOp == WARP_OP_NONE
		and window.playerInput.buttonPressedStart) {
			return true
end

return false
end

function LevelUpdate.warp_special(level)
	LevelUpdate.sCurrPlayMode = PLAY_MODE_CHANGE_LEVEL
	LevelUpdate.warpSpecialLevel = level
	LevelUpdate.gMarioState.health = 0x880
	LevelUpdate.gMarioState.hurtCounter = 0
	LevelUpdate.gMarioState.healCounter = 0
end

function LevelUpdate.fade_into_special_warp(level, color)
	if color ~= 0 then
		color = 0xFF
	end

	fadeout_music(190)
	Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x10, color, color, color)
	LevelUpdate.level_set_transition(30, nil)

	LevelUpdate.warp_special(level)
end

--/ LevelUpdate.function stub_level_update_1()
--/ }

function LevelUpdate.load_level_init_tex(arg)
	local --[[s32]] gotAchievement
	local --[[u32]] dialog = Area.gCurrentArea.dialog[arg]

        --[[switch (dialog) {
    --/         case DIALOG_129 =
    --/             gotAchievement = save_file_get_flags() & SAVE_FLAG_HAVE_VANISH_CAP
    --/             break

    --/         case DIALOG_130 =
    --/             gotAchievement = save_file_get_flags() & SAVE_FLAG_HAVE_METAL_CAP
    --/             break

    --/         case DIALOG_131 =
    --/             gotAchievement = save_file_get_flags() & SAVE_FLAG_HAVE_WING_CAP
    --/             break

            case 255 =
                gotAchievement = 1
                break

            default =
                gotAchievement = save_file_get_star_flags(gCurrSaveFileNum - 1, gCurrCourseNum - 1)
                break
        }]]

	if not gotAchievement then
		level_set_transition(-1, nil)
		create_dialog_box(dialog)
	end
end

function LevelUpdate.init_door_warp(spawnInfo, arg1)
	if bit32.band(arg1, 0x00000002) ~= 0 then
		spawnInfo.startAngle[1] += s16(0x8000)
	end

	spawnInfo.startPos[0] += 300.0 * Util.Sins(spawnInfo.startAngle[1])
	spawnInfo.startPos[2] += 300.0 * Util.Coss(spawnInfo.startAngle[1])
end

--/ LevelUpdate.function set_mario_initial_cap_powerup(m)
--/     local --[[u32]] capCourseIndex = gCurrCourseNum - COURSE_CAP_COURSES

--/     switch (capCourseIndex) {
--/         case COURSE_COTMC - COURSE_CAP_COURSES =
--/             m.flags |= MARIO_METAL_CAP | MARIO_CAP_ON_HEAD
--/             m.capTimer = 600
--/             break

--/         case COURSE_TOTWC - COURSE_CAP_COURSES =
--/             m.flags |= MARIO_WING_CAP | MARIO_CAP_ON_HEAD
--/             m.capTimer = 1200
--/             break

--/         case COURSE_VCUTM - COURSE_CAP_COURSES =
--/             m.flags |= MARIO_VANISH_CAP | MARIO_CAP_ON_HEAD
--/             m.capTimer = 600
--/             break
--/     }
--/ }

function LevelUpdate.set_mario_initial_action(m, spawnType, actionArg)
        --[[switch (spawnType) {
            case MARIO_SPAWN_DOOR_WARP =
                Mario.set_mario_action(m, ACT_WARP_DOOR_SPAWN, actionArg)
                break
            case MARIO_SPAWN_UNKNOWN_02 =
                Mario.set_mario_action(m, ACT_IDLE, 0)
                break
            case MARIO_SPAWN_UNKNOWN_03 =
                Mario.set_mario_action(m, ACT_EMERGE_FROM_PIPE, 0)
                break
            case MARIO_SPAWN_TELEPORT =
                Mario.set_mario_action(m, ACT_TELEPORT_FADE_IN, 0)
                break
            case MARIO_SPAWN_INSTANT_ACTIVE =
                Mario.set_mario_action(m, ACT_IDLE, 0)
                break
            case MARIO_SPAWN_AIRBORNE =
                Mario.set_mario_action(m, ACT_SPAWN_NO_SPIN_AIRBORNE, 0)
                break
            case MARIO_SPAWN_HARD_AIR_KNOCKBACK =
                Mario.set_mario_action(m, ACT_HARD_BACKWARD_AIR_KB, 0)
                break
            case MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE =
                Mario.set_mario_action(m, ACT_SPAWN_SPIN_AIRBORNE, 0)
                break
            case MARIO_SPAWN_DEATH =
                Mario.set_mario_action(m, ACT_FALLING_DEATH_EXIT, 0)
                break
            case MARIO_SPAWN_SPIN_AIRBORNE =
                Mario.set_mario_action(m, ACT_SPAWN_SPIN_AIRBORNE, 0)
                break
            case MARIO_SPAWN_FLYING =
                Mario.set_mario_action(m, ACT_FLYING, 2)
                break
            case MARIO_SPAWN_SWIMMING =
                Mario.set_mario_action(m, ACT_WATER_IDLE, 1)
                break
            case MARIO_SPAWN_PAINTING_STAR_COLLECT =
                Mario.set_mario_action(m, ACT_EXIT_AIRBORNE, 0)
                break
            case MARIO_SPAWN_PAINTING_DEATH =
                Mario.set_mario_action(m, ACT_DEATH_EXIT, 0)
                break
            case MARIO_SPAWN_AIRBORNE_STAR_COLLECT =
                Mario.set_mario_action(m, ACT_FALLING_EXIT_AIRBORNE, 0)
                break
            case MARIO_SPAWN_AIRBORNE_DEATH =
                Mario.set_mario_action(m, ACT_UNUSED_DEATH_EXIT, 0)
                break
            case MARIO_SPAWN_LAUNCH_STAR_COLLECT =
                Mario.set_mario_action(m, ACT_SPECIAL_EXIT_AIRBORNE, 0)
                break
            case MARIO_SPAWN_LAUNCH_DEATH =
                Mario.set_mario_action(m, ACT_SPECIAL_DEATH_EXIT, 0)
                break
        }]]

	--/ set_mario_initial_cap_powerup(m)
end

function LevelUpdate.init_mario_after_warp()
	local spawnNode = Area.area_get_warp_node(LevelUpdate.sWarpDest.nodeId)
	local marioSpawnType = Area.get_mario_spawn_type(spawnNode.object)

	if (LevelUpdate.gMarioState.action ~= ACT_UNINITIALIZED) {
		Area.gMarioSpawnInfo.startPos[0] = spawnNode.object.Position.X
		Area.gMarioSpawnInfo.startPos[1] = spawnNode.object.Position.Y
		Area.gMarioSpawnInfo.startPos[2] = spawnNode.object.Position.Z

		Area.gMarioSpawnInfo.startAngle[0] = 0
		Area.gMarioSpawnInfo.startAngle[1] = spawnNode.object.MoveAngleYaw
		Area.gMarioSpawnInfo.startAngle[2] = 0

		if marioSpawnType == MARIO_SPAWN_DOOR_WARP then
			LevelUpdate.init_door_warp(Area.gMarioSpawnInfo, LevelUpdate.sWarpDest.arg)
		end

		if LevelUpdate.sWarpDest.type == WARP_TYPE_CHANGE_LEVEL or LevelUpdate.sWarpDest.type == WARP_TYPE_CHANGE_AREA then
			Area.gMarioSpawnInfo.areaIndex = LevelUpdate.sWarpDest.areaIdx
			Area.load_mario_area()
		end

		Mario.init_marios()
		LevelUpdate.set_mario_initial_action(LevelUpdate.gMarioState, marioSpawnType, LevelUpdate.sWarpDest.arg)

		LevelUpdate.gMarioState.interactObj = spawnNode.object
		LevelUpdate.gMarioState.usedObj = spawnNode.object
end

Camera.reset_camera(Area.gCurrentArea.camera)
LevelUpdate.sWarpDest.type = WARP_TYPE_NOT_WARPING
LevelUpdate.sDelayedWarpOp = WARP_OP_NONE

        --[[switch (marioSpawnType) {
            case MARIO_SPAWN_UNKNOWN_03 =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_STAR, 0x10, 0x00, 0x00, 0x00)
                break
            case MARIO_SPAWN_DOOR_WARP =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_CIRCLE, 0x10, 0x00, 0x00, 0x00)
                break
            case MARIO_SPAWN_TELEPORT =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 0x14, 0xFF, 0xFF, 0xFF)
                break
            case MARIO_SPAWN_SPIN_AIRBORNE =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 0x1A, 0xFF, 0xFF, 0xFF)
                break
            case MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_CIRCLE, 0x10, 0x00, 0x00, 0x00)
                break
            case MARIO_SPAWN_UNKNOWN_27 =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 0x10, 0x00, 0x00, 0x00)
                break
            default =
                Area.play_transition(WARP_TRANSITION_FADE_FROM_STAR, 0x10, 0x00, 0x00, 0x00)
                break
        }]]

if Game.gCurrDemoInput == nil then
	--/     set_background_music(Area.gCurrentArea.musicParam, Area.gCurrentArea.musicParam2, 0)

	--/     if (gMarioState.flags & MARIO_METAL_CAP) {
	--/         play_cap_music(SEQUENCE_ARGS(4, SEQ_EVENT_METAL_CAP))
	--/     }

	--/     if (gMarioState.flags & (MARIO_VANISH_CAP | MARIO_WING_CAP)) {
	--/         play_cap_music(SEQUENCE_ARGS(4, SEQ_EVENT_POWERUP))
	--/     }

	--/     if (Area.gCurrLevelNum == LEVEL_BOB
	--/         and get_current_background_music() ~= SEQUENCE_ARGS(4, SEQ_LEVEL_SLIDE)
	--/         and sTimerRunning) {
	--/         play_music(SEQ_PLAYER_LEVEL, SEQUENCE_ARGS(4, SEQ_LEVEL_SLIDE), 0)
	--/     }

	--/     if (LevelUpdate.sWarpDest.levelNum == LEVEL_CASTLE and LevelUpdate.sWarpDest.areaIdx == 1
	--/         and (LevelUpdate.sWarpDest.nodeId == 31 or LevelUpdate.sWarpDest.nodeId == 32)
	--/     )
	--/         play_sound(SOUND_MENU_MARIO_CASTLE_WARP, gGlobalSoundSource)
	--/     if (LevelUpdate.sWarpDest.levelNum == LEVEL_CASTLE_GROUNDS and LevelUpdate.sWarpDest.areaIdx == 1
	--/         and (LevelUpdate.sWarpDest.nodeId == 7 or LevelUpdate.sWarpDest.nodeId == 10 or LevelUpdate.sWarpDest.nodeId == 20
	--/             or LevelUpdate.sWarpDest.nodeId == 30)) {
	--/         play_sound(SOUND_MENU_MARIO_CASTLE_WARP, gGlobalSoundSource)
	--/     }
end
end

--/ used for warps inside one level
function LevelUpdate.warp_area()
	if LevelUpdate.sWarpDest.type ~= WARP_TYPE_NOT_WARPING then
		if LevelUpdate.sWarpDest.type == WARP_TYPE_CHANGE_AREA then
			LevelUpdate.level_control_timer(TIMER_CONTROL_HIDE)
			Area.unload_mario_area()
			Area.load_area(LevelUpdate.sWarpDest.areaIdx)
		end

		LevelUpdate.init_mario_after_warp()
	end
end

--/ used for warps between levels
function LevelUpdate.warp_level()
	Area.gCurrLevelNum = LevelUpdate.sWarpDest.levelNum

	LevelUpdate.level_control_timer(TIMER_CONTROL_HIDE)

	Area.load_area(LevelUpdate.sWarpDest.areaIdx)
	LevelUpdate.init_mario_after_warp()
end

--/ LevelUpdate.function warp_credits()
--/     local --[[s32]] marioAction

--/     switch (LevelUpdate.sWarpDest.nodeId) {
--/         case WARP_NODE_CREDITS_START =
--/             marioAction = ACT_END_PEACH_CUTSCENE
--/             break

--/         case WARP_NODE_CREDITS_NEXT =
--/             marioAction = ACT_CREDITS_CUTSCENE
--/             break

--/         case WARP_NODE_CREDITS_END =
--/             marioAction = ACT_END_WAVING_CUTSCENE
--/             break
--/     }

--/     Area.gCurrLevelNum = LevelUpdate.sWarpDest.levelNum

--/     load_area(LevelUpdate.sWarpDest.areaIdx)

--/     vec3s_set(Area.gMarioSpawnInfo.startPos, gCurrCreditsEntry.marioPos{ [0] = 0},
--/               gCurrCreditsEntry.marioPos{ [0] = 1}, gCurrCreditsEntry.marioPos{ [0] = 2})

--/     vec3s_set(Area.gMarioSpawnInfo.startAngle, 0, 0x100 * gCurrCreditsEntry.marioAngle, 0)

--/     Area.gMarioSpawnInfo.areaIndex = LevelUpdate.sWarpDest.areaIdx

--/     load_mario_area()
--/     init_mario()

--/     Mario.set_mario_action(gMarioState, marioAction, 0)

--/     reset_camera(Area.gCurrentArea.camera)

--/     LevelUpdate.sWarpDest.type = WARP_TYPE_NOT_WARPING
--/     LevelUpdate.sDelayedWarpOp = WARP_OP_NONE

--/     Area.play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 0x14, 0x00, 0x00, 0x00)

--/     if (gCurrCreditsEntry == nil or gCurrCreditsEntry == sCreditsSequence) {
--/         set_background_music(Area.gCurrentArea.musicParam, Area.gCurrentArea.musicParam2, 0)
--/     }
--/ }

--/ LevelUpdate.function check_instant_warp()
--/     local --[[s16]] cameraAngle
--/     struct Surface *floor

--/     if (Area.gCurrLevelNum == LEVEL_CASTLE
--/ LevelUpdate.function save_file_get_total_star_count(1, 1, 70)
--/         return
--/     }

--/     if ((floor = gMarioState.floor) ~= nil) {
--/         local --[[s32]] index = floor.type - SURFACE_INSTANT_WARP_1B
--/         if (index >= INSTANT_WARP_INDEX_START and index < INSTANT_WARP_INDEX_STOP
--/             and Area.gCurrentArea.instantWarps ~= nil) {
--/             struct InstantWarp *warp = &Area.gCurrentArea.instantWarps{ [0] = index}

--/             if (warp.id ~= 0) {
--/                 gMarioState.pos{ [0] = 0} += warp.displacement{ [0] = 0}
--/                 gMarioState.pos{ [0] = 1} += warp.displacement{ [0] = 1}
--/                 gMarioState.pos{ [0] = 2} += warp.displacement{ [0] = 2}

--/                 gMarioState.marioObj.Position.X = gMarioState.pos{ [0] = 0}
--/                 gMarioState.marioObj.Position.Y = gMarioState.pos{ [0] = 1}
--/                 gMarioState.marioObj.Position.Z = gMarioState.pos{ [0] = 2}

--/                 cameraAngle = gMarioState.area.camera.yaw

--/                 change_area(warp.area)
--/                 gMarioState.area = Area.gCurrentArea

--/                 warp_camera(warp.displacement{ [0] = 0}, warp.displacement{ [0] = 1}, warp.displacement{ [0] = 2})

--/                 gMarioState.area.camera.yaw = cameraAngle
--/             }
--/         }
--/     }
--/ }

function LevelUpdate.music_changed_through_warp(arg)
	--/ local warpNode = Area.area_get_warp_node(arg)
	--/ local levelNum = warpNode.destLevel & 0x7F
	--/ local destArea = warpNode.destArea
	local --[[s16]] val4 = 1
	local --[[s16]] sp2C

	--/ if (levelNum == LEVEL_BOB and levelNum == Area.gCurrLevelNum and destArea == gCurrAreaIndex) {
	--/     sp2C = get_current_background_music()
	--/     if (sp2C == SEQUENCE_ARGS(4, SEQ_EVENT_POWERUP | SEQ_VARIATION)
	--/         or sp2C == SEQUENCE_ARGS(4, SEQ_EVENT_POWERUP)) {
	--/         val4 = 0
	--/     }
	--/ else
	--/     local --[[u16]] val8 = gAreas{ [0] = destArea}.musicParam
	--/     local --[[u16]] val6 = gAreas{ [0] = destArea}.musicParam2

	--/     val4 = levelNum == Area.gCurrLevelNum and val8 == Area.gCurrentArea.musicParam
	--/            and val6 == Area.gCurrentArea.musicParam2

	--/     if (get_current_background_music() ~= val6) {
	--/         val4 = 0
	--/     }
	--/ }
	return val4
end

    --[[*
     * Set the current warp type and destination level/area/node.
     ]]
function LevelUpdate.initiate_warp(destLevel, destArea, destWarpNode, arg)
	if destWarpNode >= WARP_NODE_CREDITS_MIN then
		LevelUpdate.sWarpDest.type = WARP_TYPE_CHANGE_LEVEL
	elseif destLevel ~= Area.gCurrLevelNum then
		LevelUpdate.sWarpDest.type = WARP_TYPE_CHANGE_LEVEL
	elseif destArea ~= Area.gCurrentArea.index then
		LevelUpdate.sWarpDest.type = WARP_TYPE_CHANGE_AREA
	else
		LevelUpdate.sWarpDest.type = WARP_TYPE_SAME_AREA
	end

	LevelUpdate.sWarpDest.levelNum = destLevel
	LevelUpdate.sWarpDest.areaIdx  = destArea
	LevelUpdate.sWarpDest.nodeId   = destWarpNode
	LevelUpdate.sWarpDest.arg      = arg
end

    --[[*
     * Check if Mario is above and close to a painting warp floor, and return the
     * corresponding warp node.
     ]]
function LevelUpdate.get_painting_warp_node()
	local warpNode = nil
	local paintingIndex = LevelUpdate.gMarioState.floor.type - SURFACE_PAINTING_WARP_D3

	if paintingIndex >= PAINTING_WARP_INDEX_START and paintingIndex < PAINTING_WARP_INDEX_END then
		if paintingIndex < PAINTING_WARP_INDEX_FA
			or LevelUpdate.gMarioState.pos[1] - LevelUpdate.gMarioState.floorHeight < 80.0 then
			warpNode = gLinker.Area.gCurrentArea.paintingWarpNodes{ [0] = paintingIndex}
		end
	end

	return warpNode;
end

    --[[*
     * Check is Mario has entered a painting, and if so, initiate a warp.
     ]]
function LevelUpdate.initiate_painting_warp()
	if gLinker.Area.gCurrentArea.paintingWarpNodes ~= nil and LevelUpdate.gMarioState.floor ~= nil then
		local warpNode = LevelUpdate.get_painting_warp_node()

		if warpNode ~= nil then
			if bit32.band(LevelUpdate.gMarioState.action, ACT_FLAG_INTANGIBLE) ~= 0 then
				play_painting_eject_sound()
			elseif warpNode.id ~= 0 then
				if not (bit32.band(warpNode.destLevel, 0x80) ~= 0) then
					LevelUpdate.sWarpCheckpointActive = check_warp_checkpoint(warpNode)
				end

				LevelUpdate.initiate_warp(bit32.band(warpNode.destLevel, 0x7F), warpNode.destArea, warpNode.destNode, 0)
				check_if_should_set_warp_checkpoint(warpNode)

				gLinker.Area.play_transition_after_delay(WARP_TRANSITION_FADE_INTO_COLOR, 30, 255, 255, 255, 45)
				LevelUpdate.level_set_transition(74, LevelUpdate.basic_update)

				Mario.set_mario_action(LevelUpdate.gMarioState, Mario.ACT_DISAPPEARED, 0)

				LevelUpdate.gMarioState.marioObj.gfx.flags &= ~GRAPH_RENDER_ACTIVE

				play_sound(SOUND_MENU_STAR_SOUND, gGlobalSoundSource)
				fadeout_music(398)
			end
		end
	end
end

    --[[*
     * If there is not already a delayed warp, schedule one. The source node is
     * based on the warp operation and sometimes Mario's used object.
     * Return the time left until the delayed warp is initiated.
     ]]
function LevelUpdate.level_trigger_warp(m, warpOp)
	local --[[s32]] val04 = 1

	if LevelUpdate.sDelayedWarpOp == WARP_OP_NONE then
		m.invincTimer = -1
		LevelUpdate.sDelayedWarpArg = 0
		LevelUpdate.sDelayedWarpOp = warpOp

            --[[switch (warpOp) {
                case WARP_OP_DEMO_NEXT =
                case WARP_OP_DEMO_END =
                    LevelUpdate.sDelayedWarpTimer = 20
                    LevelUpdate.sSourceWarpNodeId = WARP_NODE_F0
                    Area.gSavedCourseNum = COURSE_NONE
                    val04 = 0
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_STAR, 0x14, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_CREDITS_END =
                    LevelUpdate.sDelayedWarpTimer = 60
                    LevelUpdate.sSourceWarpNodeId = WARP_NODE_F0
                    val04 = 0
                    Area.gSavedCourseNum = COURSE_NONE
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x3C, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_STAR_EXIT =
                    LevelUpdate.sDelayedWarpTimer = 32
                    LevelUpdate.sSourceWarpNodeId = WARP_NODE_F0
                    Area.gSavedCourseNum = COURSE_NONE
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_MARIO, 0x20, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_DEATH =
                    if (m.numLives == 0) {
                        LevelUpdate.sDelayedWarpOp = WARP_OP_GAME_OVER
                    }
                    LevelUpdate.sDelayedWarpTimer = 48
                    LevelUpdate.sSourceWarpNodeId = WARP_NODE_DEATH
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_BOWSER, 0x30, 0x00, 0x00, 0x00)
                    play_sound(SOUND_MENU_BOWSER_LAUGH, gGlobalSoundSource)
                    break

                case WARP_OP_WARP_FLOOR =
                    LevelUpdate.sSourceWarpNodeId = WARP_NODE_WARP_FLOOR
                    if (!Area.area_get_warp_node(LevelUpdate.sSourceWarpNodeId)) {
                        if (m.numLives == 0) {
                            LevelUpdate.sDelayedWarpOp = WARP_OP_GAME_OVER
                        else
                            LevelUpdate.sSourceWarpNodeId = WARP_NODE_DEATH
                        }
                    }
                    LevelUpdate.sDelayedWarpTimer = 20
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_CIRCLE, 0x14, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_UNKNOWN_01 =   --/ enter totwc
                    LevelUpdate.sDelayedWarpTimer = 30
                    LevelUpdate.sSourceWarpNodeId = WARP_NODE_F2
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x1E, 0xFF, 0xFF, 0xFF)
                    play_sound(SOUND_MENU_STAR_SOUND, gGlobalSoundSource)
                    break

                case WARP_OP_UNKNOWN_02 =   --/ bbh enter
                    LevelUpdate.sDelayedWarpTimer = 30
                    LevelUpdate.sSourceWarpNodeId = (m.usedObj.BhvParams & 0x00FF0000) >> 16
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x1E, 0xFF, 0xFF, 0xFF)
                    break

                case WARP_OP_TELEPORT =
                    LevelUpdate.sDelayedWarpTimer = 20
                    LevelUpdate.sSourceWarpNodeId = (m.usedObj.BhvParams & 0x00FF0000) >> 16
                    val04 = !LevelUpdate.music_changed_through_warp(LevelUpdate.sSourceWarpNodeId)
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x14, 0xFF, 0xFF, 0xFF)
                    break

                case WARP_OP_WARP_DOOR =
                    LevelUpdate.sDelayedWarpTimer = 20
                    LevelUpdate.sDelayedWarpArg = m.actionArg
                    LevelUpdate.sSourceWarpNodeId = (m.usedObj.BhvParams & 0x00FF0000) >> 16
                    val04 = !LevelUpdate.music_changed_through_warp(LevelUpdate.sSourceWarpNodeId)
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_CIRCLE, 0x14, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_WARP_OBJECT =
                    LevelUpdate.sDelayedWarpTimer = 20
                    LevelUpdate.sSourceWarpNodeId = (m.usedObj.BhvParams & 0x00FF0000) >> 16
                    val04 = !LevelUpdate.music_changed_through_warp(LevelUpdate.sSourceWarpNodeId)
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_STAR, 0x14, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_CREDITS_START =
                    LevelUpdate.sDelayedWarpTimer = 30
                    Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x1E, 0x00, 0x00, 0x00)
                    break

                case WARP_OP_CREDITS_NEXT =
                    if (gCurrCreditsEntry == sCreditsSequence{ [0] = 0}) {
                        LevelUpdate.sDelayedWarpTimer = 60
                        Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x3C, 0x00, 0x00, 0x00)
                    else
                        LevelUpdate.sDelayedWarpTimer = 20
                        Area.play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 0x14, 0x00, 0x00, 0x00)
                    }
                    val04 = 0
                    break
            }]]

		if val04 and true then  --/ !gCurrDemoInput) {
			fadeout_music((3 * LevelUpdate.sDelayedWarpTimer / 2) * 8 - 2)
		end
	end

	return LevelUpdate.sDelayedWarpTimer
end

    --[[*
     * If a delayed warp is ready, initiate it.
     ]]
function LevelUpdate.initiate_delayed_warp()
	local warpNode
	local destWarpNode

	self.sDelayedWarpTimer = self.sDelayedWarpTimer - 1
	if self.sDelayedWarpOp ~= WARP_OP_NONE and self.sDelayedWarpTimer == 0 then
		--/ reset_dialog_render_state()

		warn('TODO')
		if (false) then  --/ gDebugLevelSelect and (LevelUpdate.sDelayedWarpOp & WARP_OP_TRIGGERS_LEVEL_SELECT)) {
			LevelUpdate.warp_special(-9)
		elseif (false) then  --/ gCurrDemoInput ~= nil) {
			if LevelUpdate.sDelayedWarpOp == WARP_OP_DEMO_END then
				LevelUpdate.warp_special(-8)
			else
				LevelUpdate.warp_special(-2)
			end
		else
                --[[switch (LevelUpdate.sDelayedWarpOp) {
                    case WARP_OP_GAME_OVER =
                        --/ save_file_reload()
                        LevelUpdate.warp_special(-3)
                        break

                    case WARP_OP_CREDITS_END =
                        LevelUpdate.warp_special(-1)
                        sound_banks_enable(SEQ_PLAYER_SFX,
                                           SOUND_BANKS_ALL & ~SOUND_BANKS_DISABLED_AFTER_CREDITS)
                        break

                    case WARP_OP_DEMO_NEXT =
                        LevelUpdate.warp_special(-2)
                        break

                    case WARP_OP_CREDITS_START =
                        gCurrCreditsEntry = sCreditsSequence{ [0] = 0}
                        LevelUpdate.initiate_warp(gCurrCreditsEntry.levelNum, gCurrCreditsEntry.areaIndex,
                                      WARP_NODE_CREDITS_START, 0)
                        break

                    case WARP_OP_CREDITS_NEXT =
                        sound_banks_disable(SEQ_PLAYER_SFX, SOUND_BANKS_ALL)

                        gCurrCreditsEntry += 1
                        gCurrActNum = gCurrCreditsEntry.unk02 & 0x07
                        if ((gCurrCreditsEntry + 1).levelNum == LEVEL_NONE) {
                            destWarpNode = WARP_NODE_CREDITS_END
                        else
                            destWarpNode = WARP_NODE_CREDITS_NEXT
                        }

                        LevelUpdate.initiate_warp(gCurrCreditsEntry.levelNum, gCurrCreditsEntry.areaIndex,
                                      destWarpNode, 0)
                        break

                    default =
                        warpNode = Area.area_get_warp_node(LevelUpdate.sSourceWarpNodeId)

                        LevelUpdate.initiate_warp(warpNode.destLevel & 0x7F, warpNode.destArea,
                                      warpNode.destNode, LevelUpdate.sDelayedWarpArg)

                        check_if_should_set_warp_checkpoint(warpNode)
                        if (LevelUpdate.sWarpDest.type ~= WARP_TYPE_CHANGE_LEVEL) {
                            LevelUpdate.level_set_transition(2, nil)
                        }
                        break
                }]]
		end
	end
end

function LevelUpdate.update_hud_values()
        --[[if gLinker.Area.gCurrCreditsEntry == nil then
		local numHealthWedges = LevelUpdate.gMarioState.health > 0 and bit32.rshift(LevelUpdate.gMarioState.health, 8) or 0 -- LevelUpdate.gMarioState.health > 0 ? LevelUpdate.gMarioState.health >> 8 = 0

            if gLinker.Area.gCurrCourseNum >= CourseTable.COURSE_MIN then
			LevelUpdate.gHudDisplay.flags = bit32.bor(LevelUpdate.gHudDisplay.flags, LevelUpdate.HUD_DISPLAY_FLAG_COIN_COUNT)
            else
			LevelUpdate.gHudDisplay.flags = bit32.band(LevelUpdate.gHudDisplay.flags, bit32.bnot(LevelUpdate.HUD_DISPLAY_FLAG_COIN_COUNT))
            end

            if LevelUpdate.gHudDisplay.coins < LevelUpdate.gMarioState.numCoins then
			if bit32.band(window.gGlobalTimer, 1) ~= 0 then
                    local coinSound;
                    if (LevelUpdate.gMarioState.action & (Mario.ACT_FLAG_SWIMMING | Mario.ACT_FLAG_METAL_WATER)) {
                        coinSound = SOUND_GENERAL_COIN_WATER;
                    else
                        coinSound = SOUND_GENERAL_COIN;
                    }

                    LevelUpdate.gHudDisplay.coins += 1;
                    play_sound(coinSound, LevelUpdate.gMarioState.marioObj.gfx.cameraToObject);
                }
            }

            if (LevelUpdate.gMarioState.numLives > 100) {
                LevelUpdate.gMarioState.numLives = 100;
            }

            if (LevelUpdate.gMarioState.numCoins > 999) {
                LevelUpdate.gMarioState.numCoins = 999;
            }

            LevelUpdate.gHudDisplay.stars = LevelUpdate.gMarioState.numStars;
            LevelUpdate.gHudDisplay.lives = LevelUpdate.gMarioState.numLives;
            LevelUpdate.gHudDisplay.keys = LevelUpdate.gMarioState.numKeys;

            if (numHealthWedges > LevelUpdate.gHudDisplay.wedges) {
                play_sound(SOUND_MENU_POWER_METER, gGlobalSoundSource);
            }
            LevelUpdate.gHudDisplay.wedges = numHealthWedges;

            if (LevelUpdate.gMarioState.hurtCounter > 0) {
                LevelUpdate.gHudDisplay.flags |= LevelUpdate.HUD_DISPLAY_FLAG_EMPHASIZE_POWER;
            else
                LevelUpdate.gHudDisplay.flags &= ~LevelUpdate.HUD_DISPLAY_FLAG_EMPHASIZE_POWER;
            }
        }]]
end

function LevelUpdate.basic_update(arg)
	gLinker.Area.area_update_objects();
	LevelUpdate.update_hud_values();

	if gLinker.Area.gCurrentArea ~= nil then
		Camera.update_camera(gLinker.Area.gCurrentArea.camera);
	end
end


function LevelUpdate.play_mode_normal()
	--/ if (gCurrDemoInput ~= nil) {
	--/     print_intro_text()
	--/     if (gPlayer1Controller.buttonPressed & END_DEMO) {
	--/         LevelUpdate.level_trigger_warp(gMarioState,
	--/                            Area.gCurrLevelNum == LEVEL_PSS ? WARP_OP_DEMO_END = WARP_OP_DEMO_NEXT)
	--/     elseif (!gWarpTransition.isActive and LevelUpdate.sDelayedWarpOp == WARP_OP_NONE
	--/                and (gPlayer1Controller.buttonPressed & START_BUTTON)) {
	--/         LevelUpdate.level_trigger_warp(gMarioState, WARP_OP_DEMO_NEXT)
	--/     }
	--/ }

	LevelUpdate.warp_area()
	--/ check_instant_warp()

	--/ if (sTimerRunning and gHudDisplay.timer < 17999) {
	--/     gHudDisplay.timer += 1
	--/ }

	gLinker.Area.area_update_objects()
	LevelUpdate.update_hud_values()

	if Area.gCurrentArea then
		Camera.update_camera(Area.gCurrentArea.camera)
	end

	LevelUpdate.initiate_painting_warp()
	LevelUpdate.initiate_delayed_warp()

	--/ If either initiate_painting_warp or initiate_delayed_warp initiated a
	--/ warp, change play mode accordingly.
	if LevelUpdate.sCurrPlayMode == PLAY_MODE_NORMAL then
		if LevelUpdate.sWarpDest.type == WARP_TYPE_CHANGE_LEVEL then
			LevelUpdate.set_play_mode(PLAY_MODE_CHANGE_LEVEL)
		elseif LevelUpdate.sTransitionTimer ~= 0 then
			LevelUpdate.set_play_mode(PLAY_MODE_CHANGE_AREA)
		elseif LevelUpdate.pressed_pause() then
			--/ lower_background_noise(1)
			Camera.gCameraMovementFlags |= CAM_MOVE_PAUSE_SCREEN
			LevelUpdate.set_play_mode(PLAY_MODE_PAUSED)
		end
	end

	return false
end

function LevelUpdate.play_mode_paused()
	if Area.gMenuOptSelectIndex == MENU_OPT_NONE then
		IngameMenu.set_menu_mode(MENU_MODE_RENDER_PAUSE_SCREEN);
	elseif Area.gMenuOptSelectIndex == MENU_OPT_DEFAULT then
		raise_background_noise(1);
		Camera.gCameraMovementFlags = bit32.band(Camera.gCameraMovementFlags, bit32.bnot(CAM_MOVE_PAUSE_SCREEN))
		LevelUpdate.set_play_mode(PLAY_MODE_NORMAL);
	else --/ MENU_OPT_EXIT_COURSE
		if window.gDebugLevelSelect then
			LevelUpdate.fade_into_special_warp(-9, 1);
		else
			LevelUpdate.initiate_warp(LEVEL_CASTLE, 1, 0x1F, 0);
			LevelUpdate.fade_into_special_warp(0, 0);
			Area.gSavedCourseNum = COURSE_NONE;
		end

		Camera.gCameraMovementFlags &= ~CAM_MOVE_PAUSE_SCREEN;
	end

	return 0;
end

    --[[*
     * Set the transition, which is a period of time after the warp is initiated
     * but before it actually occurs. If updateFunction is not NULL, it will be
     * called each frame during the transition.
     ]]
function LevelUpdate.level_set_transition(length, updateFunction)
	LevelUpdate.sTransitionTimer = length
	LevelUpdate.sTransitionUpdate = updateFunction
	if updateFunction then
		LevelUpdate.sTransitionUpdate = LevelUpdate.sTransitionUpdate.bind(LevelUpdate)
	end
end

    --[[*
     * Play the transition and then return to normal play mode.
     ]]
function LevelUpdate.play_mode_change_area()
	--/! This maybe was supposed to be sTransitionTimer == -1? sTransitionUpdate
	--/ is never set to -1.
	if LevelUpdate.sTransitionTimer == - 1 then
		Camera.update_camera(Area.gCurrentArea.camera)
	elseif LevelUpdate.sTransitionUpdate then
		LevelUpdate.sTransitionUpdate(LevelUpdate.sTransitionTimer)
	end

	if LevelUpdate.sTransitionTimer > 0 then
		LevelUpdate.sTransitionTimer -= 1
	end

	if LevelUpdate.sTransitionTimer == 0 then
		LevelUpdate.sTransitionUpdate = nil
		LevelUpdate.set_play_mode(PLAY_MODE_NORMAL)
	end

	return false
end

    --[[*
     * Play the transition and then return to normal play mode.
     ]]
function LevelUpdate.play_mode_change_level()
	if LevelUpdate.sTransitionUpdate then
		LevelUpdate.sTransitionUpdate.call(LevelUpdate.sTransitionTimer)
	end

	LevelUpdate.sTransitionTimer -= 1
	if LevelUpdate.sTransitionTimer == -1 then
		LevelUpdate.gHudDisplay.flags = LevelUpdate.HUD_DISPLAY_NONE
		LevelUpdate.sTransitionTimer = 0
		LevelUpdate.sTransitionUpdate = nil

		if LevelUpdate.sWarpDest.type ~= WARP_TYPE_NOT_WARPING then
			return LevelUpdate.sWarpDest.levelNum
		else
			return LevelUpdate.warpSpecialLevel
		end
	end

	return false
end


function LevelUpdate.update_level()
	local changeLevel

        --[[switch (LevelUpdate.sCurrPlayMode) {
            case PLAY_MODE_NORMAL =
                changeLevel = LevelUpdate.play_mode_normal()
                break
            case PLAY_MODE_PAUSED =
                changeLevel = LevelUpdate.play_mode_paused()
                break
            case PLAY_MODE_CHANGE_AREA =
                changeLevel = LevelUpdate.play_mode_change_area()
                break
            case PLAY_MODE_CHANGE_LEVEL =
                changeLevel = LevelUpdate.play_mode_change_level()
                break
            case PLAY_MODE_FRAME_ADVANCE =
                changeLevel = LevelUpdate.play_mode_frame_advance()
                break
        }]]

	if changeLevel then
		--/ reset_volume()
		--/ enable_background_sound()
	end

	return changeLevel
end

function LevelUpdate.set_play_mode(playMode)
	LevelUpdate.sCurrPlayMode = playMode
end

function LevelUpdate.load_level_init_text(arg)
	warn('TODO')
end

-- gLinker.LevelUpdate = LevelUpdateInstance

function LevelUpdate.level_trigger_warp(m, warpOp)
	LevelUpdateInstance.level_trigger_warp(m, warpOp)
end

return LevelUpdate