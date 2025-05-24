local coinCommon = require(script.Parent.Parent.Common.treeCommon)

local wrapper = {
	Name = 'BOB_BUBBLY_TREE'
}

function wrapper:New(ModelClass)
	local model, custom = coinCommon:New(ModelClass)
	
	ModelClass.image.Image = coinCommon.textures.bubble
	-- custom.addShadow(ModelClass)
	
	return model, custom
end

return setmetatable(wrapper, coinCommon)