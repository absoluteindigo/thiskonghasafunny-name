local Helpers = require(script.Parent.Parent.Helpers)

local Client = workspace.SM64.Client
local Shadow = require(game:GetService('ReplicatedStorage'):WaitForChild('Assets'):WaitForChild('Shadow'))
--
-- local model = script.coin

local Size = 3.498

local offsetForIndex = {}
for i = 0,  3 do
	local offset = Vector2.new(32 * i, 0)
	offsetForIndex[i * 2] = offset
	offsetForIndex[(i * 2) + 1] = offset
end

local class = {
	Name = false,
	Model = false,
	colors = {
		yellow = Color3.new(1, 1, 0),
		blue = Color3.fromRGB(120, 120, 255),
		red = Color3.new(1, 0, 0),
	},
	-- constant
	size = Size,
}
class.__index = class

local custom = {}
custom.__index = custom

-- build helpers
local partSize = Vector3.new(Size, Size, Size)
local pivotOffset = CFrame.new(0, -partSize.Y / 2, 0)

local function buildPart()
	local coin = Instance.new("Part")
	coin.Anchored = true
	coin.CanCollide = false
	-- coin.Size = Vector3.new(3.5, 3.5, 3.5)
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
	image.Image = "rbxassetid://101207981414556"
	image.ImageRectOffset = Vector2.new(32, 0)
	image.ImageRectSize = Vector2.new(32, 32)
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
		
		local AnimState = self.Link.AnimState
		
		if AnimState then
			self.image.ImageRectOffset = offsetForIndex[AnimState % 8]
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