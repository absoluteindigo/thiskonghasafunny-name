local Package = require(workspace.SM64.Client.Package)

local Object = Package.Game.Object

local BehaviorData = Object.BehaviorData
local Models = Object.Models
local BehaviorScripts = BehaviorData.BehaviorScripts

local Util = Package.Util

local Switch = Util.Switch

--
flagProperties = {}
for k, v in pairs({
	'ActiveFlags',
	'BhvParams',
	'CollidedObjInteractTypes',
	'Flags',
	'MoveFlags',
	'InteractStatus',
	'InteractionSubtype',
	'GfxFlags',
	}) do
	flagProperties[v] = true
end

-- HELPERS
local function hidePart(part: BasePart)
	if not part:IsA('BasePart') then return true end
	part.Transparency = 1
	part.CanCollide = false
	part:ClearAllChildren()
end

local function getBottomPosition(part: BasePart)
	local extents = Util.GetExtents(part) / Util.Scale
	local pos = Util.ToSM64(part.Position)
	local size = extents - pos

	return pos - Vector3.new(0, size.Y, 0)
end

function WrapSigned16(n)
	return ((n + 0x8000) % 0x10000) - 0x8000
end

local function getYaw(part: BasePart)
	local lookVector = part.CFrame.LookVector
	local angle = WrapSigned16(Util.Atan2s(lookVector.Z, lookVector.X))
	return angle
end

local function getPositionAndYaw(part: BasePart)
	return getBottomPosition(part), getYaw(part)
end

local CollectionService = game:GetService('CollectionService')

local function handle(part: Part)
	if not part:HasTag('Object') then return end
	local attributes = part:GetAttributes()

	local script = BehaviorScripts[assert(attributes.Script)]
	local Model = Models[attributes.Model or 'NONE']

	if hidePart(part) then return end
	
	for k, v in pairs(attributes) do
		if flagProperties[k] then
			attributes[k] = Package.Types.Flags.new(v)
		end
	end

	attributes.Script = nil
	attributes.Model = nil

	Object.Custom.SpawnObject(
		script,
		Model,
		getBottomPosition(part),
		getYaw(part),
		attributes)
end

workspace.DescendantAdded:Connect(handle)
for k, part in pairs(CollectionService:GetTagged('Object')) do
	if part:IsDescendantOf(workspace) then
		handle(part)
	end
end