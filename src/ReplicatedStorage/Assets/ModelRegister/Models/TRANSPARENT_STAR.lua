local coinCommon = require(script.Parent.Parent.Common.starCommon)

local wrapper = {
	Name = 'TRANSPARENT_STAR',
	Model = script.TRANSPARENT_STAR,
}

function wrapper:New(ModelClass)
	local model, custom = coinCommon:New(ModelClass, wrapper.Model)
	
	return model, custom
end

return setmetatable(wrapper, coinCommon)