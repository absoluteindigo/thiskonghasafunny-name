-- find_mario_anim_flags_and_translation but a million times faker
local Animations = require(script.Parent.Parent.Parent.Animations)

local transformations = {
	[Animations.PUSH_DOOR_WALK_IN] = require(script:WaitForChild('pushdoorwalkin')),
	[Animations.PULL_DOOR_WALK_IN] = require(script:WaitForChild('pulldoorwalkin'))
}

setmetatable(transformations, {
	__index = function(key)
		print('nothing for key!')
		return setmetatable({}, {__index = function()
			return Vector3.zero
		end,})
	end,
})

return transformations