-- made to ease the development of a model's reference, by prociding the most nessesary functions

local ReferenceHelper = {}
ReferenceHelper.__index = ReferenceHelper

-- helper
function ReferenceHelper:_processInstance(instance, primaryBoneName)
	if instance:IsA("BasePart") then
		self.Parts[instance] = instance.Size
	elseif instance:IsA("Bone") then
		if primaryBoneName then
			-- if primaryBoneName is being used
			if instance.Name == primaryBoneName then
				self.Bone = instance
				-- clear out bones that shouldnt be here
				for thisBone, originalPosition in pairs(table.clone(self.Bones)) do
					if thisBone == instance then continue end
					if thisBone:IsDescendantOf(instance) then continue end
					self.Bones[thisBone] = nil
					thisBone.Position = originalPosition
				end
				self.Bones[instance] = instance.Position
				-- UPDATE SCALE
			else
				local bone = self.Bone :: Bone
				if instance.Position ~= Vector3.zero then
					if bone then
						if instance:IsDescendantOf(bone) then
							self.Bones[instance] = instance.Position
							-- UPDATE SCALE
						end
					else
						self.Bones[instance] = instance.Position
						-- UPDATE SCALE
					end
				end
			end
		else
			self.Bones[instance] = instance.Position
			-- UPDATE SCALE
		end


		if primaryBoneName and instance.Name == primaryBoneName then
			self.Bone = instance
		end
		self.Bones[instance] = instance.Position
	end
	if self._onDesendantCallback then
		self:_onDesendantCallback(instance, self)
	end
end


-- CLASS
function ReferenceHelper.new(model, onDesendantCallback: (Reference: any, instance: Instance)-> nil )
	local self = setmetatable({}, ReferenceHelper)
	self.Model = model

	self.Parts = {}
	self.Bones = {}
	self.Bone = nil -- primary bone
	self.Scale = Vector3.one

	self._onDesendantCallback = onDesendantCallback or function() end

	return self
end

function ReferenceHelper:Initialize()
	local model = self.Model

	self.addedConnection = model.DescendantAdded:Connect(function(descendant)
		self:_onDesendantCallback(descendant)
	end)
	for _, instance in ipairs(model:GetDescendants()) do
		self:_onDesendantCallback(instance)
	end
end

function ReferenceHelper:InitializeWithPopulatedTables(primaryBoneName)
	self.Parts = {}
	self.Bones = {}

	-- populate
	self.addedConnection = self.Model.DescendantAdded:Connect(function(instance)
		self:_onDesendantCallback(instance)
		self:_processInstance(instance, primaryBoneName)
	end)
	for _, instance in ipairs(self.Model:GetDescendants()) do
		self:_onDesendantCallback(instance)
		self:_processInstance(instance, primaryBoneName)
	end
end

-- scaling
function ReferenceHelper:setScaleYOffset(new)
	self.scaleYOffset = new or false
end
function ReferenceHelper:setOriginalScale(new)
	self.defaultScale = new
end
function ReferenceHelper:setYAxis(new)
	self.yAxis = new or 'Y'
end

function ReferenceHelper:setScaleCallback(callback: (scale: Vector3)-> nil)
	self._applyScaleCallback = callback
end

function ReferenceHelper:applyScale(scale: Vector3?)
	self.Scale = scale or self.Scale

	local scaleYOffset = self.scaleYOffset

	for part, originalSize in pairs(self.Parts) do
		self:_scalePart(part, originalSize)
	end

	if scaleYOffset then
		local yScale = self.Scale[self.yAxis or 'Y']
		local primaryBone = self.Bone :: Bone
		for bone, originalPos in pairs(self.Bones) do
			if bone == primaryBone then
				primaryBone.Position = Vector3.new(originalPos.X, originalPos.Y + (
					scaleYOffset * ((self.defaultScale or 1) - yScale)
					), originalPos.Z)
				continue
			end
			self:_scaleBone(bone, originalPos)
		end
	else
		for bone, originalPos in pairs(self.Bones) do
			self:_scaleBone(bone, originalPos)
		end
	end
	
	if self._applyScaleCallback then
		self:_applyScaleCallback(self.Scale)
	end
end

function ReferenceHelper:_scalePart(part: BasePart, size: Vector3)
	part.Size = (size or self.Parts[part]) * self.Scale
end
function ReferenceHelper:_scaleBone(bone: Bone, position: Vector3)
	bone.Position = (position or self.Bones[bone]) * self.Scale
end


function ReferenceHelper:Destroy() -- cleanup
	if self.addedConnection then
		self.addedConnection:Disconnect()
		self.initConnection = nil
	end
end

return ReferenceHelper