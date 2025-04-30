local Helpers = require(script.Parent.Parent.Helpers)
local ReferenceHelper = Helpers.ReferenceHelper
--
local Client = workspace.SM64.Client
local Package = require(Client.Package)

local Util = Package.Util
local Shadow = require(game:GetService('ReplicatedStorage'):WaitForChild('Assets'):WaitForChild('Shadow'))

local model = script.BLACK_BOBOMB

local class = {
	Name = 'BLACK_BOBOMB',
	Model = model,
}

local BlinkStates = {
	[0] = 'rbxassetid://84853331764818',
	[1] = 'rbxassetid://89804074512332',
}

local function updateFace(face: MeshPart, i)
	local texture = BlinkStates[i] or BlinkStates[0]
	face.TextureID = texture
end

local scaleYOffset = -1.941
local defaultScale = 1

local function scaleToOffset(Y: number) -- where defaultScale returns 0 and 0 returns y offset
	return scaleYOffset * (defaultScale - Y)
end

local custom = {}
custom.__index = custom

-- helpers
local function scalePart(part, scale, size)
	part.Size = size * scale
end
local function scaleBone(bone, scale, pos)
	bone.Position = pos * scale
end

function class:New(ModelClass)
	local Link = ModelClass.Link
	ModelClass.Scale = (Link and Link.GfxScale) or Vector3.one
	--
	local newModel = Helpers.copy(self.Model) :: Model

	-- reference
	local reference = ReferenceHelper.new(newModel, function(self, instance: Instance)
		if self.TorsoBillboard then return end
		-- instance = newModel:FindFirstChild('TORSO', true)
		
		if instance.Name == 'EYES' and instance:IsA('MeshPart') then
			self.Face = instance
			local animState = Link.AnimState
			self.animState = animState
			updateFace(instance, animState)
		elseif instance.Name == 'TORSO' and instance:IsA('BillboardGui') then
			self.TorsoBillboard = instance
			self.TorsoBillboardSize = instance.Size
			
			local function scale(arg)
				local scale = arg.Scale or Vector3.one
				local size = self.TorsoBillboardSize :: UDim2
				self.TorsoBillboard.Size = UDim2.fromScale(
					size.X.Scale * scale.Z,
					size.Y.Scale * scale.X
				)
			end
			
			self:setScaleCallback(scale)
			scale(Link)
		end
	end)
	ModelClass.reference = reference

	-- shadow
	ModelClass.shadow = Shadow.new(4.5)

	-- scale
	reference:setScaleYOffset(scaleYOffset)
	reference:setOriginalScale(defaultScale)
	reference:setYAxis('X')
	reference:applyScale(Vector3.new(ModelClass.Scale.Y, ModelClass.Scale.Z, ModelClass.Scale.X))
	
	-- begin
	reference:InitializeWithPopulatedTables('000-shadow')
	
	return newModel, custom
end

function custom.Update(self)
	local wasHidden = self.shadowHidden
	local isHidden = self._lastHidden ~= nil
	if wasHidden ~= isHidden then
		self.shadowHidden = isHidden
		self.shadow:setVisible(isHidden)
	end
	--
	if not isHidden then
		local Link = self.Link
		local reference = self.reference
		local face = reference.Face :: MeshPart

		-- update shadow
		local renderedCF = self.renderedCF or self.goalCF :: CFrame
		local pos = renderedCF.Position

		self.shadow:update(
			Vector3.new(pos.X, pos.Y + .8, pos.Z)
		)

		if face then
			local animState = Link.AnimState

			if animState ~= self.animState then
				self.animState = animState
				updateFace(face, animState)
			end
		end

		local animState = Link.AnimState
		
		-- update scale
		local scale = self.Link.GfxScale
		if scale ~= self.Scale then
			self.Scale = scale
			reference:applyScale(Vector3.new(scale.Y, scale.Z, scale.X))
		end
	end
end

function custom.Destroy(self)
	self.Scale = nil
	self.shadowHidden = nil
	
	self.reference:Destroy()
	self.reference = nil
	
	self.shadow:destroy()
	self.shadow = nil
end

return class