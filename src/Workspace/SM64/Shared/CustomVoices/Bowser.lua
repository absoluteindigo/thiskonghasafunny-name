-- sound effects
-- local utils = require(script.Parent.Parent.utils)
-- local makeRollTable = utils.makeRollTable

local sounds =  {
	MARIO_COUGHING1 = script.bw_bonk0, -- 
	MARIO_COUGHING2 = script.bw_bonk1, -- 
	MARIO_COUGHING3 = script.bw_bonk2, -- 
	MARIO_ATTACKED = script.bw_ouch,
	MARIO_DOH = script.bw_bonk2,
	MARIO_DROWNING = script.bw_dying,
	MARIO_DYING = script.bw_dying,
	MARIO_EEUH = script.bw_jump0,
	MARIO_GROUND_POUND_WAH = script.bw_bonk0,
	MARIO_HAHA = script.bw_haha,
	MARIO_HAHA_2 = script.bw_haha,
	MARIO_HERE_WE_GO = script.bw_herewego,
	MARIO_HOOHOO = script.bw_doublejump,
	MARIO_HRMM = script.bw_bonk2,
	MARIO_IMA_TIRED = script.bw_dying, -- 
	MARIO_MAMA_MIA = script.bw_mamamia,
	MARIO_LETS_A_GO = script.bw_letsgo,
	MARIO_ON_FIRE = script.bw_haha, -- 
	MARIO_OOOF = script.bw_bonk0,
	MARIO_OOOF2 = script.bw_bonk0,
	--MARIO_PANTING = script.bw_screech, -- 
	MARIO_PUNCH_HOO = script.bw_attack2,
	MARIO_PUNCH_WAH = script.bw_jump1,
	MARIO_PUNCH_YAH = script.bw_attack1,
	--MARIO_SNORING1 = script.bw_screech, -- 
	--MARIO_SNORING2 = script.bw_screech, -- 
	--MARIO_SNORING3 = script.bw_screech, -- 
	MARIO_SO_LONGA_BOWSER = script.bw_haha,
	MARIO_TWIRL_BOUNCE = script.bw_wahoo1,
	MARIO_UH = script.bw_bonk1, -- 
	MARIO_UH2 = script.bw_bonk1,
	MARIO_WAAAOOOW = script.bw_falling,
	MARIO_WAH = script.bw_attack2, -- 
	MARIO_WAH2 = script.bw_attack2,
	MARIO_WAHA = script.bw_haha, -- 
	MARIO_WHOA = script.bw_bonk2,
	MARIO_YAH = script.bw_attack1, -- 
	MARIO_YAHOO = script.bw_wahoo1,

	MARIO_HOO = script.bw_jump1, -- missing??!?!? nooo
	--MARIO_YAHOO_WAHA_YIPPEE = script.bw_wahoo1, -- 
	--MARIO_YAH_WAH_HOO = script.bw_wahoo1, -- 
	--MARIO_YAWNING = script.bw_screech, -- 
	MARIO_YIPPEE = script.bw_wahoo0, -- 
	--MARIO_JUMP = script.bw_jump0, -- 

	-- groups or whatever
	--[[MARIO_YAHOO_WAHA_YIPPEE = makeRollTable({
		["bw_wahoo0"] = 1,
		["bw_wahoo1"] = 1
	}),
	MARIO_YAH_WAH_HOO = makeRollTable({
		["bw_jump0"] = 1,
		["bw_jump1"] = 1
	}),
	MARIO_JUMP = makeRollTable({
		["bw_jump0"] = 1,
		["bw_jump1"] = 1
	}), -- same as the one above]]

	-- extra
	bw_wahoo0 = script.bw_wahoo0,
	bw_wahoo1 = script.bw_wahoo1,

	bw_jump0 = script.bw_jump0,
	bw_jump1 = script.bw_jump1,
}

return sounds