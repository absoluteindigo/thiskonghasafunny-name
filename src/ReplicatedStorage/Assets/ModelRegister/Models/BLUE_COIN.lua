local coinCommon = require(script.Parent.Parent.Common.coinCommon)

local wrapper = {
	Name = 'BLUE_COIN'
}

local size = coinCommon.size * (100 / 64)
local partSize = Vector3.new(size, size, size)
local pivotOffset = CFrame.new(0, -size / 2, 0)

function wrapper:New(ModelClass)
	local model, custom = coinCommon:New(ModelClass)

	model.Size = partSize
	model.PivotOffset = pivotOffset

	ModelClass.billboard.Size = UDim2.fromScale(size, size)

	ModelClass.image.ImageColor3 = coinCommon.colors.blue

	custom.addShadow(ModelClass)
	
	return model, custom
end

return setmetatable(wrapper, coinCommon)