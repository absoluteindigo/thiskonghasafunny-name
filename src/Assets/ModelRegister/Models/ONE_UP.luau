local Helpers = require(script.Parent.Parent.Helpers)

local Client = workspace.SM64.Client
local Shadow = require(game:GetService('ReplicatedStorage'):WaitForChild('Assets'):WaitForChild('Shadow'))

local Size = 3.498 * (61 / 64)

local class = {
	Name = false,
	Model = false,
}
class.__index = class

local custom = {}
custom.__index = custom

-- build helpers
local partSize = Vector3.new(Size, Size, Size)
local pivotOffset = CFrame.new(0, -Size / 2, 0)

local function buildPart()
	local coin = Instance.new("Part")
	coin.Anchored = true
	coin.CanCollide = false
	coin.Transparency = 1
	coin.Parent = workspace.SM64.Ignore
	coin.Name = ''
	coin.Size = partSize
	coin.PivotOffset = pivotOffset
	return coin
end
local function buildBillboard(Parent)
	local billboard = Instance.new("BillboardGui")
	billboard.Active = true
	billboard.ClipsDescendants = true
	billboard.Size = UDim2.fromScale(Size, Size)
	billboard.ResetOnSpawn = false
	billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	billboard.Name = ''
	billboard.Parent = Parent
	return billboard
end
function buildImage(Parent)
	local image = Instance.new("ImageLabel")
	image.Name = ""
	image.Image = "rbxassetid://118157060896036"
	image.BackgroundTransparency = 1
	image.Size = UDim2.fromScale(1, 1)
	image.Interactable = false
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
	
	ModelClass.shadow = Shadow.new(3.1)
	
	return newModel, custom
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
	self.shadow = nil
	self.billboard = nil
	self.image = nil
end

return class