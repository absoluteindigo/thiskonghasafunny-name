-- custom audio channel to play sounds and have the play sound function called rapidly
local FFlags = require(script.Parent.Parent.FFlags)

local Audio = {}
Audio.__index = Audio

function Audio.new(Object)
	local self = setmetatable({}, Audio)
	self.Link = Object
	self.Sounds = {} :: {[Sound]: boolean?}
	self.OldSounds = {} :: {[string]: Sound}

	return self
end

function Audio:Play(Sound) -- qeue the audio
	self._UPDATE = true
	self.Sounds[Sound] = true
end

function Audio:Update()
	if self._UPDATE then
		self._UPDATE = nil

		local clear = {}
		for Sound: Sound in pairs(self.Sounds) do
			if Sound.TimeLength == 0 then continue end
			local looped = Sound.Looped

			self:CreateSound(Sound)

			if not looped then
				clear[Sound] = true
			end
		end

		for Sound in pairs(clear) do
			self.Sounds[Sound] = nil
		end
	end
end

local soundDecay = {}
-- this is wrong right here
local function stepDecay(sound: Sound)
	local decay = soundDecay[sound]

	if decay then
		task.cancel(decay)
	end

	soundDecay[sound] = task.delay(0.1, function()
		sound:Stop()
		sound:Destroy()
		soundDecay[sound] = nil
	end)

	sound.Playing = true
end

function Audio:CreateSound(Sound: Sound)
	if not Sound then return end
	local Link = self.Link
	local ModelObject = Link.Model
	if not ModelObject then return end
	local Model = ModelObject.Model :: Model
	if not Model then return end
	local root = Model:IsA('Model') and Model.PrimaryPart :: BasePart or Model
	if not root then return end
	--
	local name = Sound.Name
	local oldSound: Sound? = self.OldSounds[name]
	local canPlay = true

	if oldSound then
		canPlay = false
		
		if Sound.Looped then
			canPlay = false
		elseif name:sub(1, 6) == "MOVING" or Sound:GetAttribute("Decay") then
			-- Keep decaying audio alive.
			stepDecay(oldSound)
		elseif name:sub(1, 5) == "MARIO" then
			-- Restart mario sound if a 30hz interval passed.
			local now = os.clock()
			local lastPlay = oldSound:GetAttribute("LastPlay") or 0

			if now - lastPlay >= 2 / FFlags.STEP_RATE then
				oldSound.TimePosition = 0
				oldSound:SetAttribute("LastPlay", now)
			end
		else
			-- Allow stacking.
			canPlay = true
		end 
	elseif name:sub(1, 5) == "MARIO" then
		-- If the mario sound has a higher priority, delete
		-- the ones that are lower/equal the priority.
		-- On the other side, don't play if there's a sound
		-- with a higher priority playing than the one
		-- we wish to play.
		local nextPriority = tonumber(Sound:GetAttribute("Priority")) or 128

		local clear = {}
		for name, oldSound: Sound in pairs(self.OldSounds) do
			if name:sub(1, 5) ~= "MARIO" then
				continue
			end

			local priority = tonumber(oldSound:GetAttribute("Priority")) or 128
			if nextPriority >= priority then
				oldSound:Destroy()
				clear[name] = true
			elseif priority >= nextPriority then
				canPlay = false
			end
		end
		for key in pairs(clear) do
			self.OldSounds[key] = nil
		end
	end



	if canPlay then
		local newSound: Sound = Sound:Clone()
		newSound.Parent = root
		newSound:Play()

		if name:find("MOVING") then
			-- Audio will decay if PlaySound isn't continuously called.
			stepDecay(newSound)
		end

		newSound.Ended:Once(function()
			newSound:Destroy()
			self.OldSounds[newSound.Name] = nil
		end)

		newSound:SetAttribute("LastPlay", os.clock())
		self.OldSounds[newSound.Name] = newSound
	end

end

return Audio