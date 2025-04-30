local coinCommon = require(script.Parent.Parent.Common.treeCommon)

local wrapper = {
	Name = 'CCM_SNOW_TREE'
}

function wrapper:New(ModelClass)
	local model, custom = coinCommon:New(ModelClass)

	local size = ModelClass.billboard.Size.Y
	ModelClass.billboard.Size = UDim2.new(
		size.Scale / 2, size.Offset / 2,
		size.Scale, size.Offset
	)
	ModelClass.image.Image = coinCommon.textures.snow
	-- custom.addShadow(ModelClass)

	return model, custom
end

return setmetatable(wrapper, coinCommon)