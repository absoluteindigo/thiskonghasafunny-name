--!strict

local Interaction = {}

Interaction.AttackHandler = {
	NOP = 0,
	DIE_IF_HEALTH_NON_POSITIVE = 1,
	KNOCKBACK = 2,
	SQUISHED = 3,
	SPECIAL_KOOPA_LOSE_SHELL = 4,
	SET_SPEED_TO_ZERO = 5,
	SPECIAL_WIGGLER_JUMPED_ON = 6,
	SPECIAL_HUGE_GOOMBA_WEAKLY_ATTACKED = 7,
	SQUISHED_WITH_BLUE_COIN = 8,
}
Interaction.AttackType = {
	PUNCH = 1,
	KICK_OR_TRIP = 2,
	FROM_ABOVE = 3,
	GROUND_POUND_OR_TWIRL = 4,
	FAST_ATTACK = 5,
	FROM_BELOW = 6,
}
Interaction.Method = {
	HOOT = 0x00000001, -- (1 << 0)
	GRABBABLE = 0x00000002, -- (1 << 1)
	DOOR = 0x00000004, -- (1 << 2)
	DAMAGE = 0x00000008, -- (1 << 3)
	COIN = 0x00000010, -- (1 << 4)
	CAP = 0x00000020, -- (1 << 5)
	POLE = 0x00000040, -- (1 << 6)
	KOOPA = 0x00000080, -- (1 << 7)
	UNKNOWN_08 = 0x00000100, -- (1 << 8)
	BREAKABLE = 0x00000200, -- (1 << 9)
	STRONG_WIND = 0x00000400, -- (1 << 10)
	WARP_DOOR = 0x00000800, -- (1 << 11)
	STAR_OR_KEY = 0x00001000, -- (1 << 12)
	WARP = 0x00002000, -- (1 << 13)
	CANNON_BASE = 0x00004000, -- (1 << 14)
	BOUNCE_TOP = 0x00008000, -- (1 << 15)
	WATER_RING = 0x00010000, -- (1 << 16)
	BULLY = 0x00020000, -- (1 << 17)
	FLAME = 0x00040000, -- (1 << 18)
	KOOPA_SHELL = 0x00080000, -- (1 << 19)
	BOUNCE_TOP2 = 0x00100000, -- (1 << 20)
	MR_BLIZZARD = 0x00200000, -- (1 << 21)
	HIT_FROM_BELOW = 0x00400000, -- (1 << 22)
	TEXT = 0x00800000, -- (1 << 23)
	TORNADO = 0x01000000, -- (1 << 24)
	WHIRLPOOL = 0x02000000, -- (1 << 25)
	CLAM_OR_BUBBA = 0x04000000, -- (1 << 26)
	BBH_ENTRANCE = 0x08000000, -- (1 << 27)
	SNUFIT_BULLET = 0x10000000, -- (1 << 28)
	SHOCK = 0x20000000, -- (1 << 29)
	IGLOO_BARRIER = 0x40000000, -- (1 << 30)
	UNKNOWN_31 = 0x80000000, -- (1 << 31)
}
Interaction.Status = {
	ATTACK_MASK = 0x000000FF,

	-- Mario Interaction Status
	MARIO_STUNNED = bit32.lshift(1, 0), -- 0x00000001 --

	MARIO_UNK1 = bit32.lshift(1, 1), -- life if nobonet and max didnt change the names of source code variables

	MARIO_KNOCKBACK_DMG = bit32.lshift(1, 1), -- 0x00000002 --
	MARIO_UNK2 = bit32.lshift(1, 2), -- 0x00000004 --
	MARIO_DROP_OBJECT = bit32.lshift(1, 3), -- 0x00000008 --
	MARIO_SHOCKWAVE = bit32.lshift(1, 4), -- 0x00000010 --
	MARIO_UNK5 = bit32.lshift(1, 5), -- 0x00000020 --
	MARIO_UNK6 = bit32.lshift(1, 6), -- 0x00000040 --
	MARIO_UNK7 = bit32.lshift(1, 7), -- 0x00000080 --

	-- Object Interaction Status
	GRABBED_MARIO = bit32.lshift(1, 11), -- 0x00000800 --
	ATTACKED_MARIO = bit32.lshift(1, 13), -- 0x00002000 --
	WAS_ATTACKED = bit32.lshift(1, 14), -- 0x00004000 --
	INTERACTED = bit32.lshift(1, 15), -- 0x00008000 --
	UNK16 = bit32.lshift(1, 16), -- 0x00010000 --
	UNK17 = bit32.lshift(1, 17), -- 0x00020000 --
	UNK18 = bit32.lshift(1, 18), -- 0x00040000 --
	UNK19 = bit32.lshift(1, 19), -- 0x00080000 --
	TRAP_TURN = bit32.lshift(1, 20), -- 0x00100000 --
	HIT_MINE = bit32.lshift(1, 21), -- 0x00200000 --
	STOP_RIDING = bit32.lshift(1, 22), -- 0x00400000 --
	TOUCHED_BOB_OMB = bit32.lshift(1, 23), -- 0x00800000 --
}
Interaction.Subtype = {
	-- INTERACT_WARP
	FADING_WARP = 0x00000001,

	-- Damaging interactions
	DELAY_INVINCIBILITY = 0x00000002,
	BIG_KNOCKBACK = 0x00000008, -- Used by Bowser, sets Mario's forward velocity to 40 on hit --

	-- INTERACT_GRABBABLE
	GRABS_MARIO = 0x00000004, -- Also makes the object heavy --
	HOLDABLE_NPC = 0x00000010, -- Allows the object to be gently dropped, and sets vertical speed to 0 when dropped with no forwards velocity --
	DROP_IMMEDIATELY = 0x00000040, -- This gets set by grabbable NPCs that talk to Mario to make him drop them after the dialog is finished --
	KICKABLE = 0x00000100,
	NOT_GRABBABLE = 0x00000200, -- Used by Heavy-Ho to allow it to throw Mario, without Mario being able to pick it up --

	-- INTERACT_DOOR
	STAR_DOOR = 0x00000020,

	--INTERACT_BOUNCE_TOP
	TWIRL_BOUNCE = 0x00000080,

	-- INTERACT_STAR_OR_KEY
	NO_EXIT = 0x00000400,
	GRAND_STAR = 0x00000800,

	-- INTERACT_TEXT
	SIGN = 0x00001000,
	NPC = 0x00004000,

	-- INTERACT_CLAM_OR_BUBBA
	EATS_MARIO = 0x00002000,
}

local InteractionType = {
	GROUND_POUND_OR_TWIRL = 0x01,
	PUNCH = 0x02,
	KICK = 0x04,
	TRIP = 0x08,
	SLIDE_KICK = 0x10,
	FAST_ATTACK_OR_SHELL = 0x20,
	HIT_FROM_ABOVE = 0x40,
	HIT_FROM_BELOW = 0x80,
}

InteractionType.ATTACK_NOT_FROM_BELOW = bit32.bor(
	InteractionType.GROUND_POUND_OR_TWIRL,
	InteractionType.PUNCH,
	InteractionType.KICK,
	InteractionType.TRIP,
	InteractionType.SLIDE_KICK,
	InteractionType.FAST_ATTACK_OR_SHELL,
	InteractionType.HIT_FROM_ABOVE
)

InteractionType.ANY_ATTACK = bit32.bor(
	InteractionType.GROUND_POUND_OR_TWIRL,
	InteractionType.PUNCH,
	InteractionType.KICK,
	InteractionType.TRIP,
	InteractionType.SLIDE_KICK,
	InteractionType.FAST_ATTACK_OR_SHELL,
	InteractionType.HIT_FROM_ABOVE,
	InteractionType.HIT_FROM_BELOW
)

InteractionType.ATTACK_NOT_WEAK_FROM_ABOVE = bit32.bor(
	InteractionType.GROUND_POUND_OR_TWIRL,
	InteractionType.PUNCH,
	InteractionType.KICK,
	InteractionType.TRIP,
	InteractionType.HIT_FROM_BELOW
)

Interaction.Type = InteractionType

return table.freeze(Interaction)