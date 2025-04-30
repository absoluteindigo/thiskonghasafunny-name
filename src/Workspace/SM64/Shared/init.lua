--!strict

local Animations = require(script.Animations)
local Sounds = require(script.Sounds)
local Enums = require(script.Enums)

local CustomVoices = require(script.CustomVoices)

local Shared = {
	Animations = Animations,
	Sounds = Sounds.SoundTable,
	VoiceTable = Sounds.VoiceTable,
	Enums = Enums,
	
	CustomVoices = CustomVoices,
}

return Shared