--!strict

local Object = {}

Object.Action = {
	LAVA_DEATH = 100,
	DEATH_PLANE_DEATH = 101,

	HORIZONTAL_KNOCKBACK = 100,
	VERTICAL_KNOCKBACK = 101,
	SQUISHED = 102,
}
Object.ActiveFlag = {
	DEACTIVATED = 0, -- 0x0000
	ACTIVE = bit32.lshift(1, 0), -- 0x0001
	FAR_AWAY = bit32.lshift(1, 1), -- 0x0002
	UNK2 = bit32.lshift(1, 2), -- 0x0004
	IN_DIFFERENT_ROOM = bit32.lshift(1, 3), -- 0x0008
	UNIMPORTANT = bit32.lshift(1, 4), -- 0x0010
	INITIATED_TIME_STOP = bit32.lshift(1, 5), -- 0x0020
	MOVE_THROUGH_GRATE = bit32.lshift(1, 6), -- 0x0040
	DITHERED_ALPHA = bit32.lshift(1, 7), -- 0x0080
	UNK8 = bit32.lshift(1, 8), -- 0x0100
	UNK9 = bit32.lshift(1, 9), -- 0x0200
	UNK10 = bit32.lshift(1, 10), -- 0x0400
}
local CollisionFlag = {
	GROUNDED = bit32.lshift(1, 0),
	HIT_WALL = bit32.lshift(1, 1),
	UNDERWATER = bit32.lshift(1, 2),
	NO_Y_VEL = bit32.lshift(1, 3),
}

CollisionFlag.LANDED = bit32.bor(CollisionFlag.GROUNDED, CollisionFlag.NO_Y_VEL)
Object.CollisionFlag = CollisionFlag

Object.Flag = {
	UPDATE_GFX_POS_AND_ANGLE = bit32.lshift(1, 0), -- 0x00000001
	MOVE_XZ_USING_FVEL = bit32.lshift(1, 1), -- 0x00000002
	MOVE_Y_WITH_TERMINAL_VEL = bit32.lshift(1, 2), -- 0x00000004
	SET_FACE_YAW_TO_MOVE_YAW = bit32.lshift(1, 3), -- 0x00000008
	SET_FACE_ANGLE_TO_MOVE_ANGLE = bit32.lshift(1, 4), -- 0x00000010
	UNK0020 = bit32.lshift(1, 5), -- 0x00000020
	COMPUTE_DIST_TO_MARIO = bit32.lshift(1, 6), -- 0x00000040
	ACTIVE_FROM_AFAR = bit32.lshift(1, 7), -- 0x00000080
	UNK0100 = bit32.lshift(1, 8), -- 0x00000100
	TRANSFORM_RELATIVE_TO_PARENT = bit32.lshift(1, 9), -- 0x00000200
	HOLDABLE = bit32.lshift(1, 10), -- 0x00000400
	SET_THROW_MATRIX_FROM_TRANSFORM = bit32.lshift(1, 11), -- 0x00000800
	UNK1000 = bit32.lshift(1, 12), -- 0x00001000
	COMPUTE_ANGLE_TO_MARIO = bit32.lshift(1, 13), -- 0x00002000
	PERSISTENT_RESPAWN = bit32.lshift(1, 14), -- 0x00004000
	UNK8000 = bit32.lshift(1, 15), -- 0x00008000
	UNK30 = bit32.lshift(1, 30), -- 0x40000000
}
Object.HeldState = {
	FREE = 0,
	HELD = 1,
	THROWN = 2,
	DROPPED = 3,
}
--stylua: ignore

-- https://github.com/n64decomp/sm64/blob/9921382a68bb0c865e5e45eb594d9c64db59b1af/src/game/object_list_processor.h#L28

--[[
 * Every object is categorized into an object list, which controls the order
 * they are processed and which objects they can collide with.
]]
Object.List = {
	PLAYER 		= 0,  -- Mario

	DESTRUCTIVE = 2,  -- Things that can be used to destroy other objects,
	-- like bob-omb and corkboxes

	GENACTOR 	= 4,  -- General actors. Most normal 'enemies' or actors are
	-- on this list. MIPS, bullet bill, bully, etc)

	PUSHABLE 	= 5,  -- Pushable actors. This is a group of octors which
	-- can push eachother around as well as their árent
	-- objects. (goombas, koopas, spinies)

	LEVEL 		= 6,  -- Level objects. General level objects such as heart, star

	DEFAULT 	= 8,  -- Default objects. Objects that didnt start with a 00
	-- command are put here, so this is treated as a default.

	SURFACE 	= 9,  -- Surface objects. Objects that specifically have surface
	-- collision and not object collision. (thwomp, whomp, etc)

	POLELIKE 	= 10, -- Polelike objects. Objects that attract or otherwise
	-- "cling" Mario similar to a pole action. (hoot, whirlpool, trees/poles, etc)
	SPAWNER 	= 11, -- spawnmers

	UNIMPORTANT = 12, -- Unimportant objects. Objects that will not
	-- load if there are not enough object slots: they will also
	-- be manually unloaded to make room for slots if the list
	-- gets exhausted.
}

local MoveFlag = {
	LANDED = bit32.lshift(1, 0), -- 0x0001
	ON_GROUND = bit32.lshift(1, 1), -- 0x0002, mutually exclusive to OBJ_MOVE_LANDED
	LEFT_GROUND = bit32.lshift(1, 2), -- 0x0004
	ENTERED_WATER = bit32.lshift(1, 3), -- 0x0008
	AT_WATER_SURFACE = bit32.lshift(1, 4), -- 0x0010
	UNDERWATER_OFF_GROUND = bit32.lshift(1, 5), -- 0x0020
	UNDERWATER_ON_GROUND = bit32.lshift(1, 6), -- 0x0040
	IN_AIR = bit32.lshift(1, 7), -- 0x0080
	OUT_SCOPE = bit32.lshift(1, 8), -- 0x0100
	HIT_WALL = bit32.lshift(1, 9), -- 0x0200
	HIT_EDGE = bit32.lshift(1, 10), -- 0x0400
	ABOVE_LAVA = bit32.lshift(1, 11), -- 0x0800
	LEAVING_WATER = bit32.lshift(1, 12), -- 0x1000
	BOUNCE = bit32.lshift(1, 13), -- 0x2000
	ABOVE_DEATH_BARRIER = bit32.lshift(1, 14), -- 0x4000
}

--stylua: ignore
MoveFlag.MASK_ON_GROUND = bit32.bor(
	MoveFlag.LANDED,
	MoveFlag.ON_GROUND
)

MoveFlag.MASK_IN_WATER = bit32.bor(
	MoveFlag.ENTERED_WATER,
	MoveFlag.AT_WATER_SURFACE,
	MoveFlag.UNDERWATER_OFF_GROUND,
	MoveFlag.UNDERWATER_ON_GROUND
)
Object.MoveFlag = MoveFlag

return table.freeze(Object)