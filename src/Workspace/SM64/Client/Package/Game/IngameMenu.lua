local IngameMenu = {}

local Text = require(script.Parent.Text)

local DIALOG_005, DIALOG_009, DIALOG_010, DIALOG_011, DIALOG_012, DIALOG_013, DIALOG_014, DIALOG_017, DIALOG_020, DIALOG_055, DIALOG_114, DIALOG_115, DIALOG_116, DIALOG_117, DIALOG_118, DIALOG_128, DIALOG_150, DIALOG_152, DIALOG_164, DIALOG_NONE, seg2_dialog_table = Text.US.Dialogs.DIALOG_005, Text.US.Dialogs.DIALOG_009, Text.US.Dialogs.DIALOG_010, Text.US.Dialogs.DIALOG_011, Text.US.Dialogs.DIALOG_012, Text.US.Dialogs.DIALOG_013, Text.US.Dialogs.DIALOG_014, Text.US.Dialogs.DIALOG_017, Text.US.Dialogs.DIALOG_020, Text.US.Dialogs.DIALOG_055, Text.US.Dialogs.DIALOG_114, Text.US.Dialogs.DIALOG_115, Text.US.Dialogs.DIALOG_116, Text.US.Dialogs.DIALOG_117, Text.US.Dialogs.DIALOG_118, Text.US.Dialogs.DIALOG_128, Text.US.Dialogs.DIALOG_150, Text.US.Dialogs.DIALOG_152, Text.US.Dialogs.DIALOG_164, Text.US.Dialogs.DIALOG_NONE, Text.US.Dialogs.seg2_dialog_table

--[[import { SEQUENCE_ARGS, SEQ_PLAYER_LEVEL, play_music, play_sound, seq_player_lower_volume, seq_player_unlower_volume } from "../audio/external"
import { dl_draw_text_bg_box, dl_draw_triangle, dl_ia_text_begin, dl_ia_text_end, dl_ia_text_tex_settings, dl_rgba16_load_tex_block, dl_rgba16_text_begin, dl_rgba16_text_end, main_font_lut, main_hud_lut } from "../bin/segment2"
import * as MathUtil from "../engine/math_util"
import { SCREEN_WIDTH, SCREEN_HEIGHT } from "../include/config"
import * as Gbi from "../include/gbi"
import { SOUND_GENERAL_COLLECT_1UP, SOUND_MENU_CHANGE_SELECT, SOUND_MENU_MESSAGE_APPEAR, SOUND_MENU_MESSAGE_DISAPPEAR, SOUND_MENU_MESSAGE_NEXT_PAGE, SOUND_MENU_PAUSE, SOUND_MENU_PAUSE_2, SOUND_MENU_STAR_SOUND, SOUND_MENU_YOSHI_GAIN_LIVES } from "../include/sounds"
import { menu_font_lut, menu_hud_lut } from "../levels/menu/leveldata"
import { GameInstance as Game } from "./Game"
import { PrintInstance as Print } from "./Print"
import { gCurrCourseStarFlags, gGotFileCoinHiScore, gLastCompletedCourseNum, gLastCompletedStarNum, save_file_get_course_coin_score, save_file_get_course_star_count, save_file_get_max_coin_score, save_file_get_star_flags, save_file_get_total_star_count } from "./SaveFile"
import { CameraInstance as Camera } from "./Camera"
import { TEXT_CAMERA_ANGLE_R, TEXT_CLEAR, TEXT_COIN, TEXT_CONTINUE, TEXT_CONTINUE_WITHOUT_SAVING, TEXT_COURSE, TEXT_EXIT_COURSE, TEXT_FILE_MARIO_EXCLAMATION, TEXT_FILE_MARIO_QUESTION, TEXT_FOR_MARIO, TEXT_HI_SCORE, TEXT_LAKITU_MARIO, TEXT_LAKITU_STOP, TEXT_LETS_HAVE_CAKE, TEXT_LISTEN_EVERYBODY, TEXT_MY_SCORE, TEXT_NORMAL_FIXED, TEXT_NORMAL_UPCLOSE, TEXT_PAUSE, TEXT_POWER_STARS_RESTORED, TEXT_SAVE_AND_CONTINUE, TEXT_SAVE_AND_QUIT, TEXT_SOMETHING_SPECIAL, TEXT_STAR, TEXT_STAR_X, TEXT_THANKS_TO_YOU, TEXT_THANK_YOU_MARIO, TEXT_UNFILLED_STAR } from "../include/text_strings"
import { seg2_act_name_table, seg2_course_name_table } from "../text/us/courses"
import { COURSE_BITFS, COURSE_BONUS_STAGES, COURSE_NUM_TO_INDEX, COURSE_STAGES_MAX } from "../levels/course_defines"
import { COURSE_BITDW, COURSE_MAX, COURSE_MIN, COURSE_NONE } from "../include/course_table"
import { ACT_FLAG_PAUSE_EXIT } from "./Mario"
import { coin_seg3_dl_03007940, coin_seg3_dl_03007968, coin_seg3_dl_03007990, coin_seg3_dl_030079B8 } from "../actors/coin/model.inc"
import { GFX_DIMENSIONS_FROM_LEFT_EDGE, GFX_DIMENSIONS_FROM_RIGHT_EDGE } from "../include/gfx_dimensions"
import { castle_grounds_seg7_dl_0700EA58 } from "../levels/castle_grounds/areas/1/12/model.inc"
import { castle_grounds_seg7_us_dl_0700F2E8 } from "../levels/castle_grounds/areas/1/13/model.inc"
import { SEQ_EVENT_BOSS } from "../include/seq_ids"
import { Util.Sins } from "../utils"]]

function ASCII_TO_DIALOG(asc)
	local byte = string.byte(asc)
	if byte >= string.byte('0') and byte <= string.byte('9') then
		return byte - string.byte('0')
	elseif byte >= string.byte('A') and byte <= string.byte('Z') then
		return byte - string.byte('A') + 0x0A
	elseif byte >= string.byte('a') and byte <= string.byte('z') then
		return byte - string.byte('a') + 0x24
	else
		return 0x00
	end
end
IngameMenu.ASCII_TO_DIALOG = ASCII_TO_DIALOG

--[[function ASCII_TO_DIALOG(asc)
    return (((asc) >= '0' && (asc) <= '9') ? ((asc) - '0') :
     ((asc) >= 'A' && (asc) <= 'Z') ? ((asc) - 'A' + 0x0A) :
     ((asc) >= 'a' && (asc) <= 'z') ? ((asc) - 'a' + 0x24) : 0x00)
end]]

IngameMenu.DIALOG_RESPONSE_NONE = 0
IngameMenu.DIALOG_RESPONSE_YES = 1
IngameMenu.DIALOG_RESPONSE_NO = 2
IngameMenu.DIALOG_RESPONSE_NOT_DEFINED = 3

IngameMenu.MENU_MTX_PUSH = 1
IngameMenu.MENU_MTX_NOPUSH = 2

IngameMenu.MENU_OPT_NONE = 0;
IngameMenu.MENU_OPT_1 = 1;
IngameMenu.MENU_OPT_2 = 2;
IngameMenu.MENU_OPT_3 = 3;
IngameMenu.MENU_OPT_DEFAULT = IngameMenu.MENU_OPT_1;

IngameMenu.MENU_OPT_CONTINUE = IngameMenu.MENU_OPT_1;
IngameMenu.MENU_OPT_EXIT_COURSE = IngameMenu.MENU_OPT_2;
IngameMenu.MENU_OPT_CAMERA_ANGLE_R = IngameMenu.MENU_OPT_3;

IngameMenu.MENU_OPT_SAVE_AND_CONTINUE = IngameMenu.MENU_OPT_1;
IngameMenu.MENU_OPT_SAVE_AND_QUIT = IngameMenu.MENU_OPT_2;
IngameMenu.MENU_OPT_CONTINUE_DONT_SAVE = IngameMenu.MENU_OPT_3;

IngameMenu.DIALOG_BOX_ANGLE_DEFAULT = 90.0
IngameMenu.DIALOG_BOX_SCALE_DEFAULT = 19.0

IngameMenu.TEXT_THE_RAW = { [0] = ASCII_TO_DIALOG('t'), ASCII_TO_DIALOG('h'), ASCII_TO_DIALOG('e'), 0x00}
IngameMenu.TEXT_YOU_RAW = { [0] = ASCII_TO_DIALOG('y'), ASCII_TO_DIALOG('o'), ASCII_TO_DIALOG('u'), 0x00}

IngameMenu.MAX_STRING_WIDTH = 16

IngameMenu.HUD_LUT_JPMENU = 1
IngameMenu.HUD_LUT_GLOBAL = 2

IngameMenu.DIALOG_MARK_NONE = 0
IngameMenu.DIALOG_MARK_DAKUTEN = 1
IngameMenu.DIALOG_MARK_HANDAKUTEN = 2

IngameMenu.HUD_PRINT_HISCORE = 0
IngameMenu.HUD_PRINT_CONGRATULATIONS = 1

IngameMenu.MENU_SCROLL_VERTICAL = 1
IngameMenu.MENU_SCROLL_HORIZONTAL = 2


IngameMenu.CAM_SELECTION_MARIO = 1
IngameMenu.CAM_SELECTION_FIXED = 2

MENU_OPT_1, DIALOG_MARK_DAKUTEN, DIALOG_RESPONSE_YES, CAM_SELECTION_FIXED, MENU_SCROLL_HORIZONTAL, DIALOG_RESPONSE_NOT_DEFINED, HUD_LUT_GLOBAL, DIALOG_MARK_NONE, CAM_SELECTION_MARIO, MENU_MTX_PUSH, MENU_SCROLL_VERTICAL, HUD_LUT_JPMENU, MENU_OPT_2, MAX_STRING_WIDTH, MENU_OPT_3, HUD_PRINT_CONGRATULATIONS, DIALOG_BOX_SCALE_DEFAULT, HUD_PRINT_HISCORE, DIALOG_MARK_HANDAKUTEN, DIALOG_BOX_ANGLE_DEFAULT, DIALOG_RESPONSE_NO, MENU_OPT_NONE, DIALOG_RESPONSE_NONE, MENU_MTX_NOPUSH = IngameMenu.MENU_OPT_1,IngameMenu.DIALOG_MARK_DAKUTEN,IngameMenu.DIALOG_RESPONSE_YES,IngameMenu.CAM_SELECTION_FIXED,IngameMenu.MENU_SCROLL_HORIZONTAL,IngameMenu.DIALOG_RESPONSE_NOT_DEFINED,IngameMenu.HUD_LUT_GLOBAL,IngameMenu.DIALOG_MARK_NONE,IngameMenu.CAM_SELECTION_MARIO,IngameMenu.MENU_MTX_PUSH,IngameMenu.MENU_SCROLL_VERTICAL,IngameMenu.HUD_LUT_JPMENU,IngameMenu.MENU_OPT_2,IngameMenu.MAX_STRING_WIDTH,IngameMenu.MENU_OPT_3,IngameMenu.HUD_PRINT_CONGRATULATIONS,IngameMenu.DIALOG_BOX_SCALE_DEFAULT,IngameMenu.HUD_PRINT_HISCORE,IngameMenu.DIALOG_MARK_HANDAKUTEN,IngameMenu.DIALOG_BOX_ANGLE_DEFAULT,IngameMenu.DIALOG_RESPONSE_NO,IngameMenu.MENU_OPT_NONE,IngameMenu.DIALOG_RESPONSE_NONE,IngameMenu.MENU_MTX_NOPUSH


local DIALOG_CHAR_SLASH =                0xD0
local DIALOG_CHAR_MULTI_THE =            0xD1 --/ 'the'
local DIALOG_CHAR_MULTI_YOU =            0xD2 --/ 'you'
local DIALOG_CHAR_PERIOD =               0x6E
local DIALOG_CHAR_COMMA =                0x6F
local DIALOG_CHAR_SPACE =                0x9E
local DIALOG_CHAR_STAR_COUNT =           0xE0 --/ number of stars
local DIALOG_CHAR_UMLAUT =               0xE9
local DIALOG_CHAR_MARK_START =           0xEF
local DIALOG_CHAR_DAKUTEN =              0xEF + DIALOG_MARK_DAKUTEN
local DIALOG_CHAR_PERIOD_OR_HANDAKUTEN = 0xEF + DIALOG_MARK_HANDAKUTEN
local DIALOG_CHAR_STAR_FILLED =          0xFA
local DIALOG_CHAR_STAR_OPEN =            0xFD
local DIALOG_CHAR_NEWLINE =              0xFE
local DIALOG_CHAR_TERMINATOR =           0xFF

local GLOBAL_CHAR_SPACE = 0x9E
local GLOBAL_CHAR_TERMINATOR = 0xFF


local STRING_THE = 0
local STRING_YOU = 1

--/--/ MENU STATES --/--/
IngameMenu.MENU_STATE_0 = 0;
IngameMenu.MENU_STATE_1 = 1;
IngameMenu.MENU_STATE_2 = 2;
IngameMenu.MENU_STATE_3 = 3;
IngameMenu.MENU_STATE_DEFAULT = IngameMenu.MENU_STATE_0;

--/ Dialog
IngameMenu.MENU_STATE_DIALOG_OPENING = IngameMenu.MENU_STATE_0;
IngameMenu.MENU_STATE_DIALOG_OPEN = IngameMenu.MENU_STATE_1;
IngameMenu.MENU_STATE_DIALOG_SCROLLING = IngameMenu.MENU_STATE_2;
IngameMenu.MENU_STATE_DIALOG_CLOSING = IngameMenu.MENU_STATE_3;

--/ Pause Screen
IngameMenu.MENU_STATE_PAUSE_SCREEN_OPENING = IngameMenu.MENU_STATE_0;
IngameMenu.MENU_STATE_PAUSE_SCREEN_COURSE = IngameMenu.MENU_STATE_1;
IngameMenu.MENU_STATE_PAUSE_SCREEN_CASTLE = IngameMenu.MENU_STATE_2;

--/ Course Complete Screen
IngameMenu.MENU_STATE_COURSE_COMPLETE_SCREEN_OPENING = IngameMenu.MENU_STATE_0;
IngameMenu.MENU_STATE_COURSE_COMPLETE_SCREEN_OPEN = IngameMenu.MENU_STATE_1;

--/ MODES --/
IngameMenu.MENU_MODE_NONE = -1;
IngameMenu.MENU_MODE_UNUSED_0 = 0;
IngameMenu.MENU_MODE_RENDER_PAUSE_SCREEN = 1;
IngameMenu.MENU_MODE_RENDER_COURSE_COMPLETE_SCREEN = 2;
IngameMenu.MENU_MODE_UNUSED_3 = 3;

--/--/ DIALOG STATES --/--/
IngameMenu.DIALOG_PAGE_STATE_NONE = 0;
IngameMenu.DIALOG_PAGE_STATE_SCROLL = 1;
IngameMenu.DIALOG_PAGE_STATE_END = 2;

--/--/ DIALOG BOX TYPE --/--/
IngameMenu.DIALOG_TYPE_ROTATE = 0;
IngameMenu.DIALOG_TYPE_ZOOM = 1;

DIALOG_PAGE_STATE_NONE, MENU_STATE_PAUSE_SCREEN_OPENING, MENU_STATE_COURSE_COMPLETE_SCREEN_OPENING, MENU_STATE_DIALOG_OPEN, DIALOG_PAGE_STATE_END, DIALOG_TYPE_ROTATE, MENU_MODE_UNUSED_0, MENU_STATE_DIALOG_CLOSING, DIALOG_TYPE_ZOOM, DIALOG_PAGE_STATE_SCROLL, MENU_MODE_UNUSED_3, MENU_STATE_PAUSE_SCREEN_CASTLE, MENU_STATE_DIALOG_OPENING, MENU_MODE_RENDER_COURSE_COMPLETE_SCREEN, MENU_STATE_DEFAULT, MENU_STATE_3, MENU_STATE_1, MENU_STATE_PAUSE_SCREEN_COURSE, MENU_MODE_RENDER_PAUSE_SCREEN, MENU_STATE_2, MENU_MODE_NONE, MENU_STATE_DIALOG_SCROLLING, MENU_STATE_COURSE_COMPLETE_SCREEN_OPEN, MENU_STATE_0 = IngameMenu.DIALOG_PAGE_STATE_NONE,IngameMenu.MENU_STATE_PAUSE_SCREEN_OPENING,IngameMenu.MENU_STATE_COURSE_COMPLETE_SCREEN_OPENING,IngameMenu.MENU_STATE_DIALOG_OPEN,IngameMenu.DIALOG_PAGE_STATE_END,IngameMenu.DIALOG_TYPE_ROTATE,IngameMenu.MENU_MODE_UNUSED_0,IngameMenu.MENU_STATE_DIALOG_CLOSING,IngameMenu.DIALOG_TYPE_ZOOM,IngameMenu.DIALOG_PAGE_STATE_SCROLL,IngameMenu.MENU_MODE_UNUSED_3,IngameMenu.MENU_STATE_PAUSE_SCREEN_CASTLE,IngameMenu.MENU_STATE_DIALOG_OPENING,IngameMenu.MENU_MODE_RENDER_COURSE_COMPLETE_SCREEN,IngameMenu.MENU_STATE_DEFAULT,IngameMenu.MENU_STATE_3,IngameMenu.MENU_STATE_1,IngameMenu.MENU_STATE_PAUSE_SCREEN_COURSE,IngameMenu.MENU_MODE_RENDER_PAUSE_SCREEN,IngameMenu.MENU_STATE_2,IngameMenu.MENU_MODE_NONE,IngameMenu.MENU_STATE_DIALOG_SCROLLING,IngameMenu.MENU_STATE_COURSE_COMPLETE_SCREEN_OPEN,IngameMenu.MENU_STATE_0

IngameMenu.gDialogCharWidths = { [0] =
	7,  7,  7,  7,  7,  7,  7,  7,  7,  7,  6,  6,  6,  6,  6,  6,
	6,  6,  5,  6,  6,  5,  8,  8,  6,  6,  6,  6,  6,  5,  6,  6,
	8,  7,  6,  6,  6,  5,  5,  6,  5,  5,  6,  5,  4,  5,  5,  3,
	7,  5,  5,  5,  6,  5,  5,  5,  5,  5,  7,  7,  5,  5,  4,  4,
	8,  6,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	8,  8,  8,  8,  7,  7,  6,  7,  7,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  4,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  5,  6,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	7,  5, 10,  5,  9,  8,  4,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  5,  7,  7,  6,  6,  8,  0,  8, 10,  6,  4, 10,  0,  0
}

IngameMenu.strPos = 0
IngameMenu.lineNum = 1

IngameMenu.gMenuTextColorTransTimer = 0;
IngameMenu.gLastDialogLineNum = 0;
IngameMenu.gDialogVariable = 0;
IngameMenu.gMenuTextAlpha = 0;

IngameMenu.gCutsceneMsgXOffset = 0;
IngameMenu.gCutsceneMsgYOffset = 0;

IngameMenu.gMenuHoldKeyIndex = 0;
IngameMenu.gMenuHoldKeyTimer = 0;

IngameMenu.gCourseCompleteCoinsEqual = false;
IngameMenu.gCourseCompleteScreenTimer = 0;
IngameMenu.gCourseCompleteCoins = 0;

-- IngameMenu.gHudSymCoin = { [0] = Print.GLYPH_COIN, Print.GLYPH_SPACE };
-- IngameMenu.gHudSymX = { [0] = Print.GLYPH_MULTIPLY, Print.GLYPH_SPACE };
IngameMenu.gHudFlash = 0;

IngameMenu.gMenuState = IngameMenu.MENU_STATE_DEFAULT
IngameMenu.gMenuMode = IngameMenu.MENU_MODE_NONE
IngameMenu.gDialogBoxAngle = DIALOG_BOX_ANGLE_DEFAULT;
IngameMenu.gDialogBoxScale = DIALOG_BOX_SCALE_DEFAULT;
IngameMenu.gDialogScrollOffsetY = 0;
IngameMenu.gDialogBoxType = IngameMenu.DIALOG_TYPE_ROTATE;
IngameMenu.gDialogID = DIALOG_NONE.id;
IngameMenu.gNextDialogPageStartStrIndex = 0;
IngameMenu.gDialogPageStartStrIndex = 0;
IngameMenu.gMenuLineNum = 1;
IngameMenu.gDialogWithChoice = false;
IngameMenu.gMenuHoldKeyIndex = 0;
IngameMenu.gMenuHoldKeyTimer = 0;
IngameMenu.gDialogResponse = DIALOG_RESPONSE_NONE;

IngameMenu.gCutsceneMsgFade = 0;
IngameMenu.gCutsceneMsgIndex = -1;
IngameMenu.gCutsceneMsgDuration = -1;
IngameMenu.gCutsceneMsgTimer = 0;
IngameMenu.gDialogCameraAngleIndex = CAM_SELECTION_MARIO;
IngameMenu.gDialogCourseActNum = 1;

        --[[IngameMenu.gEndCutsceneStr0 = TEXT_FILE_MARIO_EXCLAMATION;
        IngameMenu.gEndCutsceneStr1 = TEXT_POWER_STARS_RESTORED;
        IngameMenu.gEndCutsceneStr2 = TEXT_THANKS_TO_YOU;
        IngameMenu.gEndCutsceneStr3 = TEXT_THANK_YOU_MARIO;
        IngameMenu.gEndCutsceneStr4 = TEXT_SOMETHING_SPECIAL;
        IngameMenu.gEndCutsceneStr5 = TEXT_LISTEN_EVERYBODY;
        IngameMenu.gEndCutsceneStr6 = TEXT_LETS_HAVE_CAKE;
        IngameMenu.gEndCutsceneStr7 = TEXT_FOR_MARIO;
        IngameMenu.gEndCutsceneStr8 = TEXT_FILE_MARIO_QUESTION;
        IngameMenu.gEndCutsceneStrings = { [0] =
            IngameMenu.gEndCutsceneStr0, IngameMenu.gEndCutsceneStr1, IngameMenu.gEndCutsceneStr2, IngameMenu.gEndCutsceneStr3,
            IngameMenu.gEndCutsceneStr4, IngameMenu.gEndCutsceneStr5, IngameMenu.gEndCutsceneStr6, IngameMenu.gEndCutsceneStr7,
            IngameMenu.gEndCutsceneStr8
        };]]

IngameMenu.gRedCoinsCollected = 0;

function IngameMenu.get_dialog_id()
       return IngameMenu.gDialogID
end

function IngameMenu.create_dialog_box(dialog)
	if IngameMenu.gDialogID == DIALOG_NONE.id then
		IngameMenu.gDialogID = dialog;
		IngameMenu.gDialogBoxType = DIALOG_TYPE_ROTATE;
	end
end

function IngameMenu.create_dialog_box_with_var(dialog, dialogVar)
	if IngameMenu.gDialogID == DIALOG_NONE.id then
		IngameMenu.gDialogID = dialog;
		IngameMenu.gDialogVariable = dialogVar;
		IngameMenu.gDialogBoxType = DIALOG_TYPE_ROTATE;
	end
end

return IngameMenu