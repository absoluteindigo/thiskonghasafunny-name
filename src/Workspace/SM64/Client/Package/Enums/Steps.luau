--!strict

local Steps = {}

Steps.Air = {
	NONE = 0,
	LANDED = 1,
	HIT_WALL = 2,
	GRABBED_LEDGE = 3,
	GRABBED_CEILING = 4,
	HIT_LAVA_WALL = 6,

	CHECK_LEDGE_GRAB = 1,
	CHECK_HANG = 2,
}
Steps.Ground = {
	LEFT_GROUND = 0,
	NONE = 1,
	HIT_WALL = 2,
	HIT_WALL_STOP_QSTEPS = 2,
	HIT_WALL_CONTINUE_QSTEPS = 3,
}
Steps.Hang = {
	NONE = 0,
	HIT_CEIL_OR_OOB = 1,
	LEFT_CEIL = 2,
}
Steps.Water = {
	NONE = 0,
	HIT_FLOOR = 1,
	HIT_CEILING = 2,
	CANCELLED = 3,
	HIT_WALL = 4,
}

return Steps