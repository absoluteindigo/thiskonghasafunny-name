local Helpers = require(script.Parent.Parent.Helpers)

local Client = workspace.SM64.Client
local Shadow = require(game:GetService('ReplicatedStorage'):WaitForChild('Assets'):WaitForChild('Shadow'))

local class = {
	Name = false,
	Model = false,
	textures = {
		bubble = 'rbxassetid://90473357768502',
		spike = 'rbxassetid://86525356700215',
		palm = 'rbxassetid://99559631148467',
		snow = 'rbxassetid://122000763172668',
	}
}
class.__index = class

local custom = {}
custom.__index = custom

-- build helpers
local partSize = Vector3.new(3.2, 3.2, 3.2)
local pivotOffset = CFrame.new(0, -partSize.Y / 2, 0)
local function buildPart()
	--[[local coin = Instance.new("Part")
	coin.Anchored = true
	coin.CanCollide = false
	-- coin.Size = Vector3.new(3.5, 3.5, 3.5)
	coin.Transparency = 1
	coin.Parent = workspace.SM64.Ignore
	coin.Name = ''
	coin.Size = partSize
	coin.PivotOffset = pivotOffset
	return coin]]
	
	local tree = Instance.new("Part")
	tree.Anchored = true
	tree.CanCollide = false
	tree.CastShadow = false
	tree.EnableFluidForces = false
	tree.Transparency = 1
	tree.Parent = workspace.SM64.Ignore
	return tree
end
local function buildBillboard(Parent)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = ""
	billboard.AutoLocalize = false
	billboard.ResetOnSpawn = false
	billboard.Size = UDim2.fromScale(20.8, 30)
	billboard.StudsOffset = Vector3.new(0, 15.006999969482422, 0)
	billboard.Parent = Parent
	return billboard
end
function buildImage(Parent)
	local image = Instance.new("ImageLabel")
	image.Name = ""
	image.AutoLocalize = false
	image.BackgroundTransparency = 1
	image.Image = "rbxassetid://90473357768502"
	image.Interactable = false
	image.Size = UDim2.fromScale(1, 1)
	image.Parent = Parent
	return image
end

function class:New(ModelClass)
	-- local newModel = Helpers.copy(self.Model)

	local newModel = buildPart()
	local billboard = buildBillboard(newModel)
	local image = buildImage(billboard)

	ModelClass.billboard = billboard
	ModelClass.image = image

	return newModel, custom
end

function custom:addShadow()
	if self.shadow then return end
	self.shadow = Shadow.new(3.1)
end

function custom:Update()
	local shadow = self.shadow

	local wasHidden = self.shadowHidden
	local isHidden = self._lastHidden ~= nil
	if wasHidden ~= isHidden then
		self.shadowHidden = isHidden
		if shadow then
			shadow:setVisible(isHidden)
		end
	end
	--
	if not isHidden then

		-- update shadow
		if shadow then
			local renderedCF = self.renderedCF or self.goalCF :: CFrame
			local pos = renderedCF.Position

			self.shadow:update(
				Vector3.new(pos.X, pos.Y + .8, pos.Z)
			)
		end
	end
end

function custom:Destroy()
	if self.shadow then
		self.shadow:destroy()
	end
end

return class