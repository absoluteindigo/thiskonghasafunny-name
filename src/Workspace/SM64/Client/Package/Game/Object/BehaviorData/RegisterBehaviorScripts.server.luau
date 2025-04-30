-- Import common BehaviorData and ObjectListProcessor constants
local Enums = require(script.Parent.Parent.Parent.Parent.Enums)
a, b, c = require(script.Parent.BehaviorScripts), require(script.Parent.Parent.ObjectListProcessor), require(script.Parent.Parent.ObjectConstants)
ADD_INT,ADD_FLOAT,ANIMATE,ANIMATE_TEXTURE,BEGIN,BEGIN_LOOP,BEGIN_REPEAT,BILLBOARD,BREAK,CALL,CALL_NATIVE,DEACTIVATE,DEBUGGER,DELAY,DELAY_VAR,DISABLE_RENDERING,DROP_TO_FLOOR,END_LOOP,END_REPEAT,END_REPEAT_CONTINUE,GOTO,HIDE,LOAD_ANIMATIONS,LOAD_COLLISION_DATA,OR_INT,PARENT_BIT_CLEAR,RETURN,SCALE,SET_FLOAT,SET_HITBOX,SET_HITBOX_WITH_OFFSET,SET_HURTBOX,SET_HOME,SET_INT,SET_INTERACT_TYPE,SET_MODEL,SET_OBJ_PHYSICS,SET_RANDOM_INT,SET_RANDOM_FLOAT,SUM_FLOAT,SPAWN_CHILD,SPAWN_OBJ,SPAWN_WATER_DROPLET,CYLBOARD,SPAWN_CHILD_WITH_PARAM,CLEAR_BIT_PARENT,SET_INT_RAND_RSHIFT,ADD_RANDOM_FLOAT=a.ADD_INT,a.ADD_FLOAT,a.ANIMATE,a.ANIMATE_TEXTURE,a.BEGIN,a.BEGIN_LOOP,a.BEGIN_REPEAT,a.BILLBOARD,a.BREAK,a.CALL,a.CALL_NATIVE,a.DEACTIVATE,a.DEBUGGER,a.DELAY,a.DELAY_VAR,a.DISABLE_RENDERING,a.DROP_TO_FLOOR,a.END_LOOP,a.END_REPEAT,a.END_REPEAT_CONTINUE,a.GOTO,a.HIDE,a.LOAD_ANIMATIONS,a.LOAD_COLLISION_DATA,a.OR_INT,a.PARENT_BIT_CLEAR,a.RETURN,a.SCALE,a.SET_FLOAT,a.SET_HITBOX,a.SET_HITBOX_WITH_OFFSET,a.SET_HURTBOX,a.SET_HOME,a.SET_INT,a.SET_INTERACT_TYPE,a.SET_MODEL,a.SET_OBJ_PHYSICS,a.SET_RANDOM_INT,a.SET_RANDOM_FLOAT,a.SUM_FLOAT,a.SPAWN_CHILD,a.SPAWN_OBJ,a.SPAWN_WATER_DROPLET,a.CYLBOARD,a.SPAWN_CHILD_WITH_PARAM,a.CLEAR_BIT_PARENT,a.SET_INT_RAND_RSHIFT,a.ADD_RANDOM_FLOAT
NUM_OBJ_LISTS,OBJ_LIST_UNIMPORTANT,OBJ_LIST_SPAWNER,OBJ_LIST_SURFACE,OBJ_LIST_POLELIKE,OBJ_LIST_DEFAULT,OBJ_LIST_UNUSED_3,OBJ_LIST_UNUSED_7,OBJ_LIST_PLAYER,OBJ_LIST_LEVEL,OBJ_LIST_GENACTOR,OBJ_LIST_DESTRUCTIVE,OBJ_LIST_PUSHABLE,OBJ_LIST_UNUSED_1=b.NUM_OBJ_LISTS,b.OBJ_LIST_UNIMPORTANT,b.OBJ_LIST_SPAWNER,b.OBJ_LIST_SURFACE,b.OBJ_LIST_POLELIKE,b.OBJ_LIST_DEFAULT,b.OBJ_LIST_UNUSED_3,b.OBJ_LIST_UNUSED_7,b.OBJ_LIST_PLAYER,b.OBJ_LIST_LEVEL,b.OBJ_LIST_GENACTOR,b.OBJ_LIST_DESTRUCTIVE,b.OBJ_LIST_PUSHABLE,b.OBJ_LIST_UNUSED_1
OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE,OBJ_FLAG_COMPUTE_DIST_TO_MARIO,OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO,OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW,OBJ_FLAG_PERSISTENT_RESPAWN,OBJ_FLAG_HOLDABLE,OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL,OBJ_FLAG_MOVE_XZ_USING_FVEL,OBJ_FLAG_ACTIVE_FROM_AFAR,OBJ_FLAG_0100,OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM,OBJ_FLAG_0020,ACTIVE_PARTICLE_H_STAR,ACTIVE_PARTICLE_V_STAR,ACTIVE_PARTICLE_TRIANGLE,ACTIVE_PARTICLE_DUST,ACTIVE_PARTICLE_BUBBLE,ACTIVE_PARTICLE_WATER_SPLASH,ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH,ACTIVE_PARTICLE_SHALLOW_WATER_WAVE,ACTIVE_PARTICLE_WAVE_TRAIL,ACTIVE_PARTICLE_PLUNGE_BUBBLE,ACTIVE_PARTICLE_SPARKLES,OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE=c.OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE,c.OBJ_FLAG_COMPUTE_DIST_TO_MARIO,c.OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO,c.OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW,c.OBJ_FLAG_PERSISTENT_RESPAWN,c.OBJ_FLAG_HOLDABLE,c.OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL,c.OBJ_FLAG_MOVE_XZ_USING_FVEL,c.OBJ_FLAG_ACTIVE_FROM_AFAR,c.OBJ_FLAG_0100,c.OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM,c.OBJ_FLAG_0020,c.ACTIVE_PARTICLE_H_STAR,c.ACTIVE_PARTICLE_V_STAR,c.ACTIVE_PARTICLE_TRIANGLE,c.ACTIVE_PARTICLE_DUST,c.ACTIVE_PARTICLE_BUBBLE,c.ACTIVE_PARTICLE_WATER_SPLASH,c.ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH,c.ACTIVE_PARTICLE_SHALLOW_WATER_WAVE,c.ACTIVE_PARTICLE_WAVE_TRAIL,c.ACTIVE_PARTICLE_PLUNGE_BUBBLE,c.ACTIVE_PARTICLE_SPARKLES,c.OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE
IS, IM = Enums.Interaction.Subtype, Enums.Interaction.Method
INT_SUBTYPE_KICKABLE,INT_SUBTYPE_DROP_IMMEDIATELY,INT_SUBTYPE_GRAND_STAR,INT_SUBTYPE_NO_EXIT,INT_SUBTYPE_NOT_GRABBABLE,INT_SUBTYPE_BIG_KNOCKBACK,INT_SUBTYPE_SIGN,INT_SUBTYPE_EATS_MARIO,INT_SUBTYPE_TWIRL_BOUNCE,INT_SUBTYPE_GRABS_MARIO,INT_SUBTYPE_FADING_WARP,INT_SUBTYPE_NPC,INT_SUBTYPE_STAR_DOOR,INT_SUBTYPE_DELAY_INVINCIBILITY,INT_SUBTYPE_HOLDABLE_NPC=IS.KICKABLE,IS.DROP_IMMEDIATELY,IS.GRAND_STAR,IS.NO_EXIT,IS.NOT_GRABBABLE,IS.BIG_KNOCKBACK,IS.SIGN,IS.EATS_MARIO,IS.TWIRL_BOUNCE,IS.GRABS_MARIO,IS.FADING_WARP,IS.NPC,IS.STAR_DOOR,IS.DELAY_INVINCIBILITY,IS.HOLDABLE_NPC
INTERACT_DAMAGE,INTERACT_UNKNOWN_31,INTERACT_GRABBABLE,INTERACT_BREAKABLE,INTERACT_SHOCK,INTERACT_WHIRLPOOL,INTERACT_DOOR,INTERACT_HOOT,INTERACT_BOUNCE_TOP,INTERACT_CANNON_BASE,INTERACT_BBH_ENTRANCE,INTERACT_WARP_DOOR,INTERACT_SNUFIT_BULLET,INTERACT_TORNADO,INTERACT_STAR_OR_KEY,INTERACT_WATER_RING,INTERACT_HIT_FROM_BELOW,INTERACT_FLAME,INTERACT_TEXT,INTERACT_KOOPA_SHELL,INTERACT_POLE,INTERACT_KOOPA,INTERACT_CLAM_OR_BUBBA,INTERACT_BULLY,INTERACT_MR_BLIZZARD,INTERACT_BOUNCE_TOP2,INTERACT_STRONG_WIND,INTERACT_WARP,INTERACT_CAP,INTERACT_IGLOO_BARRIER,INTERACT_UNKNOWN_08,INTERACT_COIN=IM.DAMAGE,IM.UNKNOWN_31,IM.GRABBABLE,IM.BREAKABLE,IM.SHOCK,IM.WHIRLPOOL,IM.DOOR,IM.HOOT,IM.BOUNCE_TOP,IM.CANNON_BASE,IM.BBH_ENTRANCE,IM.WARP_DOOR,IM.SNUFIT_BULLET,IM.TORNADO,IM.STAR_OR_KEY,IM.WATER_RING,IM.HIT_FROM_BELOW,IM.FLAME,IM.TEXT,IM.KOOPA_SHELL,IM.POLE,IM.KOOPA,IM.CLAM_OR_BUBBA,IM.BULLY,IM.MR_BLIZZARD,IM.BOUNCE_TOP2,IM.STRONG_WIND,IM.WARP,IM.CAP,IM.IGLOO_BARRIER,IM.UNKNOWN_08,IM.COIN
--
local BehaviorScripts = a
local ObjectListProcessor = b
local ObjectConstants = c
local Animations = require(script.Parent.Parent.Animations)
local Register = BehaviorScripts.Register
local MODEL = require(script.Parent.Parent.Models)

local SurfaceCollission = require(script.Parent.Parent.Parent.Parent.Custom.SurfaceCollission)
local CollissionData = SurfaceCollission.CollissionData

local amp_seg8_anims_08004034         = Animations.amp
local birds_seg5_anims_050009E8       = Animations.bird
local bobomb_seg8_anims_0802396C      = Animations.bobomb
local bully_seg5_anims_0500470C       = Animations.bully
local butterfly_seg3_anims_030056B0   = Animations.butterfly
local bowser_seg6_anims_06057690      = Animations.bowser
-- local castle_grounds_seg7_anims_flags } from "../levels/castle_grounds/areas/1/11/anim.inc"
local chain_chomp_seg6_anims_06025178 = Animations.chain_chomp
local door_seg3_anims_030156C0        = Animations.door
local goomba_seg8_anims_0801DA4C      = Animations.goomba
local lakitu_seg6_anims_060058F8      = Animations.lakitu_cameraman
local scuttlebug_seg6_anims_06015064  = Animations.scuttlebug
local yoshi_seg5_anims_05024100       = Animations.yoshi




Register('bhvStarDoor', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvStarDoor'),
    SET_INT('InteractType', INTERACT_DOOR),
    LOAD_COLLISION_DATA(inside_castle_seg7_collision_star_door),
    SET_INT('InteractionSubtype', INT_SUBTYPE_STAR_DOOR),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HITBOX(--[[Radius]] 80, --[[Height]] 100),
    SET_HOME(),
    SET_FLOAT('DrawingDistance', 20000),
    CALL_NATIVE('bhv_door_init'),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_star_door_loop'),
        CALL_NATIVE('bhv_star_door_loop_2'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvMrIBody', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvMrIBody'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_mr_i_body_loop'),
    END_LOOP(),
});

Register('bhvMrI', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvMrI'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SPAWN_CHILD(--[[Model]] MODEL.MR_I_IRIS, --[[Behavior]] bhvMrIBody),
    SET_MODEL(MODEL.MR_I),
    BILLBOARD(),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_mr_i_loop'),
    END_LOOP(),
});

Register('bhvMrIParticle', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvMrIParticle'),
    BILLBOARD(),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('IntangibleTimer', 0),
    SET_HITBOX(50, 50),
    SET_INT('DamageOrCoinValue', 1),
    SET_INT('InteractType', INTERACT_DAMAGE),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] 0, --[[Bounciness]] 0, --[[Drag strength]] 0, --[[Friction]] 0, --[[Buoyancy]] 0, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_mr_i_particle_loop'),
    END_LOOP(),
});

Register('bhvPurpleParticle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvPurpleParticle'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_REPEAT(10),
        CALL_NATIVE('bhv_piranha_particle_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvGiantPole', {
    BEGIN(OBJ_LIST_POLELIKE, 'bhvGiantPole'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('InteractType', INTERACT_POLE),
    SET_HITBOX(80, 2100),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_giant_pole_loop'),
    END_LOOP(),
});

Register('bhvPoleGrabbing', {
    BEGIN(OBJ_LIST_POLELIKE, 'bhvPoleGrabbing'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('InteractType', INTERACT_POLE),
    SET_HITBOX(--[[Radius]] 80, --[[Height]] 1500),
    CALL_NATIVE('bhv_pole_init'),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_pole_base_loop'),
    END_LOOP(),
});

Register('bhvTHIHugeIslandTop', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvTHIHugeIslandTop'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(thi_seg7_collision_top_trap),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_thi_huge_island_top_loop'),
    END_LOOP(),
});

Register('bhvTHITinyIslandTop', {
    BEGIN(OBJ_LIST_DEFAULT),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_thi_tiny_island_top_loop'),
    END_LOOP(),
});

Register('bhvCapSwitchBase', {
    BEGIN(OBJ_LIST_SURFACE),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(capswitch_collision_05003448),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvCapSwitch', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvCapSwitch'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(capswitch_collision_050033D0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_cap_switch_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvBobombAnchorMario', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBobombAnchorMario'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_FLOAT(oParentRelativePosX, 100),
    SET_FLOAT(oParentRelativePosZ, 150),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bobomb_anchor_mario_loop'),
    END_LOOP(),
});

Register('bhvKingBobomb', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvKingBobomb'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', king_bobomb_seg5_anims_0500FE30),
    SET_INT('InteractType', INTERACT_GRABBABLE),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 100),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_INT('IntangibleTimer', 0),
    DROP_TO_FLOOR(),
    SET_HOME(),
    SPAWN_OBJ(--[[Model]] MODEL.NONE, --[[Behavior]] bhvBobombAnchorMario),
    SET_INT(oHealth, 3),
    SET_INT('DamageOrCoinValue', 1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_king_bobomb_loop'),
    END_LOOP(),
});

Register('bhvSmallWaterWave398', {
    ADD_INT('AnimState', 1),
    ADD_FLOAT('PosY', 7),
    SET_RANDOM_FLOAT(oWaterObjUnkF4, --[[Minimum]] -2, --[[Range]] 5),
    SET_RANDOM_FLOAT(oWaterObjUnkF8, --[[Minimum]] -2, --[[Range]] 5),
    SUM_FLOAT(--[[Dest]] 'PosX', --[[Value 1]] 'PosX', --[[Value 2]] oWaterObjUnkF4),
    SUM_FLOAT(--[[Dest]] 'PosZ', --[[Value 1]] 'PosZ', --[[Value 2]] oWaterObjUnkF8),
    RETURN(),
});

Register('bhvSmallWaterWave', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSmallWaterWave'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    CALL_NATIVE('bhv_bubble_wave_init'),
    SET_RANDOM_FLOAT(oWaterObjUnkF4, --[[Minimum]] -50, --[[Range]] 100),
    SET_RANDOM_FLOAT(oWaterObjUnkF8, --[[Minimum]] -50, --[[Range]] 100),
    SUM_FLOAT(--[[Dest]] 'PosX', --[[Value 1]] 'PosX', --[[Value 2]] oWaterObjUnkF4),
    SUM_FLOAT(--[[Dest]] 'PosZ', --[[Value 1]] 'PosZ', --[[Value 2]] oWaterObjUnkF8),
    SET_RANDOM_FLOAT(oWaterObjUnkFC, --[[Minimum]] 0, --[[Range]] 50),
    SUM_FLOAT(--[[Dest]] 'PosY', --[[Value 1]] 'PosY', --[[Value 2]] oWaterObjUnkFC),
    SET_INT('AnimState', -1),
    CALL(bhvSmallWaterWave398),
    BEGIN_REPEAT(60),
        CALL(bhvSmallWaterWave398),
        CALL_NATIVE('bhv_small_water_wave_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvBubbleParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBubbleParticleSpawner'),
    DISABLE_RENDERING(),
    SET_RANDOM_INT(oWaterObjUnkF4, --[[Minimum]] 2, --[[Range]] 9),
    DELAY_VAR(oWaterObjUnkF4),
    SPAWN_CHILD(--[[Model]] MODEL.BUBBLE, --[[Behavior]] bhvSmallWaterWave),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_BUBBLE),
    DEACTIVATE(),
});

Register('bhvBubbleMaybe', {
    BEGIN(OBJ_LIST_UNIMPORTANT),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    CALL_NATIVE('bhv_bubble_wave_init'),
    SET_RANDOM_FLOAT(oWaterObjUnkF4, --[[Minimum]] -75, --[[Range]] 150),
    SET_RANDOM_FLOAT(oWaterObjUnkF8, --[[Minimum]] -75, --[[Range]] 150),
    SET_RANDOM_FLOAT(oWaterObjUnkFC, --[[Minimum]] -75, --[[Range]] 150),
    SUM_FLOAT(--[[Dest]] 'PosX', --[[Value 1]] 'PosX', --[[Value 2]] oWaterObjUnkF4),
    SUM_FLOAT(--[[Dest]] 'PosZ', --[[Value 1]] 'PosZ', --[[Value 2]] oWaterObjUnkF8),
    SUM_FLOAT(--[[Dest]] 'PosY', --[[Value 1]] 'PosY', --[[Value 2]] oWaterObjUnkFC),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(60),
        ADD_INT('AnimState', 1),
        CALL_NATIVE('bhv_bubble_maybe_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvWaterAirBubble', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvWaterAirBubble'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 400, --[[Height]] 150, --[[Downwards offset]] -150),
    SET_INT('IntangibleTimer', 0),
    SET_INTERACT_TYPE(INTERACT_WATER_RING),
    SET_INT('DamageOrCoinValue', 5),
    CALL_NATIVE('bhv_water_air_bubble_init'),
    SET_INT('AnimState', -1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_air_bubble_loop'),
    END_LOOP(),
});

Register('bhvSmallParticle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSmallParticle'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_particle_init'),
    BEGIN_REPEAT(70),
        CALL_NATIVE('bhv_particle_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvPlungeBubble', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvPlungeBubble'),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_PLUNGE_BUBBLE),
    DISABLE_RENDERING(),
    CALL_NATIVE('bhv_water_waves_init'),
    DEACTIVATE(),
});

Register('bhvSmallParticleSnow', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSmallParticleSnow'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_particle_init'),
    BEGIN_REPEAT(30),
        CALL_NATIVE('bhv_particle_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvSmallParticleBubbles', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSmallParticleBubbles'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_particle_init'),
    BEGIN_REPEAT(70),
        CALL_NATIVE('bhv_small_bubbles_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvFishGroup', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvFishGroup'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_fish_group_loop'),
    END_LOOP(),
});

Register('bhvCannonBarrel', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCannonBarrel'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_cannon_barrel_loop'),
    END_LOOP(),
});

Register('bhvCannon', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvCannon'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SPAWN_CHILD(--[[Model]] MODEL.CANNON_BARREL, --[[Behavior]] bhvCannonBarrel),
    SET_INT('InteractType', INTERACT_CANNON_BASE),
    ADD_FLOAT('PosY', -340),
    SET_HOME(),
    SET_HITBOX(--[[Radius]] 150, --[[Height]] 150),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_cannon_base_loop'),
    END_LOOP(),
});

Register('bhvChuckyaAnchorMario', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvChuckyaAnchorMario'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_FLOAT(oParentRelativePosY, -60),
    SET_FLOAT(oParentRelativePosZ, 150),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_chuckya_anchor_mario_loop'),
    END_LOOP(),
});

Register('bhvChuckya', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvChuckya'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', chuckya_seg8_anims_0800C070),
    ANIMATE(5),
    SET_INT('InteractType', INTERACT_GRABBABLE),
    SET_HITBOX(--[[Radius]] 150, --[[Height]] 100),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SPAWN_OBJ(--[[Model]] MODEL.NONE, --[[Behavior]] bhvChuckyaAnchorMario),
    SET_INT('NumLootCoins', 5),
    SET_INT('IntangibleTimer', 0),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_chuckya_loop'),
    END_LOOP(),
});

Register('bhvRotatingPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvRotatingPlatform'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_rotating_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvTower', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvTower'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(wf_seg7_collision_tower),
    SET_FLOAT('CollisionDistance', 3000),
    SET_FLOAT('DrawingDistance', 20000),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvBulletBillCannon', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBulletBillCannon'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(wf_seg7_collision_bullet_bill_cannon),
    SET_FLOAT('CollisionDistance', 300),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvWFBreakableWallLeft', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvWFBreakableWallLeft'),
    LOAD_COLLISION_DATA(wf_seg7_collision_breakable_wall_2),
    -- WF breakable walls - common:
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HITBOX(--[[Radius]] 300, --[[Height]] 400),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_wf_breakable_wall_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvWFBreakableWallRight', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvWFBreakableWallRight'),
    LOAD_COLLISION_DATA(wf_seg7_collision_breakable_wall),
    GOTO('bhvWFBreakableWallLeft', 3),
});

Register('bhvKickableBoard', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvKickableBoard'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(wf_seg7_collision_kickable_board),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 1200),
    SET_HURTBOX(--[[Radius]] 1, --[[Height]] 1),
    SET_FLOAT('CollisionDistance', 1500),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_kickable_board_loop'),
    END_LOOP(),
});

Register('bhvTowerDoor', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvTowerDoor'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(wf_seg7_collision_tower_door),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 100),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tower_door_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvRotatingCounterClockwise', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvRotatingCounterClockwise'),
    BREAK(),
});

Register('bhvWFRotatingWoodenPlatform', {
    BEGIN(OBJ_LIST_SURFACE),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(wf_seg7_collision_clocklike_rotation),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_wf_rotating_wooden_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvKoopaShellUnderwater', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvKoopaShellUnderwater'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_koopa_shell_underwater_loop'),
    END_LOOP(),
});

Register('bhvExitPodiumWarp', {
    BEGIN(OBJ_LIST_SURFACE),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('InteractType', INTERACT_WARP),
    DROP_TO_FLOOR(),
    SET_FLOAT('CollisionDistance', 8000),
    LOAD_COLLISION_DATA(ttm_seg7_collision_podium_warp),
    SET_INT('IntangibleTimer', 0),
    SET_HITBOX(--[[Radius]] 50, --[[Height]] 50),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
        SET_INT('InteractStatus', 0),
    END_LOOP(),
});

Register('bhvFadingWarp', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvFadingWarp'),
    SET_INT('InteractionSubtype', INT_SUBTYPE_FADING_WARP),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('InteractType', INTERACT_WARP),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_fading_warp_loop'),
    END_LOOP(),
});

Register('bhvWarp', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvWarp'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('InteractType', INTERACT_WARP),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_warp_loop'),
    END_LOOP(),
});

Register('bhvWarpPipe', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvWarpPipe'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('InteractType', INTERACT_WARP),
    LOAD_COLLISION_DATA(warp_pipe_seg3_collision_03009AC8),
    SET_FLOAT('DrawingDistance', 16000),
    SET_INT('IntangibleTimer', 0),
    SET_HITBOX(--[[Radius]] 70, --[[Height]] 50),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_warp_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvWhitePuffExplosion', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvWhitePuffExplosion'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_white_puff_exploding_loop'),
    END_LOOP(),
});

Register('bhvSpawnedStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvSpawnedStar'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('BehParams2ndByte', 1),
    GOTO('bhvSpawnedStarNoLevelExit', 2),
});

Register('bhvSpawnedStarNoLevelExit', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvSpawnedStarNoLevelExit'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    -- Spawned star - common:
    SET_HOME(),
    CALL_NATIVE('bhv_spawned_star_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_spawned_star_loop'),
    END_LOOP(),
});

Register('bhvSpawnedBlueCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvSpawnedBlueCoin'),
    SET_INT('InteractType', INTERACT_COIN),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_INT('IntangibleTimer', 0),
    SET_FLOAT('CoinBaseVelY', 20),
    SET_INT('AnimState', -1),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -70, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_spawned_coin_init'),
    SET_INT('DamageOrCoinValue', 5),
    SET_HITBOX(--[[Radius]] 120, --[[Height]] 64),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_spawned_coin_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
});

Register('bhvCoinInsideBoo', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvCoinInsideBoo'),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 64),
    SET_INT('InteractType', INTERACT_COIN),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -70, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    BILLBOARD(),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coin_inside_boo_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
});

Register('bhvCoinFormationSpawn', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvCoinFormationSpawn'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coin_formation_spawn_loop'),
    END_LOOP(),
});

Register('bhvCoinFormation', {
    BEGIN(OBJ_LIST_SPAWNER, 'bhvCoinFormation'),
	OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO)),
    CALL_NATIVE('bhv_coin_formation_loop'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coin_formation_loop'),
    END_LOOP(),
});

Register('bhvOneCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvOneCoin'),
    SET_INT('BehParams2ndByte', 1),
    GOTO('bhvYellowCoin', 1),
});

Register('bhvYellowCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvYellowCoin'),
    BILLBOARD(),
	OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO)),
    CALL_NATIVE('bhv_yellow_coin_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_yellow_coin_loop'),
    END_LOOP(),
});

Register('bhvTemporaryYellowCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvTemporaryYellowCoin'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_yellow_coin_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_temp_coin_loop'),
    END_LOOP(),
});

Register('bhvSingleCoinGetsSpawned', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvSingleCoinGetsSpawned'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    CALL_NATIVE('bhv_coin_init'),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -70, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coin_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvThreeCoinsSpawn', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvThreeCoinsSpawn'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_REPEAT(3),
        SPAWN_CHILD(--[[Model]] MODEL.YELLOW_COIN, --[[Behavior]] 'bhvSingleCoinGetsSpawned'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvTenCoinsSpawn', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvTenCoinsSpawn'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_REPEAT(10),
        SPAWN_CHILD(--[[Model]] MODEL.YELLOW_COIN, --[[Behavior]] 'bhvSingleCoinGetsSpawned'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvCoinSparkles', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCoinSparkles'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_FLOAT('GraphYOffset', 25),
    ADD_INT('AnimState', 1),
    BEGIN_REPEAT(8),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    BEGIN_REPEAT(2),
        CALL_NATIVE('bhv_coin_sparkles_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvGoldenCoinSparkles', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvGoldenCoinSparkles'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    DISABLE_RENDERING(),
    BEGIN_REPEAT(3),
        CALL_NATIVE('bhv_golden_coin_sparkles_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvWallTinyStarParticle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvWallTinyStarParticle'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    BEGIN_REPEAT(10),
    CALL_NATIVE('bhv_wall_tiny_star_particle_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvVertStarParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvVertStarParticleSpawner'),
    DISABLE_RENDERING(),
    CLEAR_BIT_PARENT('ActiveParticleFlags', ACTIVE_PARTICLE_V_STAR),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_tiny_star_particles_init'),
    DELAY(1),
    DEACTIVATE(),
});

Register('bhvPoundTinyStarParticle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvPoundTinyStarParticle'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    BEGIN_REPEAT(10),
        CALL_NATIVE('bhv_pound_tiny_star_particle_loop'),
    END_REPEAT(),
    DEACTIVATE(),
});

Register('bhvHorStarParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvHorStarParticleSpawner'),
    DISABLE_RENDERING(),
    CLEAR_BIT_PARENT('ActiveParticleFlags', ACTIVE_PARTICLE_H_STAR),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_pound_tiny_star_particle_init'),
    DELAY(1),
    DEACTIVATE(),
});

Register('bhvPunchTinyTriangle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvPunchTinyTriangle'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_punch_tiny_triangle_loop'),
    END_LOOP(),
});

Register('bhvTriangleParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvTriangleParticleSpawner'),
    DISABLE_RENDERING(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CLEAR_BIT_PARENT('ActiveParticleFlags', ACTIVE_PARTICLE_TRIANGLE),
        CALL_NATIVE('bhv_punch_tiny_triangle_init'),
    DELAY(1),
    DEACTIVATE(),
});

Register('bhvDoorWarp', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvDoorWarp'),
    SET_INT('InteractType', INTERACT_WARP_DOOR),
    GOTO('bhvDoor', 2),
});

Register('bhvDoor', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvDoor'),
    SET_INT('InteractType', INTERACT_DOOR),
    -- Door - common:
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', door_seg3_anims_030156C0),
    ANIMATE(0),
    LOAD_COLLISION_DATA('door_seg3_collision_0301CE78'),
    SET_HITBOX(--[[Radius]] 80, --[[Height]] 100),
    SET_INT('IntangibleTimer', 0),
    SET_FLOAT('CollisionDistance', 1000),
    SET_HOME(),
    CALL_NATIVE('bhv_door_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_door_loop'),
    END_LOOP(),
});

Register('bhvGrindel', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvGrindel'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA('ssl_seg7_collision_grindel'),
    DROP_TO_FLOOR(),
    ADD_FLOAT('PosY', 1),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_grindel_thwomp_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvThwomp', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvThwomp'),
    LOAD_COLLISION_DATA('thwomp_seg5_collision_0500B92C'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    ADD_FLOAT('PosY', 1),
    SET_HOME(),
    SCALE(--[[Unused]] 0, --[[Field]] 140),
    SET_FLOAT('DrawingDistance', 4000),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_grindel_thwomp_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvThwomp2', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvThwomp2'),
    LOAD_COLLISION_DATA('thwomp_seg5_collision_0500B7D0'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    ADD_FLOAT('PosY', 1),
    SCALE(--[[Unused]] 0, --[[Field]] 140),
    SET_HOME(),
    SET_FLOAT('DrawingDistance', 4000),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_grindel_thwomp_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvTumblingBridgePlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvTumblingBridgePlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_FLOAT('CollisionDistance', 300),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tumbling_bridge_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
});

Register('bhvTumblingBridge', {
    BEGIN(OBJ_LIST_SPAWNER, 'bhvTumblingBridge'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tumbling_bridge_loop'),
    END_LOOP(),
});

Register('bhvBbhTumblingBridge', {
    BEGIN(OBJ_LIST_SPAWNER, 'bhvBbhTumblingBridge'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_INT('BehParams2ndByte', 1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tumbling_bridge_loop'),
    END_LOOP(),
});

Register('bhvLLLTumblingBridge', {
    BEGIN(OBJ_LIST_SPAWNER, 'bhvLLLTumblingBridge'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_INT('BehParams2ndByte', 2),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tumbling_bridge_loop'),
    END_LOOP(),
});

Register('bhvFlame', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvFlame'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_HOME(),
    SCALE(--[[Unused]] 0, --[[Field]] 700),
    SET_INTERACT_TYPE(INTERACT_FLAME),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 50, --[[Height]] 25, --[[Downwards offset]] 25),
    SET_INT('IntangibleTimer', 0),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        SET_INT('InteractStatus', 0),
        ANIMATE_TEXTURE('AnimState', 2),
    END_LOOP(),
});

Register('bhvAnotherElavator', { 
    BEGIN(OBJ_LIST_SURFACE, 'bhvAnotherElavator'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(hmc_seg7_collision_elevator),
    SET_HOME(),
    CALL_NATIVE('bhv_elevator_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_elevator_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvRRElevatorPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvRRElevatorPlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(rr_seg7_collision_elevator_platform),
    SET_HOME(),
    CALL_NATIVE('bhv_elevator_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_elevator_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvHMCElevatorPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvHMCElevatorPlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(hmc_seg7_collision_elevator),
    SET_HOME(),
    CALL_NATIVE('bhv_elevator_init'),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_elevator_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvMario', {
    BEGIN(OBJ_LIST_PLAYER, 'bhvMario'),
    SET_INT('IntangibleTimer', 0),
    OR_INT('Flags', OBJ_FLAG_0100),
    OR_INT(oUnk94, 0x0001),
    SET_HITBOX(--[[Radius]] 37, --[[Height]] 160),
    BEGIN_LOOP(),
        -- CALL_NATIVE(try_print_debug_mario_level_info),
        CALL_NATIVE('ObjectListProcessor.bhv_mario_update'),
        -- CALL_NATIVE(try_do_mario_debug_object_spawn),
    END_LOOP(),
})

Register('bhvTree', {
    BEGIN(OBJ_LIST_POLELIKE, 'bhvTree'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('InteractType', INTERACT_POLE),
    SET_HITBOX(--[[Radius]] 80, --[[Height]] 500),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_pole_base_loop'),
    END_LOOP(),
})

Register('bhvSparkleParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvSparkleParticleSpawner'),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_SPARKLES),
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSparkleParticleSpawner'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_FLOAT('GraphYOffset', 25),
    SET_RANDOM_FLOAT(oMarioParticleFlags, --[[Minimum]] -50, --[[Range]] 100),
    SUM_FLOAT(--[[Dest]] 'PosX', --[[Value 1]] 'PosX', --[[Value 2]] oMarioParticleFlags),
    SET_RANDOM_FLOAT(oMarioParticleFlags, --[[Minimum]] -50, --[[Range]] 100),
    SUM_FLOAT(--[[Dest]] 'PosZ', --[[Value 1]] 'PosZ', --[[Value 2]] oMarioParticleFlags),
    SET_RANDOM_FLOAT(oMarioParticleFlags, --[[Minimum]] -50, --[[Range]] 100),
    SUM_FLOAT(--[[Dest]] 'PosY', --[[Value 1]] 'PosY', --[[Value 2]] oMarioParticleFlags),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(12),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvScuttlebug', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvScuttlebug'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', scuttlebug_seg6_anims_06015064),
    ANIMATE(0),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 80, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 0, --[[Friction]] 0, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_HOME(),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_scuttlebug_loop'),
    END_LOOP(),
})

Register('bhvScuttlebugSpawn', {
    BEGIN(OBJ_LIST_SPAWNER, 'bhvScuttlebugSpawn'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_scuttlebug_spawn_loop'),
    END_LOOP(),
})

Register('bhvYellowBall', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvYellowBall'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CYLBOARD(),
    BREAK(),
})

Register('bhvStaticObject', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvStaticObject'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BREAK(),
})

Register('bhvCastleFloorTrap', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCastleFloorTrap'),
    DISABLE_RENDERING(),
    CALL_NATIVE('bhv_castle_floor_trap_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_castle_floor_trap_loop'),
    END_LOOP(),
})

Register('bhvFloorTrapInCastle', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvFloorTrapInCastle'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(inside_castle_seg7_collision_floor_trap),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_floor_trap_in_castle_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvCastleFlagWaving', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCastleFlagWaving'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_ANIMATIONS('Animations', castle_grounds_seg7_anims_flags),
    ANIMATE(0),
    CALL_NATIVE('bhv_castle_flag_init'),
    BEGIN_LOOP(),
    END_LOOP(),
})

Register('bhvCheckerboardPlatformSub', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvCheckerboardPlatformSub'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO)),
    LOAD_COLLISION_DATA(checkerboard_platform_seg8_collision_0800D710),
    CALL_NATIVE('bhv_checkerboard_platform_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_checkerboard_platform_loop'),
    END_LOOP(),
})

Register('bhvCheckerboardElevatorGroup', {
    BEGIN(OBJ_LIST_SPAWNER, 'bhvCheckerboardElevatorGroup'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_checkerboard_elevator_group_init'),
    SET_HOME(),
    DELAY(1),
    DEACTIVATE(),
})

Register('bhvMoatGrills', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvMoatGrills'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(castle_grounds_seg7_collision_moat_grills),
    SET_FLOAT('CollisionDistance', 30000),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_moat_grills_loop'),
    END_LOOP(),
})

Register('bhvPlatformOnTrack', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvPlatformOnTrack'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 50, --[[Gravity]] -100, --[[Bounciness]] -50, --[[Drag strength]] 100, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('bhv_platform_on_track_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_platform_on_track_update'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvDirtParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvDirtParticleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_ground_sand_init'),
    DELAY(1),
    DEACTIVATE(),
})

Register('bhvCloud', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCloud'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HOME(),
    SET_INT(oOpacity, 240),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_cloud_update'),
    END_LOOP(),
})

Register('bhvCameraLakitu', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCameraLakitu'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', lakitu_seg6_anims_060058F8),
    ANIMATE(0),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('bhv_camera_lakitu_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_camera_lakitu_update'),
    END_LOOP(),
})

Register('bhvTrackBall', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvTrackBall'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    CALL_NATIVE('bhv_init_room'),
    SCALE(--[[Unused]] 0, --[[Field]] 15),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_track_ball_update'),
    END_LOOP(),
})

Register('bhvSeesawPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvSeesawPlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_seesaw_platform_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_seesaw_platform_update'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvFerrisWheelAxle', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvFerrisWheelAxle'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    ADD_INT(oMoveAngleYaw, 0x4000),
    CALL_NATIVE('bhv_ferris_wheel_axle_init'),
    BEGIN_LOOP(),
        ADD_INT('FaceAngleRoll', 400),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvFerrisWheelPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvFerrisWheelPlatform'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_ferris_wheel_platform_update'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvWaterBombSpawner', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvWaterBombSpawner'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_bomb_spawner_update'),
    END_LOOP(),
})

Register('bhvWaterBomb', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvWaterBomb'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 120, --[[Gravity]] -400, --[[Bounciness]] 0, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_bomb_update'),
    END_LOOP(),
})

Register('bhvWaterBombShadow', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvWaterBombShadow'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SCALE(--[[Unused]] 0, --[[Field]] 150),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_bomb_shadow_update'),
    END_LOOP(),
})

Register('bhvRespawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvRespawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_respawner_loop'),
    END_LOOP(),
})

Register('bhvSmallBully', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvSmallBully'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bully_seg5_anims_0500470C),
    DROP_TO_FLOOR(),
    SET_HOME(),
    CALL_NATIVE('bhv_small_bully_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_bully_loop'),
    END_LOOP(),
})

Register('bhvBigBully', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBigBully'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bully_seg5_anims_0500470C),
    DROP_TO_FLOOR(),
    SET_HOME(),
    CALL_NATIVE('bhv_big_bully_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_bully_loop'),
    END_LOOP(),
})

Register('bhvBigBullyWithMinions', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBigBullyWithMinions'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bully_seg5_anims_0500470C),
    SET_HOME(),
    CALL_NATIVE('bhv_big_bully_init'),
    CALL_NATIVE('bhv_big_bully_with_minions_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_big_bully_with_minions_loop'),
    END_LOOP(),
})

--[[Register('bhvBigChillBully', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBigChillBully'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', chilly_chief_seg6_anims_06003994),
    DROP_TO_FLOOR(),
    SET_HOME(),
    SET_INT(oBullySubtype, 0x0010),
    CALL_NATIVE('bhv_big_bully_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_bully_loop'),
    END_LOOP(),
})]]

Register('bhvGoomba', {
    BEGIN(OBJ_LIST_PUSHABLE, 'bhvGoomba'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO)),
    DROP_TO_FLOOR(),
    LOAD_ANIMATIONS('Animations', goomba_seg8_anims_0801DA4C),
    SET_HOME(),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 40, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strenth]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 0, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_goomba_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_goomba_update'),
    END_LOOP(),
})

Register('bhvGoombaTripletSpawner', {
    BEGIN(OBJ_LIST_PUSHABLE, 'bhvGoombaTripletSpawner'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO)),
    DROP_TO_FLOOR(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_goomba_triplet_spawner_update'),
    END_LOOP(),
})

Register('bhvBobomb', {
    BEGIN(OBJ_LIST_DESTRUCTIVE, 'bhvBobomb'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bobomb_seg8_anims_0802396C),
    DROP_TO_FLOOR(),
    ANIMATE(0),
    SET_INT('IntangibleTimer', 0),
    SET_HOME(),
    CALL_NATIVE('bhv_bobomb_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bobomb_loop'),
    END_LOOP(),
})

Register('bhvBobombFuseSmoke', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBobombFuseSmoke'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_INT('AnimState', -1),
    CALL_NATIVE('bhv_bobomb_fuse_smoke_init'),
    DELAY(1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_dust_smoke_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvExplosion', {
    BEGIN(OBJ_LIST_DESTRUCTIVE, 'bhvExplosion'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_INTERACT_TYPE(INTERACT_DAMAGE),
    SET_INT('DamageOrCoinValue', 2),
    SET_INT('IntangibleTimer', 0),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 150, --[[Height]] 150, --[[Downwards offset]] 150),
    SET_INT('AnimState', -1),
    CALL_NATIVE('bhv_explosion_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_explosion_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvBobombBuddy', {
    BEGIN(OBJ_LIST_GENACTOR, "bhvBobombBuddy"),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bobomb_seg8_anims_0802396C),
    SET_INTERACT_TYPE(INTERACT_TEXT),
    DROP_TO_FLOOR(),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 60),
    ANIMATE(0),
    SET_INT(oBobombBuddyRole, 0),
    SET_HOME(),
    CALL_NATIVE('bhv_bobomb_buddy_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_bobomb_buddy_loop'),
    END_LOOP(),
})

-- The only difference between this and the previous behavior are what 'Flags' and oBobombBuddyRole are set to, why didn't they just use a jump?
Register('bhvBobombBuddyOpensCannon', {
    BEGIN(OBJ_LIST_GENACTOR, "bhvBobombBuddyOpensCannon"),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bobomb_seg8_anims_0802396C),
    SET_INTERACT_TYPE(INTERACT_TEXT),
    DROP_TO_FLOOR(),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 60),
    ANIMATE(0),
    SET_INT(oBobombBuddyRole, 1),
    SET_HOME(),
    CALL_NATIVE('bhv_bobomb_buddy_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_bobomb_buddy_loop'),
    END_LOOP(),
})

Register('bhvCannonClosed', {
    BEGIN(OBJ_LIST_SURFACE, "bhvCannonClosed"),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(cannon_lid_seg8_collision_08004950),
    SET_HOME(),
    CALL_NATIVE('bhv_cannon_closed_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_cannon_closed_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

-- Register('bhvWhirlpool', {

-- Register('bhvJetStream', {

Register('bhvMessagePanel', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvMessagePanel'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(wooden_signpost_seg3_collision_0302DD80),
    SET_FLOAT('CollisionDistance', 150),  -- 'CollisionDistance' = 150.0 from BehaviorCommands.
    SET_INTERACT_TYPE(INTERACT_TEXT),
    SET_INT('InteractionSubtype', INT_SUBTYPE_SIGN),
    DROP_TO_FLOOR(),
    SET_HITBOX(--[[Radius]] 150, --[[Height]] 80),
    SET_INT(oWoodenPostTotalMarioAngle, 0),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
        SET_INT('InteractStatus', 0),
    END_LOOP(),
})

Register('bhvSignOnWall', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvSignOnWall'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(wooden_signpost_seg3_collision_0302DD80),
    SET_INTERACT_TYPE(INTERACT_TEXT),
    SET_INT('InteractionSubtype', INT_SUBTYPE_SIGN),
    DROP_TO_FLOOR(),
    SET_HITBOX(--[[Radius]] 150, --[[Height]] 80),
    SET_INT(oWoodenPostTotalMarioAngle, 0),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        SET_INT('InteractStatus', 0),
    END_LOOP(),
})

Register('bhvBobombBullyDeathSmoke', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvBobombBullyDeathSmoke'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL, OBJ_FLAG_MOVE_XZ_USING_FVEL)),
    BILLBOARD(),
    ADD_INT('AnimState', 1),
    CALL_NATIVE('bhv_bobomb_bully_death_smoke_init'),
    DELAY(1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_dust_smoke_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvWoodenPost', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvWoodenPost'),
    LOAD_COLLISION_DATA(poundable_pole_collision_06002490),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO)),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 0, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_INT('NumLootCoins', 5),
    DROP_TO_FLOOR(),
    SET_HOME(),
    SCALE(--[[Unused]] 0, --[[Field]] 50),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_wooden_post_update'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvChainChomp', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvChainChomp'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_ACTIVE_FROM_AFAR)),
    DROP_TO_FLOOR(),
    LOAD_ANIMATIONS('Animations', chain_chomp_seg6_anims_06025178),
    ANIMATE(0),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 0, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 0, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    HIDE(),
    SET_HOME(),
    SET_FLOAT('GraphYOffset', 240),
    SCALE(--[[Unused]] 0, --[[Field]] 200),
    SPAWN_CHILD_WITH_PARAM(--[[Bhv param]] 0, --[[Model]] MODEL.WOODEN_POST, --[[Behavior]] bhvWoodenPost),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_chain_chomp_update'),
    END_LOOP(),
})

Register('bhvChainChompChainPart', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvChainChompChainPart'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 0, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_FLOAT('GraphYOffset', 40),
    SCALE(--[[Unused]] 0, --[[Field]] 200),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_chain_chomp_chain_part_update'),
    END_LOOP(),
})

Register('bhvChainChompGate', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvChainChompGate'),
    LOAD_COLLISION_DATA(bob_seg7_collision_chain_chomp_gate),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_chain_chomp_gate_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_chain_chomp_gate_update'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvWhitePuff1', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvWhitePuff1'),
    CLEAR_BIT_PARENT('ActiveParticleFlags', ACTIVE_PARTICLE_DUST),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_white_puff_1_loop'),
    END_LOOP(),
})

Register('bhvWhitePuff2', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvWhitePuff2'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE, OBJ_FLAG_MOVE_XZ_USING_FVEL)),
    BILLBOARD(),
    ADD_INT('AnimState', 1),
    BEGIN_REPEAT(7),
        CALL_NATIVE('bhv_white_puff_2_loop'),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvBlueCoinSwitch', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBlueCoinSwitch'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(blue_coin_switch_seg8_collision_08000E98),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_blue_coin_switch_loop'),
    END_LOOP(),
})

Register('bhvHiddenBlueCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHiddenBlueCoin'),
    SET_INT('InteractType', INTERACT_COIN),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 64),
    SET_INT('DamageOrCoinValue', 5),
    SET_INT('IntangibleTimer', 0),
    SET_INT('AnimState', -1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_hidden_blue_coin_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvBreakBoxTriangle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvBreakBoxTriangle'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_REPEAT(18),
        CALL_NATIVE('cur_obj_rotate_face_angle_using_vel'),
        CALL_NATIVE('cur_obj_move_using_fvel_and_gravity'),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvWaterMist', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvWaterMist'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_INT(oOpacity, 254),
    SET_FLOAT(oForwardVel, 20),
    SET_FLOAT(oVelY, -8),
    ADD_FLOAT('PosY', 62),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_mist_loop'),
    END_LOOP(),
})

Register('bhvBreathParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBreathParticleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_REPEAT(8),
        CALL_NATIVE('bhv_water_mist_spawn_loop'),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvWaterMist2', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvWaterMist2'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_INT('FaceAnglePitch', 0xC000),
    SCALE(--[[Unused]] 0, --[[Field]] 2100),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_mist_2_loop'),
    END_LOOP(),
})

Register('bhvMistParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvMistParticleSpawner'),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_DUST),
    DISABLE_RENDERING(),
    SPAWN_CHILD(--[[Model]] MODEL.MIST,  --[[Behavior]] bhvWhitePuff1),
    SPAWN_CHILD(--[[Model]] MODEL.SMOKE, --[[Behavior]] bhvWhitePuff2),
    DELAY(1),
    DEACTIVATE(),
})

Register('bhvSnowParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvSnowParticleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_ground_snow_init'),
    DELAY(1),
    DEACTIVATE(),
})

Register('bhvMistCircParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvMistCircParticleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
        CALL_NATIVE('bhv_pound_white_puffs_init'),
    DELAY(1),
    DEACTIVATE(),
})

Register('bhvMrIBlueCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvMrIBlueCoin'),
    SET_INT('InteractType', INTERACT_COIN),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_INT('IntangibleTimer', 0),
    SET_FLOAT('CoinBaseVelY', 20),
    SET_INT('AnimState', -1),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -70, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_coin_init'),
    SET_INT('DamageOrCoinValue', 5),
    SET_HITBOX(--[[Radius]] 120, --[[Height]] 64),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coin_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvTiltingBowserLavaPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvTiltingBowserPlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(bowser_2_seg7_collision_tilting_platform),
    --SET_FLOAT('DrawingDistance', 20000),
    SET_FLOAT('CollisionDistance', 20000),
    SET_INT('FaceAngleYaw', 0),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('cur_obj_rotate_face_angle_using_vel'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvFish', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvFish'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_fish_loop'),
    END_LOOP(),
})

Register('bhvFishSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvFishSpawner'),
    -- Fish Spawner - common
    DISABLE_RENDERING(),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_fish_spawner_loop'),
    END_LOOP(),
})

Register('bhvManyBlueFishSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvManyBlueFishSpawner'),
    SET_INT('BehParams2ndByte', 0),
    -- GOTO(bhvFishSpawner + 1)
    DISABLE_RENDERING(),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_fish_spawner_loop'),
    END_LOOP(),
})

Register('bhvHomingAmp', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvHomingAmp'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', amp_seg8_anims_08004034),
    ANIMATE(0),
    SET_FLOAT('GraphYOffset', 40),
    SET_INT('IntangibleTimer', 0),
    CALL_NATIVE('bhv_homing_amp_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_homing_amp_loop'),
    END_LOOP(),
})

Register('bhvCirclingAmp', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvCirclingAmp'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', amp_seg8_anims_08004034),
    ANIMATE(0),
    SET_FLOAT('GraphYOffset', 40),
    SET_INT('IntangibleTimer', 0),
    CALL_NATIVE('bhv_circling_amp_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_circling_amp_loop'),
    END_LOOP(),
})

Register('bhvButterfly', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvButterfly'),
	OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', butterfly_seg3_anims_030056B0),
    DROP_TO_FLOOR(),
    SET_FLOAT('GraphYOffset', 5),
    CALL_NATIVE('bhv_butterfly_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_butterfly_loop'),
    END_LOOP(),
})

Register('bhvCarrySomething1', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCarrySomething1'),
    BREAK(),
})

Register('bhvCarrySomething2', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCarrySomething2'),
    BREAK(),
})

Register('bhvCarrySomething3', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCarrySomething3'),
    BREAK(),
})

Register('bhvCarrySomething4', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCarrySomething4'),
    BREAK(),
})

Register('bhvCarrySomething5', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCarrySomething5'),
    BREAK(),
})

Register('bhvCarrySomething6', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCarrySomething6'),
    BREAK(),
})

Register('bhvSlidingPlatform2', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvSlidingPlatform2'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    CALL_NATIVE('bhv_sliding_plat_2_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_sliding_plat_2_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvBird', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBird'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', birds_seg5_anims_050009E8),
    ANIMATE(0),
    HIDE(),
    SCALE(--[[Unused]] 0, --[[Field]] 70),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bird_update'),
    END_LOOP(),
})

Register('bhvCoffinSpawner', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvCoffinSpawner'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coffin_spawner_loop'),
    END_LOOP(),
})

Register('bhvCoffin', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvCoffin'),
    LOAD_COLLISION_DATA(bbh_seg7_collision_coffin),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_coffin_loop'),
    END_LOOP(),
})

-- The large splash Mario makes when he jumps into a pool of water.
Register('bhvWaterSplash', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvWaterSplash'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(3),
        ADD_INT('AnimState', 1),
        CALL_NATIVE('bhv_water_splash_spawn_droplets'),
        DELAY(1),
        CALL_NATIVE('bhv_water_splash_spawn_droplets'),
    END_REPEAT(),
    BEGIN_REPEAT(5),
        ADD_INT('AnimState', 1),
        DELAY(1),
    END_REPEAT(),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_WATER_SPLASH),
    DEACTIVATE(),
})

-- Droplets of water that spawn as a result of various water splashes.
Register('bhvWaterDroplet', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvWaterDroplet'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_droplet_loop'),
    END_LOOP(),
})

-- Small splashes that are seen when a water droplet lands back into the water.
Register('bhvWaterDropletSplash', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvWaterDropletSplash'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('FaceAnglePitch', 0),
    SET_INT('FaceAngleYaw', 0),
    SET_INT('FaceAngleRoll', 0),
    CALL_NATIVE('bhv_water_droplet_splash_init'),
    ADD_FLOAT('PosY', 5),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(6),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    DEACTIVATE(),
})

-- The splash created when an air bubble hits the surface of the water.
Register('bhvBubbleSplash', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBubbleSplash'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('FaceAnglePitch', 0),
    SET_INT('FaceAngleYaw', 0),
    SET_INT('FaceAngleRoll', 0),
    SET_INT('AnimState', -1),
    CALL_NATIVE('bhv_bubble_splash_init'),
    BEGIN_REPEAT(6),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    DEACTIVATE(),
})

-- The water wave surrounding Mario when he is idle in a pool of water.
Register('bhvIdleWaterWave', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvIdleWaterWave'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('FaceAnglePitch', 0),
    SET_INT('FaceAngleYaw', 0),
    SET_INT('FaceAngleRoll', 0),
    SET_INT('AnimState', -1),
    ADD_INT('AnimState', 1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_idle_water_wave_loop'),
        ADD_INT('AnimState', 1),
        BEGIN_REPEAT(6),
            CALL_NATIVE('bhv_idle_water_wave_loop'),
        END_REPEAT(),
        CALL_NATIVE('bhv_idle_water_wave_loop'),
    END_LOOP(),
})

-- Water splashes similar to the splashes created by water droplets, but are created by other objects.
-- Unlike water droplet splashes, they are unimportant objects.
Register('bhvObjectWaterSplash', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvObjectWaterSplash'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('FaceAnglePitch', 0),
    SET_INT('FaceAngleYaw', 0),
    SET_INT('FaceAngleRoll', 0),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(6),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    DEACTIVATE(),
})

-- Waves that are generated when running in shallow water.
Register('bhvShallowWaterWave', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvShallowWaterWave'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    DISABLE_RENDERING(),
    BEGIN_REPEAT(5),
        SPAWN_WATER_DROPLET('gShallowWaterWaveDropletParams'),
    END_REPEAT_CONTINUE(),
    DELAY(1),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_SHALLOW_WATER_WAVE),
    DEACTIVATE(),
})

-- A small water splash that occurs when jumping in and out of shallow water.
-- Unlike the larger water splash it has no visible model of its own.
-- It has a 1 in 256 chance of spawning the fish particle easter egg.
Register('bhvShallowWaterSplash', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvShallowWaterSplash'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    DISABLE_RENDERING(),
    BEGIN_REPEAT(18),
        SPAWN_WATER_DROPLET('gShallowWaterSplashDropletParams'),
    END_REPEAT_CONTINUE(),
    CALL_NATIVE('bhv_shallow_water_splash_init'),
    DELAY(1),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH),
    DEACTIVATE(),
})

-- Waves created by other objects along the water's surface, specifically the koopa shell and Sushi.
-- Unlike Mario's waves, they are unimportant objects.
Register('bhvObjectWaveTrail', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvObjectWaveTrail'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    GOTO('bhvWaveTrail', 3), -- Wave trail - common
})

-- The waves created by Mario while he is swimming.
Register('bhvWaveTrail', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvWaveTrail'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    PARENT_BIT_CLEAR('ActiveParticleFlags', ACTIVE_PARTICLE_WAVE_TRAIL),
    -- Wave trail - common:
    SET_FLOAT('FaceAnglePitch', 0),
    SET_FLOAT('FaceAngleYaw', 0),
    SET_FLOAT('FaceAngleRoll', 0),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(8),
        ADD_INT('AnimState', 1),
        CALL_NATIVE('bhv_wave_trail_shrink'),
        DELAY(1),
        CALL_NATIVE('bhv_wave_trail_shrink'),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvGhostHuntBigBoo', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvCoinInsideBoo'),
    -- Big boo - common:
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('bhv_boo_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_big_boo_loop'),
    END_LOOP(),
})

Register('bhvBooInCastle', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBooInCastle'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_FLOAT('GraphYOffset', 60),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_boo_in_castle_loop'),
    END_LOOP(),
})

Register('bhvBooWithCage', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBooWithCage'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_INT('DamageOrCoinValue', 3),
    SET_HURTBOX(--[[Radius]] 80, --[[Height]] 120),
    SET_HITBOX(--[[Radius]] 180, --[[Height]] 140),
    SET_FLOAT('GraphYOffset', 60),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_boo_with_cage_init'),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_boo_with_cage_loop'),
    END_LOOP(),
})

Register('bhvBalconyBigBoo', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBalconyBigBoo'),
    SET_INT('BehParams2ndByte', 2),
    SET_INT('BigBooNumMinionBoosKilled', 10),
    GOTO('bhvGhostHuntBigBoo', 1),
})

Register('bhvMerryGoRoundBigBoo', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvMerryGoRoundBigBoo'),
    SET_INT('BehParams2ndByte', 1),
    -- Set number of minion boos killed to 10, which is greater than 5 so that the boo always loads without needing to kill any boos.
    SET_INT('BigBooNumMinionBoosKilled', 10),
    GOTO('bhvGhostHuntBigBoo', 1),
})

Register('bhvCourtyardBooTriplet', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCourtyardBooTriplet'),
    DISABLE_RENDERING(),
    CALL_NATIVE('bhv_courtyard_boo_triplet_init'),
    DEACTIVATE(),
})

Register('bhvBooCage', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBooCage'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_FLOAT('GraphYOffset', 10),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 0, --[[Friction]] 0, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_boo_cage_loop'),
    END_LOOP(),
})

Register('bhvGhostHuntBoo', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvGhostHuntBoo'),
    -- Boo - common:
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('IntangibleTimer', 0),
    SET_HOME(),
    SET_INT('DamageOrCoinValue', 2),
    SET_HITBOX(--[[Radius]] 140, --[[Height]] 80),
    SET_HURTBOX(--[[Radius]] 40, --[[Height]] 60),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_init_room'),
    SPAWN_CHILD(--[[Model]] MODEL.YELLOW_COIN, --[[Behavior]] bhvCoinInsideBoo),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    CALL_NATIVE('bhv_boo_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_boo_loop'),
    END_LOOP(),
})

Register('bhvMerryGoRoundBoo', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvMerryGoRoundBoo'),
    SET_INT('BehParams2ndByte', 2),
    GOTO('bhvGhostHuntBoo', 1),
})

Register('bhvBoo', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBoo'),
    SET_INT('BehParams2ndByte', 1),
    GOTO('bhvGhostHuntBoo', 1),
})

Register('bhvMerryGoRoundBooManager', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvMerryGoRoundBooManager'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_merry_go_round_boo_manager_loop'),
    END_LOOP(),
})

Register('bhvHiddenAt120Stars', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvHiddenAt120Stars'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(castle_grounds_seg7_collision_cannon_grill),
    SET_FLOAT('CollisionDistance', 4000),
    CALL_NATIVE('bhv_castle_cannon_grate_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvWingCap', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvWingCap'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_wing_cap_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_wing_vanish_cap_loop'),
    END_LOOP(),
})

Register('bhvMetalCap', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvMetalCap'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_metal_cap_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_metal_cap_loop'),
    END_LOOP(),
})

Register('bhvNormalCap', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvNormalCap'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_normal_cap_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_normal_cap_loop'),
    END_LOOP(),
})

Register('bhvVanishCap', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvVanishCap'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_vanish_cap_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_wing_vanish_cap_loop'),
    END_LOOP(),
})

Register('bhvStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvStar'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('bhv_collect_star_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_collect_star_loop'),
    END_LOOP(),
})

Register('bhvStarSpawnCoordinates', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvStarSpawnCoordinates'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_collect_star_init'),
    CALL_NATIVE('bhv_star_spawn_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_star_spawn_loop'),
    END_LOOP(),
})

Register('bhvHiddenRedCoinStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHiddenRedCoinStar'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_hidden_red_coin_star_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_hidden_red_coin_star_loop'),
    END_LOOP(),
})

Register('bhvRedCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvRedCoin'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_INT('IntangibleTimer', 0),
    SET_INT('AnimState', -1),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('bhv_red_coin_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_red_coin_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvBowserCourseRedCoinStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvBowserCourseRedCoinStar'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bowser_course_red_coin_star_loop'),
    END_LOOP(),
})

Register('bhvHiddenStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHiddenStar'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_hidden_star_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_hidden_star_loop'),
    END_LOOP(),
})

Register('bhvHiddenStarTrigger', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHiddenStarTrigger'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 100),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_hidden_star_trigger_loop'),
    END_LOOP(),
})

Register('bhvRedCoinStarMarker', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvRedCoinStarMarker'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    DROP_TO_FLOOR(),
    SCALE(--[[Unused]] 0, --[[Field]] 150),
    SET_INT('FaceAnglePitch', 0x4000),
    ADD_FLOAT('PosY', 60),
    CALL_NATIVE('bhv_red_coin_star_marker_init'),
    BEGIN_LOOP(),
        ADD_INT('FaceAngleYaw', 0x100),
    END_LOOP(),
})

Register('bhv1upWalking', {
    BEGIN(OBJ_LIST_LEVEL, 'bhv1upWalking'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_common_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_1up_walking_loop'),
    END_LOOP(),
})

Register('bhv1upRunningAway', {
    BEGIN(OBJ_LIST_LEVEL, 'bhv1upRunningAway'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_common_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_1up_running_away_loop'),
    END_LOOP(),
})

Register('bhv1upSliding', {
    BEGIN(OBJ_LIST_LEVEL, 'bhv1upSliding'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_common_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_1up_sliding_loop'),
    END_LOOP(),
})

Register('bhv1Up', {
    BEGIN(OBJ_LIST_LEVEL, 'bhv1Up'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_1up_loop'),
    END_LOOP(),
})

Register('bhv1upJumpOnApproach', {
    BEGIN(OBJ_LIST_LEVEL, 'bhv1upJumpOnApproach'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_common_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_1up_jump_on_approach_loop'),
    END_LOOP(),
})

Register('bhvHidden1up', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHidden1up'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_common_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_1up_hidden_loop'),
    END_LOOP(),
})

Register('bhvHidden1upTrigger', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHidden1upTrigger'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 100),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_1up_hidden_trigger_loop'),
    END_LOOP(),
})

Register('bhvHidden1upInPole', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHidden1upInPole'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 30, --[[Height]] 30, --[[Downwards offset]] 0),
    SET_FLOAT('GraphYOffset', 30),
    CALL_NATIVE('bhv_1up_common_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_1up_hidden_in_pole_loop'),
    END_LOOP(),
})

Register('bhvHidden1upInPoleTrigger', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHidden1upInPoleTrigger'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 100),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_1up_hidden_in_pole_trigger_loop'),
    END_LOOP(),
})

Register('bhvHidden1upInPoleSpawner', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvHidden1upInPoleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_1up_hidden_in_pole_spawner_loop'),
    END_LOOP(),
})

Register('bhvMovingYellowCoin', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvMovingYellowCoin'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 64),
    SET_INT('InteractType', INTERACT_COIN),
    SET_INT('IntangibleTimer', 0),
    SET_INT('AnimState', -1),
    CALL_NATIVE('bhv_moving_yellow_coin_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_moving_yellow_coin_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),

})

Register('bhvBowser', {
    BEGIN(OBJ_LIST_GENACTOR, "bhvBowser"),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_HOLDABLE, OBJ_FLAG_ACTIVE_FROM_AFAR, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_INT('InteractType', INTERACT_GRABBABLE),
    SET_HITBOX(--[[Radius]] 400, --[[Height]] 400),
    DROP_TO_FLOOR(),
    SET_HOME(),
    LOAD_ANIMATIONS('Animations', bowser_seg6_anims_06057690),
    --SPAWN_CHILD(--[[Model]] MODEL.NONE, --[[Behavior]] 'bhvBowserBodyAnchor'),
    --SPAWN_CHILD(--[[Model]] MODEL.BOWSER_BOMB_CHILD_OBJ, --[[Behavior]] 'bhvBowserFlameSpawn'),
    --SPAWN_OBJ(--[[Model]] MODEL.NONE, --[[Behavior]] 'bhvBowserTailAnchor'), Uncaught unlinked spawn_obj behavior: bhvBowserTailAnchor
    SET_INT('NumLootCoins', 50),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 0, --[[Gravity]] -400, --[[Bounciness]] -70, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_HOME(),
    --CALL_NATIVE('bhv_bowser_init'), Uncaught deferred native function not found: bhv_bowser_init | sorry Bowser but I gotta cripple you because I am limitted to the technology of my time.
    BEGIN_LOOP(),
        --CALL_NATIVE('bhv_bowser_loop'),
    END_LOOP(),
})

Register('bhvBowserBodyAnchor', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBowserBodyAnchor'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_HITBOX(--[[Radius]] 100, --[[Height]] 300),
    SET_INTERACT_TYPE(INTERACT_DAMAGE),
    SET_INT('InteractionSubtype', INT_SUBTYPE_BIG_KNOCKBACK),
    DISABLE_RENDERING(),
    SET_INT('DamageOrCoinValue', 2),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bowser_body_anchor_loop'),
    END_LOOP(),
})

Register('bhvBowserFlameSpawn', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBowserFlameSpawn'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_MODEL(MODEL.NONE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bowser_flame_spawn_loop'),
    END_LOOP(),
})

Register('bhvExclamationBox', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvExclamationBox'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(exclamation_box_outline_seg8_collision_08025F78),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_FLOAT('CollisionDistance', 300),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_exclamation_box_loop'),
    END_LOOP(),
})

Register('bhvLeafParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvLeafParticleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_snow_leaf_particle_spawn_init'),
    DELAY(1),
    DEACTIVATE(),
});

Register('bhvTreeSnow', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvTreeSnow'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tree_snow_or_leaf_loop'),
    END_LOOP(),
});

Register('bhvTreeLeaf', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvTreeLeaf'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tree_snow_or_leaf_loop'),
    END_LOOP(),
})

Register('bhvRotatingExclamationMark', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvRotatingExclamationMark'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SCALE(--[[Unused]] 0, --[[Field]] 200),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_rotating_exclamation_box_loop'),
        ADD_INT(oMoveAngleYaw, 0x800),
    END_LOOP(),
})

Register('bhvSoundSpawner', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSoundSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    DELAY(3),
    CALL_NATIVE('bhv_sound_spawner_init'),
    DELAY(30),
    DEACTIVATE(),
})

-- Register('bhvMips', {
--     BEGIN(OBJ_LIST_GENACTOR, 'bhvMips'),
--     OR_INT('Flags', bit32.bor(OBJ_FLAG_HOLDABLE, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
--     LOAD_ANIMATIONS('Animations', mips_seg6_anims_06015634),
--     SET_INT('InteractType', INTERACT_GRABBABLE),
--     DROP_TO_FLOOR(),
--     SET_HITBOX(--[[Radius]] 50, --[[Height]] 75),
--     SET_INT('IntangibleTimer', 0),
--     CALL_NATIVE('bhv_mips_init'),
--     BEGIN_LOOP(),
--         CALL_NATIVE('bhv_mips_loop'),
--     END_LOOP(),
-- })

Register('bhvYellowBackgroundInMenu', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvYellowBackgroundInMenu'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('beh_yellow_background_menu_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('beh_yellow_background_menu_loop'),
    END_LOOP(),
})

Register('bhvYoshi', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvYoshi'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', yoshi_seg5_anims_05024100),
    SET_INTERACT_TYPE(INTERACT_TEXT),
    DROP_TO_FLOOR(),
    SET_HITBOX(--[[Radius]] 160, --[[Height]] 150),
    ANIMATE(0),
    SET_HOME(),
    CALL_NATIVE('bhv_yoshi_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_yoshi_loop'),
    END_LOOP(),
})

-- Register('bhvKoopa', {
--     BEGIN(OBJ_LIST_PUSHABLE, 'bhvKoopa'),
--     OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
--     DROP_TO_FLOOR(),
--     LOAD_ANIMATIONS('Animations', koopa_seg6_anims_06011364),
--     ANIMATE(9),
--     SET_HOME(),
--     SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 50, --[[Gravity]] -400, --[[Bounciness]] 0, --[[Drag strength]] 0, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
--     SCALE(--[[Unused]] 0, --[[Field]] 150),
--     SET_FLOAT(oKoopaAgility, 1),
--     CALL_NATIVE('bhv_koopa_init'),
--     BEGIN_LOOP(),
--         CALL_NATIVE('bhv_koopa_update'),
--     END_LOOP(),
-- })

-- Register('bhvKoopaRaceEndpoint', {
--     BEGIN(OBJ_LIST_DEFAULT, 'bhvKoopaRaceEndpoint'),
--     OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
--     DROP_TO_FLOOR(),
--     SPAWN_CHILD_WITH_PARAM(--[[Bhv param]] 0, --[[Model]] MODEL.KOOPA_FLAG, --[[Behavior]] bhvKoopaFlag),
--     BEGIN_LOOP(),
--         CALL_NATIVE('bhv_koopa_race_endpoint_update'),
--     END_LOOP(),
-- })

-- Register('bhvKoopaFlag', {
--     BEGIN(OBJ_LIST_POLELIKE, 'bhvKoopaFlag'),
--     SET_INTERACT_TYPE(INTERACT_POLE),
--     SET_HITBOX(--[[Radius]] 80, --[[Height]] 700),
--     SET_INT('IntangibleTimer', 0),
--     OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
--     DROP_TO_FLOOR(),
--     LOAD_ANIMATIONS('Animations', koopa_flag_seg6_anims_06001028),
--     ANIMATE(0),
--     BEGIN_LOOP(),
--         CALL_NATIVE('bhv_pole_base_loop'),
--     END_LOOP(),
-- })

Register('bhvWaterBombCannon', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvWaterBombCannon'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_water_bomb_cannon_loop'),
    END_LOOP(),
})

Register('bhvAnimatesOnFloorSwitchPress', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvAnimatesOnFloorSwitchPress'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_FLOAT('CollisionDistance', 8000),
    CALL_NATIVE('bhv_animates_on_floor_switch_press_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_animates_on_floor_switch_press_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvActivatedBackAndForthPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvActivatedBackAndForthPlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    CALL_NATIVE('bhv_activated_back_and_forth_platform_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_activated_back_and_forth_platform_update'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvRecoveryHeart', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvRecoveryHeart'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_recovery_heart_loop'),
    END_LOOP(),
})

Register('bhvCannonBarrelBubbles', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvCannonBarrelBubbles'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bubble_cannon_barrel_loop'),
    END_LOOP(),
})

Register('bhvCelebrationStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvCelebrationStar'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    CALL_NATIVE('bhv_celebration_star_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_celebration_star_loop'),
    END_LOOP(),
})

Register('bhvCelebrationStarSparkle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvCelebrationStarSparkle'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_FLOAT('GraphYOffset', 25),
    SET_INT('AnimState', -1),
    BEGIN_LOOP(),
        ADD_INT('AnimState', 1),
        CALL_NATIVE('bhv_celebration_star_sparkle_loop'),
    END_LOOP(),
})

Register('bhvStarKeyCollectionPuffSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvStarKeyCollectionPuffSpawner'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('AnimState', -1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_star_key_collection_puff_spawner_loop'),
    END_LOOP(),
})

Register('bhvPitBowlingBall', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvPitBowlingBall'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_FLOAT('GraphYOffset', 130),
    CALL_NATIVE('bhv_bob_pit_bowling_ball_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bob_pit_bowling_ball_loop'),
    END_LOOP(),
})

Register('bhvFreeBowlingBall', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvFreeBowlingBall'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_FLOAT('GraphYOffset', 130),
    CALL_NATIVE('bhv_free_bowling_ball_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_free_bowling_ball_loop'),
    END_LOOP(),
})

Register('bhvBowlingBall', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBowlingBall'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_FLOAT('GraphYOffset', 130),
    CALL_NATIVE('bhv_bowling_ball_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bowling_ball_loop'),
    END_LOOP(),
})

Register('bhvTtmBowlingBallSpawner', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvTtmBowlingBallSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT(oBBallSpawnerPeriodMinus1, 63),
    CALL_NATIVE('bhv_generic_bowling_ball_spawner_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_generic_bowling_ball_spawner_loop'),
    END_LOOP(),
})

Register('bhvBobBowlingBallSpawner', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBobBowlingBallSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT(oBBallSpawnerPeriodMinus1, 127),
    CALL_NATIVE('bhv_generic_bowling_ball_spawner_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_generic_bowling_ball_spawner_loop'),
    END_LOOP(),
})

Register('bhvTHIBowlingBallSpawner', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvTHIBowlingBallSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_thi_bowling_ball_spawner_loop'),
    END_LOOP(),
})

Register('bhvFloorSwitchHardcodedModel', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvFloorSwitchHardcodedModel'),
    -- Floor switch - common:
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(purple_switch_seg8_collision_0800C7A8),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_purple_switch_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvFloorSwitchAnimatesObject', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvFloorSwitchAnimatesObject'),
    SET_INT('BehParams2ndByte', 1),
    GOTO('bhvFloorSwitchHardcodedModel', 1),
})

Register('bhvBreakableBox', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBreakableBox'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(breakable_box_seg8_collision_08012D70),
    SET_FLOAT('CollisionDistance', 500),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_breakable_box_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
    BREAK(),
})

Register('bhvBreakableBoxSmall', {
    BEGIN(OBJ_LIST_DESTRUCTIVE, 'bhvBreakableBoxSmall'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    SET_HOME(),
    CALL_NATIVE('bhv_breakable_box_small_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_breakable_box_small_loop'),
    END_LOOP(),
})

Register('bhvBitfsSinkingPlatforms', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBitfsSinkingPlatforms'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(bitfs_seg7_collision_sinking_platform),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bitfs_sinking_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvArrowLift', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvArrowList'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(wdw_seg7_collision_arrow_lift),
    SET_INT_RAND_RSHIFT(oArrowLiftUnk100, 1, 32),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_arrow_lift_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvOrangeNumber', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvOrangeNumber'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_HOME(),
    CALL_NATIVE('bhv_orange_number_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_orange_number_loop'),
    END_LOOP(),
})

Register('bhvDddMovingPole', {
    BEGIN(OBJ_LIST_POLELIKE, 'bhvDddMovingPole'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('InteractType', INTERACT_POLE),
    SET_HITBOX(--[[Radius]] 80, --[[Height]] 710),
    SET_INT('IntangibleTimer', 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_ddd_moving_pole_loop'),
        CALL_NATIVE('bhv_pole_base_loop'),
    END_LOOP(),
})

Register('bhvBitfsSinkingCagePlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBitfsSinkingCagePlatform'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(bitfs_seg7_collision_sinking_cage_platform),
    SET_HOME(),
    SPAWN_CHILD(--[[Model]] MODEL.BITFS_BLUE_POLE, --[[Behavior]] bhvDddMovingPole),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bitfs_sinking_cage_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvBitfsTiltingInvertedPyramid', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBitfsTiltingInvertedPyramid'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(bitfs_seg7_collision_inverted_pyramid),
    SET_HOME(),
    CALL_NATIVE('bhv_platform_normals_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_tilting_inverted_pyramid_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvSquishablePlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvSquishablePlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(bitfs_seg7_collision_squishable_platform),
    SET_FLOAT('CollisionDistance', 10000),
    CALL_NATIVE('bhv_platform_normals_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_squishable_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvFlamethrower', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvFlamethrower'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_flamethrower_loop'),
    END_LOOP(),
})

Register('bhvFlamethrowerFlame', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvFlamethrowerFlame'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INTERACT_TYPE(INTERACT_FLAME),
    SET_HITBOX_WITH_OFFSET(--[[Radius]] 50, --[[Height]] 25, --[[Downwards offset]] 25),
    BILLBOARD(),
    SET_HOME(),
    SET_INT('IntangibleTimer', 0),
    --CALL_NATIVE(bhv_init_room),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_flamethrower_flame_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvJumpingBox', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvJumpingBox'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_HOLDABLE, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 30, --[[Gravity]] -400, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 600, --[[Unused]] 0, 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_jumping_box_loop'),
    END_LOOP(),
})

Register('bhvSmoke', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSmoke'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_INT('AnimState', -1),
    DELAY(1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_dust_smoke_loop'),
        ADD_INT('AnimState', 1),
    END_LOOP(),
})

Register('bhvBobombExplosionBubble', {
	BEGIN(OBJ_LIST_DEFAULT, 'bhvBobombExplosionBubble'),
	BILLBOARD(),
	OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
	CALL_NATIVE('bhv_bobomb_explosion_bubble_init'),
	ADD_RANDOM_FLOAT('PosX', --[[Minimum]] -50, --[[Range]] 100),
	ADD_RANDOM_FLOAT('PosY', --[[Minimum]] -50, --[[Range]] 100),
	ADD_RANDOM_FLOAT('PosZ', --[[Minimum]] -50, --[[Range]] 100),
	CALL('bhvBobombExplosionBubble3600'),
	DELAY(1),
	BEGIN_LOOP(),
		CALL('bhvBobombExplosionBubble3600'),
		CALL_NATIVE('bhv_bobomb_explosion_bubble_loop'),
	END_LOOP(),
})

Register('bhvBobombExplosionBubble3600', {
	ADD_RANDOM_FLOAT('PosX', --[[Minimum]] -2, --[[Range]] 4),
	ADD_RANDOM_FLOAT('PosZ', --[[Minimum]] -2, --[[Range]] 4),
	RETURN(),
})

Register('bhvFireParticleSpawner', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvFireParticleSpawner'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BILLBOARD(),
    SET_FLOAT('GraphYOffset', 70),
    SET_INT('AnimState', -1),
    BEGIN_LOOP(),
        ADD_INT('AnimState', 1),
        CALL_NATIVE('bhv_flame_mario_loop'),
    END_LOOP(),
})

Register('bhvBlackSmokeMario', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvBlackSmokeMario'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_INT('AnimState', 4),
    SET_FLOAT('GraphYOffset', 50),
    BEGIN_REPEAT(8),
        CALL_NATIVE('bhv_black_smoke_mario_loop'),
        DELAY(1),
        CALL_NATIVE('bhv_black_smoke_mario_loop'),
        DELAY(1),
        CALL_NATIVE('bhv_black_smoke_mario_loop'),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvBlackSmokeBowser', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvBlackSmokeBowser'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_MOVE_XZ_USING_FVEL, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    BILLBOARD(),
    SET_FLOAT('GraphYOffset', 0),
    BEGIN_REPEAT(8),
        CALL_NATIVE('bhv_black_smoke_bowser_loop'),
        ANIMATE_TEXTURE('AnimState', 4),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvSquarishPathMoving', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvSquarishPathMoving'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(bitdw_seg7_collision_moving_pyramid),
    SET_HOME(),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_squarish_path_moving_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvUnlockDoorStar', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvUnlockDoorStar'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('MarioMisc.bhv_unlock_door_star_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('MarioMisc.bhv_unlock_door_star_loop'),
    END_LOOP(),
})

Register('bhvInstantActiveWarp', {
    BREAK(),
})

Register('bhvAirborneWarp', {
    BREAK(),
})

Register('bhvHardAirKnockBackWarp', {
    BREAK(),
})

Register('bhvSpinAirborneCircleWarp', {
    BREAK(),
})

Register('bhvDeathWarp', {
    BREAK(),
})

Register('bhvSpinAirborneWarp', {
    BREAK(),
})

Register('bhvFlyingWarp', {
    BREAK(),
})

Register('bhvPaintingStarCollectWarp', {
    BREAK(),
})

Register('bhvPaintingDeathWarp', {
    BREAK(),
})

Register('bhvAirborneDeathWarp', {
    BREAK(),
})

Register('bhvAirborneStarCollectWarp', {
    BREAK(),
})

Register('bhvLaunchStarCollectWarp', {
    BREAK(),
})

Register('bhvLaunchDeathWarp', {
    BREAK(),
})

Register('bhvSwimmingWarp', {
    BREAK(),
})

Register('bhvSparkle', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSparkle'),
    BILLBOARD(),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_INT('AnimState', -1),
    BEGIN_REPEAT(9),
        ADD_INT('AnimState', 1),
    END_REPEAT(),
    DEACTIVATE(),
})

Register('bhvSparkleSpawn', {
    BEGIN(OBJ_LIST_UNIMPORTANT, 'bhvSparkleSpawn'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_sparkle_spawn_loop'),
    END_LOOP(),
})

Register('bhvTripletButterfly', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvTripletButterfly'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', butterfly_seg3_anims_030056B0),
    ANIMATE(0),
    HIDE(),
    SET_HOME(),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 0, --[[Gravity]] 0, --[[Bounciness]] 0, --[[Drag strength]] 0, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_FLOAT(oTripletButterflyScale, 1),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_triplet_butterfly_update'),
    END_LOOP(),
})

Register('bhvDddWarp', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvDddWarp'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    SET_FLOAT('CollisionDistance', 30000),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_ddd_warp_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvRockSolid', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvRockSolid'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(jrb_seg7_collision_rock_solid),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvPillarBase', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvPillarBase'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(jrb_seg7_collision_pillar_base),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvInvisibleObjectsUnderBridge', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvInvisibleObjectsUnderBridge'),
    CALL_NATIVE('bhv_invisible_objects_under_bridge_init'),
    BREAK(),
})

Register('bhvWaterLevelPillar', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvWaterLevelPillar'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(inside_castle_seg7_collision_water_level_pillar),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvHiddenStaircaseStep', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvHiddenStaircaseStep'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(bbh_seg7_collision_staircase_step),
    BEGIN_LOOP(),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvMenuButtonManager', {
    BEGIN(OBJ_LIST_LEVEL, 'bhvMenuButtonManager'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM, OBJ_FLAG_0020, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_menu_button_manager_init'),
    BEGIN_LOOP(),
        SET_INT('IntangibleTimer', 0),
        CALL_NATIVE('bhv_menu_button_manager_loop'),
    END_LOOP(),
})

Register('bhvHauntedChair', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvHauntedChair'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    LOAD_ANIMATIONS('Animations', chair_seg5_anims_05005784),
    ANIMATE(0),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 40, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_HOME(),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('bhv_haunted_chair_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_haunted_chair_loop'),
    END_LOOP(),
})

Register('bhvMadPiano', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvMadPiano'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    DROP_TO_FLOOR(),
    LOAD_ANIMATIONS('Animations', mad_piano_seg5_anims_05009B14),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 40, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_HOME(),
    ADD_INT(oMoveAngleYaw, 0x4000),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_mad_piano_update'),
    END_LOOP(),
})

Register('bhvBbhTiltingTrapPlatform', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvBbhTiltingTrapPlatform'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(bbh_seg7_collision_tilt_floor_platform),
    SET_HOME(),
    SET_INT(oRoom, 2),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bbh_tilting_trap_platform_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvHauntedBookshelf', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvHauntedBookshelf'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(bbh_seg7_collision_haunted_bookshelf),
    SET_HOME(),
    SET_INT(oRoom, 6),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_haunted_bookshelf_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvMeshElevator', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvMeshElevator'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_COLLISION_DATA(bbh_seg7_collision_mesh_elevator),
    SET_HOME(),
    SET_INT(oRoom, 12),
    SET_INT('BehParams2ndByte', 4),
    CALL_NATIVE('bhv_elevator_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_elevator_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvFlyingBookend', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvFlyingBookend'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', bookend_seg5_anims_05002540),
    ANIMATE(0),
    SET_OBJ_PHYSICS(--[[Wall hitbox radius]] 60, --[[Gravity]] 0, --[[Bounciness]] -50, --[[Drag strength]] 1000, --[[Friction]] 1000, --[[Buoyancy]] 200, --[[Unused]] 0, 0),
    SET_INT(oMoveFlags, 0),
    SCALE(--[[Unused]] 0, --[[Field]] 70),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_flying_bookend_loop'),
    END_LOOP(),
})

Register('bhvBookendSpawn', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBookendSpawn'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_bookend_spawn_loop'),
    END_LOOP(),
})

Register('bhvHauntedBookshelfManager', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvHauntedBookshelfManager'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_haunted_bookshelf_manager_loop'),
    END_LOOP(),
})

Register('bhvBookSwitch', {
    BEGIN(OBJ_LIST_GENACTOR, 'bhvBookSwitch'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    SET_HOME(),
    SET_FLOAT('GraphYOffset', 30),
    ADD_INT(oMoveAngleYaw, 0x4000),
    CALL_NATIVE('bhv_init_room'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_book_switch_loop'),
    END_LOOP(),
})

Register('bhvMerryGoRound', {
    BEGIN(OBJ_LIST_SURFACE, 'bhvMerryGoRound'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_COLLISION_DATA(bbh_seg7_collision_merry_go_round),
    SET_FLOAT('CollisionDistance', 2000),
    SET_INT(oRoom, 10),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_merry_go_round_loop'),
        CALL_NATIVE('SurfaceLoad.load_object_collision_model'),
    END_LOOP(),
})

Register('bhvBeginningPeach', {
    BEGIN(OBJ_LIST_DEFAULT),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_ANIMATIONS('Animations', peach_seg5_anims_0501C41C),
    ANIMATE(0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_intro_peach_loop'),
    END_LOOP(),
})

Register('bhvBeginningLakitu', {
    BEGIN(OBJ_LIST_DEFAULT),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    LOAD_ANIMATIONS('Animations', lakitu_seg6_anims_060058F8),
    ANIMATE(0),
    SET_FLOAT(oOpacity, 0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_intro_lakitu_loop'),
    END_LOOP(),
})

Register('bhvEndBirds1', {
    BEGIN(OBJ_LIST_DEFAULT),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', birds_seg5_anims_050009E8),
    ANIMATE(0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_end_birds_1_loop'),
    END_LOOP(),
});

Register('bhvEndBirds2', {
    BEGIN(OBJ_LIST_DEFAULT),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', birds_seg5_anims_050009E8),
    ANIMATE(0),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_end_birds_2_loop'),
    END_LOOP(),
});

Register('bhvToadMessage', {
    -- it works, but toads are invisible, and currently softlock you
    -- (due to bugged dialog systems)
    BEGIN(OBJ_LIST_GENACTOR, 'bhvToadMessage'),
    OR_INT('Flags', bit32.bor(OBJ_FLAG_PERSISTENT_RESPAWN, OBJ_FLAG_COMPUTE_DIST_TO_MARIO, OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW, OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)),
    LOAD_ANIMATIONS('Animations', toad_seg6_anims_0600FB58),
    ANIMATE(6),
    SET_INTERACT_TYPE(INTERACT_TEXT),
    SET_HITBOX(--[[Radius]] 80, --[[Height]] 100),
    SET_INT('IntangibleTimer', 0),
    CALL_NATIVE('bhv_init_room'),
    CALL_NATIVE('MarioMisc.bhv_toad_message_init'),
    BEGIN_LOOP(),
        CALL_NATIVE('MarioMisc.bhv_toad_message_loop'),
    END_LOOP(),
})

Register('bhvBirdsSoundLoop', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvBirdsSoundLoop'),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_birds_sound_loop'),
    END_LOOP(),
    BREAK(),
})

Register('bhvAmbientSounds', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvAmbientSounds'),
    CALL_NATIVE('bhv_ambient_sounds_init'),
    BEGIN_LOOP(),
    END_LOOP(),
});

Register('bhvWaterfallSoundLoop', {
    BREAK(),
})

Register('bhvIntroScene', {
    BEGIN(OBJ_LIST_DEFAULT, 'bhvIntroScene'),
    OR_INT('Flags', OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE),
    BEGIN_LOOP(),
        CALL_NATIVE('bhv_intro_scene_loop'),
    END_LOOP(),
});
