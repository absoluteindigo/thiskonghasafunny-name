-- SM64 styled circular shadow

-- CONFIG
MAX_DISTANCE = 120 -- 80
TRANSPARENCY = .51 -- .46
RADIUS = 2

INVERSE_TRANSPARENCY = 1 - TRANSPARENCY

local IGNORE = workspace.SM64.Ignore
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local Package = require(workspace.SM64.Client.Package)
-- local Helpers = require(script.Parent.Parent.Helpers)

local Util = Package.Util
-- local Assets = ReplicatedStorage:WaitForChild('Assets'):WaitForChild('Shadow')
local base = script:WaitForChild('Base')

local VEC3 = Vector3.new
local fromAxisAngle = CFrame.fromAxisAngle
local lookAt = CFrame.lookAt
local yAxis = Vector3.yAxis

local TAU = math.pi * 0.5
rayDistance = -yAxis * MAX_DISTANCE

-- optimization common rotations
local preset = {
	[yAxis] = Vector3.new(90, 0, 0),
}

-- raycast paramaters
local rayParams = Util.rayParams

--
local Shadow = {}
Shadow.__index = Shadow

function Shadow.new(radius: number?)
	local self = setmetatable({}, Shadow)

	radius = radius or RADIUS
	local model = base:Clone()-- Assets.Base:Clone() :: Part
	local decal = model:WaitForChild('a'):WaitForChild('b') :: ImageLabel

	self.radius = radius
	self.model = model
	self.image = decal
	self.hidden = false

	model.Size = VEC3(radius, radius, .1)
	model.Parent = IGNORE

	return self
end

function Shadow:changeSize(radius: number)
	self.radius = radius
	self.model.Size = VEC3(radius, radius, .1)
end

function Shadow:update(position: Vector3)
	local decal = self.image :: ImageLabel

	local hit = Util.Raycast(position, rayDistance)
	-- local hit = workspace:Raycast(position, rayDistance, rayParams)

	if hit then
		local model = self.model :: Part
		local distance = hit.Distance / MAX_DISTANCE -- 0 = closest
		local size = 1 - distance
		local position, normal = hit.Position, hit.Normal

		decal.ImageTransparency = TRANSPARENCY + INVERSE_TRANSPARENCY * distance -- TODO: replace this with better code, 1 = invisible
		decal.Size = UDim2.fromScale(size, size)

		if preset[normal] then
			model.Position = position
			model.Rotation = preset[normal]
		elseif self.lastNorm == normal then
			model.Position = position
			model.Rotation = self.lastRot
		else
			model.CFrame = lookAt(position, position + normal)
			self.lastNorm = normal
			self.lastRot = model.Rotation
		end
	else
		decal.ImageTransparency = 1
	end
end

function Shadow:show()
	self.hidden = false
	self.image.Visible = true
end

function Shadow:hide()
	self.hidden = true
	self.image.Visible = false
end

function Shadow:setVisible(new)
	self[new and 'hide' or 'show'](self)
end

function Shadow:destroy()
	self.model:Destroy()
	self = nil
end

return Shadow