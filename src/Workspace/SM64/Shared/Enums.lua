--!strict

-- mainly player replication enums

local Enums = {
	Particle = '1',
	TorsoAngle = '2',
	HeadAngle = '3',
	Health = '4',
	Camera = '5',
	Position = '6',
	Sound = '7',
	EyeStates = '8',
	LeftHand = '9',
	RightHand = '10',
}

--[[if game:GetService('RunService'):IsStudio() then
	return table.freeze(({
		Particle = 'Particle',
		TorsoAngle = 'TorsoAngle',
		HeadAngle = 'HeadAngle',
		Health = 'Health',
		Camera = 'Camera',
		Position = 'Position',
		Sound = 'Sound',
		EyeStates = 'EyeStates',
	} :: any))
end]]

return table.freeze(Enums)