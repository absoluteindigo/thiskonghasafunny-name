local Helpers = require(script.Parent.Parent.Helpers)
local ReferenceHelper = Helpers.ReferenceHelper

local size = 3.4


sparkles_animation_seg4_dl_04035300 = 'rbxassetid://77469449677653'
sparkles_animation_seg4_dl_04035318 = 'rbxassetid://117134893036608'
sparkles_animation_seg4_dl_04035330 = 'rbxassetid://74847226580728'
sparkles_animation_seg4_dl_04035348 = 'rbxassetid://75343917119038'
sparkles_animation_seg4_dl_04035360 = 'rbxassetid://71385262839825'
-- rbxassetid://130300725866577?

local textures = {[0] =
	sparkles_animation_seg4_dl_04035300,
	sparkles_animation_seg4_dl_04035318,
	sparkles_animation_seg4_dl_04035330,
	sparkles_animation_seg4_dl_04035348,
	sparkles_animation_seg4_dl_04035360,
	sparkles_animation_seg4_dl_04035348,
	sparkles_animation_seg4_dl_04035330,
	sparkles_animation_seg4_dl_04035318,
	sparkles_animation_seg4_dl_04035300,
}

local class = {
	Name = 'SPARKLES',
	Model = script.hawktwo,
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