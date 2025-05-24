function parseInt(num) -- EXPERIMENTAL
	return num >= 0 and math.floor(num) or math.ceil(num)
end

function sqrtf(x)
	return math.sqrt(x)
end

local Package = script.Parent.Parent.Parent
local Object = script.Parent
local ObjectConstants = require(Object.ObjectConstants)
local GraphNodeConstats = require(Object.GraphNodeConstats)
local MODEL = require(Object.Models)
local BehaviorScripts = require(Object.BehaviorData.BehaviorScripts)

local SpawnSound = require(Object.SpawnSound)
-- local SpawnObject = require(Object.SpawnObject)
local SpawnObject = nil
SpawnObject = setmetatable({}, {
	__index = function(self, key)
		local real = require(Object.SpawnObject)
		SpawnObject = real
		return SpawnObject[key]
	end,
})

local Util = require(Package.Util)
local Types = require(Package.Types)
local Enums = require(Package.Enums)

type Object = Types.ObjectState

local s16 = Util.SignedShort
local OBJ_FLAG_30 = ObjectConstants.OBJ_FLAG_30
local ATTACK_PUNCH = Enums.Interaction.AttackType.PUNCH
local INT_STATUS_WAS_ATTACKED = Enums.Interaction.Status.WAS_ATTACKED
local INT_STATUS_INTERACTED = Enums.Interaction.Status.INTERACTED
local INT_STATUS_TOUCHED_BOB_OMB = Enums.Interaction.Status.TOUCHED_BOB_OMB

-- class ObjectHelpers
local Helpers = {}
Helpers.parseInt = parseInt
Helpers.sqrtf = sqrtf

gMarioObject = nil :: Types.MarioState

function Helpers.setMario(Mario: Types.MarioState)
	gMarioObject = Mario
end

-- TODO: get_move_angle
-- TODO: init_obj
-- TODO: treat_far_home_as_mario
-- TODO: obj_bounce_off_walls_edges_objects
-- TODO: random_u16
-- TODO: obj_random_fixed_turn
-- TODO: random_linear_offset

function Helpers.abs_angle_diff(x0: number, x1: number)
	local diff = x1 - x0

	if (diff == -0x8000) then
		diff = -0x7FFF
	end

	if (diff < 0) then
		diff = -diff
	end

	return diff
end


function Helpers.obj_angle_to_object(obj1: Object, obj2: Object)
	local x1, z1 = obj1.Position.X, obj1.Position.Z
	local x2, z2 = obj2.Position.X, obj2.Position.Z

	return Util.Atan2s(z2 - z1, x2 - x1)
end
function Helpers.dist_between_objects(obj1: Object, obj2: Object)
	local dx = obj1.Position.X - obj2.Position.X
	local dy = obj1.Position.Y - obj2.Position.Y
	local dz = obj1.Position.Z - obj2.Position.Z

	return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function Helpers.obj_set_hitbox(obj: Object, hitbox)
	if not obj.Flags:Has(ObjectConstants.OBJ_FLAG_30) then
		obj.Flags:Add(ObjectConstants.OBJ_FLAG_30)

		obj.InteractType = hitbox.InteractType
		obj.DamageOrCoinValue = hitbox.DamageOrCoinValue
		obj.Health = hitbox.health
		obj.NumLootCoins = hitbox.numLootCoins

		Helpers.cur_obj_become_tangible(obj);
	end

	--[[
	obj.HitboxRadius = obj.gfx.scale[0] * hitbox.radius;
	obj.HitboxHeight = obj.gfx.scale[1] * hitbox.height;
	obj.HurtboxRadius = obj.gfx.scale[0] * hitbox.HurtboxRadius;
	obj.HurtboxHeight = obj.gfx.scale[1] * hitbox.HurtboxHeight;
	obj.HitboxDownOffset = obj.gfx.scale[1] * hitbox.downOffset;
	]]
	local scale = obj.GfxScale -- Vector3.one
	obj.HitboxRadius = scale.X * hitbox.radius;
	obj.HitboxHeight = scale.Y * hitbox.height;
	obj.HurtboxRadius = scale.X * hitbox.HurtboxRadius;
	obj.HurtboxHeight = scale.Y * hitbox.HurtboxHeight;
	obj.HitboxDownOffset = scale.Y * hitbox.downOffset;
end

-- arg1: object
function Helpers.cur_obj_forward_vel_approach_upward(o: Object, target, increment)
	if o.ForwardVel >= target then
		o.ForwardVel = target
	else
		o.ForwardVel += increment
	end
end

function Helpers.approach_symmetric(value, target, increment)
	local dist = target - value

	if dist >= 0 then
		if dist > increment then
			value += increment
		else
			value = target
		end
	else
		if dist < -increment then
			value -= increment
		else
			value = target
		end
	end

	return value
end

-- arg1: object
function Helpers.cur_obj_rotate_yaw_toward(o: Object, target, increment)
	-- local startYaw = parseInt(o.MoveAngleYaw)
	local startYaw = o.MoveAngleYaw
	o.MoveAngleYaw = Helpers.approach_symmetric(o.MoveAngleYaw, target, increment)

	o.AngleVelYaw = parseInt(o.MoveAngleYaw - startYaw)
	if ((o.AngleVelYaw) == 0) then
		return true
	else
		return false
	end
end

function Helpers.cur_obj_become_tangible(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	o.IntangibleTimer = 0
end

function Helpers.cur_obj_become_intangible(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	o.IntangibleTimer = -1
end

function Helpers.cur_obj_move_xz_using_fvel_and_yaw(o: Object)
	o.Velocity = Vector3.new(
		o.ForwardVel * Util.Sins(o.MoveAngleYaw),
		o.Velocity.Y,
		o.ForwardVel * Util.Coss(o.MoveAngleYaw)
	)
	-- o.VelX = o.ForwardVel * sins(o.MoveAngleYaw)
	-- o.VelZ = o.ForwardVel * coss(o.MoveAngleYaw)

	o.Position = Vector3.new(
		o.Position.X + o.Velocity.X,
		o.Position.Y,
		o.Position.Z + o.Velocity.Z
	)
	-- o.Position.X += o.VelX
	-- o.Position.Z += o.VelZ
end

function Helpers.cur_obj_reflect_move_angle_off_wall(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	return s16(o.WallAngle - (s16(o.MoveAngleYaw) - s16(o.WallAngle)) + 0x8000)
end

function Helpers.obj_mark_for_deletion(obj: Object)
	-- obj.ActiveFlags = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED
	--print('TODO: mark for deletion is probably innacurate')
	--obj.MarkedForDeletion = true
	obj.ActiveFlags.Value = ObjectConstants.ACTIVE_FLAGS_DEACTIVATED
	obj.ActiveFlags:Set(ObjectConstants.ACTIVE_FLAGS_DEACTIVATED)
end

function Helpers.cur_obj_scale(o: Object, scale)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	o.GfxScale = Vector3.new(scale, scale, scale)
	--[[o.gfx.scale[0] = scale
	o.gfx.scale[1] = scale
	o.gfx.scale[2] = scale]]
end

local OBJ_MOVE_ABOVE_LAVA = ObjectConstants.OBJ_MOVE_ABOVE_LAVA
local OBJ_MOVE_ABOVE_DEATH_BARRIER = ObjectConstants.OBJ_MOVE_ABOVE_DEATH_BARRIER
local ACTIVE_FLAG_FAR_AWAY = ObjectConstants.ACTIVE_FLAG_FAR_AWAY
local ACTIVE_FLAG_IN_DIFFERENT_ROOM = ObjectConstants.ACTIVE_FLAG_IN_DIFFERENT_ROOM
local OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER = ObjectConstants.OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER
local OBJ_MOVE_IN_AIR = ObjectConstants.OBJ_MOVE_IN_AIR
local OBJ_MOVE_HIT_WALL = ObjectConstants.OBJ_MOVE_HIT_WALL

local SURFACE_BURNING = Enums.SurfaceClass.BURNING
local SURFACE_DEATH_PLANE = Enums.SurfaceClass.DEATH_PLANE

function Helpers.cur_obj_update_floor_height(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	-- o.FloorHeight = gLinker.SurfaceCollision.find_floor(o.Position.X, o.Position.Y, o.Position.Z, {})

	local _floorHeight, floor = Util.FindFloor(o.Position)
	o.FloorHeight = _floorHeight
end

-- not a big fan of this one..
warn('this is weird')
function Helpers.cur_obj_update_floor_height_and_get_floor(o)
	--warn('cur_obj_update_floor_height_and_get_floor')
	-- local o = gLinker.ObjectListProcessor.gCurrentObject

	local _floorHeight, floor = Util.FindFloor(o.Position)
	o.FloorHeight = _floorHeight

	local normal = floor and floor.Normal

	floor = floor and {
		type = Util.GetFloorType(floor),
		room = -1, -- sdsajksdakhjasd
		normal = {
			x = normal.X,
			y = normal.Y,
			z = normal.Z,
		}
	}
	return floor

    --[[local floorWrapper = {}
    o.FloorHeight = gLinker.SurfaceCollision.find_floor(o.Position.X, o.Position.Y, o.Position.Z, floorWrapper)
    return floorWrapper.floor]]
end

function Helpers.cur_obj_update_floor(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	local floor = Helpers.cur_obj_update_floor_height_and_get_floor(o)
	o.Floor = floor

	if floor then
		if (floor.type == SURFACE_BURNING) then
			o.MoveFlags:Add(OBJ_MOVE_ABOVE_LAVA)
		elseif (floor.type == SURFACE_DEATH_PLANE) then
			o.MoveFlags:Add(OBJ_MOVE_ABOVE_DEATH_BARRIER)
		end
		o.FloorType = floor.type
		o.FloorRoom = floor.room
	else
		o.FloorType = 0
		o.FloorRoom = 0
	end

end

function Helpers.cur_obj_resolve_wall_collisions(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	local offsetY = 10.0
	local radius = o.WallHitboxRadius

	if radius > 0.1 then

		local newPos, lastWall, walls = Util.FindWallCollisions(o.Position, offsetY, radius)

		o.Position = newPos

		if lastWall then
			o.WallAngle = Util.Atan2s(lastWall.Normal.Z, lastWall.Normal.X)
			if Helpers.abs_angle_diff(o.WallAngle, o.MoveAngleYaw) > 0x4000 then
				return true
			else
				return false
			end
		end


		--
	--[[local collisionData = {
            offsetY,
            radius,
            x = parseInt(o.Position.X),
            y = parseInt(o.Position.Y),
            z = parseInt(o.Position.Z),
            walls = {}
        }

        local numCollisions = gLinker.SurfaceCollision.find_wall_collisions(collisionData)
        if (numCollisions != 0) {
            o.Position.X = collisionData.x
            o.Position.Y = collisionData.y
            o.Position.Z = collisionData.z

            local wall = collisionData.walls[collisionData.numWalls - 1]

            o.WallAngle = Util.Atan2s(wall.normal.z, wall.normal.x)
            if (abs_angle_diff(o.WallAngle, o.MoveAngleYaw) > 0x4000) {
                return true
            } else {
                return false
            }

        end]]
	end

	return false
end

function Helpers.cur_obj_detect_steep_floor(o: Object, steepAngleDegrees)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	local steepNormalY = Util.Coss(parseInt(steepAngleDegrees * (0x10000 / 360)))

	if o.ForwardVel ~= 0 then
		local intendedX = o.Position.X + o.Velocity.X
		local intendedZ = o.Position.Z + o.Velocity.Z

		local intendedFloorHeight, intendedFloor = Util.FindFloor(Vector3.new(intendedX, o.Position.Y, intendedZ))


		-- local intendedFloorWrapper = {}
		-- local intendedFloorHeight = gLinker.SurfaceCollision.find_floor(intendedX, o.Position.Y, intendedZ, intendedFloorWrapper)
		-- local intendedFloor = intendedFloorWrapper.floor
		local deltaFloorHeight = intendedFloorHeight - o.FloorHeight

		if intendedFloorHeight < -10000.0 then
			o.WallAngle = o.MoveAngleYaw + 0x8000
			return 2
			-- elseif (intendedFloor.normal.y < steepNormalY && deltaFloorHeight > 0 && intendedFloorHeight > o.Position.Y) {
		elseif intendedFloor and intendedFloor.Normal.Y < steepNormalY and deltaFloorHeight > 0 and intendedFloorHeight > o.Position.Y then
			o.WallAngle = Util.Atan2s(intendedFloor.Normal.Z, intendedFloor.Normal.X)
			return true
		else
			return false
		end
	end

	return false
end

local function cur_obj_update_floor_and_resolve_wall_collisions(o: Object, steepSlopeDegrees)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	o.MoveFlags:Remove(OBJ_MOVE_ABOVE_LAVA, OBJ_MOVE_ABOVE_DEATH_BARRIER)

	if o.ActiveFlags:Has(ACTIVE_FLAG_FAR_AWAY) or o.ActiveFlags:Has(ACTIVE_FLAG_IN_DIFFERENT_ROOM) then
		Helpers.cur_obj_update_floor(o)
		o.MoveFlags:Remove(OBJ_MOVE_MASK_HIT_WALL_OR_IN_WATER)

		if o.Position.Y > o.FloorHeight then
			o.MoveFlags:Add(OBJ_MOVE_IN_AIR)
		end
	else
		o.MoveFlags:Remove(OBJ_MOVE_HIT_WALL)

		if Helpers.cur_obj_resolve_wall_collisions(o) then
			o.MoveFlags:Add(OBJ_MOVE_HIT_WALL)
		end

		Helpers.cur_obj_update_floor(o)

		if o.Position.Y > o.FloorHeight then
			o.MoveFlags:Add(OBJ_MOVE_IN_AIR)
		end

		if Helpers.cur_obj_detect_steep_floor(o, steepSlopeDegrees) then
			o.MoveFlags:Add(OBJ_MOVE_HIT_WALL)
		end
	end
end

function Helpers.cur_obj_update_floor_and_walls(o)
	cur_obj_update_floor_and_resolve_wall_collisions(o, 60)
end



function Helpers.cur_obj_move_standard(o: Object, steepSlopeAngleDegrees)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject
	local gravity = o.Gravity
	local bounciness = o.Bounciness
	local bouyancy = o.Buoyancy
	local dragStrength = o.DragStrength
	local steepSlopeNormalY
	local careAboutEdgesAndSteepSlopes = false
	local negativeSpeed = false

	--! Because some objects allow these active flags to be set but don't
	--  afunction Helpers.updating when they are, we end up with "partial" update = ser=> e
	--  an object's internal state will be updated, but it doesn't move.
	--  This allows numerous glitches and is typically referred to as
	--  deactivation (though this term has a different meaning in the code).
	--  Objects that do this will be marked with --PARTIAL_UPDATE.

	if not o.ActiveFlags:Has(ACTIVE_FLAG_FAR_AWAY, ACTIVE_FLAG_IN_DIFFERENT_ROOM) then
		-- if (!(o.ActiveFlags & (ACTIVE_FLAG_FAR_AWAY | ACTIVE_FLAG_IN_DIFFERENT_ROOM))) {
		if steepSlopeAngleDegrees < 0 then
			careAboutEdgesAndSteepSlopes = 1
			steepSlopeAngleDegrees = -steepSlopeAngleDegrees
		end

		steepSlopeNormalY = Util.Coss(steepSlopeAngleDegrees * (0x10000 / 360))

		Helpers.cur_obj_compute_vel_xz(o)
		Helpers.cur_obj_apply_drag_xz(o, dragStrength)

		Helpers.cur_obj_move_xz(o, steepSlopeNormalY, careAboutEdgesAndSteepSlopes)
		Helpers.cur_obj_move_y(o, gravity, bounciness, bouyancy)

		if o.ForwardVel < 0 then
			negativeSpeed = 1
		end

		o.ForwardVel = math.sqrt(math.pow(o.Velocity.X, 2) + math.pow(o.Velocity.Z, 2))
		if negativeSpeed then
			o.ForwardVel = -o.ForwardVel
		end
	end
end

function Helpers.apply_drag_to_value(ptr: {value: number}, dragStrength)
	if (ptr.value ~= 0) then
		--! Can overshoot if |*value| > 1/(dragStrength * 0.0001)
		local decel = (ptr.value) * (ptr.value) * (dragStrength * 0.0001)

		if (ptr.value > 0) then
			ptr.value -= decel
			if (ptr.value < 0.001) then
				ptr.value = 0
			end
		else
			ptr.value += decel
			if (ptr.value > -0.001) then
				ptr.value = 0
			end
		end
	end
end

function Helpers.cur_obj_compute_vel_xz(o: Object)
	o.Velocity = Vector3.new(
		o.ForwardVel * Util.Sins(o.MoveAngleYaw),
		o.Velocity.Y,
		o.ForwardVel * Util.Coss(o.MoveAngleYaw)
	)
end
function Helpers.cur_obj_apply_drag_xz(o: Object, dragStrength)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	local wrapper = { value = o.Velocity.X } --
	Helpers.apply_drag_to_value(wrapper, dragStrength)
	local velX = wrapper.value

	wrapper.value = o.Velocity.Z --
	Helpers.apply_drag_to_value(wrapper, dragStrength)
	local velZ = wrapper.value

	o.Velocity = Vector3.new(velX, o.Velocity.Y, velZ)
end

local OBJ_MOVE_HIT_EDGE = ObjectConstants.OBJ_MOVE_HIT_EDGE
local OBJ_MOVE_ON_GROUND = ObjectConstants.OBJ_MOVE_ON_GROUND

function Helpers.cur_obj_move_xz(o: Object, steepSlopeNormalY, careAboutEdgesAndSteepSlopes)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	local intendedX = o.Position.X + o.Velocity.X
	local intendedZ = o.Position.Z + o.Velocity.Z

	-- local intendedFloorWrapper = {}
	-- local intendedFloorHeight = gLinker.SurfaceCollision.find_floor(intendedX, o.Position.Y, intendedZ, intendedFloorWrapper)

	local intendedFloorHeight, intendedFloor = Util.FindFloor(Vector3.new(intendedX, o.Position.Y, intendedZ))
	local intendedFloorWrapper = {
		floor = intendedFloor and {
			room = -1, -- asdoijashdjkhsda
			normal = {x = intendedFloor.Normal.X, y = intendedFloor.Normal.Y, z = intendedFloor.Normal.Z},
		} or nil
	}

	local deltaFloorHeight = intendedFloorHeight - o.FloorHeight

	o.MoveFlags:Remove(OBJ_MOVE_HIT_EDGE)

	if o.Room ~= -1 and intendedFloorWrapper.floor then
		if intendedFloorWrapper.floor.room ~= 0 and o.Room ~= intendedFloorWrapper.floor.room and intendedFloorWrapper.floor.room ~= 18 then
			--if (intendedFloorWrapper.floor.room != 0 && o.Room != intendedFloorWrapper.floor.room && intendedFloorWrapper.floor.room != 18) then
			-- Don't leave native room
			return false
		end
	end

	if intendedFloorHeight < -10000.0 then
		-- Don't move into OoB
		o.MoveFlags:Add(OBJ_MOVE_HIT_EDGE)
		return false
	elseif deltaFloorHeight < 5.0 then
		if not careAboutEdgesAndSteepSlopes then
			-- If we don't care about edges or steep slopes, okay to move
			o.Position = Vector3.new(intendedX, o.Position.Y, intendedZ)
			--o.Position.X = intendedX
			--o.Position.Z = intendedZ
			return true
		elseif deltaFloorHeight < -50.0 and o.MoveFlags:Has(OBJ_MOVE_ON_GROUND) then
			--elseif (deltaFloorHeight < -50.0 && (o.MoveFlags & OBJ_MOVE_ON_GROUND)) then
			-- Don't walk off an edge
			o.MoveFlags:Add(OBJ_MOVE_HIT_EDGE)
			return false
		elseif intendedFloorWrapper.floor.normal.y > steepSlopeNormalY then
			-- elseif (intendedFloorWrapper.floor.normal.y > steepSlopeNormalY) then
			-- Allow movement onto a slope, provided it's not too steep
			o.Position = Vector3.new(intendedX, o.Position.Y, intendedZ)
			--o.Position.X = intendedX
			--o.Position.Z = intendedZ
			return true
		else 
			-- We are likely trying to move onto a steep downward slope
			--o.MoveFlags |= OBJ_MOVE_HIT_EDGE
			o.MoveFlags:Add(OBJ_MOVE_HIT_EDGE)
			return false
		end
	elseif intendedFloorWrapper.floor.normal.y > steepSlopeNormalY or o.Position.Y > intendedFloorHeight then
		--elseif ((intendedFloorWrapper.floor.normal.y) > steepSlopeNormalY || o.Position.Y > intendedFloorHeight) then
		-- Allow movement upward, provided either:
		-- - The target floor is flat enough (e.g. walking up stairs)
		-- - We are above the target floor (most likely in the air)
		o.Position = Vector3.new(intendedX, o.Position.Y, intendedZ)
		-- o.Position.X = intendedX
		-- o.Position.Z = intendedZ
		--! Returning FALSE but moving anyway (not exploitable; return value is
		--  never used)
	end

	-- We are likely trying to move onto a steep upward slope
	return false
end
function Helpers.cur_obj_move_y_with_terminal_vel(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	if o.Velocity.Y < -70.0 then
		o.Velocity = Util.SetY(o.Velocity, -70.0)
		-- o.VelY = -70.0
	end
	o.Position = Util.SetY(o.Position, o.Position.Y + o.Velocity.Y)
	-- o.Position.Y += o.VelY
end


local OBJ_MOVE_LEFT_GROUND = ObjectConstants.OBJ_MOVE_LEFT_GROUND
local OBJ_MOVE_AT_WATER_SURFACE = ObjectConstants.OBJ_MOVE_AT_WATER_SURFACE
local OBJ_MOVE_MASK_IN_WATER = ObjectConstants.OBJ_MOVE_MASK_IN_WATER
local OBJ_MOVE_LEAVING_WATER = ObjectConstants.OBJ_MOVE_LEAVING_WATER
local OBJ_MOVE_LEFT_GROUND = ObjectConstants.OBJ_MOVE_LEFT_GROUND
local OBJ_MOVE_ENTERED_WATER = ObjectConstants.OBJ_MOVE_ENTERED_WATER
local OBJ_MOVE_MASK_ON_GROUND = ObjectConstants.OBJ_MOVE_MASK_ON_GROUND
local OBJ_MOVE_ENTERED_WATER = ObjectConstants.OBJ_MOVE_ENTERED_WATER
local OBJ_MOVE_MASK_IN_WATER = ObjectConstants.OBJ_MOVE_MASK_IN_WATER
local OBJ_MOVE_UNDERWATER_OFF_GROUND = ObjectConstants.OBJ_MOVE_UNDERWATER_OFF_GROUND
local OBJ_MOVE_UNDERWATER_ON_GROUND = ObjectConstants.OBJ_MOVE_UNDERWATER_ON_GROUND
local OBJ_MOVE_LEFT_GROUND = ObjectConstants.OBJ_MOVE_LEFT_GROUND
local OBJ_MOVE_MASK_33 = ObjectConstants.OBJ_MOVE_MASK_33
local ACTIVE_FLAG_UNK10 = ObjectConstants.ACTIVE_FLAG_UNK10
local OBJ_MOVE_BOUNCE = ObjectConstants.OBJ_MOVE_BOUNCE
local OBJ_MOVE_LANDED = ObjectConstants.OBJ_MOVE_LANDED

function Helpers.cur_obj_move_y_and_get_water_level(o: Object, gravity, buoyancy)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	local waterLevel

	o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y + gravity + buoyancy)
	if o.Velocity.Y < -78.0 then
		o.Velocity = Util.SetY(o.Velocity, -78.0)
	end

	-- o.Position.Y += o.VelY
	o.Position = Util.SetY(o.Position, o.Position.Y + o.Velocity.Y)
	if o.ActiveFlags:Has(ACTIVE_FLAG_UNK10) then
		waterLevel = -11000.0
	else
		-- waterLevel = gLinker.SurfaceCollision.find_water_level(o.Position.X, o.Position.Z)
		waterLevel = Util.GetWaterLevel(o.Position)
	end

	return waterLevel
end
function Helpers.cur_obj_move_update_ground_air_flags(o: Object, gravity, bounciness)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	o.MoveFlags:Remove(OBJ_MOVE_BOUNCE)

	if o.Position.Y < o.FloorHeight then
		-- On the first frame that we touch the ground, set OBJ_MOVE_LANDED.
		-- On subsequent frames, set OBJ_MOVE_ON_GROUND
		if not o.MoveFlags:Has(OBJ_MOVE_ON_GROUND) then
			local hadLanded = o.MoveFlags:Has(OBJ_MOVE_LANDED)

			o.MoveFlags:Remove(OBJ_MOVE_LANDED)

			if hadLanded then
				o.MoveFlags:Add(OBJ_MOVE_ON_GROUND)
			else
				o.MoveFlags:Add(OBJ_MOVE_LANDED)
			end
		end
        --[[if (!(o.MoveFlags & OBJ_MOVE_ON_GROUND)) then

            const { result, newBitSet } = clear_move_flag(o.MoveFlags, OBJ_MOVE_LANDED)
            o.MoveFlags = newBitSet
            if (result) then
                o.MoveFlags |= OBJ_MOVE_ON_GROUND
            else
                o.MoveFlags |= OBJ_MOVE_LANDED
            end
        end]]

		o.Position = Util.SetY(o.Position, o.FloorHeight)
		-- o.Position.Y = o.FloorHeight

		if (o.Velocity.Y < 0.0) then
			o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y * bounciness)
			-- o.Velocity.Y *= bounciness
		end

		if (o.Velocity.Y > 5.0) then
			--! If OBJ_MOVE_13 tracks bouncing, it overestimates, since velY
			-- could be > 5 here without bounce (e.g. jump into misa)
			o.MoveFlags:Add(OBJ_MOVE_BOUNCE)
		end
	else
		o.MoveFlags:Remove(OBJ_MOVE_LANDED)
		local hadOnGround = o.MoveFlags:Has(OBJ_MOVE_ON_GROUND)
		o.MoveFlags:Remove(OBJ_MOVE_ON_GROUND)

		if hadOnGround then
			o.MoveFlags:Add(OBJ_MOVE_LEFT_GROUND)
		end	
       --[[ const { result, newBitSet } = clear_move_flag(o.MoveFlags, OBJ_MOVE_ON_GROUND)
        o.MoveFlags = newBitSet
        if (result) then
            o.MoveFlags |= OBJ_MOVE_LEFT_GROUND
        end]]
	end

	o.MoveFlags:Remove(OBJ_MOVE_MASK_IN_WATER)
end
function Helpers.cur_obj_move_update_underwater_flags(o: Object)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	local decelY = sqrtf(o.Velocity.Y * o.Velocity.Y) * (o.DragStrength * 7.0) / 100.0

	if (o.Velocity.Y > 0) then
		o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y - decelY)
		-- o.VelY -= decelY
	else
		o.Velocity = Util.SetY(o.Velocity, o.Velocity.Y + decelY)
		-- o.VelY += decelY
	end

	if o.Position.Y < o.FloorHeight then
		o.Position = Util.SetY(o.Position, o.FloorHeight)
		-- o.Position.Y = o.FloorHeight
		o.MoveFlags:Add(OBJ_MOVE_UNDERWATER_ON_GROUND)
	else
		o.MoveFlags:Add(OBJ_MOVE_UNDERWATER_OFF_GROUND)
	end
end

function Helpers.cur_obj_move_y(o: Object, gravity, bounciness, buoyancy)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	-- o.MoveFlags &= ~OBJ_MOVE_LEFT_GROUND
	o.MoveFlags:Remove(OBJ_MOVE_LEFT_GROUND)
	-- if (o.MoveFlags & OBJ_MOVE_AT_WATER_SURFACE) {
	if o.MoveFlags:Has(OBJ_MOVE_AT_WATER_SURFACE) then
		if (o.Velocity.Y > 5.0) then
			-- o.MoveFlags &= ~OBJ_MOVE_MASK_IN_WATER
			--o.MoveFlags |= OBJ_MOVE_LEAVING_WATER
			o.MoveFlags:Remove(OBJ_MOVE_MASK_IN_WATER)
			o.MoveFlags:Add(OBJ_MOVE_LEAVING_WATER)
		end
	end

	if not o.MoveFlags:Has(OBJ_MOVE_MASK_IN_WATER) then
		-- if (!(o.MoveFlags & OBJ_MOVE_MASK_IN_WATER)) {
		local waterLevel = Helpers.cur_obj_move_y_and_get_water_level(o, gravity, 0.0)
		if o.Position.Y > waterLevel then
			--! We only handle floor collision if the object does not enter
			--  water. This allows e.g. coins to clip through floors if they
			--  enter water on the same frame.
			Helpers.cur_obj_move_update_ground_air_flags(o, gravity, bounciness)
		else 
			o.MoveFlags:Add(OBJ_MOVE_ENTERED_WATER)
			o.MoveFlags:Remove(OBJ_MOVE_MASK_ON_GROUND)
		end
	else
		-- o.MoveFlags &= ~OBJ_MOVE_ENTERED_WATER
		o.MoveFlags:Remove(OBJ_MOVE_ENTERED_WATER)

		local waterLevel = Helpers.cur_obj_move_y_and_get_water_level(o, gravity, buoyancy)
		if (o.Position.Y < waterLevel) then
			Helpers.cur_obj_move_update_underwater_flags(o)
		else
			if (o.Position.Y < o.FloorHeight) then
				o.Position = Util.SetY(o.Position, o.FloorHeight)
				o.MoveFlags:Remove(OBJ_MOVE_MASK_IN_WATER)
			else
				o.Position = Util.SetY(o.Position, waterLevel)
				o.Velocity = Util.SetY(o.Velocity, 0)
				o.MoveFlags:Remove(OBJ_MOVE_UNDERWATER_OFF_GROUND, OBJ_MOVE_UNDERWATER_ON_GROUND)
				o.MoveFlags:Add(OBJ_MOVE_AT_WATER_SURFACE)
			end
		end
	end

	if o.MoveFlags:Has(OBJ_MOVE_MASK_33) then
		o.MoveFlags:Remove(OBJ_MOVE_IN_AIR)
	else
		o.MoveFlags:Add(OBJ_MOVE_IN_AIR)
	end
end

function isAnimAtEnd(o): boolean
	return o.AnimFrame >= o.AnimFrameCount
end

function Helpers.cur_obj_extend_animation_if_at_end(o)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject;

	if isAnimAtEnd(o) then
		o.AnimFrame -= 1
	end
    --[[local sp4 = o.gfx.animInfo.animFrame
    local sp0 = o.gfx.animInfo.curAnim.unk08 - 2

    if sp4 == sp0 then
        o.gfx.animInfo.animFrame -= 1
    end]]
end


function Helpers.cur_obj_hide(o)
	--const o = gLinker.ObjectListProcessor.gCurrentObject;
	--print(' go invisible')
	o.GfxFlags:Add(GraphNodeConstats.GRAPH_RENDER_INVISIBLE)
	--o.gfx.flags |= GRAPH_RENDER_INVISIBLE
end

function Helpers.obj_translate_xz_random(obj, rangeLength)
	obj.Position = Vector3.new(
		obj.Position.X + math.random() * rangeLength - rangeLength * 0.5,
		obj.Position.Y,
		obj.Position.Z + math.random() * rangeLength - rangeLength * 0.5
	)
	-- obj[oPosX] += math.random() * rangeLength - rangeLength * 0.5
	-- obj[oPosZ] += math.random() * rangeLength - rangeLength * 0.5
end

local function obj_spawn_loot_coins(obj, numCoins, sp30, coinsBehavior, posJitter, model)
	--const floorWrapper = {}
	--local spawnHeight = gLinker.SurfaceCollision.find_floor(obj.Position.X, obj.Position.Y, obj.Position.Z, floorWrapper)
	local spawnHeight, _ = Util.FindFloor(obj.Position)

	if obj.Position.Y - spawnHeight > 100 then
		spawnHeight = obj.Position.Y
	end

	for i = 0, numCoins - 1 do
		-- for (local i = 0; i < numCoins; i++) {
		if obj.NumLootCoins <= 0 then break end

		obj.NumLootCoins -= 1

		local coin = Helpers.spawn_object(obj, model, coinsBehavior)
		Helpers.obj_translate_xz_random(coin, posJitter)
		coin.Position = Util.SetY(coin.Position, spawnHeight)
		-- coin.Position.Y = spawnHeight
		coin.CoinBaseVelY = sp30
	end
end

function Helpers.obj_spawn_loot_yellow_coins(obj, numCoins, sp28)
	-- warn('TODO: SPAWN COINS')
	obj_spawn_loot_coins(obj, numCoins, sp28, BehaviorScripts.bhvSingleCoinGetsSpawned, 0, MODEL.YELLOW_COIN)
end


function Helpers.cur_obj_check_anim_frame_in_range(o, startFrame, rangeLength)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	local --[[s32]] animFrame = o.AnimFrame -- o.gfx.animInfo.animFrame

	if (animFrame >= startFrame and animFrame < startFrame + rangeLength) then
		-- if animFrame >= startFrame and animFrame < startFrame + rangeLength then
		return true
	else
		return false
	end
end

local mtodo = true

function Helpers.spawn_mist_particles(o)
	if mtodo then
		mtodo = false
		warn('TODO: mist')
	end
	-- spawn_mist_particles_variable(0, 0, 46.0)
end

function Helpers.spawn_mist_particles_with_sound(o, sp18)
	if mtodo then
		mtodo = false
		warn('TODO: mist')
	end
	-- spawn_mist_particles_variable(0, 0, 46.0)
	SpawnSound.create_sound_spawner(o, sp18)
end






local function CUSTOM_setAnimation(object, anim)
	if anim and typeof(anim) == "Instance" and anim:IsA("Animation") then
		if object.AnimCurrent == anim then
			return object.AnimFrame
		end

		object.AnimFrameCount = anim:GetAttribute("NumFrames") or 0 -- or 0 is important oh my GOD
		object.AnimCurrent = anim
	else
		warn("Invalid animation provided in SetAnimation:", anim, debug.traceback())
		object.AnimFrameCount = 0
		object.AnimCurrent = nil
	end

	local startFrame: number = anim and anim:GetAttribute("StartFrame") or 0
	object.AnimAccelAssist = 0
	object.AnimAccel = 0
	-- object.AnimAccel = 74444

	object.AnimReset = true
	object.AnimDirty = true
	object.AnimFrame = startFrame

	return startFrame
end
-- Mario.SetAnimationWithAccel
local function CUSTOM_init_animation_accel(object, anim, animAccel)
	if object.AnimCurrent ~= anim then
		CUSTOM_setAnimation(object, anim)
		-- if (graphNode.animInfo.curAnim != anim) {
        --[[graphNode.animInfo.curAnim = anim
        graphNode.animInfo.animFrameAccelAssist = (anim.unk04 << 16) + ((anim.flags & Mario.ANIM_FLAG_FORWARD) ? animAccel : -animAccel)
        graphNode.animInfo.animFrame = graphNode.animInfo.animFrameAccelAssist >> 16
        graphNode.animInfo.animYTrans = 0]]
	end

	object.AnimAccel = animAccel
	-- graphNode.animInfo.animAccel = animAccel
end

function Helpers.cur_obj_init_animation_with_accel_and_sound(o: Object, animIndex, accel)
	-- print('maybe add one to the anim index')
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	local anims = o.Animations
	local animAccel = parseInt(accel * 65536.0)
	-- geo_obj_init_animation_accel(o.gfx, anims[animIndex], animAccel)
	CUSTOM_init_animation_accel(o, anims[animIndex], animAccel)
end


function Helpers.spawn_object_at_origin(parent, model, behavior)
	local obj = SpawnObject.create_object(behavior)
	
	-- if parent then -- custom
		obj.parentObj = parent
		obj.gfx.areaIndex = parent.gfx.areaIndex
	 	obj.gfx.activeAreaIndex = parent.gfx.areaIndex
	-- end

	-- geo_obj_init(obj.gfx, gLinker.Area.gLoadedGraphNodes[model], [0,0,0], [0,0,0])
	if model then
		obj.Model:SetModel(model)
	end

	return obj
end

function Helpers.obj_copy_pos(dst, src)
	dst.Position = src.Position
    --[[dst.Position.X = src.Position.X
    dst.Position.Y = src.Position.Y
    dst.Position.Z = src.Position.Z]]
end

function Helpers.obj_copy_angle(dst, src)
	dst.FaceAnglePitch = src.FaceAnglePitch
	dst.FaceAngleYaw = src.FaceAngleYaw
	dst.FaceAngleRoll = src.FaceAngleRoll

	dst.MoveAnglePitch = src.MoveAnglePitch
	dst.MoveAngleYaw = src.MoveAngleYaw
	dst.MoveAngleRoll = src.MoveAngleRoll
end

function Helpers.obj_copy_pos_and_angle(dst, src)
	Helpers.obj_copy_pos(dst, src)
	Helpers.obj_copy_angle(dst, src)
end

function Helpers.spawn_object(parent, model, behavior)
	local obj = Helpers.spawn_object_at_origin(parent, model, behavior)
	if not parent then -- custo
		return obj
	end
	Helpers.obj_copy_pos_and_angle(obj, parent)
	return obj
end

function Helpers.obj_scale(obj: Object, scale)
	obj.GfxScale = Vector3.new(scale, scale, scale)
	--[[obj.gfx.scale[0] = scale
	obj.gfx.scale[1] = scale
	obj.gfx.scale[2] = scale]]
end

function Helpers.try_to_spawn_object(offsetY, scale, parent, model, behavior)
	local obj = Helpers.spawn_object(parent, model, behavior)
	obj.Position = Util.SetY(obj.Position, obj.Position.Y + offsetY)
	-- obj.Position.Y += offsetY
	Helpers.obj_scale(obj, scale)
	return obj
end

function Helpers.spawn_object_with_scale(parent, model, behavior, scale)
	-- local obj = Helpers.spawn_object_at_origin(parent, 0, model, behavior)
	-- i dont think 0 is supposed to be there..
	local obj = Helpers.spawn_object_at_origin(parent, model, behavior)

	Helpers.obj_copy_pos_and_angle(obj, parent)
	Helpers.obj_scale(obj, scale)

	return obj
end

--
--
function Helpers.obj_build_transform_from_pos_and_angle(obj, posIndex, angleIndex,
	CUSTOMyawIndex: string, CUSTOMrollIndex: string
)
	local translate = {}
	local rotation = {}

	translate[0] = obj[posIndex].X
	translate[1] = obj[posIndex].Y
	translate[2] = obj[posIndex].Z

	rotation[0] = obj[angleIndex]
	rotation[1] = obj[CUSTOMyawIndex]
	rotation[2] = obj[CUSTOMrollIndex]

	Util.mtxf_rotate_zxy_and_translate(obj.transform, translate, rotation)
    --[[local translate = {}
    local rotation = {}

    translate[0] = obj[posIndex + 0]
    translate[1] = obj[posIndex + 1]
    translate[2] = obj[posIndex + 2]

    rotation[0] = obj[angleIndex + 0]
    rotation[1] = obj[angleIndex + 1]
    rotation[2] = obj[angleIndex + 2]

    mtxf_rotate_zxy_and_translate(obj.transform, translate, rotation)]]
end
function Helpers.obj_translate_local(obj, posIndex, localTranslateIndex)
	local dx = obj[localTranslateIndex].X
	local dy = obj[localTranslateIndex].Y
	local dz = obj[localTranslateIndex].Z
--[[
	obj[posIndex].X += obj.transform[0][0] * dx + obj.transform[1][0] * dy + obj.transform[2][0] * dz
	obj[posIndex].Y += obj.transform[0][1] * dx + obj.transform[1][1] * dy + obj.transform[2][1] * dz
	obj[posIndex].Z += obj.transform[0][2] * dx + obj.transform[1][2] * dy + obj.transform[2][2] * dz]]


	obj[posIndex] = Vector3.new(
		obj[posIndex].X + obj.transform[0][0] * dx + obj.transform[1][0] * dy + obj.transform[2][0] * dz,
		obj[posIndex].Y + obj.transform[0][1] * dx + obj.transform[1][1] * dy + obj.transform[2][1] * dz,
		obj[posIndex].Z + obj.transform[0][2] * dx + obj.transform[1][2] * dy + obj.transform[2][2] * dz)
    --[[local dx = obj[localTranslateIndex + 0]
    local dy = obj[localTranslateIndex + 1]
    local dz = obj[localTranslateIndex + 2]

    obj[posIndex + 0] += obj.transform[0][0] * dx + obj.transform[1][0] * dy + obj.transform[2][0] * dz
    obj[posIndex + 1] += obj.transform[0][1] * dx + obj.transform[1][1] * dy + obj.transform[2][1] * dz
    obj[posIndex + 2] += obj.transform[0][2] * dx + obj.transform[1][2] * dy + obj.transform[2][2] * dz]]
end

local function obj_build_relative_transform(obj)
	Helpers.obj_build_transform_from_pos_and_angle(
		obj,
		'ParentRelativePos', -- Takes all XYZ,
		'FaceAnglePitch', -- Takes all roll, pitch, yaw
		'FaceAngleYaw',
		'FaceAngleRoll'
	)
	--[[
	O_FACE_ANGLE_INDEX           = 0x12
	O_FACE_ANGLE_PITCH_INDEX     = O_FACE_ANGLE_INDEX + 0
	O_FACE_ANGLE_YAW_INDEX       = O_FACE_ANGLE_INDEX + 1
	O_FACE_ANGLE_ROLL_INDEX      = O_FACE_ANGLE_INDEX + 2
	oFaceAnglePitch              = O_FACE_ANGLE_PITCH_INDEX
	oFaceAngleYaw                = O_FACE_ANGLE_YAW_INDEX
	oFaceAngleRoll               = O_FACE_ANGLE_ROLL_INDEX
	]]
	--[[
	Helpers.obj_build_transform_from_pos_and_angle(
		obj,
		oParentRelativePosX, -- Takes all XYZ,
		oFaceAnglePitch -- Takes all roll, pitch, yaw
	)
	]]
	Helpers.obj_translate_local(obj, 'Position', 'ParentRelativePos')
	-- Helpers.obj_translate_local(obj, oPosX, oParentRelativePosX)
end
--
--

function Helpers.obj_set_parent_relative_pos(obj, relX, relY, relZ)
	obj.ParentRelativePos = Vector3.new(relX, relY, relZ)
   --[[obj.ParentRelativePosX = relX
    obj.ParentRelativePosY = relY
    obj.ParentRelativePosZ = relZ]]
end

function Helpers.spawn_object_relative(behaviorParam, relativePosX, relativePosY, relativePosZ, parent, model, behavior)
	local obj = Helpers.spawn_object_at_origin(parent, model, behavior)

	Helpers.obj_copy_pos_and_angle(obj, parent)
	Helpers.obj_set_parent_relative_pos(obj, relativePosX, relativePosY, relativePosZ)
	obj_build_relative_transform(obj)

	obj.BhvParams2ndByte = behaviorParam
	obj.BhvParams = bit32.lshift(bit32.band(behaviorParam, 0xFF), 16) -- (behaviorParam & 0xFF) << 16

	return obj
end



function Helpers.cur_obj_set_behavior(o, behavior)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	warn('SET BEHAVIOR')
	o.behavior = behavior
end


function Helpers.cur_obj_set_model(o, modelID)
	-- custom code
	o.Model:SetModel(modelID)
    --[[const o = gLinker.ObjectListProcessor.gCurrentObject

    o.gfx.sharedChild = gLinker.Area.gLoadedGraphNodes[modelID] ]]
end

function Helpers.cur_obj_if_hit_wall_bounce_away(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	if o.MoveFlags:Has(ObjectConstants.OBJ_MOVE_HIT_WALL) then
		o.MoveAngleYaw = o.WallAngle
	end
end


function Helpers.cur_obj_wait_then_blink(o: Object, timeUntilBlinking, numBlinks)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject

	--local done = 0
	local done = false
	local timeBlinking = 0

	if o.Timer >= timeUntilBlinking then
		timeBlinking = o.Timer - timeUntilBlinking
		if timeBlinking % 2 ~= 0 then
			o.GfxFlags:Add(GraphNodeConstats.GRAPH_RENDER_INVISIBLE)
			--o.gfx.flags |= GRAPH_RENDER_INVISIBLE

			if timeBlinking / 2 > numBlinks then
				done = true
				--done = 1
			end
		else
			o.GfxFlags:Remove(GraphNodeConstats.GRAPH_RENDER_INVISIBLE)
			--o.gfx.flags &= ~ GRAPH_RENDER_INVISIBLE
		end
	end

	return done
end


function Helpers.obj_attack_collided_from_other_object(obj)
	if obj.NumCollidedObjs ~= 0 then
		--local other = obj.CollidedObjs[0]
		local other = obj.CollidedObjs[1]

		if other ~= gMarioObject then
			other.InteractStatus:Add(ATTACK_PUNCH, INT_STATUS_WAS_ATTACKED, INT_STATUS_INTERACTED, INT_STATUS_TOUCHED_BOB_OMB)
			--other.InteractStatus |= ATTACK_PUNCH | INT_STATUS_WAS_ATTACKED | INT_STATUS_INTERACTED | INT_STATUS_TOUCHED_BOB_OMB
			return true
		end
	end

	return false
end


local angleIndexCase = {}
function angleIndexCase.MoveAnglePitch(target, obj)
	local a = target.Position.X - obj.Position.X
	local c = target.Position.Z - obj.Position.Z
	local a = math.sqrt(a * a + c * c)

	local b = -obj.Position.Y
	local d = -target.Position.Y

	local targetAngle = Util.Atan2s(a, d - b)
	return targetAngle, a, b, c, d
end
angleIndexCase.FaceAnglePitch = angleIndexCase.MoveAnglePitch

function angleIndexCase.MoveAngleYaw(target, obj)
	local a = obj.Position.Z
	local c = target.Position.Z
	local b = obj.Position.X
	local d = target.Position.X

	local targetAngle = Util.Atan2s(c - a, d - b)
	return targetAngle, a, b, c, d
end
angleIndexCase.FaceAngleYaw = angleIndexCase.MoveAngleYaw
function Helpers.obj_turn_toward_object(obj, target, angleIndex, turnAmount)
	local o = obj -- um
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;

	local targetAngle, a, b, c, d = Util.Switch(angleIndex, angleIndexCase, target, obj)
	local startAngle = s16(o[angleIndex])
	o[angleIndex] = Helpers.approach_symmetric(startAngle, targetAngle, turnAmount)
	return targetAngle
end

function Helpers.cur_obj_nearest_object_with_behavior(o, behavior)
	warn('TODO: cur_obj_nearest_object_with_behavior')
	-- return cur_obj_find_nearest_object_with_behavior(o, behavior)
end

function Helpers.approach_s16_symmetric(value, target, increment)
	local dist = s16(target - value)

	if dist >= 0 then
		if dist > increment then value = s16(value + increment) 
		else value = target end
	else
		if dist < -increment then value = s16(value - increment)
		else value = target end
	end
end

function Helpers.cur_obj_init_animation(o, animIndex)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	local anims = o.Animations

	local anim = anims[animIndex]
	if o.AnimCurrent ~= anim then
		CUSTOM_setAnimation(o, anim)
		-- geo_obj_init_animation(o.gfx, anims[animIndex]);
	end
end

function Helpers.cur_obj_set_pos_relative(o, other, dleft, dy, dforward)
	-- local o = gLinker.ObjectListProcessor.gCurrentObject;

	local facingZ = Util.Coss(other.MoveAngleYaw)
	local facingX = Util.Sins(other.MoveAngleYaw)

	local dz = dforward * facingZ - dleft * facingX
	local dx = dforward * facingX + dleft * facingZ

	o.MoveAngleYaw = other.MoveAngleYaw

	o.Position = Vector3.new(
		other.Position.X + dx,
		other.Position.Y + dy,
		other.Position.Z + dz
	)
	-- o.Position.X = other.Position.X + dx
	-- o.Position.Y = other.Position.Y + dy
	-- o.Position.Z = other.Position.Z + dz
end

function Helpers.cur_obj_enable_rendering(o)
	--const o = gLinker.ObjectListProcessor.gCurrentObject;
	--o.gfx.flags |= GRAPH_RENDER_ACTIVE
	o.GfxFlags:Add(GraphNodeConstats.GRAPH_RENDER_ACTIVE)
end

function cur_obj_move_after_thrown_or_dropped(o, forwardVel, velY) 
	--const o = gLinker.ObjectListProcessor.gCurrentObject
	--const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

	o.MoveFlags = 0
	local floorHeight, _ = Util.FindFloor(Vector3.new(o.Position.X, o.Position.Y + 160.0, o.Position.Z))
	o.FloorHeight = floorHeight-- gLinker.SurfaceCollision.find_floor_height(o.Position.X, o.Position.Y + 160.0, o.Position.Z)

	if o.FloorHeight > o.Position.Y then
		o.Position = Util.SetY(o.Position, o.FloorHeight)
		-- o.Position.Y = o.FloorHeight
	elseif o.FloorHeight < -10000.0 then
		--! OoB failsafe
		Helpers.obj_copy_pos(o, gMarioObject)
		local floorHeight, _ = Util.FindFloor(o.Position)
		o.FloorHeight = floorHeight-- gLinker.SurfaceCollision.find_floor_height(o.Position.X, o.Position.Y + 160.0, o.Position.Z)
		-- o.FloorHeight = gLinker.SurfaceCollision.find_floor_height(o.Position.X, o.Position.Y, o.Position.Z)
	end

	o.ForwardVel = forwardVel
	o.Velocity = Util.SetY(o.Velocity, velY)
	-- o.VelY = velY

	if o.ForwardVel ~= 0 then
		Helpers.cur_obj_move_y(o, --[[gravity]] -4.0, --[[bounciness]] -0.1, --[[buoyancy]] 2.0)
	end
end

function Helpers.cur_obj_get_dropped(o)
	-- o = gLinker.ObjectListProcessor.gCurrentObject
	Helpers.cur_obj_become_tangible(o)
	Helpers.cur_obj_enable_rendering(o)

	o.HeldState = ObjectConstants.HELD_FREE
	cur_obj_move_after_thrown_or_dropped(o, 0.0, 0.0)
end

function Helpers.obj_scale_xyz(obj, xScale, yScale, zScale)
	obj.GfxScale = Vector3.new(xScale, yScale, zScale)
	--[[obj.gfx.scale[0] = xScale
	obj.gfx.scale[1] = yScale
	obj.gfx.scale[2] = zScale]]
end

function Helpers.cur_obj_push_mario_away(o, radius)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	-- const gMarioObject = gLinker.ObjectListProcessor.gMarioObject

	local marioRelX = gMarioObject.Position.X - o.Position.X
	local marioRelZ = gMarioObject.Position.Z - o.Position.Z
	local marioDist = math.sqrt(math.pow(marioRelX, 2) + math.pow(marioRelZ, 2))

	if marioDist < radius then
		gMarioObject.Position = Vector3.new(
			gMarioObject.Position.X + (radius - marioDist) / radius * marioRelX,
			gMarioObject.Position.Y,
			gMarioObject.Position.Z + (radius - marioDist) / radius * marioRelZ
		)
		-- gLinker.LevelUpdate.gMarioState.pos[0] += (radius - marioDist) / radius * marioRelX
		-- gLinker.LevelUpdate.gMarioState.pos[2] += (radius - marioDist) / radius * marioRelZ
	end
end

function Helpers.cur_obj_init_animation_with_sound(o, animIndex)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	local anims = o.Animations
	CUSTOM_setAnimation(o, anims[animIndex])
	-- geo_obj_init_animation(o.gfx, anims[animIndex])
	o.SoundStateID = animIndex
end

function Helpers.cur_obj_clear_interact_status_flag(o, flag)
	--const o = gLinker.ObjectListProcessor.gCurrentObject
	if o.InteractStatus:Has(flag) then
		o.InteractStatus:Remove(flag)
		return true
	end

	--[[if o.InteractStatus:Has(flag) then
		o.InteractStatus:Remove(flag)
		-- o.InteractStatus &= flag ^ ~(0)
        return true
    end]]
	return false
end

local function cur_obj_reset_timer_and_subaction(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	o.Timer = 0
	o.SubAction = 0
end

function Helpers.cur_obj_change_action(o, action)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	o.Action = action
	o.PrevAction = action
	cur_obj_reset_timer_and_subaction(o)
end

warn('cur_obj_check_if_near_animation_end may be innacurate')
function Helpers.cur_obj_check_if_near_animation_end(o)
	-- const o = gLinker.ObjectListProcessor.gCurrentObject;
	local anim = o.AnimCurrent :: Animation
	-- local animFlags = o.gfx.animInfo.curAnim.flags
	local animFrame = o.AnimFrame
	-- local nearLoopEnd = o.gfx.animInfo.curAnim.unk08 - 2
	local nearLoopEnd = o.AnimFrameCount - 2 -- i dontk now?
	local isNearEnd = false -- 0

	if anim and (not anim:GetAttribute('Loop')) and nearLoopEnd + 1 == animFrame then
		isNearEnd = true -- 1
	end
	
	if animFrame == nearLoopEnd then
		isNearEnd = true -- 1
	end

	return isNearEnd
    --[[
    local animFlags = o.gfx.animInfo.curAnim.flags
	local animFrame = m.AnimFrame
    local nearLoopEnd = o.gfx.animInfo.curAnim.unk08 - 2
    local isNearEnd = false -- 0

    if animFlags & ANIM_FLAG_NOLOOP && nearLoopEnd + 1 == animFrame then
        isNearEnd = true -- 1
    end

    if animFrame == nearLoopEnd then
        isNearEnd = true -- 1
    end

    return isNearEnd
    ]]
end


function Helpers.cur_obj_has_model(o, modelID: any)
	if not modelID then return 0 end
	-- const o = gLinker.ObjectListProcessor.gCurrentObject
	local compare = type(modelID) == 'string' and modelID or modelID.Name
	if o.Model and o.Model.Name == modelID then
		-- if (o.gfx.sharedChild == gLinker.Area.gLoadedGraphNodes[modelID]) {
		return 1
	end
	return 0
end

Helpers.enable_time_stop = function()
	return Helpers.Cenable_time_stop()
end
Helpers.disable_time_stop = function()
	return Helpers.Cdisable_time_stop()
end
Helpers.set_time_stop_flags = function(flags)
	return Helpers.Cset_time_stop_flags(flags)
end
Helpers.clear_time_stop_flags = function(flags)
	return Helpers.Cclear_time_stop_flags(flags)
end


function Helpers.obj_check_if_collided_with_object(obj1: Object, obj2: Object)
    for i = 0, obj1.NumCollidedObjs do
        if obj1.CollidedObjs[i] == obj2 then
            return true;
        end
    end

    return false;
end

return Helpers

--[[local ObjectHelpers = Helpers

;(function()
	ObjectHelpers = setmetatable({}, {
		__index = function(_, k)
			local helper = Helpers[k]
			if not helper then
				warn('NO HELPER FOR', k)
			end
			return helper, function()
				return 0
			end
		end,
	})
end)()

return ObjectHelpers]]