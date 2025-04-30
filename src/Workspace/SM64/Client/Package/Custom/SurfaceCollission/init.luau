-- an entierly custom solution to sm64 object's collission CollissionData

local FLIP = CFrame.Angles(0, math.pi, 0)

local CollissionParent = workspace.SM64.Collission

local Package = script.Parent.Parent

local Enums = require(Package.Enums)
local Util = require(Package.Util)

local SurfaceClass = Enums.SurfaceClass

-- SurfaceCollission class
local CollissionData = {}
local SurfaceCollission = {
	CollissionData = CollissionData,
}
SurfaceCollission.__index = SurfaceCollission

SURFACE_SLOW = SurfaceClass.SLOW
SURFACE_WATER = SurfaceClass.WATER
SURFACE_HARD_SLIPPERY = SurfaceClass.HARD_SLIPPERY
SURFACE_DEATH_PLANE = SurfaceClass.DEATH_PLANE
SURFACE_DEFAULT = SurfaceClass.DEFAULT
SURFACE_FLOWING_WATER = SurfaceClass.FLOWING_WATER
SURFACE_DEEP_MOVING_QUICKSAND = SurfaceClass.DEEP_MOVING_QUICKSAND
SURFACE_HANGABLE = SurfaceClass.HANGABLE
SURFACE_HARD_VERY_SLIPPERY = SurfaceClass.HARD_VERY_SLIPPERY
SURFACE_VERY_SLIPPERY = SurfaceClass.VERY_SLIPPERY
SURFACE_VERTICAL_WIND = SurfaceClass.VERTICAL_WIND
SURFACE_INSTANT_QUICKSAND = SurfaceClass.INSTANT_QUICKSAND
SURFACE_HARD_NOT_SLIPPERY = SurfaceClass.HARD_NOT_SLIPPERY
SURFACE_MOVING_QUICKSAND = SurfaceClass.MOVING_QUICKSAND
SURFACE_INSTANT_MOVING_QUICKSAND = SurfaceClass.INSTANT_MOVING_QUICKSAND
SURFACE_HORIZONTAL_WIND = SurfaceClass.HORIZONTAL_WIND
SURFACE_QUICKSAND = SurfaceClass.QUICKSAND
SURFACE_SHALLOW_MOVING_QUICKSAND = SurfaceClass.SHALLOW_MOVING_QUICKSAND
SURFACE_NOT_SLIPPERY = SurfaceClass.NOT_SLIPPERY
SURFACE_DEEP_QUICKSAND = SurfaceClass.DEEP_QUICKSAND
SURFACE_SHALLOW_QUICKSAND = SurfaceClass.SHALLOW_QUICKSAND
SURFACE_HARD = SurfaceClass.HARD
SURFACE_SLIPPERY = SurfaceClass.SLIPPERY
SURFACE_BURNING = SurfaceClass.BURNING

local nullModel = {}
nullModel.__index = nullModel
function nullModel.New(key, object)
	return setmetatable({
		[2] = object,
		name = key,
	}, nullModel)
end

function nullModel:Update()
	if CollissionData[self.name] then
		self.New = nil
		self.Update = nil

		local found = SurfaceCollission.New(self.name)

		self[1] = found[1]
		-- self[2] = found[2]
		self.name = found.name

		setmetatable(self, SurfaceCollission)

		return
	end
end

function SurfaceCollission.Register(key, model)
	if CollissionData[key] then
		return false
	end
	CollissionData[key] = model
	return true
end

function SurfaceCollission.New(key, object)
	if not CollissionData[key] then
		warn('no surface collission model for', key)
		return nullModel.New(key, object)
	end
	return setmetatable({
		[1] = CollissionData[key]:Clone(),
		[2] = object,
		name = key,
	}, SurfaceCollission)
end

function SurfaceCollission:Update()
	local object = self[2] :: Instance

	if not object then
		return
	end

	local model = self[1] :: Model

	-- self.a refferes to the previous active state
	local active = self.Active
	self.Active = false

	if active ~= self.a then
		self.a = active
		model.Parent = active and CollissionParent or nil
	end
	if not active then return end

	local pos, yaw = object.Position, object.FaceAngleYaw
	if self.p ~= pos or self.y ~= yaw then
		self.p, self.y = pos, yaw
		local robloxPos = Util.ToRoblox(pos)
		local robloxRot = Util.ToRotation(Vector3int16.new(
			bit32.band(object.FaceAnglePitch, 0xFFFF),
			bit32.band(object.FaceAngleYaw, 0xFFFF),
			bit32.band(object.FaceAngleRoll, 0xFFFF)
			))
		local goal = CFrame.new(robloxPos) * FLIP * robloxRot :: CFrame
		model:PivotTo(goal)
	end
end

function SurfaceCollission:Destroy()
	-- destroy model
	if self[1] and self[1].Destroy then
		self[1]:Destroy()
	end

	-- nullify
	self[1] = nil
	self[2] = nil
	self.Active = nil
	self.a = nil
	self.p = nil
	self.y = nil
	self.name = nil

	setmetatable(self, nil)
end

return SurfaceCollission