local Helpers = require(script.Parent.Parent.Helpers)
local ReferenceHelper = Helpers.ReferenceHelper

local size = 3.4

local textures = {[0] =
	'rbxassetid://114088282651105',
	'rbxassetid://80899704095730',
	'rbxassetid://117454519047503',
	'rbxassetid://109209229483087',
	'rbxassetid://117393789360420',
	'rbxassetid://102921583400672',
	'rbxassetid://111303641943580',
}

local class = {
	Name = 'EXPLOSION',
	Model = script.hawkone,
	colors = {
		yellow = Color3.new(1, 1, 0),
		blue = Color3.fromRGB(120, 120, 255),
		red = Color3.new(1, 0, 0),
	}
}
class.__index = {}

function class:New(ModelClass)
	local newModel = Helpers.copy(self.Model)
	
	-- reference
	local reference = ReferenceHelper.new(newModel, function(self, instance: Instance)
		if instance:IsA('BillboardGui') then
			ModelClass.billboard = instance
			return
		end
		if instance:IsA('ImageLabel') then
			ModelClass.image = instance
			return
		end
	end)
	ModelClass.reference = reference
	reference:Initialize()
	
	return newModel, class
end

function class:Update()
	-- print(self.Link.GfxScale)
	local billboard = self.billboard :: BillboardGui
	local image = self.image :: ImageLabel
	
	if billboard then
		local scale = self.Link.GfxScale :: Vector3
		billboard.Size = UDim2.fromScale(size * scale.X, size * scale.Y)
	end
	
	if image then
	local AnimState = self.Link.AnimState
		if AnimState then
			if textures[AnimState] then
				image.Visible = true
				image.Image = textures[AnimState]
			else
				image.Visible = false
			end
		end
	end
	
end

function class:Destroy()
	
	self.image = nil
	
	self.reference:Destroy()
	self.reference = nil
end

return class