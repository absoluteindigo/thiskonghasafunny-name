-- https://github.com/sm64js/sm64js/blob/04c1a984117ebb8d0e7b0d5d2e3424367f69b92d/src/include/ObjectConstants.js#L4

--[[export const]] RESPAWN_INFO_DONT_RESPAWN = 0xFF

--[[export const]] RESPAWN_INFO_TYPE_NULL = 0
--[[export const]] RESPAWN_INFO_TYPE_32   = 1
--[[export const]] RESPAWN_INFO_TYPE_16   = 2

--[[export const]] ACTIVE_FLAG_DEACTIVATED            =  0         -- 0x0000
--[[export const]] ACTIVE_FLAG_ACTIVE                 =  bit32.lshift(1,  0) -- 0x0001
--[[export const]] ACTIVE_FLAG_FAR_AWAY               =  bit32.lshift(1,  1) -- 0x0002
--[[export const]] ACTIVE_FLAG_UNK2                   =  bit32.lshift(1,  2) -- 0x0004
--[[export const]] ACTIVE_FLAG_IN_DIFFERENT_ROOM      =  bit32.lshift(1,  3) -- 0x0008
--[[export const]] ACTIVE_FLAG_UNIMPORTANT            =  bit32.lshift(1,  4) -- 0x0010
--[[export const]] ACTIVE_FLAG_INITIATED_TIME_STOP    =  bit32.lshift(1,  5) -- 0x0020
--[[export const]] ACTIVE_FLAG_MOVE_THROUGH_GRATE     =  bit32.lshift(1,  6) -- 0x0040
--[[export const]] ACTIVE_FLAG_DITHERED_ALPHA         =  bit32.lshift(1,  7) -- 0x0080
--[[export const]] ACTIVE_FLAG_UNK8                   =  bit32.lshift(1,  8) -- 0x0100
--[[export const]] ACTIVE_FLAG_UNK9                   =  bit32.lshift(1,  9) -- 0x0200
--[[export const]] ACTIVE_FLAG_UNK10                  =  bit32.lshift(1, 10) -- 0x0400

--[[export const]] ACTIVE_FLAGS_DEACTIVATED = 0

--[[ oAction ]]
--[[export const]] OBJ_ACT_LAVA_DEATH = 100
--[[export const]] OBJ_ACT_DEATH_PLANE_DEATH = 101

--[[export const]] OBJ_ACT_HORIZONTAL_KNOCKBACK = 100
--[[export const]] OBJ_ACT_VERTICAL_KNOCKBACK = 101
--[[export const]] OBJ_ACT_SQUISHED = 102

--[[ oMoveFlags ]]
--[[export const]] OBJ_MOVE_LANDED  = bit32.lshift(1, 0) -- 0x0001
--[[export const]] OBJ_MOVE_ON_GROUND  = bit32.lshift(1, 1) -- 0x0002  -- mutually exclusive to OBJ_MOVE_LANDED
--[[export const]] OBJ_MOVE_LEFT_GROUND  = bit32.lshift(1, 2) -- 0x0004
--[[export const]] OBJ_MOVE_ENTERED_WATER  = bit32.lshift(1, 3) -- 0x0008
--[[export const]] OBJ_MOVE_AT_WATER_SURFACE  = bit32.lshift(1, 4) -- 0x0010
--[[export const]] OBJ_MOVE_UNDERWATER_OFF_GROUND  = bit32.lshift(1, 5) -- 0x0020
--[[export const]] OBJ_MOVE_UNDERWATER_ON_GROUND  = bit32.lshift(1, 6) -- 0x0040
--[[export const]] OBJ_MOVE_IN_AIR  = bit32.lshift(1, 7) -- 0x0080
--[[export const]] OBJ_MOVE_8  = bit32.lshift(1, 8) -- 0x0100
--[[export const]] OBJ_MOVE_HIT_WALL  = bit32.lshift(1, 9) -- 0x0200
--[[export const]] OBJ_MOVE_HIT_EDGE  = bit32.lshift(1, 10) -- 0x0400
--[[export const]] OBJ_MOVE_ABOVE_LAVA  = bit32.lshift(1, 11) -- 0x0800
--[[export const]] OBJ_MOVE_LEAVING_WATER  = bit32.lshift(1, 12) -- 0x1000
--[[export const]] OBJ_MOVE_BOUNCE  = bit32.lshift(1, 13) -- 0x2000
--[[export const]] OBJ_MOVE_ABOVE_DEATH_BARRIER = bit32.lshift(1, 14) -- 0x4000

--[[export const]] OBJ_MOVE_MASK_ON_GROUND = bit32.bor(OBJ_MOVE_LANDED, OBJ_MOVE_ON_GROUND)
--[[export const]] OBJ_MOVE_MASK_33 =  0x33
--[[export const]] OBJ_MOVE_MASK_IN_WATER = bit32.bor(OBJ_MOVE_ENTERED_WATER, OBJ_MOVE_AT_WATER_SURFACE, OBJ_MOVE_UNDERWATER_OFF_GROUND, OBJ_MOVE_UNDERWATER_ON_GROUND)
--[[export const]] OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER = bit32.bor(OBJ_MOVE_HIT_WALL, OBJ_MOVE_MASK_IN_WATER)
--[[export const]] OBJ_MOVE_MASK_NOT_AIR = bit32.bor( OBJ_MOVE_LANDED, OBJ_MOVE_ON_GROUND, OBJ_MOVE_AT_WATER_SURFACE, OBJ_MOVE_UNDERWATER_ON_GROUND)

--[[ oFlags ]]
--[[export const]] OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE        =  bit32.lshift(1,  0) -- 0x00000001
--[[export const]] OBJ_FLAG_MOVE_XZ_USING_FVEL              =  bit32.lshift(1,  1) -- 0x00000002
--[[export const]] OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL        =  bit32.lshift(1,  2) -- 0x00000004
--[[export const]] OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW        =  bit32.lshift(1,  3) -- 0x00000008
--[[export const]] OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE    =  bit32.lshift(1,  4) -- 0x00000010
--[[export const]] OBJ_FLAG_0020                            =  bit32.lshift(1,  5) -- 0x00000020
--[[export const]] OBJ_FLAG_COMPUTE_DIST_TO_MARIO           =  bit32.lshift(1,  6) -- 0x00000040
--[[export const]] OBJ_FLAG_ACTIVE_FROM_AFAR                =  bit32.lshift(1,  7) -- 0x00000080
--[[export const]] OBJ_FLAG_0100                            =  bit32.lshift(1,  8) -- 0x00000100
--[[export const]] OBJ_FLAG_TRANSFORM_RELATIVE_TO_PARENT    =  bit32.lshift(1,  9) -- 0x00000200
--[[export const]] OBJ_FLAG_HOLDABLE                        =  bit32.lshift(1, 10) -- 0x00000400
--[[export const]] OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM =  bit32.lshift(1, 11) -- 0x00000800
--[[export const]] OBJ_FLAG_1000                            =  bit32.lshift(1, 12) -- 0x00001000
--[[export const]] OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO          =  bit32.lshift(1, 13) -- 0x00002000
--[[export const]] OBJ_FLAG_PERSISTENT_RESPAWN              =  bit32.lshift(1, 14) -- 0x00004000
--[[export const]] OBJ_FLAG_8000                            =  bit32.lshift(1, 15) -- 0x00008000
--[[export const]] OBJ_FLAG_30 = bit32.lshift(1, 30) -- 0x40000000


--[[ oActiveParticleFlags ]]
--[[export const]] ACTIVE_PARTICLE_DUST                  = bit32.lshift(1, 0) -- 0x00000001
--[[export const]] ACTIVE_PARTICLE_UNUSED_1              = bit32.lshift(1, 1) -- 0x00000002
--[[export const]] ACTIVE_PARTICLE_UNUSED_2              = bit32.lshift(1, 2) -- 0x00000004
--[[export const]] ACTIVE_PARTICLE_SPARKLES              = bit32.lshift(1, 3) -- 0x00000008
--[[export const]] ACTIVE_PARTICLE_H_STAR                = bit32.lshift(1, 4) -- 0x00000010
--[[export const]] ACTIVE_PARTICLE_BUBBLE                = bit32.lshift(1, 5) -- 0x00000020
--[[export const]] ACTIVE_PARTICLE_WATER_SPLASH          = bit32.lshift(1, 6) -- 0x00000040
--[[export const]] ACTIVE_PARTICLE_IDLE_WATER_WAVE       = bit32.lshift(1, 7) -- 0x00000080
--[[export const]] ACTIVE_PARTICLE_SHALLOW_WATER_WAVE    = bit32.lshift(1, 8) -- 0x00000100
--[[export const]] ACTIVE_PARTICLE_PLUNGE_BUBBLE         = bit32.lshift(1, 9) -- 0x00000200
--[[export const]] ACTIVE_PARTICLE_WAVE_TRAIL            = bit32.lshift(1, 10) -- 0x00000400
--[[export const]] ACTIVE_PARTICLE_FIRE                  = bit32.lshift(1, 11) -- 0x00000800
--[[export const]] ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH  = bit32.lshift(1, 12) -- 0x00001000
--[[export const]] ACTIVE_PARTICLE_LEAF                  = bit32.lshift(1, 13) -- 0x00002000
--[[export const]] ACTIVE_PARTICLE_DIRT                  = bit32.lshift(1, 14) -- 0x00004000
--[[export const]] ACTIVE_PARTICLE_MIST_CIRCLE           = bit32.lshift(1, 15) -- 0x00008000
--[[export const]] ACTIVE_PARTICLE_SNOW                  = bit32.lshift(1, 16) -- 0x00010000
--[[export const]] ACTIVE_PARTICLE_BREATH                = bit32.lshift(1, 17) -- 0x00020000
--[[export const]] ACTIVE_PARTICLE_V_STAR                = bit32.lshift(1, 18) -- 0x00040000
--[[export const]] ACTIVE_PARTICLE_TRIANGLE              = bit32.lshift(1, 19) -- 0x00080000

--[[ Star Index ]]
--[[export const]] STAR_INDEX_ACT_1     = 0
--[[export const]] STAR_INDEX_ACT_2     = 1
--[[export const]] STAR_INDEX_ACT_3     = 2
--[[export const]] STAR_INDEX_ACT_4     = 3
--[[export const]] STAR_INDEX_ACT_5     = 4
--[[export const]] STAR_INDEX_ACT_6     = 5
--[[export const]] STAR_INDEX_100_COINS = 6

--[[ oHeldState ]]
--[[export const]] HELD_FREE = 0
--[[export const]] HELD_HELD = 1
--[[export const]] HELD_THROWN = 2
--[[export const]] HELD_DROPPED = 3

--[[ oDialogState ]]
--[[export const]] DIALOG_STATUS_ENABLE_TIME_STOP  = 0
--[[export const]] DIALOG_STATUS_INTERRUPT         = 1
--[[export const]] DIALOG_STATUS_START_DIALOG      = 2
--[[export const]] DIALOG_STATUS_STOP_DIALOG       = 3
--[[export const]] DIALOG_STATUS_DISABLE_TIME_STOP = 4

--[[export const]] DIALOG_FLAG_NONE              = 0
--[[export const]] DIALOG_FLAG_TURN_TO_MARIO     = bit32.lshift(1, 0) -- 0x01 -- cutscene only
--[[export const]] DIALOG_FLAG_TEXT_DEFAULT      = bit32.lshift(1, 1) -- 0x02
--[[export const]] DIALOG_FLAG_TEXT_RESPONSE     = bit32.lshift(1, 2) -- 0x04 -- non-cutscene only
--[[export const]] DIALOG_FLAG_UNK_CAPSWITCH     = bit32.lshift(1, 3) -- 0x08 -- not defined
--[[export const]] DIALOG_FLAG_TIME_STOP_ENABLED = bit32.lshift(1, 4) -- 0x10

--[[export const]] oFlags                       = 0x01
--[[export const]] oDialogResponse              = 0x02
--[[export const]] oDialogState                 = 0x02
--[[export const]] oUnk94                       = 0x03
--[[export const]] oIntangibleTimer             = 0x05
--[[export const]] O_POS_INDEX                  = 0x06
--[[export const]] oPosX                        = O_POS_INDEX + 0
--[[export const]] oPosY                        = O_POS_INDEX + 1
--[[export const]] oPosZ                        = O_POS_INDEX + 2
--[[export const]] oVelX                        = 0x09
--[[export const]] oVelY                        = 0x0A
--[[export const]] oVelZ                        = 0x0B
--[[export const]] oForwardVel                  = 0x0C
--[[export const]] oForwardVelS32               = 0x0C
--[[export const]] oUnkBC                       = 0x0D
--[[export const]] oUnkC0                       = 0x0E
--[[export const]] O_MOVE_ANGLE_INDEX           = 0x0F
--[[export const]] O_MOVE_ANGLE_PITCH_INDEX     = O_MOVE_ANGLE_INDEX + 0
--[[export const]] O_MOVE_ANGLE_YAW_INDEX       = O_MOVE_ANGLE_INDEX + 1
--[[export const]] O_MOVE_ANGLE_ROLL_INDEX      = O_MOVE_ANGLE_INDEX + 2
--[[export const]] oMoveAnglePitch              = O_MOVE_ANGLE_PITCH_INDEX
--[[export const]] oMoveAngleYaw                = O_MOVE_ANGLE_YAW_INDEX
--[[export const]] oMoveAngleRoll               = O_MOVE_ANGLE_ROLL_INDEX
--[[export const]] O_FACE_ANGLE_INDEX           = 0x12
--[[export const]] O_FACE_ANGLE_PITCH_INDEX     = O_FACE_ANGLE_INDEX + 0
--[[export const]] O_FACE_ANGLE_YAW_INDEX       = O_FACE_ANGLE_INDEX + 1
--[[export const]] O_FACE_ANGLE_ROLL_INDEX      = O_FACE_ANGLE_INDEX + 2
--[[export const]] oFaceAnglePitch              = O_FACE_ANGLE_PITCH_INDEX
--[[export const]] oFaceAngleYaw                = O_FACE_ANGLE_YAW_INDEX
--[[export const]] oFaceAngleRoll               = O_FACE_ANGLE_ROLL_INDEX
--[[export const]] oGraphYOffset                = 0x15
--[[export const]] oActiveParticleFlags         = 0x16
--[[export const]] oGravity                     = 0x17
--[[export const]] oFloorHeight                 = 0x18
--[[export const]] oMoveFlags                   = 0x19
--[[export const]] oAnimState                   = 0x1A
--[[export const]] oAngleVelPitch               = 0x23
--[[export const]] oAngleVelYaw                 = 0x24
--[[export const]] oAngleVelRoll                = 0x25
--[[export const]] oAnimations                  = 0x26
--[[export const]] oHeldState                   = 0x27
--[[export const]] oWallHitboxRadius            = 0x28
--[[export const]] oDragStrength                = 0x29
--[[export const]] oInteractType                = 0x2A
--[[export const]] oInteractStatus              = 0x2B
--[[export const]] O_PARENT_RELATIVE_POS_INDEX  = 0x2C
--[[export const]] oParentRelativePosX          = O_PARENT_RELATIVE_POS_INDEX + 0
--[[export const]] oParentRelativePosY          = O_PARENT_RELATIVE_POS_INDEX + 1
--[[export const]] oParentRelativePosZ          = O_PARENT_RELATIVE_POS_INDEX + 2
--[[export const]] oBhvParams2ndByte            = 0x2F
--[[export const]] oAction                      = 0x31
--[[export const]] oSubAction                   = 0x32
--[[export const]] oTimer                       = 0x33
--[[export const]] oBounciness                  = 0x34
--[[export const]] oDistanceToMario             = 0x35
--[[export const]] oAngleToMario                = 0x36
--[[export const]] oHomeX                       = 0x37
--[[export const]] oHomeY                       = 0x38
--[[export const]] oHomeZ                       = 0x39
--[[export const]] oFriction                    = 0x3A
--[[export const]] oBuoyancy                    = 0x3B
--[[export const]] oSoundStateID                = 0x3C
--[[export const]] oOpacity                     = 0x3D
--[[export const]] oDamageOrCoinValue           = 0x3E
--[[export const]] oHealth                      = 0x3F
--[[export const]] oBhvParams                   = 0x40
--[[export const]] oPrevAction                  = 0x41
--[[export const]] oInteractionSubtype          = 0x42
--[[export const]] oCollisionDistance           = 0x43
--[[export const]] oNumLootCoins                = 0x44
--[[export const]] oDrawingDistance             = 0x45
--[[export const]] oRoom                        = 0x46
--[[export const]] oUnk1A8                      = 0x48
--[[export const]] oWallAngle                   = 0x4B
--[[export const]] oFloorType                   = 0x4C
--[[export const]] oFloorRoom                   = 0x4C
--[[export const]] oAngleToHome                 = 0x4D
--[[export const]] oFloor                       = 0x4E
--[[export const]] oDeathSound                  = 0x4F

--[[ Pathed (see obj_follow_path) ]]
--[[export const]] oPathedStartWaypoint      = 0x1D
--[[export const]] oPathedPrevWaypoint       = 0x1E
--[[export const]] oPathedPrevWaypointFlags  = 0x1F
--[[export const]] oPathedTargetPitch        = 0x20
--[[export const]] oPathedTargetYaw          = 0x21

--[[ Special Object Macro ]]
--[[export const]] oMacroUnk108  = 0x20
--[[export const]] oMacroUnk10C  = 0x21
--[[export const]] oMacroUnk110  = 0x22

--[[ Mario ]]
--[[export const]] oMarioParticleFlags     = 0x1B
--[[export const]] oMarioPoleUnk108        = 0x20
--[[export const]] oMarioReadingSignDYaw   = 0x20
--[[export const]] oMarioPoleYawVel        = 0x21
--[[export const]] oMarioCannonObjectYaw   = 0x21
--[[export const]] oMarioTornadoYawVel     = 0x21
--[[export const]] oMarioReadingSignDPosX  = 0x21
--[[export const]] oMarioPolePos           = 0x22
--[[export const]] oMarioCannonInputYaw    = 0x22
--[[export const]] oMarioTornadoPosY       = 0x22
--[[export const]] oMarioReadingSignDPosZ  = 0x22
--[[export const]] oMarioWhirlpoolPosY     = 0x22
--[[export const]] oMarioBurnTimer         = 0x22
--[[export const]] oMarioLongJumpIsSlow    = 0x22
--[[export const]] oMarioSteepJumpYaw      = 0x22
--[[export const]] oMarioWalkingPitch      = 0x22

--[[ 1-Up Hidden ]]
--[[export const]] o1UpHiddenUnkF4  = 0x1B

--[[ Activated Back and Forth Platform ]]
--[[export const]] oActivatedBackAndForthPlatformMaxOffset     = 0x1B
--[[export const]] oActivatedBackAndForthPlatformOffset        = 0x1C
--[[export const]] oActivatedBackAndForthPlatformVel           = 0x1D
--[[export const]] oActivatedBackAndForthPlatformCountdown     = 0x1E
--[[export const]] oActivatedBackAndForthPlatformStartYaw      = 0x1F
--[[export const]] oActivatedBackAndForthPlatformVertical      = 0x20
--[[export const]] oActivatedBackAndForthPlatformFlipRotation  = 0x21

--[[ Amp ]]
--[[export const]] oAmpRadiusOfRotation  = 0x1B
--[[export const]] oAmpYPhase            = 0x1C

--[[export const]] AMP_BP_ROT_RADIUS_200 = 0
--[[export const]] AMP_BP_ROT_RADIUS_300 = 1
--[[export const]] AMP_BP_ROT_RADIUS_400 = 2
--[[export const]] AMP_BP_ROT_RADIUS_0 = 3

--[[export const]] AMP_ACT_IDLE = 2
--[[export const]] AMP_ACT_ATTACK_COOLDOWN = 4

--[[ Homing Amp ]]
--[[export const]] oHomingAmpLockedOn  = 0x1B
--[[export const]] oHomingAmpAvgY      = 0x1D

--[[export const]] HOMING_AMP_ACT_INACTIVE = 0
--[[export const]] HOMING_AMP_ACT_APPEAR = 1
--[[export const]] HOMING_AMP_ACT_CHASE = 2
--[[export const]] HOMING_AMP_ACT_GIVE_UP = 3
--[[export const]] HOMING_AMP_ACT_ATTACK_COOLDOWN = 4

--[[ Bully (all variants) ]]
--[[ oBhvParams2ndByte ]]
--[[export const]] BULLY_BP_SIZE_SMALL = 0
--[[export const]] BULLY_BP_SIZE_BIG   = 1

--[[ oAction ]]
--[[export const]] BULLY_ACT_PATROL              = 0
--[[export const]] BULLY_ACT_CHASE_MARIO         = 1
--[[export const]] BULLY_ACT_KNOCKBACK           = 2
--[[export const]] BULLY_ACT_BACK_UP             = 3
--[[export const]] BULLY_ACT_INACTIVE            = 4
--[[export const]] BULLY_ACT_ACTIVATE_AND_FALL   = 5
--[[export const]] BULLY_ACT_LAVA_DEATH          = 100
--[[export const]] BULLY_ACT_DEATH_PLANE_DEATH   = 101

--[[ oBullySubtype ]]
--[[export const]] BULLY_STYPE_GENERIC  = 0
--[[export const]] BULLY_STYPE_MINION   = 1
--[[export const]] BULLY_STYPE_CHILL    = 16

--[[ Celebration Star ]]
--[[ oAction ]]
--[[export const]] CELEB_STAR_ACT_SPIN_AROUND_MARIO = 0
--[[export const]] CELEB_STAR_ACT_FACE_CAMERA       = 1

--[[ Arrow Lift ]]
--[[export const]] oArrowLiftDisplacement        = 0x1B
--[[export const]] oArrowLiftUnk100              = 0x1E

--[[ Back-and-Forth Platform ]]
--[[export const]] oBackAndForthPlatformDirection   = 0x1B
--[[export const]] oBackAndForthPlatformPathLength  = 0x1C
--[[export const]] oBackAndForthPlatformDistance    = 0x1D
--[[export const]] oBackAndForthPlatformVel         = 0x1E

--[[ Bird ]]
--[[export const]] oBirdSpeed        = 0x1B
--[[export const]] oBirdTargetPitch  = 0x1C
--[[export const]] oBirdTargetYaw    = 0x1D

--[[ Bird Chirp Chirp ]]
--[[export const]] oBirdChirpChirpUnkF4  = 0x1B

--[[ End Birds ]]
--[[export const]] oEndBirdUnk104  = 0x1F

--[[ Hidden Blue Coin ]]
--[[export const]] oHiddenBlueCoinSwitch  = 0x1C

--[[ Bob-omb ]]
--[[export const]] oBobombBlinkTimer  = 0x1B
--[[export const]] oBobombFuseLit     = 0x1C
--[[export const]] oBobombFuseTimer   = 0x1D

--[[ Bob-omb Buddy ]]
--[[export const]] oBobombBuddyBlinkTimer        = 0x1B
--[[export const]] oBobombBuddyHasTalkedToMario  = 0x1C
--[[export const]] oBobombBuddyRole              = 0x1D
--[[export const]] oBobombBuddyCannonStatus      = 0x1E
--[[export const]] oBobombBuddyPosXCopy          = 0x20
--[[export const]] oBobombBuddyPosYCopy          = 0x21
--[[export const]] oBobombBuddyPosZCopy          = 0x22

--[[ Bob-omb Explosion Bubble ]]
--[[export const]] oBobombExpBubGfxScaleFacX  = 0x1D
--[[export const]] oBobombExpBubGfxScaleFacY  = 0x1E
--[[export const]] oBobombExpBubGfxExpRateX   = 0x1F
--[[export const]] oBobombExpBubGfxExpRateY   = 0x20

--[[ Bomp (Small) ]]
--[[export const]] oSmallBompInitX  = 0x1E

--[[ Boo ]]
--[[export const]] oBooDeathStatus            = 0x00
--[[export const]] oBooTargetOpacity          = 0x1B
--[[export const]] oBooBaseScale              = 0x1C
--[[export const]] oBooOscillationTimer       = 0x1D
--[[export const]] oBooMoveYawDuringHit       = 0x1E
--[[export const]] oBooMoveYawBeforeHit       = 0x1F
--[[export const]] oBooParentBigBoo           = 0x20
--[[export const]] oBooNegatedAggressiveness  = 0x21
--[[export const]] oBooInitialMoveYaw         = 0x22
--[[export const]] oBooTurningSpeed           = 0x4A

--[[ Big Boo ]]
--[[export const]] oBigBooNumMinionBoosKilled  = 0x49

--[[ Bookend ]]
--[[export const]] oBookendUnkF4  = 0x1B
--[[export const]] oBookendUnkF8  = 0x1C

--[[ Book Switch ]]
--[[export const]] oBookSwitchUnkF4  = 0x1B

--[[ Book Switch Manager ]]
--[[export const]] oBookSwitchManagerUnkF4  = 0x1B
--[[export const]] oBookSwitchManagerUnkF8  = 0x1C

--[[ Haunted Bookshelf ]]
--[[export const]] oHauntedBookshelfShouldOpen  = 0x00

--[[ Bouncing FireBall ]]
--[[export const]] oBouncingFireBallUnkF4  = 0x1B

--[[ Bowling Ball ]]
--[[export const]] oBowlingBallTargetYaw  = 0x1B
-- 0x1D-0x21 reserved for pathing

--[[ Bowling Ball Spawner (Generic) ]]
--[[export const]] oBBallSpawnerMaxSpawnDist  = 0x1B
--[[export const]] oBBallSpawnerSpawnOdds     = 0x1C
--[[export const]] oBBallSpawnerPeriodMinus1  = 0x1D

--[[ Bowser ]]
--[[export const]] oBowserUnk88            = 0x00
--[[export const]] oBowserUnkF4            = 0x1B
--[[export const]] oBowserUnkF8            = 0x1C
--[[export const]] oBowserDistToCentre     = 0x1D
--[[export const]] oBowserUnk106           = 0x1F
--[[export const]] oBowserUnk108           = 0x20
--[[export const]] oBowserHeldAnglePitch   = 0x20
--[[export const]] oBowserHeldAngleVelYaw  = 0x21
--[[export const]] oBowserUnk10E           = 0x21
--[[export const]] oBowserUnk110           = 0x22
--[[export const]] oBowserAngleToCentre    = 0x22
--[[export const]] oBowserUnk1AC           = 0x49
--[[export const]] oBowserUnk1AE           = 0x49
--[[export const]] oBowserEyesShut         = 0x4A
--[[export const]] oBowserUnk1B2           = 0x4A

--[[ Bowser Shockwave ]]
--[[export const]] oBowserShockWaveUnkF4  = 0x1B

--[[ Black Smoke Bowser ]]
--[[export const]] oBlackSmokeBowserUnkF4  = 0x1B

--[[ Bowser Key Cutscene ]]
--[[export const]] oBowserKeyScale  = 0x1B

--[[ Bowser Puzzle ]]
--[[export const]] oBowserPuzzleCompletionFlags  = 0x1B

--[[ Bowser Puzzle Piece ]]
--[[export const]] oBowserPuzzlePieceOffsetX                   = 0x1D
--[[export const]] oBowserPuzzlePieceOffsetY                   = 0x1E
--[[export const]] oBowserPuzzlePieceOffsetZ                   = 0x1F
--[[export const]] oBowserPuzzlePieceContinuePerformingAction  = 0x20
--[[export const]] oBowserPuzzlePieceActionList                = 0x21
--[[export const]] oBowserPuzzlePieceNextAction                = 0x22

--[[ Bubba ]]
--[[export const]] oBubbaUnkF4   = 0x1B
--[[export const]] oBubbaUnkF8   = 0x1C
--[[export const]] oBubbaUnkFC   = 0x1D
--[[export const]] oBubbaUnk100  = 0x1E
--[[export const]] oBubbaUnk104  = 0x1F
--[[export const]] oBubbaUnk108  = 0x20
--[[export const]] oBubbaUnk10C  = 0x21
--[[export const]] oBubbaUnk1AC  = 0x49
--[[export const]] oBubbaUnk1AE  = 0x49
--[[export const]] oBubbaUnk1B0  = 0x4A
--[[export const]] oBubbaUnk1B2  = 0x4A

--[[ Bullet Bill ]]
--[[export const]] oBulletBillInitialMoveYaw  = 0x1C

--[[ Bully (all variants) ]]
--[[export const]] oBullySubtype                    = 0x1B
--[[export const]] oBullyPrevX                      = 0x1C
--[[export const]] oBullyPrevY                      = 0x1D
--[[export const]] oBullyPrevZ                      = 0x1E
--[[export const]] oBullyKBTimerAndMinionKOCounter  = 0x1F
--[[export const]] oBullyMarioCollisionAngle        = 0x20

--[[ Butterfly ]]
--[[export const]] oButterflyYPhase  = 0x1B

--[[ Triplet Butterfly ]]
--[[export const]] oTripletButterflyScale              = 0x1B
--[[export const]] oTripletButterflySpeed              = 0x1C
--[[export const]] oTripletButterflyBaseYaw            = 0x1D
--[[export const]] oTripletButterflyTargetPitch        = 0x1E
--[[export const]] oTripletButterflyTargetYaw          = 0x1F
--[[export const]] oTripletButterflyType               = 0x20
--[[export const]] oTripletButterflyModel              = 0x21
--[[export const]] oTripletButterflySelectedButterfly  = 0x22
--[[export const]] oTripletButterflyScalePhase         = 0x49

--[[ Cannon ]]
--[[export const]] oCannonUnkF4   = 0x1B
--[[export const]] oCannonUnkF8   = 0x1C
--[[export const]] oCannonUnk10C  = 0x21

--[[ Cap ]]
--[[export const]] oCapUnkF4  = 0x1B
--[[export const]] oCapUnkF8  = 0x1C

--[[ Chain Chomp ]]
--[[export const]] oChainChompSegments                      = 0x1B
--[[export const]] oChainChompMaxDistFromPivotPerChainPart  = 0x1C
--[[export const]] oChainChompMaxDistBetweenChainParts      = 0x1D
--[[export const]] oChainChompDistToPivot                   = 0x1E
--[[export const]] oChainChompUnk104                        = 0x1F
--[[export const]] oChainChompRestrictedByChain             = 0x20
--[[export const]] oChainChompTargetPitch                   = 0x21
--[[export const]] oChainChompNumLunges                     = 0x22
--[[export const]] oChainChompReleaseStatus                 = 0x49
--[[export const]] oChainChompHitGate                       = 0x4A

--[[ Checkerboard Platform ]]
--[[export const]] oCheckerBoardPlatformUnkF8   = 0x1C -- oAction like
--[[export const]] oCheckerBoardPlatformUnkFC   = 0x1D
--[[export const]] oCheckerBoardPlatformUnk1AC  = 0x49

--[[ Cheep Cheep ]]
--[[export const]] oCheepCheepUnkF4   = 0x1B
--[[export const]] oCheepCheepUnkF8   = 0x1C
--[[export const]] oCheepCheepUnkFC   = 0x1D
--[[export const]] oCheepCheepUnk104  = 0x1F
--[[export const]] oCheepCheepUnk108  = 0x20

--[[ Chuckya ]]
--[[export const]] oChuckyaUnk88   = 0x00
--[[export const]] oChuckyaUnkF8   = 0x1C
--[[export const]] oChuckyaUnkFC   = 0x1D
--[[export const]] oChuckyaUnk100  = 0x1E

--[[ Clam ]]
--[[export const]] oClamUnkF4  = 0x1B

--[[ Cloud ]]
--[[export const]] oCloudCenterX               = 0x1B
--[[export const]] oCloudCenterY               = 0x1C
--[[export const]] oCloudBlowing               = 0x1D
--[[export const]] oCloudGrowSpeed             = 0x1E
--[[export const]] oCloudFwooshMovementRadius  = 0x49

--[[ Coin ]]
--[[export const]] oCoinCollectedFlags        = 0x1B
--[[export const]] oCoinOnGround              = 0x1C
--[[export const]] oCoinBaseVelY              = 0x22
--[[export const]] oCoinNumBounceSoundPlayed  = 0x4A

--[[ Collision Particle ]]
--[[export const]] oCollisionParticleUnkF4   = 0x1B

--[[ Controllable Platform ]]
--[[export const]] oControllablePlatformUnkF8   = 0x1C
--[[export const]] oControllablePlatformUnkFC   = 0x1D
--[[export const]] oControllablePlatformUnk100  = 0x1E

--[[ Jumping Box (Crazy Box) ]]
--[[export const]] oJumpingBoxUnkF4  = 0x1B
--[[export const]] oJumpingBoxUnkF8  = 0x1C

--[[ RR Cruiser Wing ]]
--[[export const]] oRRCruiserWingUnkF4  = 0x1B
--[[export const]] oRRCruiserWingUnkF8  = 0x1C

--[[ Donut Platform Spawner ]]
--[[export const]] oDonutPlatformSpawnerSpawnedPlatforms  = 0x1B

--[[ Dorrie ]]
--[[export const]] oDorrieDistToHome          = 0x1B
--[[export const]] oDorrieOffsetY             = 0x1C
--[[export const]] oDorrieVelY                = 0x1D
--[[export const]] oDorrieForwardDistToMario  = 0x1E
--[[export const]] oDorrieYawVel              = 0x1F
--[[export const]] oDorrieLiftingMario        = 0x21
--[[export const]] oDorrieGroundPounded       = 0x49
--[[export const]] oDorrieAngleToHome         = 0x49
--[[export const]] oDorrieNeckAngle           = 0x4A
--[[export const]] oDorrieHeadRaiseSpeed      = 0x4A

--[[ Elevator ]]
--[[export const]] oElevatorUnkF4   = 0x1B
--[[export const]] oElevatorUnkF8   = 0x1C
--[[export const]] oElevatorUnkFC   = 0x1D
--[[export const]] oElevatorUnk100  = 0x1E

--[[ Exclamation Box ]]
--[[export const]] oExclamationBoxUnkF4  = 0x1B -- scale?
--[[export const]] oExclamationBoxUnkF8  = 0x1C -- scale?
--[[export const]] oExclamationBoxUnkFC  = 0x1D -- angle?

--[[ Eyerok Boss ]]
--[[export const]] oEyerokBossNumHands    = 0x1C
--[[export const]] oEyerokBossUnkFC       = 0x1D
--[[export const]] oEyerokBossActiveHand  = 0x1E
--[[export const]] oEyerokBossUnk104      = 0x1F
--[[export const]] oEyerokBossUnk108      = 0x20
--[[export const]] oEyerokBossUnk10C      = 0x21
--[[export const]] oEyerokBossUnk110      = 0x22
--[[export const]] oEyerokBossUnk1AC      = 0x49

--[[ Eyerok Hand ]]
--[[export const]] oEyerokHandWakeUpTimer  = 0x1B
--[[export const]] oEyerokReceivedAttack   = 0x1C
--[[export const]] oEyerokHandUnkFC        = 0x1D
--[[export const]] oEyerokHandUnk100       = 0x1E

--[[ Falling Pillar ]]
--[[export const]] oFallingPillarPitchAcceleration  = 0x1B

--[[ Fire Spitter ]]
--[[export const]] oFireSpitterScaleVel  = 0x1B

--[[ Blue Fish ]]
--[[export const]] oBlueFishRandomVel    = 0x1B
--[[export const]] oBlueFishRandomTime   = 0x1C
--[[export const]] oBlueFishRandomAngle  = 0x1E

--[[ Fire spitter ]]
--[[ oAction ]]
--[[export const]] FIRE_SPITTER_ACT_IDLE      = 0
--[[export const]] FIRE_SPITTER_ACT_SPIT_FIRE = 1

--[[ Fish Group ]]
--[[export const]] oFishWaterLevel      = 0x1B
--[[export const]] oFishGoalY           = 0x1C
--[[export const]] oFishHeightOffset    = 0x1D
--[[export const]] oFishYawVel          = 0x1E
--[[export const]] oFishRoamDistance    = 0x1F
--[[export const]] oFishGoalVel         = 0x20
--[[export const]] oFishDepthDistance   = 0x21
--[[export const]] oFishActiveDistance  = 0x22

--[[ Flame ]]
--[[export const]] oFlameScale             = 0x1B
--[[export const]] oFlameSpeedTimerOffset  = 0x1C
--[[export const]] oFlameUnkFC             = 0x1D
--[[export const]] oFlameBowser            = 0x1E

--[[ Blue Flame ]]
--[[export const]] oBlueFlameNextScale  = 0x1C

--[[ Small Piranha Flame ]]
--[[export const]] oSmallPiranhaFlameStartSpeed      = 0x1B
--[[export const]] oSmallPiranhaFlameEndSpeed        = 0x1C
--[[export const]] oSmallPiranhaFlameModel           = 0x1D
--[[export const]] oSmallPiranhaFlameNextFlameTimer  = 0x1E
--[[export const]] oSmallPiranhaFlameSpeed           = 0x1F

--[[ Moving Flame ]]
--[[export const]] oMovingFlameTimer  = 0x1B

--[[ Flamethrower Flame ]]
--[[export const]] oFlameThowerFlameUnk110  = 0x22

--[[ Flamethrower ]]
--[[export const]] oFlameThowerUnk110  = 0x22

--[[ Floating Platform ]]
--[[export const]] oFloatingPlatformUnkF4   = 0x1B
--[[export const]] oFloatingPlatformUnkF8   = 0x1C
--[[export const]] oFloatingPlatformUnkFC   = 0x1D
--[[export const]] oFloatingPlatformUnk100   = 0x1E

--[[ Floor Switch Press Animation ]]
--[[export const]] oFloorSwitchPressAnimationUnkF4   = 0x1B
--[[export const]] oFloorSwitchPressAnimationUnkF8   = 0x1C
--[[export const]] oFloorSwitchPressAnimationUnkFC   = 0x1D
--[[export const]] oFloorSwitchPressAnimationUnk100  = 0x1E

--[[ Fly Guy ]]
--[[export const]] oFlyGuyIdleTimer         = 0x1B
--[[export const]] oFlyGuyOscTimer          = 0x1C
--[[export const]] oFlyGuyUnusedJitter      = 0x1D
--[[export const]] oFlyGuyLungeYDecel       = 0x1E
--[[export const]] oFlyGuyLungeTargetPitch  = 0x1F
--[[export const]] oFlyGuyTargetRoll        = 0x20
--[[export const]] oFlyGuyScaleVel          = 0x21

--[[ Grand Star ]]
--[[export const]] oGrandStarUnk108  = 0x20

--[[ Horizontal Grindel ]]
--[[export const]] oHorizontalGrindelTargetYaw   = 0x1B
--[[export const]] oHorizontalGrindelDistToHome  = 0x1C
--[[export const]] oHorizontalGrindelOnGround    = 0x1D

--[[ Goomba ]]
--[[export const]] oGoombaSize                 = 0x1B
--[[export const]] oGoombaScale                = 0x1C
--[[export const]] oGoombaWalkTimer            = 0x1D
--[[export const]] oGoombaTargetYaw            = 0x1E
--[[export const]] oGoombaBlinkTimer           = 0x1F
--[[export const]] oGoombaTurningAwayFromWall  = 0x20
--[[export const]] oGoombaRelativeSpeed        = 0x21

--[[ Haunted Chair ]]
--[[export const]] oHauntedChairUnkF4   = 0x1B
--[[export const]] oHauntedChairUnkF8   = 0x1C
--[[export const]] oHauntedChairUnkFC   = 0x1D
--[[export const]] oHauntedChairUnk100  = 0x1E
--[[export const]] oHauntedChairUnk104  = 0x1F

--[[ Heave-Ho ]]
--[[export const]] oHeaveHoUnk88  = 0x00
--[[export const]] oHeaveHoUnkF4  = 0x1B

--[[ Hoot ]]
--[[export const]] oHootAvailability      = 0x1B
--[[export const]] oHootMarioReleaseTime  = 0x22

--[[ Horizontal Movement ]]
--[[export const]] oHorizontalMovementUnkF4   = 0x1B
--[[export const]] oHorizontalMovementUnkF8   = 0x1C
--[[export const]] oHorizontalMovementUnk100  = 0x1E
--[[export const]] oHorizontalMovementUnk104  = 0x1F
--[[export const]] oHorizontalMovementUnk108  = 0x20

--[[ Kickable Board ]]
--[[export const]] oKickableBoardF4  = 0x1B
--[[export const]] oKickableBoardF8  = 0x1C

--[[ King Bob-omb ]]
--[[export const]] oKingBobombUnk88   = 0x00
--[[export const]] oKingBobombUnkF8   = 0x1C
--[[export const]] oKingBobombUnkFC   = 0x1D
--[[export const]] oKingBobombUnk100  = 0x1E
--[[export const]] oKingBobombUnk104  = 0x1F
--[[export const]] oKingBobombUnk108  = 0x20

--[[ Klepto ]]
--[[export const]] oKleptoDistanceToTarget       = 0x1B
--[[export const]] oKleptoUnkF8                  = 0x1C
--[[export const]] oKleptoUnkFC                  = 0x1D
--[[export const]] oKleptoSpeed                  = 0x1E
--[[export const]] oKleptoStartPosX              = 0x1F
--[[export const]] oKleptoStartPosY              = 0x20
--[[export const]] oKleptoStartPosZ              = 0x21
--[[export const]] oKleptoTimeUntilTargetChange  = 0x22
--[[export const]] oKleptoTargetNumber           = 0x49
--[[export const]] oKleptoUnk1AE                 = 0x49
--[[export const]] oKleptoUnk1B0                 = 0x4A
--[[export const]] oKleptoYawToTarget            = 0x4A

--[[ Koopa ]]
--[[export const]] oKoopaAgility                      = 0x1B
--[[export const]] oKoopaMovementType                 = 0x1C
--[[export const]] oKoopaTargetYaw                    = 0x1D
--[[export const]] oKoopaUnshelledTimeUntilTurn       = 0x1E
--[[export const]] oKoopaTurningAwayFromWall          = 0x1F
--[[export const]] oKoopaDistanceToMario              = 0x20
--[[export const]] oKoopaAngleToMario                 = 0x21
--[[export const]] oKoopaBlinkTimer                   = 0x22
--[[export const]] oKoopaCountdown                    = 0x49
--[[export const]] oKoopaTheQuickRaceIndex            = 0x49
--[[export const]] oKoopaTheQuickInitTextboxCooldown  = 0x4A
-- 0x1D-0x21 for koopa the quick reserved for pathing

--[[ Koopa Race Endpoint ]]
--[[export const]] oKoopaRaceEndpointRaceBegun      = 0x1B
--[[export const]] oKoopaRaceEndpointKoopaFinished  = 0x1C
--[[export const]] oKoopaRaceEndpointRaceStatus     = 0x1D
--[[export const]] oKoopaRaceEndpointUnk100         = 0x1E
--[[export const]] oKoopaRaceEndpointRaceEnded      = 0x1F

--[[ Koopa Shell Flame ]]
--[[export const]] oKoopaShellFlameUnkF4  = 0x1B
--[[export const]] oKoopaShellFlameUnkF8  = 0x1C

--[[ Camera Lakitu ]]
--[[export const]] oCameraLakituBlinkTimer      = 0x1B
--[[export const]] oCameraLakituSpeed           = 0x1C
--[[export const]] oCameraLakituCircleRadius    = 0x1D
--[[export const]] oCameraLakituFinishedDialog  = 0x1E
--[[export const]] oCameraLakituUnk104          = 0x1F
--[[export const]] oCameraLakituPitchVel        = 0x49
--[[export const]] oCameraLakituYawVel          = 0x49

--[[ Evil Lakitu ]]
--[[export const]] oEnemyLakituNumSpinies            = 0x1B
--[[export const]] oEnemyLakituBlinkTimer            = 0x1C
--[[export const]] oEnemyLakituSpinyCooldown         = 0x1D
--[[export const]] oEnemyLakituFaceForwardCountdown  = 0x1E

--[[ Intro Cutscene Lakitu ]]
--[[export const]] oIntroLakituSplineSegmentProgress   = 0x1C
--[[export const]] oIntroLakituSplineSegment           = 0x1D
--[[export const]] oIntroLakituUnk100                  = 0x1E
--[[export const]] oIntroLakituUnk104                  = 0x1F
--[[export const]] oIntroLakituUnk108                  = 0x20
--[[export const]] oIntroLakituUnk10C                  = 0x21
--[[export const]] oIntroLakituUnk110                  = 0x22
--[[export const]] oIntroLakituCloud                   = 0x49

--[[ Main Menu Button ]]
--[[export const]] oMenuButtonState        = 0x1B
--[[export const]] oMenuButtonTimer        = 0x1C
--[[export const]] oMenuButtonOrigPosX     = 0x1D
--[[export const]] oMenuButtonOrigPosY     = 0x1E
--[[export const]] oMenuButtonOrigPosZ     = 0x1F
--[[export const]] oMenuButtonScale        = 0x20
--[[export const]] oMenuButtonActionPhase  = 0x21

--[[ Manta Ray ]]
--[[export const]] oMantaTargetPitch  = 0x1B
--[[export const]] oMantaTargetYaw    = 0x1C

--[[ Merry-Go-Round ]]
--[[export const]] oMerryGoRoundStopped          = 0x00
--[[export const]] oMerryGoRoundMusicShouldPlay  = 0x1C
--[[export const]] oMerryGoRoundMarioIsOutside   = 0x1D

--[[ Merry-Go-Round Boo Manager ]]
--[[export const]] oMerryGoRoundBooManagerNumBoosKilled   = 0x00
--[[export const]] oMerryGoRoundBooManagerNumBoosSpawned  = 0x1D

--[[ Mips ]]
--[[export const]] oMipsStarStatus          = 0x1B
--[[export const]] oMipsStartWaypointIndex  = 0x1C
-- 0x1D-0x21 reserved for pathing
--[[export const]] oMipsForwardVelocity     = 0x49

--[[ Moneybag ]]
--[[export const]] oMoneybagJumpState  = 0x1B

--[[ Monty Mole ]]
--[[export const]] oMontyMoleCurrentHole            = 0x1B
--[[export const]] oMontyMoleHeightRelativeToFloor  = 0x1C

--[[ Monty Mole Hole ]]
--[[export const]] oMontyMoleHoleCooldown  = 0x1B

--[[ Mr. Blizzard ]]
--[[export const]] oMrBlizzardScale              = 0x1B
--[[export const]] oMrBlizzardHeldObj            = 0x1C
--[[export const]] oMrBlizzardGraphYVel          = 0x1D
--[[export const]] oMrBlizzardTimer              = 0x1E
--[[export const]] oMrBlizzardDizziness          = 0x1F
--[[export const]] oMrBlizzardChangeInDizziness  = 0x20
--[[export const]] oMrBlizzardGraphYOffset       = 0x21
--[[export const]] oMrBlizzardDistFromHome       = 0x22
--[[export const]] oMrBlizzardTargetMoveYaw      = 0x49

--[[ Mr. I ]]
--[[export const]] oMrIUnkF4   = 0x1B
--[[export const]] oMrIUnkFC   = 0x1D
--[[export const]] oMrIUnk100  = 0x1E
--[[export const]] oMrIUnk104  = 0x1F
--[[export const]] oMrIUnk108  = 0x20
--[[export const]] oMrIScale   = 0x21
--[[export const]] oMrIUnk110  = 0x22

--[[ Object Respawner ]]
--[[export const]] oRespawnerModelToRespawn     = 0x1B
--[[export const]] oRespawnerMinSpawnDist       = 0x1C
--[[export const]] oRespawnerBehaviorToRespawn  = 0x1D

--[[ Openable Grill ]]
--[[export const]] oOpenableGrillUnk88  = 0x00
--[[export const]] oOpenableGrillUnkF4  = 0x1B

--[[ Intro Cutscene Peach ]]
--[[export const]] oIntroPeachYawFromFocus  = 0x20
--[[export const]] oIntroPeachPitchFromFocus  = 0x21
--[[export const]] oIntroPeachDistToCamera  = 0x22

--[[ Racing Penguin ]]
--[[export const]] oRacingPenguinInitTextCooldown        = 0x1B
-- 0x1D-0x21 reserved for pathing
--[[export const]] oRacingPenguinWeightedNewTargetSpeed  = 0x22
--[[export const]] oRacingPenguinFinalTextbox            = 0x49
--[[export const]] oRacingPenguinMarioWon                = 0x49
--[[export const]] oRacingPenguinReachedBottom           = 0x4A
--[[export const]] oRacingPenguinMarioCheated            = 0x4A

--[[ Small Penguin ]]
--[[export const]] oSmallPenguinUnk88   = 0x00
--[[export const]] oSmallPenguinUnk100  = 0x1E -- angle?
--[[export const]] oSmallPenguinUnk104  = 0x1F
--[[export const]] oSmallPenguinUnk108  = 0x20
--[[export const]] oSmallPenguinUnk110  = 0x22

--[[ SL Walking Penguin ]]
--[[export const]] oSLWalkingPenguinWindCollisionXPos  = 0x1E
--[[export const]] oSLWalkingPenguinWindCollisionZPos  = 0x1F
--[[export const]] oSLWalkingPenguinCurStep            = 0x21
--[[export const]] oSLWalkingPenguinCurStepTimer       = 0x22

--[[ Piranha Plant ]]
--[[export const]] oPiranhaPlantSleepMusicState  = 0x1B
--[[export const]] oPiranhaPlantScale            = 0x1C

--[[ Fire Piranha Plant ]]
--[[export const]] oFirePiranhaPlantNeutralScale    = 0x1B
--[[export const]] oFirePiranhaPlantScale           = 0x1C --Shared with above obj? Coincidence?
--[[export const]] oFirePiranhaPlantActive          = 0x1D
--[[export const]] oFirePiranhaPlantDeathSpinTimer  = 0x1E
--[[export const]] oFirePiranhaPlantDeathSpinVel    = 0x1F

--[[ Pitoune ]]
--[[export const]] oPitouneUnkF4  = 0x1B
--[[export const]] oPitouneUnkF8  = 0x1C
--[[export const]] oPitouneUnkFC  = 0x1D

--[[ Falling Rising Bitfs Platform ]]
--[[export const]] oBitfsPlatformTimer = 0x1B

--[[ Platform ]]
--[[export const]] oPlatformTimer   = 0x1B
--[[export const]] oPlatformUnkF8   = 0x1C
--[[export const]] oPlatformUnkFC   = 0x1D
--[[export const]] oPlatformUnk10C  = 0x21
--[[export const]] oPlatformUnk110  = 0x22

--[[ Platform on Tracks ]]
--[[export const]] oPlatformOnTrackBaseBallIndex           = 0x00
--[[export const]] oPlatformOnTrackDistMovedSinceLastBall  = 0x1B
--[[export const]] oPlatformOnTrackSkiLiftRollVel          = 0x1C
--[[export const]] oPlatformOnTrackStartWaypoint           = 0x1D
--[[export const]] oPlatformOnTrackPrevWaypoint            = 0x1E
--[[export const]] oPlatformOnTrackPrevWaypointFlags       = 0x1F
--[[export const]] oPlatformOnTrackPitch                   = 0x20
--[[export const]] oPlatformOnTrackYaw                     = 0x21
--[[export const]] oPlatformOnTrackOffsetY                 = 0x22
--[[export const]] oPlatformOnTrackIsNotSkiLift            = 0x49
--[[export const]] oPlatformOnTrackIsNotHMC                = 0x49
--[[export const]] oPlatformOnTrackType                    = 0x4A
--[[export const]] oPlatformOnTrackWasStoodOn              = 0x4A

--[[ Platform Spawner ]]
--[[export const]] oPlatformSpawnerUnkF4   = 0x1B
--[[export const]] oPlatformSpawnerUnkF8   = 0x1C
--[[export const]] oPlatformSpawnerUnkFC   = 0x1D
--[[export const]] oPlatformSpawnerUnk100  = 0x1E
--[[export const]] oPlatformSpawnerUnk104  = 0x1F
--[[export const]] oPlatformSpawnerUnk108  = 0x20

--[[ Pokey ]]
--[[export const]] oPokeyAliveBodyPartFlags   = 0x1B
--[[export const]] oPokeyNumAliveBodyParts    = 0x1C
--[[export const]] oPokeyBottomBodyPartSize   = 0x1D
--[[export const]] oPokeyHeadWasKilled        = 0x1E
--[[export const]] oPokeyTargetYaw            = 0x1F
--[[export const]] oPokeyChangeTargetTimer    = 0x20
--[[export const]] oPokeyTurningAwayFromWall  = 0x21

--[[ Pokey Body Part ]]
--[[export const]] oPokeyBodyPartDeathDelayAfterHeadKilled  = 0x1C
--[[export const]] oPokeyBodyPartBlinkTimer                 = 0x22

--[[ DDD Pole ]]
--[[export const]] oDDDPoleVel        = 0x1B
--[[export const]] oDDDPoleMaxOffset  = 0x1C
--[[export const]] oDDDPoleOffset     = 0x1D

--[[ Pyramid Top ]]
--[[export const]] oPyramidTopPillarsTouched  = 0x1B

--[[ Pyramid Top Explosion ]]
--[[export const]] oPyramidTopFragmentsScale  = 0x1B

--[[ Rolling Log ]]
--[[export const]] oRollingLogUnkF4  = 0x1B

--[[ Lll Rotating Hex Flame ]]
--[[export const]] oLllRotatingHexFlameUnkF4  = 0x1B
--[[export const]] oLllRotatingHexFlameUnkF8  = 0x1C
--[[export const]] oLllRotatingHexFlameUnkFC  = 0x1D

--[[ Scuttlebug ]]
--[[export const]] oScuttlebugUnkF4  = 0x1B
--[[export const]] oScuttlebugUnkF8  = 0x1C
--[[export const]] oScuttlebugUnkFC  = 0x1D

--[[ Scuttlebug Spawner ]]
--[[export const]] oScuttlebugSpawnerUnk88  = 0x00
--[[export const]] oScuttlebugSpawnerUnkF4  = 0x1B

--[[ Seesaw Platform ]]
--[[export const]] oSeesawPlatformPitchVel  = 0x1B

--[[ Ship Part 3 ]]
--[[export const]] oShipPart3UnkF4  = 0x1B -- angle?
--[[export const]] oShipPart3UnkF8  = 0x1C -- angle?

--[[ Sink When Stepped On ]]
--[[export const]] oSinkWhenSteppedOnUnk104  = 0x1F
--[[export const]] oSinkWhenSteppedOnUnk108  = 0x20

--[[ Skeeter ]]
--[[export const]] oSkeeterTargetAngle  = 0x1B
--[[export const]] oSkeeterUnkF8        = 0x1C
--[[export const]] oSkeeterUnkFC        = 0x1D
--[[export const]] oSkeeterWaitTime     = 0x1E
--[[export const]] oSkeeterUnk1AC       = 0x49

--[[ Jrb Sliding Box ]]
--[[export const]] oJrbSlidingBoxUnkF4  = 0x1B
--[[export const]] oJrbSlidingBoxUnkF8  = 0x1C
--[[export const]] oJrbSlidingBoxUnkFC  = 0x1D

--[[ WF Sliding Brick Platform ]]
--[[export const]] oWFSlidBrickPtfmMovVel  = 0x1B

--[[ Smoke ]]
--[[export const]] oSmokeTimer  = 0x1B

--[[ Snowman's Bottom ]]
--[[export const]] oSnowmansBottomUnkF4   = 0x1B
--[[export const]] oSnowmansBottomUnkF8   = 0x1C
--[[export const]] oSnowmansBottomUnk1AC  = 0x49
-- 0x1D-0x21 reserved for pathing

--[[ Snowman's Head ]]
--[[export const]] oSnowmansHeadUnkF4  = 0x1B

--[[ Snowman Wind Blowing ]]
--[[export const]] oSLSnowmanWindOriginalYaw  = 0x1B

--[[ Snufit ]]
--[[export const]] oSnufitRecoil           = 0x1B
--[[export const]] oSnufitScale            = 0x1C
--[[export const]] oSnufitCircularPeriod   = 0x1E
--[[export const]] oSnufitBodyScalePeriod  = 0x1F
--[[export const]] oSnufitBodyBaseScale    = 0x20
--[[export const]] oSnufitBullets          = 0x21
--[[export const]] oSnufitXOffset          = 0x49
--[[export const]] oSnufitYOffset          = 0x49
--[[export const]] oSnufitZOffset          = 0x4A
--[[export const]] oSnufitBodyScale        = 0x4A

--[[ Spindel ]]
--[[export const]] oSpindelUnkF4  = 0x1B
--[[export const]] oSpindelUnkF8  = 0x1C

--[[ Spinning Heart ]]
--[[export const]] oSpinningHeartTotalSpin    = 0x1B
--[[export const]] oSpinningHeartPlayedSound  = 0x1C

--[[ Spiny ]]
--[[export const]] oSpinyTimeUntilTurn        = 0x1B
--[[export const]] oSpinyTargetYaw            = 0x1C
--[[export const]] oSpinyTurningAwayFromWall  = 0x1E

--[[ Sound Effect ]]
--[[export const]] oSoundEffectUnkF4  = 0x1B

--[[ Star Spawn ]]
--[[export const]] oStarSpawnDisFromHome  = 0x1B
--[[export const]] oStarSpawnUnkFC        = 0x1D

--[[ Hidden Star ]]
-- Secrets/Red Coins
--[[export const]] oHiddenStarTriggerCounter  = 0x1B

-- Overall very difficult to determine usage, mostly stubbed code.
--[[ Sparkle Spawn Star ]]
--[[export const]] oSparkleSpawnUnk1B0  = 0x4A

--[[ Sealed Door Star ]]
--[[export const]] oUnlockDoorStarState   = 0x20
--[[export const]] oUnlockDoorStarTimer   = 0x21
--[[export const]] oUnlockDoorStarYawVel  = 0x22

--[[ Celebration Star ]]
--[[export const]] oCelebStarUnkF4               = 0x1B
--[[export const]] oCelebStarDiameterOfRotation  = 0x20

--[[ Star Selector ]]
--[[export const]] oStarSelectorType   = 0x1B
--[[export const]] oStarSelectorTimer  = 0x1C
--[[export const]] oStarSelectorSize   = 0x20

--[[ Sushi Shark ]]
--[[export const]] oSushiSharkUnkF4  = 0x1B -- angle?

--[[ Swing Platform ]]
--[[export const]] oSwingPlatformAngle  = 0x1B
--[[export const]] oSwingPlatformSpeed  = 0x1C

--[[ Swoop ]]
--[[export const]] oSwoopBonkCountdown  = 0x1B
--[[export const]] oSwoopTargetPitch    = 0x1C
--[[export const]] oSwoopTargetYaw      = 0x1D

--[[ Thwomp ]]
--[[export const]] oGrindelThwompRandomTimer  = 0x1B

--[[ Tilting Platform ]]
--[[export const]] oTiltingPyramidNormalX          = 0x1B
--[[export const]] oTiltingPyramidNormalY          = 0x1C
--[[export const]] oTiltingPyramidNormalZ          = 0x1D
--[[export const]] oTiltingPyramidMarioOnPlatform  = 0x21

--[[ Toad Message ]]
--[[export const]] oToadMessageDialogId        = 0x20
--[[export const]] oToadMessageRecentlyTalked  = 0x21
--[[export const]] oToadMessageState           = 0x22

--[[ Tox Box ]]
--[[export const]] oToxBoxActionTable  = 0x49
--[[export const]] oToxBoxActionStep   = 0x4A

--[[ TTC Rotating Solid ]]
--[[export const]] oTTCRotatingSolidNumTurns       = 0x1B
--[[export const]] oTTCRotatingSolidNumSides       = 0x1C
--[[export const]] oTTCRotatingSolidRotationDelay  = 0x1D
--[[export const]] oTTCRotatingSolidVelY           = 0x1E
--[[export const]] oTTCRotatingSolidSoundTimer     = 0x1F

--[[ TTC Pendulum ]]
--[[export const]] oTTCPendulumAccelDir    = 0x1B
--[[export const]] oTTCPendulumAngle       = 0x1C
--[[export const]] oTTCPendulumAngleVel    = 0x1D
--[[export const]] oTTCPendulumAngleAccel  = 0x1E
--[[export const]] oTTCPendulumDelay       = 0x1F
--[[export const]] oTTCPendulumSoundTimer  = 0x20

--[[ TTC Treadmill ]]
--[[export const]] oTTCTreadmillBigSurface       = 0x1B
--[[export const]] oTTCTreadmillSmallSurface     = 0x1C
--[[export const]] oTTCTreadmillSpeed            = 0x1D
--[[export const]] oTTCTreadmillTargetSpeed      = 0x1E
--[[export const]] oTTCTreadmillTimeUntilSwitch  = 0x1F

--[[ TTC Moving Bar ]]
--[[export const]] oTTCMovingBarDelay         = 0x1B
--[[export const]] oTTCMovingBarStoppedTimer  = 0x1C
--[[export const]] oTTCMovingBarOffset        = 0x1D
--[[export const]] oTTCMovingBarSpeed         = 0x1E
--[[export const]] oTTCMovingBarStartOffset   = 0x1F

--[[ TTC Cog ]]
--[[export const]] oTTCCogDir        = 0x1B
--[[export const]] oTTCCogSpeed      = 0x1C
--[[export const]] oTTCCogTargetVel  = 0x1D

--[[ TTC Pit Block ]]
--[[export const]] oTTCPitBlockPeakY     = 0x1B
--[[export const]] oTTCPitBlockDir       = 0x1C
--[[export const]] oTTCPitBlockWaitTime  = 0x1D

--[[ TTC Elevator ]]
--[[export const]] oTTCElevatorDir       = 0x1B
--[[export const]] oTTCElevatorPeakY     = 0x1C
--[[export const]] oTTCElevatorMoveTime  = 0x1D

--[[ TTC 2D Rotator ]]
--[[export const]] oTTC2DRotatorMinTimeUntilNextTurn  = 0x1B
--[[export const]] oTTC2DRotatorTargetYaw             = 0x1C
--[[export const]] oTTC2DRotatorIncrement             = 0x1D
--[[export const]] oTTC2DRotatorRandomDirTimer        = 0x1F
--[[export const]] oTTC2DRotatorSpeed                 = 0x20

--[[ TTC Spinner ]]
--[[export const]] oTTCSpinnerDir      = 0x1B
--[[export const]] oTTCChangeDirTimer  = 0x1C

--[[ Beta Trampoline ]]
--[[export const]] oBetaTrampolineMarioOnTrampoline  = 0x22

--[[ Treasure Chest ]]
--[[export const]] oTreasureChestUnkF4  = 0x1B
--[[export const]] oTreasureChestUnkF8  = 0x1C
--[[export const]] oTreasureChestUnkFC  = 0x1D

--[[ Tree Snow Or Leaf ]]
--[[export const]] oTreeSnowOrLeafUnkF4  = 0x1B
--[[export const]] oTreeSnowOrLeafUnkF8  = 0x1C
--[[export const]] oTreeSnowOrLeafUnkFC  = 0x1D

--[[ Tumbling Bridge ]]
--[[export const]] oTumblingBridgeUnkF4  = 0x1B

--[[ Tweester ]]
--[[export const]] oTweesterScaleTimer  = 0x1B
--[[export const]] oTweesterUnused      = 0x1C

--[[ Ukiki ]]
--[[export const]] oUkikiTauntCounter    = 0x1B
--[[export const]] oUkikiTauntsToBeDone  = 0x1B
-- 0x1D-0x21 reserved for pathing
--[[export const]] oUkikiChaseFleeRange  = 0x22
--[[export const]] oUkikiTextState       = 0x49
--[[export const]] oUkikiTextboxTimer    = 0x49
--[[export const]] oUkikiCageSpinTimer   = 0x4A
--[[export const]] oUkikiHasCap          = 0x4A

--[[ Ukiki Cage]]
--[[export const]] oUkikiCageNextAction  = 0x00

--[[ Unagi ]]
--[[export const]] oUnagiUnkF4   = 0x1B
--[[export const]] oUnagiUnkF8   = 0x1C
-- 0x1D-0x21 reserved for pathing
--[[export const]] oUnagiUnk110  = 0x22
--[[export const]] oUnagiUnk1AC  = 0x49
--[[export const]] oUnagiUnk1B0  = 0x4A
--[[export const]] oUnagiUnk1B2  = 0x4A

--[[ Water Level Pillar ]]
--[[export const]] oWaterLevelPillarDrained  = 0x1C

--[[ Water Level Trigger ]]
--[[export const]] oWaterLevelTriggerUnkF4             = 0x1B
--[[export const]] oWaterLevelTriggerTargetWaterLevel  = 0x1C

--[[ Water Objects ]]
--[[export const]] oWaterObjUnkF4   = 0x1B
--[[export const]] oWaterObjUnkF8   = 0x1C
--[[export const]] oWaterObjUnkFC   = 0x1D
--[[export const]] oWaterObjUnk100  = 0x1E

--[[ Water Ring (both variants) ]]
--[[export const]] oWaterRingScalePhaseX       = 0x1B
--[[export const]] oWaterRingScalePhaseY       = 0x1C
--[[export const]] oWaterRingScalePhaseZ       = 0x1D
--[[export const]] oWaterRingNormalX           = 0x1E
--[[export const]] oWaterRingNormalY           = 0x1F
--[[export const]] oWaterRingNormalZ           = 0x20
--[[export const]] oWaterRingMarioDistInFront  = 0x21
--[[export const]] oWaterRingIndex             = 0x22
--[[export const]] oWaterRingAvgScale          = 0x49

--[[ Water Ring Spawner (Jet Stream Ring Spawner and Manta Ray) ]]
--[[export const]] oWaterRingSpawnerRingsCollected  = 0x49

--[[ Water Ring Manager (Jet Stream Ring Spawner and Manta Ray Ring Manager) ]]
--[[export const]] oWaterRingMgrNextRingIndex      = 0x1B
--[[export const]] oWaterRingMgrLastRingCollected  = 0x1C

--[[ Wave Trail ]]
--[[export const]] oWaveTrailSize  = 0x1C

--[[ Whirlpool ]]
--[[export const]] oWhirlpoolInitFacePitch  = 0x1B
--[[export const]] oWhirlpoolInitFaceRoll   = 0x1C

--[[ White Puff Explode ]]
--[[export const]] oWhitePuffUnkF4  = 0x1B
--[[export const]] oWhitePuffUnkF8  = 0x1C
--[[export const]] oWhitePuffUnkFC  = 0x1D

--[[ White Wind Particle ]]
--[[export const]] oStrongWindParticlePenguinObj  = 0x1B

--[[ Whomp ]]
--[[export const]] oWhompShakeVal  = 0x1C

--[[ Wiggler ]]
--[[export const]] oWigglerFallThroughFloorsHeight  = 0x1B
--[[export const]] oWigglerSegments                 = 0x1C
--[[export const]] oWigglerWalkAnimSpeed            = 0x1D
--[[export const]] oWigglerSquishSpeed              = 0x1F
--[[export const]] oWigglerTimeUntilRandomTurn      = 0x20
--[[export const]] oWigglerTargetYaw                = 0x21
--[[export const]] oWigglerWalkAwayFromWallTimer    = 0x22
--[[export const]] oWigglerUnused                   = 0x49
--[[export const]] oWigglerTextStatus               = 0x49

--[[ Lll Wood Piece ]]
--[[export const]] oLllWoodPieceOscillationTimer  = 0x1B

--[[ Wooden Post ]]
--[[export const]] oWoodenPostTotalMarioAngle   = 0x1B
--[[export const]] oWoodenPostPrevAngleToMario  = 0x1C
--[[export const]] oWoodenPostSpeedY            = 0x1D
--[[export const]] oWoodenPostMarioPounding     = 0x1E
--[[export const]] oWoodenPostOffsetY           = 0x1F

--[[ oAction ]]
--[[export const]] CHAIN_CHOMP_ACT_UNINITIALIZED = 0
--[[export const]] CHAIN_CHOMP_ACT_MOVE = 1
--[[export const]] CHAIN_CHOMP_ACT_UNLOAD_CHAIN = 2

--[[ oSubAction ]]
--[[export const]] CHAIN_CHOMP_SUB_ACT_TURN = 0
--[[export const]] CHAIN_CHOMP_SUB_ACT_LUNGE = 1

--[[ Mad piano ]]
--[[ oAction ]]
--[[export const]] MAD_PIANO_ACT_WAIT   = 0
--[[export const]] MAD_PIANO_ACT_ATTACK = 1

--[[ Moving Yellow Coin ]]
--[[ oAction ]]
--[[export const]] MOV_YCOIN_ACT_IDLE = 0
--[[export const]] MOV_YCOIN_ACT_BLINKING = 1
--[[export const]] MOV_YCOIN_ACT_LAVA_DEATH = 100
--[[export const]] MOV_YCOIN_ACT_DEATH_PLANE_DEATH = 101

--[[ oChainChompReleaseStatus ]]
--[[export const]] CHAIN_CHOMP_NOT_RELEASED = 0
--[[export const]] CHAIN_CHOMP_RELEASED_TRIGGER_CUTSCENE = 1
--[[export const]] CHAIN_CHOMP_RELEASED_LUNGE_AROUND = 2
--[[export const]] CHAIN_CHOMP_RELEASED_BREAK_GATE = 3
--[[export const]] CHAIN_CHOMP_RELEASED_JUMP_AWAY = 4
--[[export const]] CHAIN_CHOMP_RELEASED_END_CUTSCENE = 5

--[[ Chain chomp chain part ]]
--[[ oBhvParams2ndByte ]]
--[[export const]] CHAIN_CHOMP_CHAIN_PART_BP_PIVOT = 0

--[[ Wooden post ]]
--[[ oBhvParams ]]
--[[export const]] WOODEN_POST_BP_NO_COINS_MASK = 0x0000FF00

--[[ Goomba triplet spawner ]]
--[[ oBhvParams2ndByte ]]
--[[export const]] GOOMBA_TRIPLET_SPAWNER_BP_SIZE_MASK = 0x00000003
--[[export const]] GOOMBA_TRIPLET_SPAWNER_BP_EXTRA_GOOMBAS_MASK = 0x000000FC
--[[ oAction ]]
--[[export const]] GOOMBA_TRIPLET_SPAWNER_ACT_UNLOADED = 0
--[[export const]] GOOMBA_TRIPLET_SPAWNER_ACT_LOADED = 1

--[[ Goomba ]]
--[[ oBhvParams2ndByte ]]
--[[export const]] GOOMBA_BP_SIZE_MASK = 0x00000003
--[[export const]] GOOMBA_SIZE_REGULAR = 0
--[[export const]] GOOMBA_SIZE_HUGE = 1
--[[export const]] GOOMBA_SIZE_TINY = 2
--[[export const]] GOOMBA_BP_TRIPLET_FLAG_MASK = 0x000000FC
--[[ oAction ]]
--[[export const]] GOOMBA_ACT_WALK = 0
--[[export const]] GOOMBA_ACT_ATTACKED_MARIO = 1
--[[export const]] GOOMBA_ACT_JUMP = 2

--[[ BBH Merry-Go-Round ]]
--[[ gMarioCurrentRoom ]]
--[[export const]] BBH_NEAR_MERRY_GO_ROUND_ROOM = 10
--[[export const]] BBH_DYNAMIC_SURFACE_ROOM     = 0
--[[export const]] BBH_OUTSIDE_ROOM             = 13

--[[ Coffin Spawner ]]
--[[ oAction ]]
--[[export const]] COFFIN_SPAWNER_ACT_COFFINS_UNLOADED = 0

--[[ Coffin ]]
--[[ oAction ]]
--[[export const]] COFFIN_ACT_IDLE     = 0
--[[export const]] COFFIN_ACT_STAND_UP = 1

--[[ oBhvParams2ndByte ]]
--[[export const]] COFFIN_BP_STATIC = 0

--[[ Bob-omb ]]
--[[ oBhvParams2ndByte ]]
--[[export const]] BOBOMB_BP_STYPE_GENERIC = 0
--[[export const]] BOBOMB_BP_STYPE_STATIONARY = 1
--[[ oAction ]]
--[[export const]] BOBOMB_ACT_PATROL = 0
--[[export const]] BOBOMB_ACT_LAUNCHED = 1
--[[export const]] BOBOMB_ACT_CHASE_MARIO = 2
--[[export const]] BOBOMB_ACT_EXPLODE = 3
--[[export const]] BOBOMB_ACT_LAVA_DEATH = 100
--[[export const]] BOBOMB_ACT_DEATH_PLANE_DEATH = 101

--[[ Evil lakitu ]]
--[[ oAction ]]
--[[export const]] ENEMY_LAKITU_ACT_UNINITIALIZED = 0
--[[export const]] ENEMY_LAKITU_ACT_MAIN          = 1

--[[ oSubAction ]]
--[[export const]] ENEMY_LAKITU_SUB_ACT_NO_SPINY    = 0
--[[export const]] ENEMY_LAKITU_SUB_ACT_HOLD_SPINY  = 1
--[[export const]] ENEMY_LAKITU_SUB_ACT_THROW_SPINY = 2

--[[ Coin Formation ]]
--[[ oAction ]]
--[[export const]] COIN_FORMATION_ACT_SPAWN_COINS   = 0
--[[export const]] COIN_FORMATION_ACT_IDLE          = 1
--[[export const]] COIN_FORMATION_ACT_RESPAWN_COINS = 2

--[[ oBhvParams2ndByte ]]
--[[export const]] COIN_FORMATION_BP_FLAG_HORIZONTAL = bit32.lshift(0, 0)
--[[export const]] COIN_FORMATION_BP_FLAG_VERTICAL   = bit32.lshift(1, 0)
--[[export const]] COIN_FORMATION_BP_FLAG_RING       = bit32.lshift(1, 1)
--[[export const]] COIN_FORMATION_BP_FLAG_ARROW      = bit32.lshift(1, 2)
--[[export const]] COIN_FORMATION_BP_FLAG_FLYING     = bit32.lshift(1, 4)
--[[export const]] COIN_FORMATION_BP_FLAG_MASK       = bit32.bor(COIN_FORMATION_BP_FLAG_HORIZONTAL, 
	COIN_FORMATION_BP_FLAG_VERTICAL,
	COIN_FORMATION_BP_FLAG_RING,
	COIN_FORMATION_BP_FLAG_ARROW)

--[[export const]] COIN_FORMATION_BP_LINE_HORIZONTAL = (COIN_FORMATION_BP_FLAG_HORIZONTAL)
--[[export const]] COIN_FORMATION_BP_LINE_VERTICAL   = (COIN_FORMATION_BP_FLAG_VERTICAL)
--[[export const]] COIN_FORMATION_BP_RING_HORIZONTAL = bit32.bor(COIN_FORMATION_BP_FLAG_HORIZONTAL, COIN_FORMATION_BP_FLAG_RING)
--[[export const]] COIN_FORMATION_BP_RING_VERTICAL   = bit32.bor(COIN_FORMATION_BP_FLAG_VERTICAL, COIN_FORMATION_BP_FLAG_RING)
--[[export const]] COIN_FORMATION_BP_ARROW           = (COIN_FORMATION_BP_FLAG_ARROW)

--[[ Hidden Blue Coin ]]
--[[ oAction ]]
--[[export const]] HIDDEN_BLUE_COIN_ACT_INACTIVE = 0
--[[export const]] HIDDEN_BLUE_COIN_ACT_WAITING  = 1
--[[export const]] HIDDEN_BLUE_COIN_ACT_ACTIVE   = 2

--[[ Blue Coin Switch ]]
--[[ oAction ]]
--[[export const]] BLUE_COIN_SWITCH_ACT_IDLE     = 0
--[[export const]] BLUE_COIN_SWITCH_ACT_RECEDING = 1
--[[export const]] BLUE_COIN_SWITCH_ACT_TICKING  = 2

--[[ Cloud ]]
--[[ oAction ]]
--[[export const]] CLOUD_ACT_SPAWN_PARTS   = 0
--[[export const]] CLOUD_ACT_MAIN          = 1
--[[export const]] CLOUD_ACT_UNLOAD        = 2
--[[export const]] CLOUD_ACT_FWOOSH_HIDDEN = 3

--[[ oBhvParams2ndByte ]]
--[[export const]] CLOUD_BP_FWOOSH       = 0
--[[export const]] CLOUD_BP_LAKITU_CLOUD = 1

--[[ Camera lakitu ]]
--[[ oAction ]]
--[[export const]] CAMERA_LAKITU_INTRO_ACT_TRIGGER_CUTSCENE = 0
--[[export const]] CAMERA_LAKITU_INTRO_ACT_SPAWN_CLOUD      = 1
--[[export const]] CAMERA_LAKITU_INTRO_ACT_UNK2             = 2

--[[ oBhvParams2ndByte ]]
--[[export const]] CAMERA_LAKITU_BP_FOLLOW_CAMERA = 0
--[[export const]] CAMERA_LAKITU_BP_INTRO         = 1

--[[ BBH Haunted Bookshelf ]]
--[[ oAction ]]
--[[export const]] HAUNTED_BOOKSHELF_ACT_IDLE   = 0
--[[export const]] HAUNTED_BOOKSHELF_ACT_RECEDE = 1

--[[ WDW Arrow Lift ]]
--[[ oAction ]]
--[[export const]] ARROW_LIFT_ACT_IDLE        = 0
--[[export const]] ARROW_LIFT_ACT_MOVING_AWAY = 1
--[[export const]] ARROW_LIFT_ACT_MOVING_BACK = 2

--[[ status ]]
--[[export const]] ARROW_LIFT_NOT_DONE_MOVING = 0
--[[export const]] ARROW_LIFT_DONE_MOVING     = 1

--[[ WF Rotating Wooden Platform ]]
--[[ oAction ]]
--[[export const]] WF_ROTATING_WOODEN_PLATFORM_ACT_IDLE     = 0
--[[export const]] WF_ROTATING_WOODEN_PLATFORM_ACT_ROTATING = 1

--[[ Grindel or Thwomp ]]
--[[ oAction ]]
--[[export const]] GRINDEL_THWOMP_ACT_RAISE          = 0
--[[export const]] GRINDEL_THWOMP_ACT_IDLE_AT_TOP    = 1
--[[export const]] GRINDEL_THWOMP_ACT_LOWER          = 2
--[[export const]] GRINDEL_THWOMP_ACT_LAND           = 3
--[[export const]] GRINDEL_THWOMP_ACT_IDLE_AT_BOTTOM = 4

--[[ Tox Box ]]
--[[ oAction ]]
--[[export const]] TOX_BOX_ACT_INIT          = 0
--[[export const]] TOX_BOX_ACT_ROLL_LAND     = 1
--[[export const]] TOX_BOX_ACT_IDLE          = 2
--[[export const]] TOX_BOX_ACT_UNUSED_IDLE   = 3
--[[export const]] TOX_BOX_ACT_ROLL_FORWARD  = 4
--[[export const]] TOX_BOX_ACT_ROLL_BACKWARD = 5
--[[export const]] TOX_BOX_ACT_ROLL_RIGHT    = 6
--[[export const]] TOX_BOX_ACT_ROLL_LEFT     = 7
--[[export const]] TOX_BOX_ACT_TABLE_END     = -1

--[[ oBhvParams2ndByte ]]
--[[export const]] TOX_BOX_BP_MOVEMENT_PATTERN_1 = 0
--[[export const]] TOX_BOX_BP_MOVEMENT_PATTERN_2 = 1
--[[export const]] TOX_BOX_BP_MOVEMENT_PATTERN_3 = 2

return table.freeze({
	ACTIVE_FLAGS_DEACTIVATED = ACTIVE_FLAGS_DEACTIVATED,
	ACTIVE_FLAG_ACTIVE = ACTIVE_FLAG_ACTIVE,
	ACTIVE_FLAG_DEACTIVATED = ACTIVE_FLAG_DEACTIVATED,
	ACTIVE_FLAG_DITHERED_ALPHA = ACTIVE_FLAG_DITHERED_ALPHA,
	ACTIVE_FLAG_FAR_AWAY = ACTIVE_FLAG_FAR_AWAY,
	ACTIVE_FLAG_INITIATED_TIME_STOP = ACTIVE_FLAG_INITIATED_TIME_STOP,
	ACTIVE_FLAG_IN_DIFFERENT_ROOM = ACTIVE_FLAG_IN_DIFFERENT_ROOM,
	ACTIVE_FLAG_MOVE_THROUGH_GRATE = ACTIVE_FLAG_MOVE_THROUGH_GRATE,
	ACTIVE_FLAG_UNIMPORTANT = ACTIVE_FLAG_UNIMPORTANT,
	ACTIVE_FLAG_UNK10 = ACTIVE_FLAG_UNK10,
	ACTIVE_FLAG_UNK2 = ACTIVE_FLAG_UNK2,
	ACTIVE_FLAG_UNK8 = ACTIVE_FLAG_UNK8,
	ACTIVE_FLAG_UNK9 = ACTIVE_FLAG_UNK9,
	ACTIVE_PARTICLE_BREATH = ACTIVE_PARTICLE_BREATH,
	ACTIVE_PARTICLE_BUBBLE = ACTIVE_PARTICLE_BUBBLE,
	ACTIVE_PARTICLE_DIRT = ACTIVE_PARTICLE_DIRT,
	ACTIVE_PARTICLE_DUST = ACTIVE_PARTICLE_DUST,
	ACTIVE_PARTICLE_FIRE = ACTIVE_PARTICLE_FIRE,
	ACTIVE_PARTICLE_H_STAR = ACTIVE_PARTICLE_H_STAR,
	ACTIVE_PARTICLE_IDLE_WATER_WAVE = ACTIVE_PARTICLE_IDLE_WATER_WAVE,
	ACTIVE_PARTICLE_LEAF = ACTIVE_PARTICLE_LEAF,
	ACTIVE_PARTICLE_MIST_CIRCLE = ACTIVE_PARTICLE_MIST_CIRCLE,
	ACTIVE_PARTICLE_PLUNGE_BUBBLE = ACTIVE_PARTICLE_PLUNGE_BUBBLE,
	ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH = ACTIVE_PARTICLE_SHALLOW_WATER_SPLASH,
	ACTIVE_PARTICLE_SHALLOW_WATER_WAVE = ACTIVE_PARTICLE_SHALLOW_WATER_WAVE,
	ACTIVE_PARTICLE_SNOW = ACTIVE_PARTICLE_SNOW,
	ACTIVE_PARTICLE_SPARKLES = ACTIVE_PARTICLE_SPARKLES,
	ACTIVE_PARTICLE_TRIANGLE = ACTIVE_PARTICLE_TRIANGLE,
	ACTIVE_PARTICLE_UNUSED_1 = ACTIVE_PARTICLE_UNUSED_1,
	ACTIVE_PARTICLE_UNUSED_2 = ACTIVE_PARTICLE_UNUSED_2,
	ACTIVE_PARTICLE_V_STAR = ACTIVE_PARTICLE_V_STAR,
	ACTIVE_PARTICLE_WATER_SPLASH = ACTIVE_PARTICLE_WATER_SPLASH,
	ACTIVE_PARTICLE_WAVE_TRAIL = ACTIVE_PARTICLE_WAVE_TRAIL,
	AMP_ACT_ATTACK_COOLDOWN = AMP_ACT_ATTACK_COOLDOWN,
	AMP_ACT_IDLE = AMP_ACT_IDLE,
	AMP_BP_ROT_RADIUS_0 = AMP_BP_ROT_RADIUS_0,
	AMP_BP_ROT_RADIUS_200 = AMP_BP_ROT_RADIUS_200,
	AMP_BP_ROT_RADIUS_300 = AMP_BP_ROT_RADIUS_300,
	AMP_BP_ROT_RADIUS_400 = AMP_BP_ROT_RADIUS_400,
	ARROW_LIFT_ACT_IDLE = ARROW_LIFT_ACT_IDLE,
	ARROW_LIFT_ACT_MOVING_AWAY = ARROW_LIFT_ACT_MOVING_AWAY,
	ARROW_LIFT_ACT_MOVING_BACK = ARROW_LIFT_ACT_MOVING_BACK,
	ARROW_LIFT_DONE_MOVING = ARROW_LIFT_DONE_MOVING,
	ARROW_LIFT_NOT_DONE_MOVING = ARROW_LIFT_NOT_DONE_MOVING,
	BBH_DYNAMIC_SURFACE_ROOM = BBH_DYNAMIC_SURFACE_ROOM,
	BBH_NEAR_MERRY_GO_ROUND_ROOM = BBH_NEAR_MERRY_GO_ROUND_ROOM,
	BBH_OUTSIDE_ROOM = BBH_OUTSIDE_ROOM,
	BLUE_COIN_SWITCH_ACT_IDLE = BLUE_COIN_SWITCH_ACT_IDLE,
	BLUE_COIN_SWITCH_ACT_RECEDING = BLUE_COIN_SWITCH_ACT_RECEDING,
	BLUE_COIN_SWITCH_ACT_TICKING = BLUE_COIN_SWITCH_ACT_TICKING,
	BOBOMB_ACT_CHASE_MARIO = BOBOMB_ACT_CHASE_MARIO,
	BOBOMB_ACT_DEATH_PLANE_DEATH = BOBOMB_ACT_DEATH_PLANE_DEATH,
	BOBOMB_ACT_EXPLODE = BOBOMB_ACT_EXPLODE,
	BOBOMB_ACT_LAUNCHED = BOBOMB_ACT_LAUNCHED,
	BOBOMB_ACT_LAVA_DEATH = BOBOMB_ACT_LAVA_DEATH,
	BOBOMB_ACT_PATROL = BOBOMB_ACT_PATROL,
	BOBOMB_BP_STYPE_GENERIC = BOBOMB_BP_STYPE_GENERIC,
	BOBOMB_BP_STYPE_STATIONARY = BOBOMB_BP_STYPE_STATIONARY,
	BULLY_ACT_ACTIVATE_AND_FALL = BULLY_ACT_ACTIVATE_AND_FALL,
	BULLY_ACT_BACK_UP = BULLY_ACT_BACK_UP,
	BULLY_ACT_CHASE_MARIO = BULLY_ACT_CHASE_MARIO,
	BULLY_ACT_DEATH_PLANE_DEATH = BULLY_ACT_DEATH_PLANE_DEATH,
	BULLY_ACT_INACTIVE = BULLY_ACT_INACTIVE,
	BULLY_ACT_KNOCKBACK = BULLY_ACT_KNOCKBACK,
	BULLY_ACT_LAVA_DEATH = BULLY_ACT_LAVA_DEATH,
	BULLY_ACT_PATROL = BULLY_ACT_PATROL,
	BULLY_BP_SIZE_BIG = BULLY_BP_SIZE_BIG,
	BULLY_BP_SIZE_SMALL = BULLY_BP_SIZE_SMALL,
	BULLY_STYPE_CHILL = BULLY_STYPE_CHILL,
	BULLY_STYPE_GENERIC = BULLY_STYPE_GENERIC,
	BULLY_STYPE_MINION = BULLY_STYPE_MINION,
	CAMERA_LAKITU_BP_FOLLOW_CAMERA = CAMERA_LAKITU_BP_FOLLOW_CAMERA,
	CAMERA_LAKITU_BP_INTRO = CAMERA_LAKITU_BP_INTRO,
	CAMERA_LAKITU_INTRO_ACT_SPAWN_CLOUD = CAMERA_LAKITU_INTRO_ACT_SPAWN_CLOUD,
	CAMERA_LAKITU_INTRO_ACT_TRIGGER_CUTSCENE = CAMERA_LAKITU_INTRO_ACT_TRIGGER_CUTSCENE,
	CAMERA_LAKITU_INTRO_ACT_UNK2 = CAMERA_LAKITU_INTRO_ACT_UNK2,
	CELEB_STAR_ACT_FACE_CAMERA = CELEB_STAR_ACT_FACE_CAMERA,
	CELEB_STAR_ACT_SPIN_AROUND_MARIO = CELEB_STAR_ACT_SPIN_AROUND_MARIO,
	CHAIN_CHOMP_ACT_MOVE = CHAIN_CHOMP_ACT_MOVE,
	CHAIN_CHOMP_ACT_UNINITIALIZED = CHAIN_CHOMP_ACT_UNINITIALIZED,
	CHAIN_CHOMP_ACT_UNLOAD_CHAIN = CHAIN_CHOMP_ACT_UNLOAD_CHAIN,
	CHAIN_CHOMP_CHAIN_PART_BP_PIVOT = CHAIN_CHOMP_CHAIN_PART_BP_PIVOT,
	CHAIN_CHOMP_NOT_RELEASED = CHAIN_CHOMP_NOT_RELEASED,
	CHAIN_CHOMP_RELEASED_BREAK_GATE = CHAIN_CHOMP_RELEASED_BREAK_GATE,
	CHAIN_CHOMP_RELEASED_END_CUTSCENE = CHAIN_CHOMP_RELEASED_END_CUTSCENE,
	CHAIN_CHOMP_RELEASED_JUMP_AWAY = CHAIN_CHOMP_RELEASED_JUMP_AWAY,
	CHAIN_CHOMP_RELEASED_LUNGE_AROUND = CHAIN_CHOMP_RELEASED_LUNGE_AROUND,
	CHAIN_CHOMP_RELEASED_TRIGGER_CUTSCENE = CHAIN_CHOMP_RELEASED_TRIGGER_CUTSCENE,
	CHAIN_CHOMP_SUB_ACT_LUNGE = CHAIN_CHOMP_SUB_ACT_LUNGE,
	CHAIN_CHOMP_SUB_ACT_TURN = CHAIN_CHOMP_SUB_ACT_TURN,
	CLOUD_ACT_FWOOSH_HIDDEN = CLOUD_ACT_FWOOSH_HIDDEN,
	CLOUD_ACT_MAIN = CLOUD_ACT_MAIN,
	CLOUD_ACT_SPAWN_PARTS = CLOUD_ACT_SPAWN_PARTS,
	CLOUD_ACT_UNLOAD = CLOUD_ACT_UNLOAD,
	CLOUD_BP_FWOOSH = CLOUD_BP_FWOOSH,
	CLOUD_BP_LAKITU_CLOUD = CLOUD_BP_LAKITU_CLOUD,
	COFFIN_ACT_IDLE = COFFIN_ACT_IDLE,
	COFFIN_ACT_STAND_UP = COFFIN_ACT_STAND_UP,
	COFFIN_BP_STATIC = COFFIN_BP_STATIC,
	COFFIN_SPAWNER_ACT_COFFINS_UNLOADED = COFFIN_SPAWNER_ACT_COFFINS_UNLOADED,
	COIN_FORMATION_ACT_IDLE = COIN_FORMATION_ACT_IDLE,
	COIN_FORMATION_ACT_RESPAWN_COINS = COIN_FORMATION_ACT_RESPAWN_COINS,
	COIN_FORMATION_ACT_SPAWN_COINS = COIN_FORMATION_ACT_SPAWN_COINS,
	COIN_FORMATION_BP_ARROW = COIN_FORMATION_BP_ARROW,
	COIN_FORMATION_BP_FLAG_ARROW = COIN_FORMATION_BP_FLAG_ARROW,
	COIN_FORMATION_BP_FLAG_FLYING = COIN_FORMATION_BP_FLAG_FLYING,
	COIN_FORMATION_BP_FLAG_HORIZONTAL = COIN_FORMATION_BP_FLAG_HORIZONTAL,
	COIN_FORMATION_BP_FLAG_MASK = COIN_FORMATION_BP_FLAG_MASK,
	COIN_FORMATION_BP_FLAG_RING = COIN_FORMATION_BP_FLAG_RING,
	COIN_FORMATION_BP_FLAG_VERTICAL = COIN_FORMATION_BP_FLAG_VERTICAL,
	COIN_FORMATION_BP_LINE_HORIZONTAL = COIN_FORMATION_BP_LINE_HORIZONTAL,
	COIN_FORMATION_BP_LINE_VERTICAL = COIN_FORMATION_BP_LINE_VERTICAL,
	COIN_FORMATION_BP_RING_HORIZONTAL = COIN_FORMATION_BP_RING_HORIZONTAL,
	COIN_FORMATION_BP_RING_VERTICAL = COIN_FORMATION_BP_RING_VERTICAL,
	DIALOG_FLAG_NONE = DIALOG_FLAG_NONE,
	DIALOG_FLAG_TEXT_DEFAULT = DIALOG_FLAG_TEXT_DEFAULT,
	DIALOG_FLAG_TEXT_RESPONSE = DIALOG_FLAG_TEXT_RESPONSE,
	DIALOG_FLAG_TIME_STOP_ENABLED = DIALOG_FLAG_TIME_STOP_ENABLED,
	DIALOG_FLAG_TURN_TO_MARIO = DIALOG_FLAG_TURN_TO_MARIO,
	DIALOG_FLAG_UNK_CAPSWITCH = DIALOG_FLAG_UNK_CAPSWITCH,
	DIALOG_STATUS_DISABLE_TIME_STOP = DIALOG_STATUS_DISABLE_TIME_STOP,
	DIALOG_STATUS_ENABLE_TIME_STOP = DIALOG_STATUS_ENABLE_TIME_STOP,
	DIALOG_STATUS_INTERRUPT = DIALOG_STATUS_INTERRUPT,
	DIALOG_STATUS_START_DIALOG = DIALOG_STATUS_START_DIALOG,
	DIALOG_STATUS_STOP_DIALOG = DIALOG_STATUS_STOP_DIALOG,
	ENEMY_LAKITU_ACT_MAIN = ENEMY_LAKITU_ACT_MAIN,
	ENEMY_LAKITU_ACT_UNINITIALIZED = ENEMY_LAKITU_ACT_UNINITIALIZED,
	ENEMY_LAKITU_SUB_ACT_HOLD_SPINY = ENEMY_LAKITU_SUB_ACT_HOLD_SPINY,
	ENEMY_LAKITU_SUB_ACT_NO_SPINY = ENEMY_LAKITU_SUB_ACT_NO_SPINY,
	ENEMY_LAKITU_SUB_ACT_THROW_SPINY = ENEMY_LAKITU_SUB_ACT_THROW_SPINY,
	FIRE_SPITTER_ACT_IDLE = FIRE_SPITTER_ACT_IDLE,
	FIRE_SPITTER_ACT_SPIT_FIRE = FIRE_SPITTER_ACT_SPIT_FIRE,
	GOOMBA_ACT_ATTACKED_MARIO = GOOMBA_ACT_ATTACKED_MARIO,
	GOOMBA_ACT_JUMP = GOOMBA_ACT_JUMP,
	GOOMBA_ACT_WALK = GOOMBA_ACT_WALK,
	GOOMBA_BP_SIZE_MASK = GOOMBA_BP_SIZE_MASK,
	GOOMBA_BP_TRIPLET_FLAG_MASK = GOOMBA_BP_TRIPLET_FLAG_MASK,
	GOOMBA_SIZE_HUGE = GOOMBA_SIZE_HUGE,
	GOOMBA_SIZE_REGULAR = GOOMBA_SIZE_REGULAR,
	GOOMBA_SIZE_TINY = GOOMBA_SIZE_TINY,
	GOOMBA_TRIPLET_SPAWNER_ACT_LOADED = GOOMBA_TRIPLET_SPAWNER_ACT_LOADED,
	GOOMBA_TRIPLET_SPAWNER_ACT_UNLOADED = GOOMBA_TRIPLET_SPAWNER_ACT_UNLOADED,
	GOOMBA_TRIPLET_SPAWNER_BP_EXTRA_GOOMBAS_MASK = GOOMBA_TRIPLET_SPAWNER_BP_EXTRA_GOOMBAS_MASK,
	GOOMBA_TRIPLET_SPAWNER_BP_SIZE_MASK = GOOMBA_TRIPLET_SPAWNER_BP_SIZE_MASK,
	GRINDEL_THWOMP_ACT_IDLE_AT_BOTTOM = GRINDEL_THWOMP_ACT_IDLE_AT_BOTTOM,
	GRINDEL_THWOMP_ACT_IDLE_AT_TOP = GRINDEL_THWOMP_ACT_IDLE_AT_TOP,
	GRINDEL_THWOMP_ACT_LAND = GRINDEL_THWOMP_ACT_LAND,
	GRINDEL_THWOMP_ACT_LOWER = GRINDEL_THWOMP_ACT_LOWER,
	GRINDEL_THWOMP_ACT_RAISE = GRINDEL_THWOMP_ACT_RAISE,
	HAUNTED_BOOKSHELF_ACT_IDLE = HAUNTED_BOOKSHELF_ACT_IDLE,
	HAUNTED_BOOKSHELF_ACT_RECEDE = HAUNTED_BOOKSHELF_ACT_RECEDE,
	HELD_DROPPED = HELD_DROPPED,
	HELD_FREE = HELD_FREE,
	HELD_HELD = HELD_HELD,
	HELD_THROWN = HELD_THROWN,
	HIDDEN_BLUE_COIN_ACT_ACTIVE = HIDDEN_BLUE_COIN_ACT_ACTIVE,
	HIDDEN_BLUE_COIN_ACT_INACTIVE = HIDDEN_BLUE_COIN_ACT_INACTIVE,
	HIDDEN_BLUE_COIN_ACT_WAITING = HIDDEN_BLUE_COIN_ACT_WAITING,
	HOMING_AMP_ACT_APPEAR = HOMING_AMP_ACT_APPEAR,
	HOMING_AMP_ACT_ATTACK_COOLDOWN = HOMING_AMP_ACT_ATTACK_COOLDOWN,
	HOMING_AMP_ACT_CHASE = HOMING_AMP_ACT_CHASE,
	HOMING_AMP_ACT_GIVE_UP = HOMING_AMP_ACT_GIVE_UP,
	HOMING_AMP_ACT_INACTIVE = HOMING_AMP_ACT_INACTIVE,
	MAD_PIANO_ACT_ATTACK = MAD_PIANO_ACT_ATTACK,
	MAD_PIANO_ACT_WAIT = MAD_PIANO_ACT_WAIT,
	MOV_YCOIN_ACT_BLINKING = MOV_YCOIN_ACT_BLINKING,
	MOV_YCOIN_ACT_DEATH_PLANE_DEATH = MOV_YCOIN_ACT_DEATH_PLANE_DEATH,
	MOV_YCOIN_ACT_IDLE = MOV_YCOIN_ACT_IDLE,
	MOV_YCOIN_ACT_LAVA_DEATH = MOV_YCOIN_ACT_LAVA_DEATH,
	OBJ_ACT_DEATH_PLANE_DEATH = OBJ_ACT_DEATH_PLANE_DEATH,
	OBJ_ACT_HORIZONTAL_KNOCKBACK = OBJ_ACT_HORIZONTAL_KNOCKBACK,
	OBJ_ACT_LAVA_DEATH = OBJ_ACT_LAVA_DEATH,
	OBJ_ACT_SQUISHED = OBJ_ACT_SQUISHED,
	OBJ_ACT_VERTICAL_KNOCKBACK = OBJ_ACT_VERTICAL_KNOCKBACK,
	OBJ_FLAG_0020 = OBJ_FLAG_0020,
	OBJ_FLAG_0100 = OBJ_FLAG_0100,
	OBJ_FLAG_1000 = OBJ_FLAG_1000,
	OBJ_FLAG_30 = OBJ_FLAG_30,
	OBJ_FLAG_8000 = OBJ_FLAG_8000,
	OBJ_FLAG_ACTIVE_FROM_AFAR = OBJ_FLAG_ACTIVE_FROM_AFAR,
	OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO = OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO,
	OBJ_FLAG_COMPUTE_DIST_TO_MARIO = OBJ_FLAG_COMPUTE_DIST_TO_MARIO,
	OBJ_FLAG_HOLDABLE = OBJ_FLAG_HOLDABLE,
	OBJ_FLAG_MOVE_XZ_USING_FVEL = OBJ_FLAG_MOVE_XZ_USING_FVEL,
	OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL = OBJ_FLAG_MOVE_Y_WITH_TERMINAL_VEL,
	OBJ_FLAG_PERSISTENT_RESPAWN = OBJ_FLAG_PERSISTENT_RESPAWN,
	OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE = OBJ_FLAG_SET_FACE_ANGLE_TO_MOVE_ANGLE,
	OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW,
	OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM = OBJ_FLAG_SET_THROW_MATRIX_FROM_TRANSFORM,
	OBJ_FLAG_TRANSFORM_RELATIVE_TO_PARENT = OBJ_FLAG_TRANSFORM_RELATIVE_TO_PARENT,
	OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE,
	OBJ_MOVE_8 = OBJ_MOVE_8,
	OBJ_MOVE_ABOVE_DEATH_BARRIER = OBJ_MOVE_ABOVE_DEATH_BARRIER,
	OBJ_MOVE_ABOVE_LAVA = OBJ_MOVE_ABOVE_LAVA,
	OBJ_MOVE_AT_WATER_SURFACE = OBJ_MOVE_AT_WATER_SURFACE,
	OBJ_MOVE_BOUNCE = OBJ_MOVE_BOUNCE,
	OBJ_MOVE_ENTERED_WATER = OBJ_MOVE_ENTERED_WATER,
	OBJ_MOVE_HIT_EDGE = OBJ_MOVE_HIT_EDGE,
	OBJ_MOVE_HIT_WALL = OBJ_MOVE_HIT_WALL,
	OBJ_MOVE_IN_AIR = OBJ_MOVE_IN_AIR,
	OBJ_MOVE_LANDED = OBJ_MOVE_LANDED,
	OBJ_MOVE_LEAVING_WATER = OBJ_MOVE_LEAVING_WATER,
	OBJ_MOVE_LEFT_GROUND = OBJ_MOVE_LEFT_GROUND,
	OBJ_MOVE_MASK_33 = OBJ_MOVE_MASK_33,
	OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER = OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER,
	OBJ_MOVE_MASK_IN_WATER = OBJ_MOVE_MASK_IN_WATER,
	OBJ_MOVE_MASK_NOT_AIR = OBJ_MOVE_MASK_NOT_AIR,
	OBJ_MOVE_MASK_ON_GROUND = OBJ_MOVE_MASK_ON_GROUND,
	OBJ_MOVE_ON_GROUND = OBJ_MOVE_ON_GROUND,
	OBJ_MOVE_UNDERWATER_OFF_GROUND = OBJ_MOVE_UNDERWATER_OFF_GROUND,
	OBJ_MOVE_UNDERWATER_ON_GROUND = OBJ_MOVE_UNDERWATER_ON_GROUND,
	O_FACE_ANGLE_INDEX = O_FACE_ANGLE_INDEX,
	O_FACE_ANGLE_PITCH_INDEX = O_FACE_ANGLE_PITCH_INDEX,
	O_FACE_ANGLE_ROLL_INDEX = O_FACE_ANGLE_ROLL_INDEX,
	O_FACE_ANGLE_YAW_INDEX = O_FACE_ANGLE_YAW_INDEX,
	O_MOVE_ANGLE_INDEX = O_MOVE_ANGLE_INDEX,
	O_MOVE_ANGLE_PITCH_INDEX = O_MOVE_ANGLE_PITCH_INDEX,
	O_MOVE_ANGLE_ROLL_INDEX = O_MOVE_ANGLE_ROLL_INDEX,
	O_MOVE_ANGLE_YAW_INDEX = O_MOVE_ANGLE_YAW_INDEX,
	O_PARENT_RELATIVE_POS_INDEX = O_PARENT_RELATIVE_POS_INDEX,
	O_POS_INDEX = O_POS_INDEX,
	RESPAWN_INFO_DONT_RESPAWN = RESPAWN_INFO_DONT_RESPAWN,
	RESPAWN_INFO_TYPE_16 = RESPAWN_INFO_TYPE_16,
	RESPAWN_INFO_TYPE_32 = RESPAWN_INFO_TYPE_32,
	RESPAWN_INFO_TYPE_NULL = RESPAWN_INFO_TYPE_NULL,
	STAR_INDEX_100_COINS = STAR_INDEX_100_COINS,
	STAR_INDEX_ACT_1 = STAR_INDEX_ACT_1,
	STAR_INDEX_ACT_2 = STAR_INDEX_ACT_2,
	STAR_INDEX_ACT_3 = STAR_INDEX_ACT_3,
	STAR_INDEX_ACT_4 = STAR_INDEX_ACT_4,
	STAR_INDEX_ACT_5 = STAR_INDEX_ACT_5,
	STAR_INDEX_ACT_6 = STAR_INDEX_ACT_6,
	TOX_BOX_ACT_IDLE = TOX_BOX_ACT_IDLE,
	TOX_BOX_ACT_INIT = TOX_BOX_ACT_INIT,
	TOX_BOX_ACT_ROLL_BACKWARD = TOX_BOX_ACT_ROLL_BACKWARD,
	TOX_BOX_ACT_ROLL_FORWARD = TOX_BOX_ACT_ROLL_FORWARD,
	TOX_BOX_ACT_ROLL_LAND = TOX_BOX_ACT_ROLL_LAND,
	TOX_BOX_ACT_ROLL_LEFT = TOX_BOX_ACT_ROLL_LEFT,
	TOX_BOX_ACT_ROLL_RIGHT = TOX_BOX_ACT_ROLL_RIGHT,
	TOX_BOX_ACT_TABLE_END = TOX_BOX_ACT_TABLE_END,
	TOX_BOX_ACT_UNUSED_IDLE = TOX_BOX_ACT_UNUSED_IDLE,
	TOX_BOX_BP_MOVEMENT_PATTERN_1 = TOX_BOX_BP_MOVEMENT_PATTERN_1,
	TOX_BOX_BP_MOVEMENT_PATTERN_2 = TOX_BOX_BP_MOVEMENT_PATTERN_2,
	TOX_BOX_BP_MOVEMENT_PATTERN_3 = TOX_BOX_BP_MOVEMENT_PATTERN_3,
	WF_ROTATING_WOODEN_PLATFORM_ACT_IDLE = WF_ROTATING_WOODEN_PLATFORM_ACT_IDLE,
	WF_ROTATING_WOODEN_PLATFORM_ACT_ROTATING = WF_ROTATING_WOODEN_PLATFORM_ACT_ROTATING,
	WOODEN_POST_BP_NO_COINS_MASK = WOODEN_POST_BP_NO_COINS_MASK,
	o1UpHiddenUnkF4 = o1UpHiddenUnkF4,
	oAction = oAction,
	oActivatedBackAndForthPlatformCountdown = oActivatedBackAndForthPlatformCountdown,
	oActivatedBackAndForthPlatformFlipRotation = oActivatedBackAndForthPlatformFlipRotation,
	oActivatedBackAndForthPlatformMaxOffset = oActivatedBackAndForthPlatformMaxOffset,
	oActivatedBackAndForthPlatformOffset = oActivatedBackAndForthPlatformOffset,
	oActivatedBackAndForthPlatformStartYaw = oActivatedBackAndForthPlatformStartYaw,
	oActivatedBackAndForthPlatformVel = oActivatedBackAndForthPlatformVel,
	oActivatedBackAndForthPlatformVertical = oActivatedBackAndForthPlatformVertical,
	oActiveParticleFlags = oActiveParticleFlags,
	oAmpRadiusOfRotation = oAmpRadiusOfRotation,
	oAmpYPhase = oAmpYPhase,
	oAngleToHome = oAngleToHome,
	oAngleToMario = oAngleToMario,
	oAngleVelPitch = oAngleVelPitch,
	oAngleVelRoll = oAngleVelRoll,
	oAngleVelYaw = oAngleVelYaw,
	oAnimState = oAnimState,
	oAnimations = oAnimations,
	oArrowLiftDisplacement = oArrowLiftDisplacement,
	oArrowLiftUnk100 = oArrowLiftUnk100,
	oBBallSpawnerMaxSpawnDist = oBBallSpawnerMaxSpawnDist,
	oBBallSpawnerPeriodMinus1 = oBBallSpawnerPeriodMinus1,
	oBBallSpawnerSpawnOdds = oBBallSpawnerSpawnOdds,
	oBackAndForthPlatformDirection = oBackAndForthPlatformDirection,
	oBackAndForthPlatformDistance = oBackAndForthPlatformDistance,
	oBackAndForthPlatformPathLength = oBackAndForthPlatformPathLength,
	oBackAndForthPlatformVel = oBackAndForthPlatformVel,
	oBhvParams = oBhvParams,
	oBhvParams2ndByte = oBhvParams2ndByte,
	oBetaTrampolineMarioOnTrampoline = oBetaTrampolineMarioOnTrampoline,
	oBigBooNumMinionBoosKilled = oBigBooNumMinionBoosKilled,
	oBirdChirpChirpUnkF4 = oBirdChirpChirpUnkF4,
	oBirdSpeed = oBirdSpeed,
	oBirdTargetPitch = oBirdTargetPitch,
	oBirdTargetYaw = oBirdTargetYaw,
	oBitfsPlatformTimer = oBitfsPlatformTimer,
	oBlackSmokeBowserUnkF4 = oBlackSmokeBowserUnkF4,
	oBlueFishRandomAngle = oBlueFishRandomAngle,
	oBlueFishRandomTime = oBlueFishRandomTime,
	oBlueFishRandomVel = oBlueFishRandomVel,
	oBlueFlameNextScale = oBlueFlameNextScale,
	oBobombBlinkTimer = oBobombBlinkTimer,
	oBobombBuddyBlinkTimer = oBobombBuddyBlinkTimer,
	oBobombBuddyCannonStatus = oBobombBuddyCannonStatus,
	oBobombBuddyHasTalkedToMario = oBobombBuddyHasTalkedToMario,
	oBobombBuddyPosXCopy = oBobombBuddyPosXCopy,
	oBobombBuddyPosYCopy = oBobombBuddyPosYCopy,
	oBobombBuddyPosZCopy = oBobombBuddyPosZCopy,
	oBobombBuddyRole = oBobombBuddyRole,
	oBobombExpBubGfxExpRateX = oBobombExpBubGfxExpRateX,
	oBobombExpBubGfxExpRateY = oBobombExpBubGfxExpRateY,
	oBobombExpBubGfxScaleFacX = oBobombExpBubGfxScaleFacX,
	oBobombExpBubGfxScaleFacY = oBobombExpBubGfxScaleFacY,
	oBobombFuseLit = oBobombFuseLit,
	oBobombFuseTimer = oBobombFuseTimer,
	oBooBaseScale = oBooBaseScale,
	oBooDeathStatus = oBooDeathStatus,
	oBooInitialMoveYaw = oBooInitialMoveYaw,
	oBooMoveYawBeforeHit = oBooMoveYawBeforeHit,
	oBooMoveYawDuringHit = oBooMoveYawDuringHit,
	oBooNegatedAggressiveness = oBooNegatedAggressiveness,
	oBooOscillationTimer = oBooOscillationTimer,
	oBooParentBigBoo = oBooParentBigBoo,
	oBooTargetOpacity = oBooTargetOpacity,
	oBooTurningSpeed = oBooTurningSpeed,
	oBookSwitchManagerUnkF4 = oBookSwitchManagerUnkF4,
	oBookSwitchManagerUnkF8 = oBookSwitchManagerUnkF8,
	oBookSwitchUnkF4 = oBookSwitchUnkF4,
	oBookendUnkF4 = oBookendUnkF4,
	oBookendUnkF8 = oBookendUnkF8,
	oBounciness = oBounciness,
	oBouncingFireBallUnkF4 = oBouncingFireBallUnkF4,
	oBowlingBallTargetYaw = oBowlingBallTargetYaw,
	oBowserAngleToCentre = oBowserAngleToCentre,
	oBowserDistToCentre = oBowserDistToCentre,
	oBowserEyesShut = oBowserEyesShut,
	oBowserHeldAnglePitch = oBowserHeldAnglePitch,
	oBowserHeldAngleVelYaw = oBowserHeldAngleVelYaw,
	oBowserKeyScale = oBowserKeyScale,
	oBowserPuzzleCompletionFlags = oBowserPuzzleCompletionFlags,
	oBowserPuzzlePieceActionList = oBowserPuzzlePieceActionList,
	oBowserPuzzlePieceContinuePerformingAction = oBowserPuzzlePieceContinuePerformingAction,
	oBowserPuzzlePieceNextAction = oBowserPuzzlePieceNextAction,
	oBowserPuzzlePieceOffsetX = oBowserPuzzlePieceOffsetX,
	oBowserPuzzlePieceOffsetY = oBowserPuzzlePieceOffsetY,
	oBowserPuzzlePieceOffsetZ = oBowserPuzzlePieceOffsetZ,
	oBowserShockWaveUnkF4 = oBowserShockWaveUnkF4,
	oBowserUnk106 = oBowserUnk106,
	oBowserUnk108 = oBowserUnk108,
	oBowserUnk10E = oBowserUnk10E,
	oBowserUnk110 = oBowserUnk110,
	oBowserUnk1AC = oBowserUnk1AC,
	oBowserUnk1AE = oBowserUnk1AE,
	oBowserUnk1B2 = oBowserUnk1B2,
	oBowserUnk88 = oBowserUnk88,
	oBowserUnkF4 = oBowserUnkF4,
	oBowserUnkF8 = oBowserUnkF8,
	oBubbaUnk100 = oBubbaUnk100,
	oBubbaUnk104 = oBubbaUnk104,
	oBubbaUnk108 = oBubbaUnk108,
	oBubbaUnk10C = oBubbaUnk10C,
	oBubbaUnk1AC = oBubbaUnk1AC,
	oBubbaUnk1AE = oBubbaUnk1AE,
	oBubbaUnk1B0 = oBubbaUnk1B0,
	oBubbaUnk1B2 = oBubbaUnk1B2,
	oBubbaUnkF4 = oBubbaUnkF4,
	oBubbaUnkF8 = oBubbaUnkF8,
	oBubbaUnkFC = oBubbaUnkFC,
	oBulletBillInitialMoveYaw = oBulletBillInitialMoveYaw,
	oBullyKBTimerAndMinionKOCounter = oBullyKBTimerAndMinionKOCounter,
	oBullyMarioCollisionAngle = oBullyMarioCollisionAngle,
	oBullyPrevX = oBullyPrevX,
	oBullyPrevY = oBullyPrevY,
	oBullyPrevZ = oBullyPrevZ,
	oBullySubtype = oBullySubtype,
	oBuoyancy = oBuoyancy,
	oButterflyYPhase = oButterflyYPhase,
	oCameraLakituBlinkTimer = oCameraLakituBlinkTimer,
	oCameraLakituCircleRadius = oCameraLakituCircleRadius,
	oCameraLakituFinishedDialog = oCameraLakituFinishedDialog,
	oCameraLakituPitchVel = oCameraLakituPitchVel,
	oCameraLakituSpeed = oCameraLakituSpeed,
	oCameraLakituUnk104 = oCameraLakituUnk104,
	oCameraLakituYawVel = oCameraLakituYawVel,
	oCannonUnk10C = oCannonUnk10C,
	oCannonUnkF4 = oCannonUnkF4,
	oCannonUnkF8 = oCannonUnkF8,
	oCapUnkF4 = oCapUnkF4,
	oCapUnkF8 = oCapUnkF8,
	oCelebStarDiameterOfRotation = oCelebStarDiameterOfRotation,
	oCelebStarUnkF4 = oCelebStarUnkF4,
	oChainChompDistToPivot = oChainChompDistToPivot,
	oChainChompHitGate = oChainChompHitGate,
	oChainChompMaxDistBetweenChainParts = oChainChompMaxDistBetweenChainParts,
	oChainChompMaxDistFromPivotPerChainPart = oChainChompMaxDistFromPivotPerChainPart,
	oChainChompNumLunges = oChainChompNumLunges,
	oChainChompReleaseStatus = oChainChompReleaseStatus,
	oChainChompRestrictedByChain = oChainChompRestrictedByChain,
	oChainChompSegments = oChainChompSegments,
	oChainChompTargetPitch = oChainChompTargetPitch,
	oChainChompUnk104 = oChainChompUnk104,
	oCheckerBoardPlatformUnk1AC = oCheckerBoardPlatformUnk1AC,
	oCheckerBoardPlatformUnkF8 = oCheckerBoardPlatformUnkF8,
	oCheckerBoardPlatformUnkFC = oCheckerBoardPlatformUnkFC,
	oCheepCheepUnk104 = oCheepCheepUnk104,
	oCheepCheepUnk108 = oCheepCheepUnk108,
	oCheepCheepUnkF4 = oCheepCheepUnkF4,
	oCheepCheepUnkF8 = oCheepCheepUnkF8,
	oCheepCheepUnkFC = oCheepCheepUnkFC,
	oChuckyaUnk100 = oChuckyaUnk100,
	oChuckyaUnk88 = oChuckyaUnk88,
	oChuckyaUnkF8 = oChuckyaUnkF8,
	oChuckyaUnkFC = oChuckyaUnkFC,
	oClamUnkF4 = oClamUnkF4,
	oCloudBlowing = oCloudBlowing,
	oCloudCenterX = oCloudCenterX,
	oCloudCenterY = oCloudCenterY,
	oCloudFwooshMovementRadius = oCloudFwooshMovementRadius,
	oCloudGrowSpeed = oCloudGrowSpeed,
	oCoinBaseVelY = oCoinBaseVelY,
	oCoinCollectedFlags = oCoinCollectedFlags,
	oCoinNumBounceSoundPlayed = oCoinNumBounceSoundPlayed,
	oCoinOnGround = oCoinOnGround,
	oCollisionDistance = oCollisionDistance,
	oCollisionParticleUnkF4 = oCollisionParticleUnkF4,
	oControllablePlatformUnk100 = oControllablePlatformUnk100,
	oControllablePlatformUnkF8 = oControllablePlatformUnkF8,
	oControllablePlatformUnkFC = oControllablePlatformUnkFC,
	oDDDPoleMaxOffset = oDDDPoleMaxOffset,
	oDDDPoleOffset = oDDDPoleOffset,
	oDDDPoleVel = oDDDPoleVel,
	oDamageOrCoinValue = oDamageOrCoinValue,
	oDeathSound = oDeathSound,
	oDialogResponse = oDialogResponse,
	oDialogState = oDialogState,
	oDistanceToMario = oDistanceToMario,
	oDonutPlatformSpawnerSpawnedPlatforms = oDonutPlatformSpawnerSpawnedPlatforms,
	oDorrieAngleToHome = oDorrieAngleToHome,
	oDorrieDistToHome = oDorrieDistToHome,
	oDorrieForwardDistToMario = oDorrieForwardDistToMario,
	oDorrieGroundPounded = oDorrieGroundPounded,
	oDorrieHeadRaiseSpeed = oDorrieHeadRaiseSpeed,
	oDorrieLiftingMario = oDorrieLiftingMario,
	oDorrieNeckAngle = oDorrieNeckAngle,
	oDorrieOffsetY = oDorrieOffsetY,
	oDorrieVelY = oDorrieVelY,
	oDorrieYawVel = oDorrieYawVel,
	oDragStrength = oDragStrength,
	oDrawingDistance = oDrawingDistance,
	oElevatorUnk100 = oElevatorUnk100,
	oElevatorUnkF4 = oElevatorUnkF4,
	oElevatorUnkF8 = oElevatorUnkF8,
	oElevatorUnkFC = oElevatorUnkFC,
	oEndBirdUnk104 = oEndBirdUnk104,
	oEnemyLakituBlinkTimer = oEnemyLakituBlinkTimer,
	oEnemyLakituFaceForwardCountdown = oEnemyLakituFaceForwardCountdown,
	oEnemyLakituNumSpinies = oEnemyLakituNumSpinies,
	oEnemyLakituSpinyCooldown = oEnemyLakituSpinyCooldown,
	oExclamationBoxUnkF4 = oExclamationBoxUnkF4,
	oExclamationBoxUnkF8 = oExclamationBoxUnkF8,
	oExclamationBoxUnkFC = oExclamationBoxUnkFC,
	oEyerokBossActiveHand = oEyerokBossActiveHand,
	oEyerokBossNumHands = oEyerokBossNumHands,
	oEyerokBossUnk104 = oEyerokBossUnk104,
	oEyerokBossUnk108 = oEyerokBossUnk108,
	oEyerokBossUnk10C = oEyerokBossUnk10C,
	oEyerokBossUnk110 = oEyerokBossUnk110,
	oEyerokBossUnk1AC = oEyerokBossUnk1AC,
	oEyerokBossUnkFC = oEyerokBossUnkFC,
	oEyerokHandUnk100 = oEyerokHandUnk100,
	oEyerokHandUnkFC = oEyerokHandUnkFC,
	oEyerokHandWakeUpTimer = oEyerokHandWakeUpTimer,
	oEyerokReceivedAttack = oEyerokReceivedAttack,
	oFaceAnglePitch = oFaceAnglePitch,
	oFaceAngleRoll = oFaceAngleRoll,
	oFaceAngleYaw = oFaceAngleYaw,
	oFallingPillarPitchAcceleration = oFallingPillarPitchAcceleration,
	oFirePiranhaPlantActive = oFirePiranhaPlantActive,
	oFirePiranhaPlantDeathSpinTimer = oFirePiranhaPlantDeathSpinTimer,
	oFirePiranhaPlantDeathSpinVel = oFirePiranhaPlantDeathSpinVel,
	oFirePiranhaPlantNeutralScale = oFirePiranhaPlantNeutralScale,
	oFirePiranhaPlantScale = oFirePiranhaPlantScale,
	oFireSpitterScaleVel = oFireSpitterScaleVel,
	oFishActiveDistance = oFishActiveDistance,
	oFishDepthDistance = oFishDepthDistance,
	oFishGoalVel = oFishGoalVel,
	oFishGoalY = oFishGoalY,
	oFishHeightOffset = oFishHeightOffset,
	oFishRoamDistance = oFishRoamDistance,
	oFishWaterLevel = oFishWaterLevel,
	oFishYawVel = oFishYawVel,
	oFlags = oFlags,
	oFlameBowser = oFlameBowser,
	oFlameScale = oFlameScale,
	oFlameSpeedTimerOffset = oFlameSpeedTimerOffset,
	oFlameThowerFlameUnk110 = oFlameThowerFlameUnk110,
	oFlameThowerUnk110 = oFlameThowerUnk110,
	oFlameUnkFC = oFlameUnkFC,
	oFloatingPlatformUnk100 = oFloatingPlatformUnk100,
	oFloatingPlatformUnkF4 = oFloatingPlatformUnkF4,
	oFloatingPlatformUnkF8 = oFloatingPlatformUnkF8,
	oFloatingPlatformUnkFC = oFloatingPlatformUnkFC,
	oFloor = oFloor,
	oFloorHeight = oFloorHeight,
	oFloorRoom = oFloorRoom,
	oFloorSwitchPressAnimationUnk100 = oFloorSwitchPressAnimationUnk100,
	oFloorSwitchPressAnimationUnkF4 = oFloorSwitchPressAnimationUnkF4,
	oFloorSwitchPressAnimationUnkF8 = oFloorSwitchPressAnimationUnkF8,
	oFloorSwitchPressAnimationUnkFC = oFloorSwitchPressAnimationUnkFC,
	oFloorType = oFloorType,
	oFlyGuyIdleTimer = oFlyGuyIdleTimer,
	oFlyGuyLungeTargetPitch = oFlyGuyLungeTargetPitch,
	oFlyGuyLungeYDecel = oFlyGuyLungeYDecel,
	oFlyGuyOscTimer = oFlyGuyOscTimer,
	oFlyGuyScaleVel = oFlyGuyScaleVel,
	oFlyGuyTargetRoll = oFlyGuyTargetRoll,
	oFlyGuyUnusedJitter = oFlyGuyUnusedJitter,
	oForwardVel = oForwardVel,
	oForwardVelS32 = oForwardVelS32,
	oFriction = oFriction,
	oGoombaBlinkTimer = oGoombaBlinkTimer,
	oGoombaRelativeSpeed = oGoombaRelativeSpeed,
	oGoombaScale = oGoombaScale,
	oGoombaSize = oGoombaSize,
	oGoombaTargetYaw = oGoombaTargetYaw,
	oGoombaTurningAwayFromWall = oGoombaTurningAwayFromWall,
	oGoombaWalkTimer = oGoombaWalkTimer,
	oGrandStarUnk108 = oGrandStarUnk108,
	oGraphYOffset = oGraphYOffset,
	oGravity = oGravity,
	oGrindelThwompRandomTimer = oGrindelThwompRandomTimer,
	oHauntedBookshelfShouldOpen = oHauntedBookshelfShouldOpen,
	oHauntedChairUnk100 = oHauntedChairUnk100,
	oHauntedChairUnk104 = oHauntedChairUnk104,
	oHauntedChairUnkF4 = oHauntedChairUnkF4,
	oHauntedChairUnkF8 = oHauntedChairUnkF8,
	oHauntedChairUnkFC = oHauntedChairUnkFC,
	oHealth = oHealth,
	oHeaveHoUnk88 = oHeaveHoUnk88,
	oHeaveHoUnkF4 = oHeaveHoUnkF4,
	oHeldState = oHeldState,
	oHiddenBlueCoinSwitch = oHiddenBlueCoinSwitch,
	oHiddenStarTriggerCounter = oHiddenStarTriggerCounter,
	oHomeX = oHomeX,
	oHomeY = oHomeY,
	oHomeZ = oHomeZ,
	oHomingAmpAvgY = oHomingAmpAvgY,
	oHomingAmpLockedOn = oHomingAmpLockedOn,
	oHootAvailability = oHootAvailability,
	oHootMarioReleaseTime = oHootMarioReleaseTime,
	oHorizontalGrindelDistToHome = oHorizontalGrindelDistToHome,
	oHorizontalGrindelOnGround = oHorizontalGrindelOnGround,
	oHorizontalGrindelTargetYaw = oHorizontalGrindelTargetYaw,
	oHorizontalMovementUnk100 = oHorizontalMovementUnk100,
	oHorizontalMovementUnk104 = oHorizontalMovementUnk104,
	oHorizontalMovementUnk108 = oHorizontalMovementUnk108,
	oHorizontalMovementUnkF4 = oHorizontalMovementUnkF4,
	oHorizontalMovementUnkF8 = oHorizontalMovementUnkF8,
	oIntangibleTimer = oIntangibleTimer,
	oInteractStatus = oInteractStatus,
	oInteractType = oInteractType,
	oInteractionSubtype = oInteractionSubtype,
	oIntroLakituCloud = oIntroLakituCloud,
	oIntroLakituSplineSegment = oIntroLakituSplineSegment,
	oIntroLakituSplineSegmentProgress = oIntroLakituSplineSegmentProgress,
	oIntroLakituUnk100 = oIntroLakituUnk100,
	oIntroLakituUnk104 = oIntroLakituUnk104,
	oIntroLakituUnk108 = oIntroLakituUnk108,
	oIntroLakituUnk10C = oIntroLakituUnk10C,
	oIntroLakituUnk110 = oIntroLakituUnk110,
	oIntroPeachDistToCamera = oIntroPeachDistToCamera,
	oIntroPeachPitchFromFocus = oIntroPeachPitchFromFocus,
	oIntroPeachYawFromFocus = oIntroPeachYawFromFocus,
	oJrbSlidingBoxUnkF4 = oJrbSlidingBoxUnkF4,
	oJrbSlidingBoxUnkF8 = oJrbSlidingBoxUnkF8,
	oJrbSlidingBoxUnkFC = oJrbSlidingBoxUnkFC,
	oJumpingBoxUnkF4 = oJumpingBoxUnkF4,
	oJumpingBoxUnkF8 = oJumpingBoxUnkF8,
	oKickableBoardF4 = oKickableBoardF4,
	oKickableBoardF8 = oKickableBoardF8,
	oKingBobombUnk100 = oKingBobombUnk100,
	oKingBobombUnk104 = oKingBobombUnk104,
	oKingBobombUnk108 = oKingBobombUnk108,
	oKingBobombUnk88 = oKingBobombUnk88,
	oKingBobombUnkF8 = oKingBobombUnkF8,
	oKingBobombUnkFC = oKingBobombUnkFC,
	oKleptoDistanceToTarget = oKleptoDistanceToTarget,
	oKleptoSpeed = oKleptoSpeed,
	oKleptoStartPosX = oKleptoStartPosX,
	oKleptoStartPosY = oKleptoStartPosY,
	oKleptoStartPosZ = oKleptoStartPosZ,
	oKleptoTargetNumber = oKleptoTargetNumber,
	oKleptoTimeUntilTargetChange = oKleptoTimeUntilTargetChange,
	oKleptoUnk1AE = oKleptoUnk1AE,
	oKleptoUnk1B0 = oKleptoUnk1B0,
	oKleptoUnkF8 = oKleptoUnkF8,
	oKleptoUnkFC = oKleptoUnkFC,
	oKleptoYawToTarget = oKleptoYawToTarget,
	oKoopaAgility = oKoopaAgility,
	oKoopaAngleToMario = oKoopaAngleToMario,
	oKoopaBlinkTimer = oKoopaBlinkTimer,
	oKoopaCountdown = oKoopaCountdown,
	oKoopaDistanceToMario = oKoopaDistanceToMario,
	oKoopaMovementType = oKoopaMovementType,
	oKoopaRaceEndpointKoopaFinished = oKoopaRaceEndpointKoopaFinished,
	oKoopaRaceEndpointRaceBegun = oKoopaRaceEndpointRaceBegun,
	oKoopaRaceEndpointRaceEnded = oKoopaRaceEndpointRaceEnded,
	oKoopaRaceEndpointRaceStatus = oKoopaRaceEndpointRaceStatus,
	oKoopaRaceEndpointUnk100 = oKoopaRaceEndpointUnk100,
	oKoopaShellFlameUnkF4 = oKoopaShellFlameUnkF4,
	oKoopaShellFlameUnkF8 = oKoopaShellFlameUnkF8,
	oKoopaTargetYaw = oKoopaTargetYaw,
	oKoopaTheQuickInitTextboxCooldown = oKoopaTheQuickInitTextboxCooldown,
	oKoopaTheQuickRaceIndex = oKoopaTheQuickRaceIndex,
	oKoopaTurningAwayFromWall = oKoopaTurningAwayFromWall,
	oKoopaUnshelledTimeUntilTurn = oKoopaUnshelledTimeUntilTurn,
	oLllRotatingHexFlameUnkF4 = oLllRotatingHexFlameUnkF4,
	oLllRotatingHexFlameUnkF8 = oLllRotatingHexFlameUnkF8,
	oLllRotatingHexFlameUnkFC = oLllRotatingHexFlameUnkFC,
	oLllWoodPieceOscillationTimer = oLllWoodPieceOscillationTimer,
	oMacroUnk108 = oMacroUnk108,
	oMacroUnk10C = oMacroUnk10C,
	oMacroUnk110 = oMacroUnk110,
	oMantaTargetPitch = oMantaTargetPitch,
	oMantaTargetYaw = oMantaTargetYaw,
	oMarioBurnTimer = oMarioBurnTimer,
	oMarioCannonInputYaw = oMarioCannonInputYaw,
	oMarioCannonObjectYaw = oMarioCannonObjectYaw,
	oMarioLongJumpIsSlow = oMarioLongJumpIsSlow,
	oMarioParticleFlags = oMarioParticleFlags,
	oMarioPolePos = oMarioPolePos,
	oMarioPoleUnk108 = oMarioPoleUnk108,
	oMarioPoleYawVel = oMarioPoleYawVel,
	oMarioReadingSignDPosX = oMarioReadingSignDPosX,
	oMarioReadingSignDPosZ = oMarioReadingSignDPosZ,
	oMarioReadingSignDYaw = oMarioReadingSignDYaw,
	oMarioSteepJumpYaw = oMarioSteepJumpYaw,
	oMarioTornadoPosY = oMarioTornadoPosY,
	oMarioTornadoYawVel = oMarioTornadoYawVel,
	oMarioWalkingPitch = oMarioWalkingPitch,
	oMarioWhirlpoolPosY = oMarioWhirlpoolPosY,
	oMenuButtonActionPhase = oMenuButtonActionPhase,
	oMenuButtonOrigPosX = oMenuButtonOrigPosX,
	oMenuButtonOrigPosY = oMenuButtonOrigPosY,
	oMenuButtonOrigPosZ = oMenuButtonOrigPosZ,
	oMenuButtonScale = oMenuButtonScale,
	oMenuButtonState = oMenuButtonState,
	oMenuButtonTimer = oMenuButtonTimer,
	oMerryGoRoundBooManagerNumBoosKilled = oMerryGoRoundBooManagerNumBoosKilled,
	oMerryGoRoundBooManagerNumBoosSpawned = oMerryGoRoundBooManagerNumBoosSpawned,
	oMerryGoRoundMarioIsOutside = oMerryGoRoundMarioIsOutside,
	oMerryGoRoundMusicShouldPlay = oMerryGoRoundMusicShouldPlay,
	oMerryGoRoundStopped = oMerryGoRoundStopped,
	oMipsForwardVelocity = oMipsForwardVelocity,
	oMipsStarStatus = oMipsStarStatus,
	oMipsStartWaypointIndex = oMipsStartWaypointIndex,
	oMoneybagJumpState = oMoneybagJumpState,
	oMontyMoleCurrentHole = oMontyMoleCurrentHole,
	oMontyMoleHeightRelativeToFloor = oMontyMoleHeightRelativeToFloor,
	oMontyMoleHoleCooldown = oMontyMoleHoleCooldown,
	oMoveAnglePitch = oMoveAnglePitch,
	oMoveAngleRoll = oMoveAngleRoll,
	oMoveAngleYaw = oMoveAngleYaw,
	oMoveFlags = oMoveFlags,
	oMovingFlameTimer = oMovingFlameTimer,
	oMrBlizzardChangeInDizziness = oMrBlizzardChangeInDizziness,
	oMrBlizzardDistFromHome = oMrBlizzardDistFromHome,
	oMrBlizzardDizziness = oMrBlizzardDizziness,
	oMrBlizzardGraphYOffset = oMrBlizzardGraphYOffset,
	oMrBlizzardGraphYVel = oMrBlizzardGraphYVel,
	oMrBlizzardHeldObj = oMrBlizzardHeldObj,
	oMrBlizzardScale = oMrBlizzardScale,
	oMrBlizzardTargetMoveYaw = oMrBlizzardTargetMoveYaw,
	oMrBlizzardTimer = oMrBlizzardTimer,
	oMrIScale = oMrIScale,
	oMrIUnk100 = oMrIUnk100,
	oMrIUnk104 = oMrIUnk104,
	oMrIUnk108 = oMrIUnk108,
	oMrIUnk110 = oMrIUnk110,
	oMrIUnkF4 = oMrIUnkF4,
	oMrIUnkFC = oMrIUnkFC,
	oNumLootCoins = oNumLootCoins,
	oOpacity = oOpacity,
	oOpenableGrillUnk88 = oOpenableGrillUnk88,
	oOpenableGrillUnkF4 = oOpenableGrillUnkF4,
	oParentRelativePosX = oParentRelativePosX,
	oParentRelativePosY = oParentRelativePosY,
	oParentRelativePosZ = oParentRelativePosZ,
	oPathedPrevWaypoint = oPathedPrevWaypoint,
	oPathedPrevWaypointFlags = oPathedPrevWaypointFlags,
	oPathedStartWaypoint = oPathedStartWaypoint,
	oPathedTargetPitch = oPathedTargetPitch,
	oPathedTargetYaw = oPathedTargetYaw,
	oPiranhaPlantScale = oPiranhaPlantScale,
	oPiranhaPlantSleepMusicState = oPiranhaPlantSleepMusicState,
	oPitouneUnkF4 = oPitouneUnkF4,
	oPitouneUnkF8 = oPitouneUnkF8,
	oPitouneUnkFC = oPitouneUnkFC,
	oPlatformOnTrackBaseBallIndex = oPlatformOnTrackBaseBallIndex,
	oPlatformOnTrackDistMovedSinceLastBall = oPlatformOnTrackDistMovedSinceLastBall,
	oPlatformOnTrackIsNotHMC = oPlatformOnTrackIsNotHMC,
	oPlatformOnTrackIsNotSkiLift = oPlatformOnTrackIsNotSkiLift,
	oPlatformOnTrackOffsetY = oPlatformOnTrackOffsetY,
	oPlatformOnTrackPitch = oPlatformOnTrackPitch,
	oPlatformOnTrackPrevWaypoint = oPlatformOnTrackPrevWaypoint,
	oPlatformOnTrackPrevWaypointFlags = oPlatformOnTrackPrevWaypointFlags,
	oPlatformOnTrackSkiLiftRollVel = oPlatformOnTrackSkiLiftRollVel,
	oPlatformOnTrackStartWaypoint = oPlatformOnTrackStartWaypoint,
	oPlatformOnTrackType = oPlatformOnTrackType,
	oPlatformOnTrackWasStoodOn = oPlatformOnTrackWasStoodOn,
	oPlatformOnTrackYaw = oPlatformOnTrackYaw,
	oPlatformSpawnerUnk100 = oPlatformSpawnerUnk100,
	oPlatformSpawnerUnk104 = oPlatformSpawnerUnk104,
	oPlatformSpawnerUnk108 = oPlatformSpawnerUnk108,
	oPlatformSpawnerUnkF4 = oPlatformSpawnerUnkF4,
	oPlatformSpawnerUnkF8 = oPlatformSpawnerUnkF8,
	oPlatformSpawnerUnkFC = oPlatformSpawnerUnkFC,
	oPlatformTimer = oPlatformTimer,
	oPlatformUnk10C = oPlatformUnk10C,
	oPlatformUnk110 = oPlatformUnk110,
	oPlatformUnkF8 = oPlatformUnkF8,
	oPlatformUnkFC = oPlatformUnkFC,
	oPokeyAliveBodyPartFlags = oPokeyAliveBodyPartFlags,
	oPokeyBodyPartBlinkTimer = oPokeyBodyPartBlinkTimer,
	oPokeyBodyPartDeathDelayAfterHeadKilled = oPokeyBodyPartDeathDelayAfterHeadKilled,
	oPokeyBottomBodyPartSize = oPokeyBottomBodyPartSize,
	oPokeyChangeTargetTimer = oPokeyChangeTargetTimer,
	oPokeyHeadWasKilled = oPokeyHeadWasKilled,
	oPokeyNumAliveBodyParts = oPokeyNumAliveBodyParts,
	oPokeyTargetYaw = oPokeyTargetYaw,
	oPokeyTurningAwayFromWall = oPokeyTurningAwayFromWall,
	oPosX = oPosX,
	oPosY = oPosY,
	oPosZ = oPosZ,
	oPrevAction = oPrevAction,
	oPyramidTopFragmentsScale = oPyramidTopFragmentsScale,
	oPyramidTopPillarsTouched = oPyramidTopPillarsTouched,
	oRRCruiserWingUnkF4 = oRRCruiserWingUnkF4,
	oRRCruiserWingUnkF8 = oRRCruiserWingUnkF8,
	oRacingPenguinFinalTextbox = oRacingPenguinFinalTextbox,
	oRacingPenguinInitTextCooldown = oRacingPenguinInitTextCooldown,
	oRacingPenguinMarioCheated = oRacingPenguinMarioCheated,
	oRacingPenguinMarioWon = oRacingPenguinMarioWon,
	oRacingPenguinReachedBottom = oRacingPenguinReachedBottom,
	oRacingPenguinWeightedNewTargetSpeed = oRacingPenguinWeightedNewTargetSpeed,
	oRespawnerBehaviorToRespawn = oRespawnerBehaviorToRespawn,
	oRespawnerMinSpawnDist = oRespawnerMinSpawnDist,
	oRespawnerModelToRespawn = oRespawnerModelToRespawn,
	oRollingLogUnkF4 = oRollingLogUnkF4,
	oRoom = oRoom,
	oSLSnowmanWindOriginalYaw = oSLSnowmanWindOriginalYaw,
	oSLWalkingPenguinCurStep = oSLWalkingPenguinCurStep,
	oSLWalkingPenguinCurStepTimer = oSLWalkingPenguinCurStepTimer,
	oSLWalkingPenguinWindCollisionXPos = oSLWalkingPenguinWindCollisionXPos,
	oSLWalkingPenguinWindCollisionZPos = oSLWalkingPenguinWindCollisionZPos,
	oScuttlebugSpawnerUnk88 = oScuttlebugSpawnerUnk88,
	oScuttlebugSpawnerUnkF4 = oScuttlebugSpawnerUnkF4,
	oScuttlebugUnkF4 = oScuttlebugUnkF4,
	oScuttlebugUnkF8 = oScuttlebugUnkF8,
	oScuttlebugUnkFC = oScuttlebugUnkFC,
	oSeesawPlatformPitchVel = oSeesawPlatformPitchVel,
	oShipPart3UnkF4 = oShipPart3UnkF4,
	oShipPart3UnkF8 = oShipPart3UnkF8,
	oSinkWhenSteppedOnUnk104 = oSinkWhenSteppedOnUnk104,
	oSinkWhenSteppedOnUnk108 = oSinkWhenSteppedOnUnk108,
	oSkeeterTargetAngle = oSkeeterTargetAngle,
	oSkeeterUnk1AC = oSkeeterUnk1AC,
	oSkeeterUnkF8 = oSkeeterUnkF8,
	oSkeeterUnkFC = oSkeeterUnkFC,
	oSkeeterWaitTime = oSkeeterWaitTime,
	oSmallBompInitX = oSmallBompInitX,
	oSmallPenguinUnk100 = oSmallPenguinUnk100,
	oSmallPenguinUnk104 = oSmallPenguinUnk104,
	oSmallPenguinUnk108 = oSmallPenguinUnk108,
	oSmallPenguinUnk110 = oSmallPenguinUnk110,
	oSmallPenguinUnk88 = oSmallPenguinUnk88,
	oSmallPiranhaFlameEndSpeed = oSmallPiranhaFlameEndSpeed,
	oSmallPiranhaFlameModel = oSmallPiranhaFlameModel,
	oSmallPiranhaFlameNextFlameTimer = oSmallPiranhaFlameNextFlameTimer,
	oSmallPiranhaFlameSpeed = oSmallPiranhaFlameSpeed,
	oSmallPiranhaFlameStartSpeed = oSmallPiranhaFlameStartSpeed,
	oSmokeTimer = oSmokeTimer,
	oSnowmansBottomUnk1AC = oSnowmansBottomUnk1AC,
	oSnowmansBottomUnkF4 = oSnowmansBottomUnkF4,
	oSnowmansBottomUnkF8 = oSnowmansBottomUnkF8,
	oSnowmansHeadUnkF4 = oSnowmansHeadUnkF4,
	oSnufitBodyBaseScale = oSnufitBodyBaseScale,
	oSnufitBodyScale = oSnufitBodyScale,
	oSnufitBodyScalePeriod = oSnufitBodyScalePeriod,
	oSnufitBullets = oSnufitBullets,
	oSnufitCircularPeriod = oSnufitCircularPeriod,
	oSnufitRecoil = oSnufitRecoil,
	oSnufitScale = oSnufitScale,
	oSnufitXOffset = oSnufitXOffset,
	oSnufitYOffset = oSnufitYOffset,
	oSnufitZOffset = oSnufitZOffset,
	oSoundEffectUnkF4 = oSoundEffectUnkF4,
	oSoundStateID = oSoundStateID,
	oSparkleSpawnUnk1B0 = oSparkleSpawnUnk1B0,
	oSpindelUnkF4 = oSpindelUnkF4,
	oSpindelUnkF8 = oSpindelUnkF8,
	oSpinningHeartPlayedSound = oSpinningHeartPlayedSound,
	oSpinningHeartTotalSpin = oSpinningHeartTotalSpin,
	oSpinyTargetYaw = oSpinyTargetYaw,
	oSpinyTimeUntilTurn = oSpinyTimeUntilTurn,
	oSpinyTurningAwayFromWall = oSpinyTurningAwayFromWall,
	oStarSelectorSize = oStarSelectorSize,
	oStarSelectorTimer = oStarSelectorTimer,
	oStarSelectorType = oStarSelectorType,
	oStarSpawnDisFromHome = oStarSpawnDisFromHome,
	oStarSpawnUnkFC = oStarSpawnUnkFC,
	oStrongWindParticlePenguinObj = oStrongWindParticlePenguinObj,
	oSubAction = oSubAction,
	oSushiSharkUnkF4 = oSushiSharkUnkF4,
	oSwingPlatformAngle = oSwingPlatformAngle,
	oSwingPlatformSpeed = oSwingPlatformSpeed,
	oSwoopBonkCountdown = oSwoopBonkCountdown,
	oSwoopTargetPitch = oSwoopTargetPitch,
	oSwoopTargetYaw = oSwoopTargetYaw,
	oTTC2DRotatorIncrement = oTTC2DRotatorIncrement,
	oTTC2DRotatorMinTimeUntilNextTurn = oTTC2DRotatorMinTimeUntilNextTurn,
	oTTC2DRotatorRandomDirTimer = oTTC2DRotatorRandomDirTimer,
	oTTC2DRotatorSpeed = oTTC2DRotatorSpeed,
	oTTC2DRotatorTargetYaw = oTTC2DRotatorTargetYaw,
	oTTCChangeDirTimer = oTTCChangeDirTimer,
	oTTCCogDir = oTTCCogDir,
	oTTCCogSpeed = oTTCCogSpeed,
	oTTCCogTargetVel = oTTCCogTargetVel,
	oTTCElevatorDir = oTTCElevatorDir,
	oTTCElevatorMoveTime = oTTCElevatorMoveTime,
	oTTCElevatorPeakY = oTTCElevatorPeakY,
	oTTCMovingBarDelay = oTTCMovingBarDelay,
	oTTCMovingBarOffset = oTTCMovingBarOffset,
	oTTCMovingBarSpeed = oTTCMovingBarSpeed,
	oTTCMovingBarStartOffset = oTTCMovingBarStartOffset,
	oTTCMovingBarStoppedTimer = oTTCMovingBarStoppedTimer,
	oTTCPendulumAccelDir = oTTCPendulumAccelDir,
	oTTCPendulumAngle = oTTCPendulumAngle,
	oTTCPendulumAngleAccel = oTTCPendulumAngleAccel,
	oTTCPendulumAngleVel = oTTCPendulumAngleVel,
	oTTCPendulumDelay = oTTCPendulumDelay,
	oTTCPendulumSoundTimer = oTTCPendulumSoundTimer,
	oTTCPitBlockDir = oTTCPitBlockDir,
	oTTCPitBlockPeakY = oTTCPitBlockPeakY,
	oTTCPitBlockWaitTime = oTTCPitBlockWaitTime,
	oTTCRotatingSolidNumSides = oTTCRotatingSolidNumSides,
	oTTCRotatingSolidNumTurns = oTTCRotatingSolidNumTurns,
	oTTCRotatingSolidRotationDelay = oTTCRotatingSolidRotationDelay,
	oTTCRotatingSolidSoundTimer = oTTCRotatingSolidSoundTimer,
	oTTCRotatingSolidVelY = oTTCRotatingSolidVelY,
	oTTCSpinnerDir = oTTCSpinnerDir,
	oTTCTreadmillBigSurface = oTTCTreadmillBigSurface,
	oTTCTreadmillSmallSurface = oTTCTreadmillSmallSurface,
	oTTCTreadmillSpeed = oTTCTreadmillSpeed,
	oTTCTreadmillTargetSpeed = oTTCTreadmillTargetSpeed,
	oTTCTreadmillTimeUntilSwitch = oTTCTreadmillTimeUntilSwitch,
	oTiltingPyramidMarioOnPlatform = oTiltingPyramidMarioOnPlatform,
	oTiltingPyramidNormalX = oTiltingPyramidNormalX,
	oTiltingPyramidNormalY = oTiltingPyramidNormalY,
	oTiltingPyramidNormalZ = oTiltingPyramidNormalZ,
	oTimer = oTimer,
	oToadMessageDialogId = oToadMessageDialogId,
	oToadMessageRecentlyTalked = oToadMessageRecentlyTalked,
	oToadMessageState = oToadMessageState,
	oToxBoxActionStep = oToxBoxActionStep,
	oToxBoxActionTable = oToxBoxActionTable,
	oTreasureChestUnkF4 = oTreasureChestUnkF4,
	oTreasureChestUnkF8 = oTreasureChestUnkF8,
	oTreasureChestUnkFC = oTreasureChestUnkFC,
	oTreeSnowOrLeafUnkF4 = oTreeSnowOrLeafUnkF4,
	oTreeSnowOrLeafUnkF8 = oTreeSnowOrLeafUnkF8,
	oTreeSnowOrLeafUnkFC = oTreeSnowOrLeafUnkFC,
	oTripletButterflyBaseYaw = oTripletButterflyBaseYaw,
	oTripletButterflyModel = oTripletButterflyModel,
	oTripletButterflyScale = oTripletButterflyScale,
	oTripletButterflyScalePhase = oTripletButterflyScalePhase,
	oTripletButterflySelectedButterfly = oTripletButterflySelectedButterfly,
	oTripletButterflySpeed = oTripletButterflySpeed,
	oTripletButterflyTargetPitch = oTripletButterflyTargetPitch,
	oTripletButterflyTargetYaw = oTripletButterflyTargetYaw,
	oTripletButterflyType = oTripletButterflyType,
	oTumblingBridgeUnkF4 = oTumblingBridgeUnkF4,
	oTweesterScaleTimer = oTweesterScaleTimer,
	oTweesterUnused = oTweesterUnused,
	oUkikiCageNextAction = oUkikiCageNextAction,
	oUkikiCageSpinTimer = oUkikiCageSpinTimer,
	oUkikiChaseFleeRange = oUkikiChaseFleeRange,
	oUkikiHasCap = oUkikiHasCap,
	oUkikiTauntCounter = oUkikiTauntCounter,
	oUkikiTauntsToBeDone = oUkikiTauntsToBeDone,
	oUkikiTextState = oUkikiTextState,
	oUkikiTextboxTimer = oUkikiTextboxTimer,
	oUnagiUnk110 = oUnagiUnk110,
	oUnagiUnk1AC = oUnagiUnk1AC,
	oUnagiUnk1B0 = oUnagiUnk1B0,
	oUnagiUnk1B2 = oUnagiUnk1B2,
	oUnagiUnkF4 = oUnagiUnkF4,
	oUnagiUnkF8 = oUnagiUnkF8,
	oUnk1A8 = oUnk1A8,
	oUnk94 = oUnk94,
	oUnkBC = oUnkBC,
	oUnkC0 = oUnkC0,
	oUnlockDoorStarState = oUnlockDoorStarState,
	oUnlockDoorStarTimer = oUnlockDoorStarTimer,
	oUnlockDoorStarYawVel = oUnlockDoorStarYawVel,
	oVelX = oVelX,
	oVelY = oVelY,
	oVelZ = oVelZ,
	oWFSlidBrickPtfmMovVel = oWFSlidBrickPtfmMovVel,
	oWallAngle = oWallAngle,
	oWallHitboxRadius = oWallHitboxRadius,
	oWaterLevelPillarDrained = oWaterLevelPillarDrained,
	oWaterLevelTriggerTargetWaterLevel = oWaterLevelTriggerTargetWaterLevel,
	oWaterLevelTriggerUnkF4 = oWaterLevelTriggerUnkF4,
	oWaterObjUnk100 = oWaterObjUnk100,
	oWaterObjUnkF4 = oWaterObjUnkF4,
	oWaterObjUnkF8 = oWaterObjUnkF8,
	oWaterObjUnkFC = oWaterObjUnkFC,
	oWaterRingAvgScale = oWaterRingAvgScale,
	oWaterRingIndex = oWaterRingIndex,
	oWaterRingMarioDistInFront = oWaterRingMarioDistInFront,
	oWaterRingMgrLastRingCollected = oWaterRingMgrLastRingCollected,
	oWaterRingMgrNextRingIndex = oWaterRingMgrNextRingIndex,
	oWaterRingNormalX = oWaterRingNormalX,
	oWaterRingNormalY = oWaterRingNormalY,
	oWaterRingNormalZ = oWaterRingNormalZ,
	oWaterRingScalePhaseX = oWaterRingScalePhaseX,
	oWaterRingScalePhaseY = oWaterRingScalePhaseY,
	oWaterRingScalePhaseZ = oWaterRingScalePhaseZ,
	oWaterRingSpawnerRingsCollected = oWaterRingSpawnerRingsCollected,
	oWaveTrailSize = oWaveTrailSize,
	oWhirlpoolInitFacePitch = oWhirlpoolInitFacePitch,
	oWhirlpoolInitFaceRoll = oWhirlpoolInitFaceRoll,
	oWhitePuffUnkF4 = oWhitePuffUnkF4,
	oWhitePuffUnkF8 = oWhitePuffUnkF8,
	oWhitePuffUnkFC = oWhitePuffUnkFC,
	oWhompShakeVal = oWhompShakeVal,
	oWigglerFallThroughFloorsHeight = oWigglerFallThroughFloorsHeight,
	oWigglerSegments = oWigglerSegments,
	oWigglerSquishSpeed = oWigglerSquishSpeed,
	oWigglerTargetYaw = oWigglerTargetYaw,
	oWigglerTextStatus = oWigglerTextStatus,
	oWigglerTimeUntilRandomTurn = oWigglerTimeUntilRandomTurn,
	oWigglerUnused = oWigglerUnused,
	oWigglerWalkAnimSpeed = oWigglerWalkAnimSpeed,
	oWigglerWalkAwayFromWallTimer = oWigglerWalkAwayFromWallTimer,
	oWoodenPostMarioPounding = oWoodenPostMarioPounding,
	oWoodenPostOffsetY = oWoodenPostOffsetY,
	oWoodenPostPrevAngleToMario = oWoodenPostPrevAngleToMario,
	oWoodenPostSpeedY = oWoodenPostSpeedY,
	oWoodenPostTotalMarioAngle = oWoodenPostTotalMarioAngle,
})