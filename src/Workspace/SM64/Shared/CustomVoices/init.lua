local Sounds = require(script.Parent.Sounds)

local CustomVoice = {}

CustomVoice.None = {}
for k, v in pairs(Sounds.VoiceTable) do
	if not v:IsA('Sound') then continue end
	CustomVoice.None[k] = script.Silent
end
setmetatable(CustomVoice.None, {
	__index = Sounds.SoundTable,
})

local function prepareNewSoundTable(key, soundTable)
	setmetatable(soundTable, {
		__index = CustomVoice.None,
	})
	rawset(CustomVoice, key, soundTable)
	return soundTable
end

setmetatable(CustomVoice, {
	__index = function(self, key)
		local instance = script:FindFirstChild(key) :: ModuleScript
		if instance and instance:IsA('ModuleScript') then
			return prepareNewSoundTable(key, require(instance))
		end
		warn('UNKNOWN TABLE:', key)
		return nil
	end,
})

return CustomVoice