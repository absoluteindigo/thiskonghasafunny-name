--!strict

local Animations = require(script.Animations)
local Sounds = require(script.Sounds)
local Enums = require(script.Enums)

local Shared = {
	Animations = Animations,
	Sounds = Sounds.SoundTable,
	VoiceTable = Sounds.VoiceTable,
	Enums = Enums,
}

return Shared