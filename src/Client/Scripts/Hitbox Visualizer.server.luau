-- hitbox debuger
local HITBOX = 'HITBOX'
local HURTBOX = 'HURTBOX'

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local Client = workspace.SM64.Client

local Package = require(Client.Package)
local FFlags = Package.FFlags
-- local TickManager = require(Client.TickManager)
local Player = Players.LocalPlayer
local Object = Package.Game.Object

local Util = Package.Util
local ObjectListProcessor = Object.ObjectListProcessor

local objList = ObjectListProcessor.objList

local hitboxes = {} :: {[any]: Part}

local Rotation = Vector3.new(0, 0, 90)

local hitboxes = {}

local hitbox = {}
hitbox.__index = hitbox

local colorRegular = Color3.fromRGB(83, 0, 165)
local colorHurtBox = Color3.fromRGB(214, 0, 86)

-- helper, adds lighting basically
local function newDecal(parent, face)
	local decal = Instance.new("Decal")
	decal.Name = ""
	decal.Texture = "rbxassetid://13619407848"
	decal.Transparency = 0.67
	decal.ZIndex = 2
	decal.Face = face -- Enum.NormalId.Right
	decal.Parent = parent
	decal.Archivable = false
end

function hitbox.new(object: Package.ObjectState, type: any)
	local self = setmetatable({}, hitbox)
	local type = type or HITBOX
	local isAHurtbox = type == HURTBOX
	
	self.object = object
	self.type = type
	self.isAHurtbox = isAHurtbox
	
	local visual = Instance.new('Part')
	visual.Shape = Enum.PartType.Cylinder
	visual.CanCollide = false
	visual.Transparency = .5
	visual.Color = isAHurtbox and colorHurtBox or colorRegular
	visual.Material = Enum.Material.Neon
	visual.Name = `HB_{type}`
	visual.Anchored = true
	visual.Parent = workspace.SM64.Ignore
	visual.Rotation = Rotation
	visual.Archivable = false

	newDecal(visual, Enum.NormalId.Right) -- top
	newDecal(visual, Enum.NormalId.Left) -- bottom
	
	self.visual = visual
	
	self:update()
	
	-- hitboxes[object] = self
	hitboxes[object] = hitboxes[object] or {}
	hitboxes[object][type] = self
	
	return self
end

function hitbox:destroy()
	-- hitboxes[self.object] = nil
	if hitboxes[self.object] then
		hitboxes[self.object][self.type] = nil
		if not next(hitboxes[self.object]) then
			hitboxes[self.object] = nil
		end
	end
	self.visual:Destroy()
	self = nil
end

function hitbox:updateSize()
	local Scale = Util.Scale
	local height = self.height * Scale
	local diameter = (self.radius * Scale) * 2
	self.yOffset = height / 2

	self.visual.Size = Vector3.new(height, diameter, diameter)
end

function hitbox:update()
	local object = self.object
	
	local isAHurtbox = self.isAHurtbox
	local radius = isAHurtbox and object.HurtboxRadius or object.HitboxRadius
	local height = isAHurtbox and object.HurtboxHeight or object.HitboxHeight
	
	if (self.height ~= height) or (self.radius ~= radius) then
		self.radius = radius
		self.height = height
		self:updateSize()
	end
	
	local position = Util.ToRoblox(object.Position)
	
	self.visual.Position = Vector3.new(position.X, position.Y + self.yOffset, position.Z)
end

local function updateHitboxPosition()
	--[[for _, hb in pairs(hitboxes) do
		hb:update()
	end]]
	for _, types in pairs(hitboxes) do
		for _, hb in pairs(types) do
			hb:update()
		end
	end
end


local lastDebug = false

local function updateHitboxes()
	local currentObjects = {}
	-- create hitboxes for new objects and track existing ones
	for _, object in ipairs(objList) do
		currentObjects[object] = true
		--[[if not hitboxes[object] then
			hitbox.new(object)
		end]]
		if not (hitboxes[object] and hitboxes[object][HITBOX]) then
			hitbox.new(object, HITBOX)
		end
		if not (hitboxes[object] and hitboxes[object][HURTBOX]) then
			hitbox.new(object, HURTBOX)
		end
	end

	-- destroy hitboxes for objects that no longer exist
	for object, types in pairs(hitboxes) do
		if not currentObjects[object] then
			for _, hb in pairs(types) do
				hb:destroy()
			end
		end
	end
end

game:GetService('RunService').RenderStepped:Connect(function()
	if FFlags.DEBUG then
		updateHitboxes()
		updateHitboxPosition()
	elseif lastDebug then
		for _, types in pairs(hitboxes) do
			for _, hb in pairs(types) do
				hb:destroy()
			end
		end
	end

	lastDebug = FFlags.DEBUG
end)
--[[function TickManager.postUpdate.objecthitboxdebugger()
	if FFlags.DEBUG then
		updateHitboxes()
		updateHitboxPosition()
	elseif lastDebug then
		for _, types in pairs(hitboxes) do
			for _, hb in pairs(types) do
				hb:destroy()
			end
		end
	end
	
	lastDebug = FFlags.DEBUG
end]]