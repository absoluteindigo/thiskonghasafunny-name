
-- sound effects
-- local utils = require(script.Parent.Parent.utils)
-- local makeRollTable = utils.makeRollTable

local beta_mario_attacked = script.beta_mario_attacked
local beta_mario_carry = script.beta_mario_carry
local beta_mario_climb = script.beta_mario_climb
local beta_mario_double_jump = script.beta_mario_double_jump
local beta_mario_jump_hoo = script.beta_mario_jump_hoo
local beta_mario_jump_wah = script.beta_mario_jump_wah
local beta_mario_jump_yah = script.beta_mario_jump_yah
local beta_mario_ledge = script.beta_mario_ledge
local beta_mario_scream = script.beta_mario_scream
local beta_mario_triple_jump = script.beta_mario_triple_jump
local beta_mario_victory = script.beta_mario_victory

local sounds = {
	GENERAL_OPEN_WOOD_DOOR = script.sound_wooden_door,
	GENERAL_IRON_WOOD_DOOR = script.sound_wooden_door,
	
	MARIO_ATTACKED = beta_mario_attacked,
	MARIO_COUGHING1 = nil,
	MARIO_COUGHING2 = nil,
	MARIO_COUGHING3 = nil,
	MARIO_DOH = nil,
	MARIO_DROWNING = nil,
	MARIO_DYING = beta_mario_attacked,
	MARIO_EEUH = beta_mario_climb,
	MARIO_GAME_OVER = nil,
	MARIO_GROUND_POUND_WAH = nil,
	MARIO_HAHA = beta_mario_victory,
	MARIO_HAHA_2 = beta_mario_victory,
	MARIO_HELLO = nil,
	MARIO_HERE_WE_GO = beta_mario_victory,
	MARIO_HOOHOO = beta_mario_double_jump,
	MARIO_HRMM = beta_mario_carry,
	MARIO_IMA_TIRED = nil,
	MARIO_LETS_A_GO = nil,
	MARIO_MAMA_MIA = nil,
	MARIO_OKEY_DOKEY = nil,
	MARIO_ON_FIRE = beta_mario_scream,
	MARIO_OOOF = beta_mario_double_jump,
	MARIO_OOOF2 = beta_mario_double_jump,
	MARIO_PANTING = nil,
	MARIO_PANTING_COLD = nil,
	MARIO_PRESS_START_TO_PLAY = nil,
	--[[MARIO_PUNCH_HOO = SOUND_ACTION_KEY_SWISH,
	MARIO_PUNCH_WAH = SOUND_ACTION_THROW,
	MARIO_PUNCH_YAH = SOUND_ACTION_THROW,]]
	MARIO_SNORING1 = nil,
	MARIO_SNORING2 = nil,
	MARIO_SNORING3 = nil,
	MARIO_SO_LONGA_BOWSER = beta_mario_victory,
	MARIO_TWIRL_BOUNCE = nil,
	MARIO_UH = beta_mario_double_jump,
	MARIO_UH2 = beta_mario_climb,
	MARIO_UH2_2 = beta_mario_climb,
	MARIO_WAAAOOOW = beta_mario_scream,
	MARIO_WAH2 = nil,
	MARIO_WHOA = beta_mario_ledge,
	MARIO_YAHOO = beta_mario_victory,
	MARIO_YAHOO_WAHA_YIPPEE = beta_mario_triple_jump,
	-- MARIO_YAH_WAH_HOO = {beta_mario_jump_yah, beta_mario_jump_wah, beta_mario_jump_hoo},
	MARIO_YAWNING = nil,
	
	MARIO_YAH_WAH_HOO = script.MARIO_YAH_WAH_HOO,
	
	beta_mario_attacked = beta_mario_attacked,
	beta_mario_carry = beta_mario_carry,
	beta_mario_climb = beta_mario_climb,
	beta_mario_double_jump = beta_mario_double_jump,
	beta_mario_jump_hoo = beta_mario_jump_hoo,
	beta_mario_jump_wah = beta_mario_jump_wah,
	beta_mario_jump_yah = beta_mario_jump_yah,
	beta_mario_ledge = beta_mario_ledge,
	beta_mario_scream = beta_mario_scream,
	beta_mario_triple_jump = beta_mario_triple_jump,
	beta_mario_victory = beta_mario_victory,
}
--[[local sounds =  {
	--ACTION_TERRAIN_STEP_DEFAULT = script.ACTION_TERRAIN_STEP_DEFAULT,
	--ACTION_TERRAIN_JUMP_DEFAULT = script.terrain_jump,
	--ACTION_TERRAIN_LANDING_DEFAULT = script.ACTION_TERRAIN_LANDING_DEFAULT,
	
	MARIO_ATTACKED = script.MARIO_ATTACKED,
	-- MARIO_DOH = script.MARIO_DOH,
	MARIO_GROUND_POUND_WAH = script.MARIO_GROUND_POUND_WAH,
	MARIO_HAHA = script.MARIO_HAHA,
	MARIO_HOO = script.MARIO_HOO,
	MARIO_HOOHOO = script.MARIO_HOOHOO,
	MARIO_IMA_TIRED = script.MARIO_IMA_TIRED,
	MARIO_MAMA_MIA = script.MARIO_MAMA_MIA,
	MARIO_HERE_WE_GO = script.MARIO_HERE_WE_GO,
	MARIO_ON_FIRE = script.MARIO_ON_FIRE,
	MARIO_OOOF = script.MARIO_OOOF,
	MARIO_PANTING = script.MARIO_PANTING,
	MARIO_PUNCH_YAH = script.MARIO_PUNCH_YAH,
	MARIO_PUNCH_WAH = script.MARIO_PUNCH_WAH,
	MARIO_PUNCH_HOO = script.MARIO_PUNCH_HOO,
	MARIO_SNORING1 = script.MARIO_SNORING1,
	MARIO_SNORING2 = script.MARIO_SNORING2,
	MARIO_SNORING3 = script.MARIO_SNORING3,
	MARIO_UH = script.MARIO_UH,
	MARIO_UH2 = script.MARIO_UH2,
	MARIO_WAAAOOOW = script.MARIO_WAAAOOOW,
	MARIO_DYING = script.MARIO_DYING,
	MARIO_WAH = script.MARIO_WAH,
	MARIO_WAHA = script.MARIO_WAHA,
	MARIO_WHOA = script.MARIO_WHOA,
	MARIO_YAH = script.MARIO_YAH,
	MARIO_YAHOO = script.MARIO_YAHOO,
	MARIO_YAWNING = script.MARIO_YAWNING,
	MARIO_YIPPEE = script.MARIO_YIPPEE,
	--[[] ]
	MARIO_JUMP = makeRollTable({}),
	MARIO_YAH_WAH_HOO = makeRollTable({
		MARIO_HOO = 1,
		MARIO_WAH = 1,
		MARIO_YAH = 1,
	}),
	MARIO_YAHOO_WAHA_YIPPEE = makeRollTable({
		MARIO_WAHA = 1,
		MARIO_YAHOO = 3,
		MARIO_YIPPEE = 1,
	}),
}]]

return sounds