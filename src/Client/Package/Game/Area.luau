local function band(...)
	return bit32.band(...) ~= 0
end
-- isActive
local Game = script.Parent
local Package = Game.Parent
local Object = Game.Object

local ObjectConstants = require(Object.ObjectConstants)
local GraphNodeConstats = require(Object.GraphNodeConstats)
local ObjectListProcessor = require(Object.ObjectListProcessor)
local IngameMenu = require(Game.IngameMenu)

--/ import { GeoRendererInstance as GeoRenderer } from "../engine/GeoRenderer"
--/ import { SurfaceLoadInstance as SurfaceLoad } from "./SurfaceLoad"
--/ import { ObjectListProcessorInstance as ObjectListProc } from "./ObjectListProcessor"
--/ import { GameInstance as Game } from "./Game"
--local GEO_CONTEXT_AREA_LOAD, GEO_CONTEXT_AREA_UNLOAD, GEO_CONTEXT_AREA_INIT, geo_call_global_function_nodes = GraphNodeConstats.GEO_CONTEXT_AREA_LOAD, GraphNodeConstats.GEO_CONTEXT_AREA_UNLOAD, GraphNodeConstats.GEO_CONTEXT_AREA_INIT, GraphNodeConstats.geo_call_global_function_nodes
-- import { GEO_CONTEXT_AREA_LOAD, GEO_CONTEXT_AREA_UNLOAD, GEO_CONTEXT_AREA_INIT, geo_call_global_function_nodes } from "../engine/graph_node"
-- import { gSPViewport } from "../include/gbi"
-- import { render_screen_transition } from "./ScreenTransition"
-- import { HudInstance as Hud } from "./Hud"
-- import { PrintInstance as Print } from "./Print"
local SCREEN_WIDTH = 320
local SCREEN_HEIGHT = 240
-- import { SCREEN_WIDTH } from "../include/config"
local oBehParams, ACTIVE_FLAG_DEACTIVATED, oActiveParticleFlags = ObjectConstants.oBehParams, ObjectConstants.ACTIVE_FLAG_DEACTIVATED, ObjectConstants.oActiveParticleFlags
local MENU_OPT_NONE = IngameMenu.MENU_OPT_NONE
-- import { LEVEL_MIN } from "../levels/level_defines_constants"

local Area = {}
Area.WARP_TRANSITION_FADE_FROM_COLOR   = 0x00
Area.WARP_TRANSITION_FADE_INTO_COLOR   = 0x01
Area.WARP_TRANSITION_FADE_FROM_STAR    = 0x08
Area.WARP_TRANSITION_FADE_INTO_STAR    = 0x09
Area.WARP_TRANSITION_FADE_FROM_CIRCLE  = 0x0A
Area.WARP_TRANSITION_FADE_INTO_CIRCLE  = 0x0B
Area.WARP_TRANSITION_FADE_FROM_MARIO   = 0x10
Area.WARP_TRANSITION_FADE_INTO_MARIO   = 0x11
Area.WARP_TRANSITION_FADE_FROM_BOWSER  = 0x12
Area.WARP_TRANSITION_FADE_INTO_BOWSER  = 0x13

Area.MARIO_SPAWN_DOOR_WARP             = 0x01
Area.MARIO_SPAWN_UNKNOWN_02            = 0x02
Area.MARIO_SPAWN_UNKNOWN_03            = 0x03
Area.MARIO_SPAWN_TELEPORT              = 0x04
Area.MARIO_SPAWN_INSTANT_ACTIVE        = 0x10
Area.MARIO_SPAWN_SWIMMING              = 0x11
Area.MARIO_SPAWN_AIRBORNE              = 0x12
Area.MARIO_SPAWN_HARD_AIR_KNOCKBACK    = 0x13
Area.MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE  = 0x14
Area.MARIO_SPAWN_DEATH                 = 0x15
Area.MARIO_SPAWN_SPIN_AIRBORNE         = 0x16
Area.MARIO_SPAWN_FLYING                = 0x17
Area.MARIO_SPAWN_PAINTING_STAR_COLLECT = 0x20
Area.MARIO_SPAWN_PAINTING_DEATH        = 0x21
Area.MARIO_SPAWN_AIRBORNE_STAR_COLLECT = 0x22
Area.MARIO_SPAWN_AIRBORNE_DEATH        = 0x23
Area.MARIO_SPAWN_LAUNCH_STAR_COLLECT   = 0x24
Area.MARIO_SPAWN_LAUNCH_DEATH          = 0x25
Area.MARIO_SPAWN_UNKNOWN_27            = 0x27

WARP_TRANSITION_FADE_INTO_CIRCLE = Area.WARP_TRANSITION_FADE_INTO_CIRCLE
WARP_TRANSITION_FADE_FROM_BOWSER = Area.WARP_TRANSITION_FADE_FROM_BOWSER
WARP_TRANSITION_FADE_INTO_COLOR = Area.WARP_TRANSITION_FADE_INTO_COLOR
MARIO_SPAWN_LAUNCH_STAR_COLLECT = Area.MARIO_SPAWN_LAUNCH_STAR_COLLECT
MARIO_SPAWN_INSTANT_ACTIVE = Area.MARIO_SPAWN_INSTANT_ACTIVE
WARP_TRANSITION_FADE_FROM_CIRCLE = Area.WARP_TRANSITION_FADE_FROM_CIRCLE
MARIO_SPAWN_PAINTING_STAR_COLLECT = Area.MARIO_SPAWN_PAINTING_STAR_COLLECT
MARIO_SPAWN_TELEPORT = Area.MARIO_SPAWN_TELEPORT
MARIO_SPAWN_SPIN_AIRBORNE = Area.MARIO_SPAWN_SPIN_AIRBORNE
MARIO_SPAWN_DEATH = Area.MARIO_SPAWN_DEATH
MARIO_SPAWN_UNKNOWN_27 = Area.MARIO_SPAWN_UNKNOWN_27
MARIO_SPAWN_PAINTING_DEATH = Area.MARIO_SPAWN_PAINTING_DEATH
MARIO_SPAWN_LAUNCH_DEATH = Area.MARIO_SPAWN_LAUNCH_DEATH
MARIO_SPAWN_FLYING = Area.MARIO_SPAWN_FLYING
MARIO_SPAWN_DOOR_WARP = Area.MARIO_SPAWN_DOOR_WARP
WARP_TRANSITION_FADE_INTO_STAR = Area.WARP_TRANSITION_FADE_INTO_STAR
MARIO_SPAWN_AIRBORNE_DEATH = Area.MARIO_SPAWN_AIRBORNE_DEATH
MARIO_SPAWN_AIRBORNE = Area.MARIO_SPAWN_AIRBORNE
MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE = Area.MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE
WARP_TRANSITION_FADE_FROM_COLOR = Area.WARP_TRANSITION_FADE_FROM_COLOR
MARIO_SPAWN_HARD_AIR_KNOCKBACK = Area.MARIO_SPAWN_HARD_AIR_KNOCKBACK
WARP_TRANSITION_FADE_INTO_MARIO = Area.WARP_TRANSITION_FADE_INTO_MARIO
MARIO_SPAWN_SWIMMING = Area.MARIO_SPAWN_SWIMMING
WARP_TRANSITION_FADE_FROM_STAR = Area.WARP_TRANSITION_FADE_FROM_STAR
MARIO_SPAWN_UNKNOWN_03 = Area.MARIO_SPAWN_UNKNOWN_03
MARIO_SPAWN_AIRBORNE_STAR_COLLECT = Area.MARIO_SPAWN_AIRBORNE_STAR_COLLECT
MARIO_SPAWN_UNKNOWN_02 = Area.MARIO_SPAWN_UNKNOWN_02
WARP_TRANSITION_FADE_INTO_BOWSER = Area.WARP_TRANSITION_FADE_INTO_BOWSER
WARP_TRANSITION_FADE_FROM_MARIO = Area.WARP_TRANSITION_FADE_FROM_MARIO

--[[local D_8032CF00 = {  --// default view port?
    vscale = [640, 480, 511, 0],
    vtrans = [640, 480, 511, 0]
}]]

--local canvas = document.querySelector('#gameCanvas')


Area.gCurrentArea = nil
--Area.gAreas = Array(8).fill(0).map(() => { return { index = 0 } })
Area.gCurrAreaIndex = 0
Area.gCurrLevelNum = LEVEL_MIN
Area.gCurrCourseNum = 0
Area.gSavedCourseNum = 0
Area.gCurrSaveFileNum = 1
--Area.gLoadedGraphNodes = new Array(256)

Area.D_8032CE74 = nil
Area.D_8032CE78 = nil

Area.gMarioSpawnInfo = {
	startPos = { [0] = 0, 0, 0},
	startAngle = { [0] = 0, 0, 0},
	areaIndex = 0, activeAreaIndex = 0,
	behaviorArg = 0, behaviorScript = nil,
	unk18 = nil,
	next = nil
}

Area.gWarpTransition = {
	data = {}
}
Area.gWarpTransDelay = 0
Area.gFBSetColor = 0
Area.gWarpTransFBSetColor = 0
Area.gWarpTransRed = 0
Area.gWarpTransGreen = 0
Area.gWarpTransBlue = 0
Area.sSpawnTypeFromWarpBhv = { [0] =
	MARIO_SPAWN_DOOR_WARP,             MARIO_SPAWN_UNKNOWN_02,           MARIO_SPAWN_UNKNOWN_03,            MARIO_SPAWN_UNKNOWN_03,
	MARIO_SPAWN_UNKNOWN_03,            MARIO_SPAWN_TELEPORT,             MARIO_SPAWN_INSTANT_ACTIVE,        MARIO_SPAWN_AIRBORNE,
	MARIO_SPAWN_HARD_AIR_KNOCKBACK,    MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE, MARIO_SPAWN_DEATH,                 MARIO_SPAWN_SPIN_AIRBORNE,
	MARIO_SPAWN_FLYING,                MARIO_SPAWN_SWIMMING,             MARIO_SPAWN_PAINTING_STAR_COLLECT, MARIO_SPAWN_PAINTING_DEATH,
	MARIO_SPAWN_AIRBORNE_STAR_COLLECT, MARIO_SPAWN_AIRBORNE_DEATH,       MARIO_SPAWN_LAUNCH_STAR_COLLECT,   MARIO_SPAWN_LAUNCH_DEATH,
}

Area.sWarpBhvSpawnTable = { [0] =
	'bhvDoorWarp',                'bhvStar',                   'bhvExitPodiumWarp',          'bhvWarp',
	'bhvWarpPipe',                'bhvFadingWarp',             'bhvInstantActiveWarp',       'bhvAirborneWarp',
	'bhvHardAirKnockBackWarp',    'bhvSpinAirborneCircleWarp', 'bhvDeathWarp',               'bhvSpinAirborneWarp',
	'bhvFlyingWarp',              'bhvSwimmingWarp',           'bhvPaintingStarCollectWarp', 'bhvPaintingDeathWarp',
	'bhvAirborneStarCollectWarp', 'bhvAirborneDeathWarp',      'bhvLaunchStarCollectWarp',   'bhvLaunchDeathWarp',
}


--/ PARAMETERS =
--/ a = Vp | set D_8032CE74
--/ b = Vp | set D_8032CE78
--/ c = u8 | set gFBSetColor part 1
--/ d = u8 | set gFBSetColor part 2
--/ e = u8 | set gFBSetColor part 3
function Area.override_viewport_and_clip(a, b, c, d, e)
	local sp6 = bit32.bor(
		bit32.lshift(bit32.rshift(c, 3), 11),
		bit32.lshift(bit32.rshift(d, 3), 6),
		bit32.lshift(bit32.rshift(e, 3), 1),
		1
	)
	-- local sp6 = ((c >> 3) << 11) | ((d >> 3) << 6) | ((e >> 3) << 1) | 1

	Area.gFBSetColor = bit32.bor(bit32.lshift(sp6, 16), sp6) -- (sp6 << 16) | sp6
	Area.D_8032CE74 = a
	Area.D_8032CE78 = b
end

function Area.set_warp_transition_rgb(red, green, blue)
	local warpTransitionRGBA16 = bit32.bor(
		bit32.lshift(bit32.rshift(red, 3), 11),
		bit32.lshift(bit32.rshift(green, 3), 6),
		bit32.lshift(bit32.rshift(blue, 3), 1),
		1
	)-- ((red >> 3) << 11) | ((green >> 3) << 6) | ((blue >> 3) << 1) | 1 

	Area.gWarpTransFBSetColor = bit32.bor(bit32.lshift(warpTransitionRGBA16, 16), warpTransitionRGBA16)

	Area.gWarpTransRed = red
	Area.gWarpTransGreen = green
	Area.gWarpTransBlue = blue
end

function Area.print_intro_text()
	if bit32.band(gGlobalTimer, 0x1F) < 20 then
		print('TODO')
		local noController = false; --/ gControllerBits == 0

		if noController then
			Print.print_text_centered(SCREEN_WIDTH / 2, 20, "NO CONTROLLER");
		else
			Print.print_text_centered(60, 38, "PRESS");
			Print.print_text_centered(60, 20, "START");
		end
	end
end

function Area.get_mario_spawn_type(o)
	print('get_mario_spawn_type')
        --[[LevelUpdate.init_mario_warp_spawn_type()
        local sWarpBhvSpawnType = LevelUpdate.sWarpBhvSpawnType

        for i = 0, sWarpBhvSpawnType.length do
            if sWarpBhvSpawnType[i][0] == o.behavior
                return sWarpBhvSpawnType[i][1]
            end
        end
        return false]]
end

function Area.area_get_warp_node(id)
	return Area.gCurrentArea.warpNodes[id]
end

function Area.area_get_warp_node_from_params(o)
	-- local warp_id = (o.BhvParams & 0x00FF0000) >> 16
	local warp_id = bit32.rshift(bit32.band(o.BhvParams(), 0x00FF0000), 16)
	return Area.area_get_warp_node(warp_id)
end

function Area.load_obj_warp_nodes()
	for node in gLinker.GeoLayout.gObjParentGraphNode.children do
		local object = node.object

		if object.ActiveFlags() ~= ACTIVE_FLAG_DEACTIVATED and Area.get_mario_spawn_type(object) ~= 0 then
			-- if (object.ActiveFlags != ACTIVE_FLAG_DEACTIVATED && Area.get_mario_spawn_type(object) != 0) {
			local warp_node = Area.area_get_warp_node_from_params(object)
			if (warp_node) then
				warp_node.object = object
			end
		end
	end
end

function Area.clear_areas()
	Area.gCurrentArea = nil
	Area.gWarpTransition.isActive = 0
	Area.gWarpTransition.pauseRendering = 0
	Area.gMarioSpawnInfo.areaIndex = -1

	for i, areaData in ipairs(Area.gAreas) do
		for k, v in pairs({
			index = i,
			flags = 0,
			terrainType = 0,
			geometryLayoutData = nil,
			terrainData = nil,
			surfaceRooms = nil,
			macroObjects = nil,
			warpNodes = {},
			paintingWarpNodes = {},
			instantWarps = {},
			objectSpawnInfos = nil,
			camera = nil,
			unused28 = nil,
			whirlpools = { nil, nil },
			dialog = { nil, nil },
			musicParam = 0,
			musicParam2 = 0
			}) do
			areaData[k] = v
		end
	end

	--[[for i, areaData in pairs(Area.gAreas) do
        -- Area.gAreas.forEach((areaData, i)
            Object.assign(areaData, {
                index = i,
                flags = 0,
                terrainType = 0,
                geometryLayoutData = nil,
                terrainData = nil,
                surfaceRooms = nil,
                macroObjects = nil,
                warpNodes = [],
                paintingWarpNodes = [],
                instantWarps = [],
                objectSpawnInfos = nil,
                camera = nil,
                unused28 = nil,
                whirlpools = [ nil, nil ],
                dialog = [nil, nil],
                musicParam = 0,
                musicParam2 = 0
            })
        })]]
end

function Area.clear_area_graph_nodes()
	if Area.gCurrentArea then
		geo_call_global_function_nodes(Area.gCurrentArea.geometryLayoutData, GEO_CONTEXT_AREA_UNLOAD)
		Area.gCurrentArea = nil
		Area.gWarpTransition.isActive = 0
	end

	print('Area.gAreas.forEach')
        --[[Area.gAreas.forEach((areaData) => {
            if (areaData.geometryLayoutData) {
                geo_call_global_function_nodes(areaData.geometryLayoutData, GEO_CONTEXT_AREA_INIT)
                areaData.geometryLayoutData = nil
            }
        })]]
end

function Area.load_area(index)
	if  not Area.gCurrentArea and Area.gAreas[index].geometryLayoutData then
		Area.gCurrentArea = Area.gAreas[index]
		Area.gCurrAreaIndex = Area.gCurrentArea.index

		if Area.gCurrentArea.terrainData then
			print('load_area_terrain')
			-- gLinker.SurfaceLoad.load_area_terrain(index, Area.gCurrentArea.terrainData, Area.gCurrentArea.surfaceRooms, Area.gCurrentArea.macroObjects)
		end

		if Area.gCurrentArea.objectSpawnInfos then
			ObjectListProcessor.spawn_objects_from_info(Area.gCurrentArea.objectSpawnInfos)
		end

		Area.load_obj_warp_nodes()
		geo_call_global_function_nodes(Area.gCurrentArea.geometryLayoutData, GEO_CONTEXT_AREA_LOAD)
	end
end

function Area.unload_area()
	if Area.gCurrentArea then
		ObjectListProcessor.unload_objects_from_area(Area.gCurrentArea.index)
		geo_call_global_function_nodes(Area.gCurrentArea.geometryLayoutData, GEO_CONTEXT_AREA_UNLOAD)

		Area.gCurrentArea.flags = 0
		Area.gCurrentArea = nil
		Area.gWarpTransition.isActive = 0
	end
end

function Area.load_mario_area()
	Area.load_area(Area.gMarioSpawnInfo.areaIndex)

	if Area.gCurrentArea.index == Area.gMarioSpawnInfo.areaIndex then
		-- Area.gCurrentArea.flags |= 0x01
		Area.gCurrentArea.flags = bit32.bor(Area.gCurrentArea.flags, 0x01)
		ObjectListProcessor.spawn_objects_from_info(Area.gMarioSpawnInfo)
		print('marioCloneSpawnInfo was commented out in the original js?')
--[[            local marioCloneSpawnInfo = Area.gMarioSpawnInfo
            marioCloneSpawnInfo.startPos[0] -= 500
            ObjectListProcessor.spawn_objects_from_info(marioCloneSpawnInfo)]]
	end
end

function Area.unload_mario_area()
	if Area.gCurrentArea and (band(Area.gCurrentArea.flags, 0x01)) then
		ObjectListProcessor.unload_objects_from_area(Area.gMarioSpawnInfo.activeAreaIndex)

		-- Area.gCurrentArea.flags &= ~0x01
		Area.gCurrentArea.flags = bit32.band(Area.gCurrentArea.flags, bit32.bnot(0x01))
		if Area.gCurrentArea.flags == 0 then
			Area.unload_area()
		end
	end
end

function Area.change_area(index)
	local areaFlags = Area.gCurrentArea.flags;
	local gMarioObject = ObjectListProcessor.gMarioObject;

	if Area.gCurrAreaIndex ~= index then
		Area.unload_area();
		Area.load_area(index);

		Area.gCurrentArea.flags = areaFlags;
		gMarioObject.ActiveParticleFlags = 0;
	end

	if band(areaFlags, 0x01) then
		gMarioObject.gfx.areaIndex = index;
		Area.gMarioSpawnInfo.areaIndex = index;
	end
end

function Area.area_update_objects()
	print('what,!!')
	-- gLinker.GeoRenderer.gAreaUpdateCounter += 1;
	ObjectListProcessor.update_objects(0);
end

function Area.play_transition(transType, time, red, green, blue)
	Area.gWarpTransition.isActive = 1;
	Area.gWarpTransition.type = transType;
	Area.gWarpTransition.time = time;
	Area.gWarpTransition.pauseRendering = false;

	--/ The lowest bit of transType determines if the transition is fading in or out.
	if band(transType, 1) then
		Area.set_warp_transition_rgb(red, green, blue)
	else
		red = Area.gWarpTransRed; green = Area.gWarpTransGreen; blue = Area.gWarpTransBlue
	end

	if transType < 8 then --/ if transition is RGB
		Area.gWarpTransition.data.red = red
		Area.gWarpTransition.data.green = green
		Area.gWarpTransition.data.blue = blue
	else
		Area.gWarpTransition.data.red = red
		Area.gWarpTransition.data.green = green
		Area.gWarpTransition.data.blue = blue

		--/ Both the start and end textured transition are always located in the middle of the screen.
		--/ If you really wanted to, you could place the start at one corner and the end at
		--/ the opposite corner. This will make the transition image look like it is moving
		--/ across the screen.
		Area.gWarpTransition.data.startTexX = SCREEN_WIDTH / 2 / 2
		Area.gWarpTransition.data.startTexY = SCREEN_HEIGHT / 2 / 2
		Area.gWarpTransition.data.endTexX = SCREEN_WIDTH / 2 / 2
		Area.gWarpTransition.data.endTexY = SCREEN_HEIGHT / 2 / 2

		Area.gWarpTransition.data.texTimer = 0

		if band(transType, 1) then --/ fading in
			Area.gWarpTransition.data.startTexRadius = SCREEN_WIDTH / 2
			if transType >= 0x0F then
				Area.gWarpTransition.data.endTexRadius = 16
			else
				Area.gWarpTransition.data.endTexRadius = 0
			end
		else --/ fading out
			if transType >= 0x0E then
				Area.gWarpTransition.data.startTexRadius = 16
			else
				Area.gWarpTransition.data.startTexRadius = 0
			end
			Area.gWarpTransition.data.endTexRadius = SCREEN_WIDTH / 2
		end
	end
end

function Area.play_transition_after_delay(transType, time, red, green, blue, delay)
	Area.gWarpTransDelay = delay;
	Area.play_transition(transType, time, red, green, blue);
end

function Area.render_game()
	if Area.gCurrentArea and not Area.gWarpTransition.pauseRendering then
		gLinker.GeoRenderer.geo_process_root(Area.gCurrentArea.geometryLayoutData, Area.D_8032CE74, Area.D_8032CE78, Area.gFBSetColor)

		gSPViewport(gLinker.Game.gDisplayList, D_8032CF00)
		Hud.render_hud()
		Print.render_text_labels()
		IngameMenu.do_cutscene_handler();
		--/ print_displaying_credits_entry();

		Area.gMenuOptSelectIndex = IngameMenu.render_menus_and_dialogs();

		if Area.gMenuOptSelectIndex ~= MENU_OPT_NONE then
			Area.gSaveOptSelectIndex = Area.gMenuOptSelectIndex;
		end
		--/ if (D_8032CE78 != NULL) {
		--/     make_viewport_clip_rect(D_8032CE78);
		--/ } else
		--/     gDPSetScissor(gDisplayListHead += 1, G_SC_NON_INTERLACE, 0, BORDER_HEIGHT, SCREEN_WIDTH,
		--/                   SCREEN_HEIGHT - BORDER_HEIGHT);

		if Area.gWarpTransition.isActive then
			if Area.gWarpTransDelay == 0 then

				Area.gWarpTransition.isActive = not render_screen_transition(0, Area.gWarpTransition.type, Area.gWarpTransition.time, Area.gWarpTransition.data)

				if not Area.gWarpTransition.isActive then
					if band(Area.gWarpTransition.type, 1) then
						Area.gWarpTransition.pauseRendering = true
					else
						Area.set_warp_transition_rgb(0, 0, 0)
					end
				end
			else
				Area.gWarpTransDelay-= 1
			end
		end
	else
		Print.render_text_labels()
		if Area.D_8032CE78 then
			gLinker.Game.clear_viewport(Area.D_8032CE78, Area.gWarpTransFBSetColor)
		else
			gLinker.Game.clear_frame_buffer(Area.gWarpTransFBSetColor)
		end
	end

	Area.D_8032CE74 = nil
	Area.D_8032CE78 = nil
end

return Area