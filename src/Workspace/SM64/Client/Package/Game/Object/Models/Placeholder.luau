return function(Models)
	local class = {
		Name = false,
		Model = false,
	}
	class.__index = class

	local custom = {}
	custom.__index = custom

	-- build helpers
	local partSize = Vector3.new(5, 5, 0)
	local pivotOffset = CFrame.new(0, -partSize.Y / 2, 0)
	
	local function decal(parent, color)
		local decal = Instance.new("Decal")
		decal.Parent = parent
		decal.Name = ''
		decal.Color3 = color
		decal.Texture = "rbxassetid://13619407848"
		decal.Transparency = 0.8
		return decal
	end
	
	local function cone(parent)
		local coneHandleAdornment = Instance.new("ConeHandleAdornment")
		coneHandleAdornment.Name = "ConeHandleAdornment"
		coneHandleAdornment.AdornCullingMode = Enum.AdornCullingMode.Never
		coneHandleAdornment.Color3 = Color3.fromRGB(255, 53, 157)
		coneHandleAdornment.Height = 5
		coneHandleAdornment.Radius = 2.5
		coneHandleAdornment.ZIndex = -3
		coneHandleAdornment.Adornee = parent
		coneHandleAdornment.Transparency = .65
		coneHandleAdornment.Parent = parent
		return coneHandleAdornment
	end
	
	local function buildPart(Parent)
		local PART = Instance.new("Part")
		PART.Anchored = true
		PART.CanCollide = false
		PART.CastShadow = false
		PART.EnableFluidForces = false
		PART.Transparency = 1
		PART.Size = partSize
		PART.PivotOffset = pivotOffset
		PART.Parent = Parent
		
		cone(PART)
		decal(PART, Color3.fromRGB(255, 53, 157))
		decal(PART, Color3.fromRGB(139, 110, 255)).Face = Enum.NormalId.Back
		
		return PART
	end
	
	local function buildBillboard(Parent)
		local billboard = Instance.new("BillboardGui")
		billboard.Name = ""
		billboard.AutoLocalize = false
		billboard.ResetOnSpawn = false
		billboard.Size = UDim2.fromScale(5, 5)
		-- billboard.StudsOffset = Vector3.new(0, 2.5, 0)
		billboard.Parent = Parent
		return billboard
	end
	local function buildLabel(Parent, TEXT)
		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = Parent
		textLabel.Name = ""
		textLabel.BackgroundColor3 = Color3.new(.5, .5, .5)
		textLabel.Font = 'Code'
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.Text = tostring(TEXT)
		textLabel.TextScaled = true
		return textLabel
	end

	function class:New(ModelClass, key)
		
		local Model = Instance.new('Model', workspace.SM64.Ignore)
		ModelClass.Animator = Instance.new('AnimationController', Model)
		
		local part = buildPart(Model)
		local billboard = buildBillboard(part)
		local label = buildLabel(billboard, key)
		
		Model.PrimaryPart = part
		
		ModelClass.Part = part
		ModelClass.KEY = key

		return Model, custom
	end

	function custom:Update()
		local Model = rawget(Models, self.KEY)
		if Model then
			self:Destroy()
			self.Link.Model:Destroy()
			self.Link.Model:SetModel(Model)
			return
		end
		
		local isHidden = self._lastHidden ~= nil
		if not isHidden then
			local Link = self.Link

			local scale = Link.GfxScale
			if scale ~= self.Scale then
				self.Scale = scale
				self.Part.Size = partSize * scale
			end
		end
	--[[local isHidden = self._lastHidden ~= nil
	if not isHidden then
		
	end]]
	end

	function custom:Destroy()
		self.KEY = nil
		self.Scale = nil
		self.Part = nil
	end

	return function(key)
		local wrapper = {
			Name = key
		}

		function wrapper:New(ModelClass)
			return class:New(ModelClass, key)
		end

		return setmetatable(wrapper, class)
	end
end