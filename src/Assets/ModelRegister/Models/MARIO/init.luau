local Helpers = require(script.Parent.Parent.Helpers)
local ReferenceHelper = Helpers.ReferenceHelper
--
local Client = workspace.SM64.Client
local Package = require(Client.Package)

local Util = Package.Util
local FFlags = Package.FFlags
local Shadow = require(game:GetService('ReplicatedStorage'):WaitForChild('Assets'):WaitForChild('Shadow'))

local Enums = Package.Enums

local Action = Enums.Action

local MarioFlags = Enums.MarioFlags
local MarioFlagsCAP_ON_HEAD = MarioFlags.CAP_ON_HEAD
local MarioFlagsVANISH_CAP = MarioFlags.VANISH_CAP
local MarioFlagsMETAL_CAP = MarioFlags.METAL_CAP
local MarioFlagsWING_CAP = MarioFlags.WING_CAP

local class = {
	Name = 'MARIO',
	Model = script.MARIO,
}

local SHADOW_OFFSET = 4

SHADOW_OFFSET = Vector3.new(0, SHADOW_OFFSET, 0)
SHADOW_SIZE = 5 * 1.1801643857253745

local custom = {}
custom.__index = custom

-- helpers
local function scalePart(part, scale, size)
	part.Size = size * scale
end
local function scaleBone(bone, scale, pos)
	bone.Position = pos * scale
end

local referenceMacros = {
	['000-offset'] = 'RootOffset',
	['002-rotate'] = 'TorsoBone',
	['002-rotate.001'] = 'HeadBone',
}


local pieces = {}
for category, keys in pairs({

	--[[Cap = {'C', 'CE'},
	CapHair = {'HCL'},
	CapAll = {'C', 'CE', 'GRCC', 'GRCCI'}, -- includes mario's hand held cap
	Shirt = {'SH'},
	Skin = {'SK', 'SKM', 'SKSB', 'SKE'},
	Shoes = {'FL', 'FR'},
	Pants = {'P', 'PB'},
	Gloves = {'GL', 'GLO', 'GR', 'GRC', 'GRP', 'GRO', 'GRP'},
	Hair = {'H', 'HCL'},
	Wings = {'WL1', 'WL2', 'WR1', 'WR2'},
	LeftClosed = {'GL'},
	RightClosed = {'GR'},
	LeftOpen = {'GLO'},
	RightOpen = {'GRO'},

	RightPeace = {'GRP'},
	RightCap = {'GC'},
	RightCapWings = {},

	Eyes = {'SKE'},
	Sideburns = {'SKSB'},
	Mustache = {'SKM'},
	Buttons = {'PB'},

	LeftHand = {'GL', 'GLO'},
	RightHand = {'GR', 'GRC', 'GRP', 'GRO', 'GRP'},
	RightFoot = {'FR'},]]

	}) do
	for _, key in pairs(keys) do
		local last = pieces[key]
		if not last then
			last = {}
			pieces[key] = last
		end
		table.insert(last, category)
	end
end

local EyeImages = {
	center = 'rbxassetid://134924770915499',
	-- center = 'rbxassetid://88988438893339',
	half_closed = 'rbxassetid://80763339756107',
	closed = 'rbxassetid://95433608110282',
	dead = 'rbxassetid://117213252768378',
	up = 'rbxassetid://134010917516683', -- unused
	right = 'rbxassetid://118129297614836', -- unused
	left = 'rbxassetid://103598263259823', -- ununsed
	down = 'rbxassetid://80763339756107', -- ununsed
	closed0 = 'rbxassetid://99654555734183', -- unused
	closed1 = 'rbxassetid://103796356750914', -- unused
}
local EyeStateCase = { [0] =
	'center',
	'half_closed',
	'closed',
	'dead',
	'right', -- unused
	'left', -- unused
	'up', -- unused
	'down', -- unused
}

-- see if part is has at least one catergory tied to its name
local function handleCategory(reference: {[any]: any}, part: BasePart)
	local name = part.Name
	local categories = pieces[name]
	if categories then
		for _, category in pairs(categories) do
			local parts = reference[category]
			if not parts then
				parts = {}
				reference[category] = parts
			end
			table.insert(parts, part)
			reference.Transparencies[part] = part.Transparency ~= 1 and part.Transparency or 0
		end
	end
end

function class:New(ModelClass)
	local Link = ModelClass.Link
	ModelClass.Scale = (Link and Link.GfxScale) or Vector3.one
	--
	local newModel = Helpers.copy(self.Model) :: Model

	-- reference
	local reference = ReferenceHelper.new(newModel, function(self, instance: Instance)
		local macro = referenceMacros[instance.Name]
		if macro then
			self[macro] = instance
			return
		end
		if instance:IsA('BasePart') then
			handleCategory(self, instance)
		end
	end)
	reference.Transparencies = {}
	ModelClass.reference = reference

	-- shadow
	ModelClass.shadow = Shadow.new(SHADOW_SIZE)

	-- scale
	reference:setScaleYOffset(-1.161)
	reference:setYAxis('X')
	reference:applyScale(Vector3.new(ModelClass.Scale.Y, ModelClass.Scale.Z, ModelClass.Scale.X))

	-- begin
	reference:InitializeWithPopulatedTables('000-shadow')

	return newModel, custom
end


local marioBlinkAnimation = { [0] = 1, 2, 1, 0, 1, 2, 1 }
local numBlinkCases = #marioBlinkAnimation + 1

local ACT_FLAG_SWIMMING_OR_FLYING = Package.Enums.ActionFlags.SWIMMING_OR_FLYING
-- local ACT_FLAG_SWIMMING_OR_FLYING = bit32.lshift(1, 28) -- (1 << 28)
local MARIO_HAND_OPEN, MARIO_HAND_FIST = Package.Enums.MarioHands.OPEN, Package.Enums.MarioHands.FISTS
local marioLeftHandModels = {
	key = 'LeftHand',
	[0] = "mario_left_hand_closed",
	[1] = "mario_left_hand_open",
	selectedCase = 0,
	numCases = 1,
}
local marioRightHandModels = {
	key = 'RightHand',
	[0] = "mario_right_hand_closed",
	[1] = "mario_right_hand_open",
	[2] = "mario_right_hand_peace",
	[3] = "mario_right_hand_cap",
	[4] = "mario_right_hand_cap_wings",
	selectedCase = 0,
	numCases = 0,
}
for i, v in pairs({{marioLeftHandModels, 1}, {marioRightHandModels, 4}}) do
	local node = v[1]
	for i = 0, v[2] do
		node[i] = i
	end
	-- v.numCases = #v + 1
end
local leftHandCase = { [0] =
	"LeftClosed",
	"LeftOpen",
}
local rightHandCase = { [0] =
	"RightClosed",
	"RightOpen",
	"RightPeace",
	"RightCap",
	"RightCapWings",
}
local pseudoHandNodes = {marioLeftHandModels, marioRightHandModels}

--
local attackAnims = { [0] =
	1.0, 1.2, 1.6, 2.4, 1.0, 1.0,
	1.0, 1.4, 2.0, 3.0, 1.0, 1.0,
	1.0, 1.6, 2.0, 2.6, 2.6, 2.0,
}
leftHandScaleNode = {
	key = 'LeftScale',
	parameter = 1,
	scale = 1,
}
rightHandScaleNode = {
	key = 'RightScale',
	parameter = 0,
	scale = 1,
}
footScaleNode = {
	key = 'FootScale',
	parameter = 2,
	scale = 1,
}
sMarioAttackAnimCounter = 0
local pseudoScaleNodes = {leftHandScaleNode, rightHandScaleNode, footScaleNode}


function custom.Tick(self)
	local mario = self.Link :: Package.Mario
	if not mario then return end

	local gAreaUpdateCounter = Util.GlobalTimer -- INNACRUATE but oh well

	local action = mario.Action()
	local bodyState = mario.BodyState

	local headAngle = bodyState.HeadAngle
	local torsoAngle = bodyState.TorsoAngle
	local handState = bodyState.HandState .Value
	local capState = bodyState.CapState .Value

	--> geo_mario_tilt_torso
	if
		action ~= Action.BUTT_SLIDE
		and action ~= Action.WALKING
		and action ~= Action.RIDING_SHELL_GROUND
	then
		bodyState.TorsoAngle = Vector3.zero
	end

	--> geo_switch_mario_eyes
	local SelectedEyeState = 0

	if bodyState.EyeState == 0 then
		local blinkFrame = bit32.band(bit32.rshift((numBlinkCases * 32 + gAreaUpdateCounter), 1), 0x1F)
		if blinkFrame < 7 then
			SelectedEyeState = marioBlinkAnimation[blinkFrame]
		else
			SelectedEyeState = 0
		end
	else
		SelectedEyeState = bodyState.EyeState - 1
	end

	self.SelectedEyeState = SelectedEyeState

	--> geo_switch_mario_hand
	-- Switch between hand models.
	-- Possible options are described in the MarioHandGSCId enum.

	-- local isSwimmingOrFlying = action:Has(ACT_FLAG_SWIMMING_OR_FLYING) and 1 or 0
	local isSwimmingOrFlying = bit32.band(action, ACT_FLAG_SWIMMING_OR_FLYING) ~= 0 and 1 or 0

	for k, node in ipairs(pseudoHandNodes) do
		local key = node.key
		local selectedCase = 0

		if handState == MARIO_HAND_FIST then
			-- Switch between fists (0) and open (1) if Mario is swimming or flying
			selectedCase = isSwimmingOrFlying
		else
			if node.numCases == 0 then
				selectedCase = (handState < 5) and handState or MARIO_HAND_OPEN
			else
				selectedCase = (handState < 2) and handState or MARIO_HAND_FIST
			end
		end

		self[key] = node[selectedCase]
	end

	--> geo_mario_hand_foot_scaler
	--[[
		* Increase Mario's hand / foot size when he punches / kicks.
		* Since animation geo nodes only support rotation, this scaling animation
		* was scripted separately. The node with this script should be placed before
		* a scaling node containing the hand / foot geo layout.
		* ! Since the animation gets updated in GEO_CONTEXT_RENDER, drawing Mario multiple times
		* (such as in the mirror room) results in a faster and desynced punch / kick animation.
	]]
	bodyState.PunchState = bodyState.PunchState or 0
	for k, node in pairs(pseudoScaleNodes) do
		-- local scaleNode = node.next
		local key = node.key

		self[key] = 1
		-- scaleNode.scale = 1.0
		if node.parameter == bit32.rshift(bodyState.PunchState, 6) then
			if sMarioAttackAnimCounter ~= gAreaUpdateCounter and bit32.band(bodyState.PunchState, 0x3F) > 0 then
				bodyState.PunchState -= 1

				sMarioAttackAnimCounter = gAreaUpdateCounter
			end
			-- scaleNode.scale =
			self[key] = 
				-- gMarioAttackScaleAnimation
				attackAnims[node.parameter * 6 + bit32.band(bodyState.PunchState, 0x3F)]
			-- / 10.0 lets skip this step by diving ourselves lol
		end
	end

	--> geo_switch_mario_cap_on_off
	--[[
	* Determine whether Mario's head is drawn with or without a cap on.
	* Also sets the visibility of the wing cap wings on or off.
	]]

	self.CapOff = not mario.Flags:Has(MarioFlagsCAP_ON_HEAD) -- bit32.band(capState, 1) ~= 0
	self.WingCap = mario.Flags:Has(MarioFlagsWING_CAP)
	--[[node.selectedCase = bit32.band(capState, 1)
	-- if next.type == GRAPH_NODE_TYPE_TRANSLATION_ROTATION then
	if bit32.band(capState, 2) ~= 0 then
		next.flags = bit32.bor(next.flags, GRAPH_RENDER_ACTIVE)
	else
		next.flags = bit32.band(next.flags, bit32.bnot(GRAPH_RENDER_ACTIVE))
	end]]
	-- end
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
		local mario = self.Link

		local bodyState = mario.BodyState

		local reference = self.reference

		if bodyState then
			local TorsoAngle = bodyState.TorsoAngle
			local HeadAngle = bodyState.HeadAngle

			-- torso
			local torsoBone = reference.TorsoBone :: Bone
			if torsoBone and TorsoAngle then
				local n = 170.06
				local angle = CFrame.new() * CFrame.Angles(
					math.rad( TorsoAngle.Y / n ),
					-- 0,
					math.rad( TorsoAngle.Z / n ),
					-math.rad( TorsoAngle.X / n )
				)

				torsoBone.CFrame = angle
			end

			-- eyes
			if self.SelectedEyeState and reference.LASTE ~= self.SelectedEyeState then
				reference.LASTE = self.SelectedEyeState
				local Eyes = reference.Eyes

				if Eyes then
					local key = EyeStateCase[self.SelectedEyeState]
					local image = EyeImages[key]

					if image then
						Eyes[1].TextureID = image
					end
				end
			end

			-- hands

			local leftHand, rightHand = self.LeftHand, self.RightHand

			local Gloves = reference.Gloves
			if Gloves then
				if self.LASTL ~= leftHand or self.LASTR ~= rightHand then
					self.LASTL = leftHand
					self.LASTR = rightHand

					local lKey, rKey = leftHandCase[leftHand or reference._LLH or 0], rightHandCase[rightHand or reference._LRH or 0]
					local visible = {} :: {[BasePart]: boolean}
					for _, list in pairs({reference[lKey], reference[rKey]}) do
						for _, part in pairs(list) do
							visible[part] = 0
						end
					end
					for _, part: BasePart in pairs(Gloves) do
						part.Transparency = visible[part] or 1
					end
				end
			end

			-- scalar
			local LeftScale, RightScale, FootScale = self.LeftScale or 1, self.RightScale or 1, self.FootScale or 1
			local category = reference.LeftHand

			if category and LeftScale ~= self.LASTLS then
				print('LeftScale')
				self.LASTLS = LeftScale
				for _, piece in pairs(category) do
					piece.Size = reference.Parts[piece] * LeftScale
				end
			end
			category = reference.RightHand
			if category and RightScale ~= self.LASTRS then
				self.LASTRS = RightScale
				for _, piece in pairs(category) do
					piece.Size = reference.Parts[piece] * RightScale
				end
			end
			category = reference.RightFoot
			if category and FootScale ~= self.LASTFS then
				self.LASTFS = FootScale
				for _, piece in pairs(category) do
					piece.Size = reference.Parts[piece] * FootScale
				end
			end
		end

		-- cap

		local CapOff = self.CapOff

		if self.LASTCO ~= CapOff then
			self.LASTCO = CapOff
			local CapOn = not CapOff
			for _, part in pairs(reference.Cap or {}) do
				part.Transparency = CapOn and (reference.Transparencies[part] or 0) or 1
			end
			local transparency = CapOff and 0 or 1
			for _, part in pairs(reference.CapHair or {}) do
				part.Transparency = transparency
			end

		end

		local WingCap = self.WingCap

		if self.LASTWC ~= WingCap then
			self.LASTWC = WingCap
			local transparency = WingCap and 0 or 1
			if reference.Wings then
				for _, part in pairs(reference.Wings) do
					part.Transparency = transparency
				end
			end
		end


		-- update shadow
		local renderedCF = self.renderedCF or self.goalCF :: CFrame
		local pos = renderedCF.Position

		local Bone = reference.RootOffset :: Bone
		if Bone then
			self.shadow:update(
				Bone.WorldPosition + SHADOW_OFFSET
				-- Vector3.new(pos.X, pos.Y + .8, pos.Z)
			)
		end

		-- update scale
		local scale = mario.GfxScale
		if scale ~= self.Scale then
			self.Scale = scale
			reference:applyScale(Vector3.new(scale.Y, scale.Z, scale.X))
		end
	end
end

function custom.Destroy(self)
	-- self.Face = nil
	self.Scale = nil
	self.shadowHidden = nil
	self.TorsoBillboard = nil
	self.TorsoBillboardSize = nil
	self.animState = nil

	self.reference:Destroy()
	self.reference = nil

	self.shadow:destroy()
	self.shadow = nil
end

return class