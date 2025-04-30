local coinCommon = require(script.Parent.Parent.Common.coinCommon)

local wrapper = {
	Name = 'RED_COIN'
}

function wrapper:New(ModelClass)
	local model, custom = coinCommon:New(ModelClass)
	
	ModelClass.image.ImageColor3 = coinCommon.colors.red
	custom.addShadow(ModelClass)
	
	return model, custom
end

return setmetatable(wrapper, coinCommon)