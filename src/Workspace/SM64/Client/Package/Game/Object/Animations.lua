-- cries
-- anim frames might be unk08

local function Array(table)
	local newArray = {}
	for k, v in ipairs(table) do
		newArray[k - 1] = v
	end
	return newArray
end

local Animations = {}

Animations.goomba = Array({
	script:WaitForChild('goombawalk', 2),
})
-- https://github.com/sm64js/sm64js/blob/vanilla/src/actors/bobomb/anims.inc.js
Animations.bobomb = Array({
	script:WaitForChild('bobombwalk', 2),
	script:WaitForChild('bobombhold', 2),
})

warn(' door is pretty random i guezz')
Animations.door = Array({
	-- 5 anims
	script:WaitForChild('null', 2),
	script:WaitForChild('pulldoor', 2),
	script:WaitForChild('pushdoor', 2),
	script.pulldoor, script.pushdoor,
})

return Animations