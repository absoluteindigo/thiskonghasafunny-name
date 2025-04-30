-- like a wrapper or something
-- meh

-- typechecking
local Mario = require(script.Parent.Parent.Parent.Mario)

type Mario = Mario.Class

local gMarioObject = {
	m = nil
}

function gMarioObject.Get()
	return gMarioObject.m
end

function gMarioObject:__call()
	return (gMarioObject.m :: Mario)
end

setmetatable(gMarioObject, gMarioObject)

return gMarioObject

