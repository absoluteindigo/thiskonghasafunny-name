local coinCommon = require(script.Parent.Parent.Common.coinCommon)

local wrapper = {
	Name = 'RED_COIN_NO_SHADOW'
}

function wrapper:New(ModelClass)
	local model, custom = coinCommon:New(ModelClass)
	ModelClass.image.ImageColor3 = coinCommon.colors.red
	return model, custom
end

return setmetatable(wrapper, coinCommon)