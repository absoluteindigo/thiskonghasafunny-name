-- a custom model class (for rendering models n stuff)

--[[ fun trick
local Hidden = Instance.new('ViewportFrame')
Hidden.Name = 'Hidden'
Hidden.Archivable = false
Hidden.Parent = workspace.Terrain]]

local FFlags = require(script.Parent.Parent.FFlags)
local Assets = game:GetService('ReplicatedStorage'):WaitForChild('Assets')
local Util = require(script.Parent.Parent.Util)

local FLIP = CFrame.Angles(0, math.pi, 0)
local GraphNodeConstats = require(script.Parent.Parent.Game.Object.GraphNodeConstats)

local PLACEHOLDER_ANIM_ID = 'rbxassetid://0'
local STEP_RATE = FFlags.STEP_RATE

local ModelClass = {}
ModelClass.__index = ModelClass

local gMarioObject = require(script.Parent.Parent.Game.Object.gMarioObject)

local dontInterpoate = {
	[-1] = true,
	[0] = true,
	[1] = true,
}

-- if new is missing..
function simpleNew(model)
	local newModel = model.Model:Clone()
	newModel.Parent = workspace.SM64.Ignore
	return newModel, nil
end

function ModelClass.new(link: any?)
	local self = setmetatable({}, ModelClass)
	-- self.Model = Assets.Goomba:Clone() -- nil
	-- self.Model.Parent = workspace.SM64.Ignore

	self.Link = link or self

	self.Position = Vector3.zero
	self.GfxAngle = Vector3.zero
	self.GfxPos = Vector3.zero
	self.GfxScale = Vector3.one

	self.activeTrack = nil
	self.loadedAnims = {}

	self:Update()
	self:Render()

	return self
end


function ModelClass:SetModel(model)
	self:Destroy()
	
	if not model then
		warn('NO MODEL PASSED IN', debug.traceback())
		return
	end
	
	self.Name = model.Name
	local new = model.New or simpleNew
	local Model, Custom = new(model, self)

	if Custom then
		self.Custom = Custom
		self.CustomTick = Custom.Tick
		self.CustomUpdate = Custom.Update
		self.CustomDestroy = Custom.Destroy
	end

	self.Model = Model
end

function ModelClass:Update(model)
	local Link = self.Link
	local gMarioObject = gMarioObject()
	
	local isHeldObj = Link == gMarioObject.HeldObj
	self.IsHeldObject = isHeldObj
	-- print(Link)

	local gfxPosOffset = Util.ToRoblox(Link.GfxPos)
	local gfxPos = Util.ToRoblox(isHeldObj and gMarioObject.BodyState.HeldObjLastPos or Link.Position) + gfxPosOffset
	-- local throwPos = Util.ToRoblox((Link.ThrowMatrix or CFrame.identity).Position)
	local gfxRot = Util.ToRotation(Link.GfxAngle)
	
	-- Link.GfxPos = Vector3.zero
	-- Link.GfxAngle = Vector3int16.new()

	local prevCF = self.goalCF :: CFrame
	local goalCF = CFrame.new(gfxPos) * FLIP * gfxRot :: CFrame
	
	-- ughghhg
	local throwMatrix = Link.ThrowMatrix
	if throwMatrix then
		local throwPos = Util.ToRoblox(throwMatrix.Position)
		goalCF = throwMatrix.Rotation * FLIP + throwPos
	end
	--
	
	self.prevCF = prevCF
	self.goalCF = goalCF

	self:updateAnimation()
	
	if self.CustomTick then
		self.CustomTick(self)
	end
end
function ModelClass:Render(subframe: number)
	-- print(self.Link.GfxScale)
	local Model = self.Model :: Model
	if Model then
		local Link = self.Link
		local isHeldObj = self.IsHeldObject
		
		if (not isHeldObj) and (
			Link.GfxFlags and ( Link.GfxFlags:Has(GraphNodeConstats.GRAPH_RENDER_INVISIBLE) or (
					not Link.GfxFlags:Has(GraphNodeConstats.GRAPH_RENDER_ACTIVE)
				)
			)
		) then
			if self._lastHidden then
				return self.CustomUpdate and self.CustomUpdate(self)
			end
			self._lastHidden = Model.Parent
			Model.Parent = nil
			return self.CustomUpdate and self.CustomUpdate(self)
		end

		if self._lastHidden then
			Model.Parent = self._lastHidden
			self._lastHidden = nil
		end

		local prevCF = self.prevCF
		local goalCF = self.goalCF

		if subframe then
			if dontInterpoate[Link.Timer] == nil and FFlags.CHARACTER_INTERPOLATION and prevCF then
				goalCF = prevCF:Lerp(goalCF, subframe)
			end
		end

		self.renderedCF = goalCF
		Model:PivotTo(goalCF)
	end

	if self.CustomUpdate then
		self.CustomUpdate(self)
	end
end

-- animations
function ModelClass:updateAnimation()
	-- local CharacterReference = self.CharacterReference :: CharacterReference.PlayerReference
	local model = self.Model :: Model
	
	if model then
		local Link = self.Link
		local activeTrack = self.activeTrack :: AnimationTrack?
		local loadedAnims = self.loadedAnims
		local simSpeed = FFlags.TIME_SCALE

		--local humanoid = self.Humanoid :: Humanoid
		local animator = self.Animator :: Animator
		--[[if not humanoid then
			local humanoid = model:FindFirstChildOfClass('Humanoid') -- CharacterReference.Humanoid
			self.Humanoid = humanoid
		end]]
		if not animator then
			-- local animator = model:FindFirstChild('Animator', true) -- CharacterReference.Animator
			local animator = model:FindFirstChild('AnimationController', true) -- CharacterReference.Animator
			self.Animator = animator
		end

		-- local isExternalAnims = (humanoid and humanoid:HasTag("HandleAnimsExternally"))
		local isExternalAnims = (model and model:HasTag("HandleAnimsExternally"))

		if animator and model.Parent and (Link.AnimDirty or Link.AnimReset) and Link.AnimFrame >= 0 then
			local anim = Link.AnimCurrent
			local animSpeed = 0
			if FFlags.ANIMATION_SMOOTHENING then
				animSpeed = 0.1 / simSpeed
			end

			if activeTrack and (activeTrack.Animation ~= anim or Link.AnimReset) then
				--[[if tostring(activeTrack.Animation) == "TURNING_PART1" then
					if anim and anim.Name == "TURNING_PART2" then
						Link.AnimSkipInterp = 2
						Link.AnimSetFrame = 0
						if FFlags.ANIMATION_SMOOTHENING then
							animSpeed *= 2
						end
					end
				end]]

				activeTrack:Stop(animSpeed)
				activeTrack = nil
			end

			if animator and not activeTrack and anim then
				if anim.AnimationId == '' then
					warn('Empty AnimationId for', anim, 'Replaced with placeholder.')
					anim.AnimationId = PLACEHOLDER_ANIM_ID
				end
				
				local track = loadedAnims[anim.Name] or animator:LoadAnimation(anim)
				activeTrack = track

				if not isExternalAnims then
					if not loadedAnims[anim.Name] then
						loadedAnims[anim.Name] = track
					end
					track:Play(animSpeed, 1, 0)
				else
					animator:SetAttribute("AnimSetFrame", 0)
				end
			end
			Link.AnimDirty = false
			Link.AnimReset = false
		end

		if activeTrack then
			local speed = Link.AnimAccel / 0x10000
			speed = if speed > 0 then speed * simSpeed else simSpeed
			activeTrack:AdjustSpeed(speed)
		end

		if activeTrack and Link.AnimSetFrame > -1 then
			if isExternalAnims and animator then
				animator:SetAttribute("AnimSetFrame", Link.AnimSetFrame)
			end

			activeTrack.TimePosition = Link.AnimSetFrame / FFlags.STEP_RATE
			Link.AnimSetFrame = -1
		end

		self.activeTrack = activeTrack
		self.loadedAnims = loadedAnims
	end
end

function ModelClass:Destroy()
	self.Name = nil
	self.Humanoid = nil
	self.Animator = nil

	if self.Model then
		self.Model:Destroy()
	end
	self.CustomTick = nil
	self.CustomUpdate = nil

	local CustomDestroy = self.CustomDestroy
	self.Custom = nil
	self.CustomDestroy = nil
	
	self.activeTrack = nil
	self.loadedAnims = {}
	
	self.IsHeldObject = nil
	self.prevCF = nil

	if CustomDestroy then
		CustomDestroy(self)
	end
end


return ModelClass