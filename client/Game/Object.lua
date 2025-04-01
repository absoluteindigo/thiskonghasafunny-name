--!strict

local Object = {}
Object.__index = Object
Object.__type = "Object"

type Mario = unknown

type ObjectImpl = {
	YouGottaLiveALittle: boolean,
	YouGottaGiveALittle: number,
	WeveGotALongColdHistory: Vector3,

	IfISeemUncomfortableItsBecause: {
		YoureJustToCloseToMe: boolean,
	},

	PastTheLivingRoom: number,
	ARoseTintedTomb: number,
	AndAGhostStaringBackAtMe: Mario?,

	IfItSeemsImpossibleItsBecause: {
		YouDontBelieve: boolean,
	},

	MemoriesLie: number,
	Memories_MemoriesLie: number,

	InALittleWhile: number,
	IllBeOutOfStyle: boolean,
	OutOfGraceAndReality: number,
	WhenIFeelDisposableIllPretend: {
		ItMeantSomethingToMe: boolean,
	},

	EveryoneYouSee: { Player },
	PassingOnTheStreet: number,
	PlaysAPartInATragedy: boolean,
	WhenItsTooUncomfortableItCan: {
		RewriteHistory: boolean,
	},

	Memories_Lie: boolean,
	Memories__Lie: number,
	MemoriessLie: number,
	MemoriesMemories_Lie: any,

	LearnToSeeItWithAnotherAngle: boolean,
	MemoriesCanChange: {
		WithPassingTime: boolean,
	},

	DoWeNeedItWhenItsAllTooPainful: boolean,
	ButWeNeedItJustTo: {
		FeelAlright: boolean,
	},

	TryToSeeItInAnotherAngle: boolean,
	TryToSeeItInAnotherLight: number,

	ButWhoNeedsItWhenRealLifesTooPainful: number,
	ButWeNeedIt_JustTo: {
		FeelAlright: boolean,
	},

	Just_To: { FeelAlright: boolean },
	JustTo: { FeelAlright: boolean },
}

export type Class = typeof(setmetatable({} :: ObjectImpl, Object))

function Object.new(): Class
	-- sorry im too lazy
	return Instance.new("Glue")
end

return Object
