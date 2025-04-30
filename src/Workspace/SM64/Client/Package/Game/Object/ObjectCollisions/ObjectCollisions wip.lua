-- https://github.com/sm64js/sm64js/blob/vanilla/src/game/ObjectCollisions.js

local ObjectCollisions = {}

local ObjectListProcessor = require(script.Parent.ObjectListProcessor)
local Interaction = require(script.Parent.Parent.Interaction)
local ObjectConstants = require(script.Parent.ObjectConstants)

-- local objList = ObjectListProcessor.gObjectLists
local objList = ObjectListProcessor.objList

local function clear_object_collision(listHead)
	local obj = listHead.next

	while (obj ~= listHead) do
		obj.CollidedObjs = []
		obj.NumCollidedObjs = 0 -- possibly not necessary
		obj.CollidedObjInteractTypes = 0
		if (obj.IntangibleTimer > 0) then
			obj.IntangibleTimer -= 1
		end
		obj = obj.next
	end
end

local function detect_object_hitbox_overlap(a, b)
	local sp3C = a.PosY - a.hitboxDownOffset
	local sp38 = b.PosY - b.hitboxDownOffset
	local dx = a.PosX - b.PosX
	local dz = a.PosZ - b.PosZ
	local collisionRadius = a.HitboxRadius + b.HitboxRadius
	local distance = math.sqrt(dx * dx + dz * dz)

	if (collisionRadius > distance) then
		local sp20 = a.HitboxHeight + sp3C
		local sp1C = b.HitboxHeight + sp38

		if (sp3C > sp1C) return false
			if (sp20 < sp38) return false
				if (a.NumCollidedObjs >= 4) return false
					if (b.NumCollidedObjs >= 4) return false

						a.CollidedObjs.push(b)
						b.CollidedObjs.push(a)

						a.NumCollidedObjs += 1 --possibly unnecessary
						b.NumCollidedObjs += 1 --possibly unnecessary

						a.CollidedObjInteractTypes |= b.InteractType
						b.CollidedObjInteractTypes |= a.InteractType

						return true
	end
end

local function detect_object_hurtbox_overlap(a, b)
	local sp3C = a.PosY - a.hitboxDownOffset
	local sp38 = b.PosY - b.hitboxDownOffset
	local dx = a.PosX - b.PosX
	local dz = a.PosZ - b.PosZ
	local collisionRadius = a.hurtboxRadius + b.hurtboxRadius
	local distance = math.sqrt(dx * dx + dz * dz)

	if (a == ObjectListProcessor.gMarioObject) then
		b.InteractionSubtype |= INT_SUBTYPE_DELAY_INVINCIBILITY
	end

	if (collisionRadius > distance) then
		local sp20 = a.HitboxHeight + sp3C
		local sp1C = b.hurtboxHeight + sp38

		if (sp3C > sp1C) then return false end
		if (sp20 < sp38) then return false end

		if (a == ObjectListProcessor.gMarioObject) then
			b.InteractionSubtype &= ~INT_SUBTYPE_DELAY_INVINCIBILITY
		end

		return true
	end
end



local function check_collision_in_list(aObj, listHead, bObj)
	if (aObj.IntangibleTimer == 0) {
		bObj = bObj || listHead.next
		while (bObj ~= listHead) {
			if (bObj.IntangibleTimer == 0) then
				if (detect_object_hitbox_overlap(aObj, bObj) and bObj.hurtboxRadius ~= 0.0) then
				detect_object_hurtbox_overlap(aObj, bObj)
			end
end
	bObj = bObj.next
	end
	end
	end

	local function check_player_object_collision()
		local gObjectLists = objList
		local marioObj = gObjectLists[OBJ_LIST_PLAYER].next

		check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_POLELIKE])
		check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_LEVEL])
		check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_GENACTOR])
		check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_PUSHABLE])
		check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_SURFACE])
		check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_DESTRUCTIVE])
	end

	local function check_destructive_object_collision()
		local gObjectLists = objList
		local listHead = gObjectLists[OBJ_LIST_DESTRUCTIVE]
		local obj = listHead.next

		while (obj ~= listHead) do
			if (obj.DistanceToMario < 2000 and !(obj.ActiveFlags:Has(ACTIVE_FLAG_UNK9))) then
				check_collision_in_list(obj, listHead, obj.next)
				check_collision_in_list(obj, gObjectLists[OBJ_LIST_GENACTOR])
				check_collision_in_list(obj, gObjectLists[OBJ_LIST_PUSHABLE])
				check_collision_in_list(obj, gObjectLists[OBJ_LIST_SURFACE])
			end
			obj = obj.next
		end
	end

	local function check_pushable_object_collision()
		local gObjectLists = objList
		local listHead = gObjectLists[OBJ_LIST_PUSHABLE]
		local obj = listHead.next

		while (obj ~= listHead) do
			check_collision_in_list(obj, listHead, obj.next)
			obj = obj.next
		end
	end

	function ObjectCollisions.detect_object_collisions()
		local gObjectLists = objList
		clear_object_collision(gObjectLists[OBJ_LIST_POLELIKE])
		clear_object_collision(gObjectLists[OBJ_LIST_PLAYER])
		clear_object_collision(gObjectLists[OBJ_LIST_PUSHABLE])
		clear_object_collision(gObjectLists[OBJ_LIST_GENACTOR])
		clear_object_collision(gObjectLists[OBJ_LIST_LEVEL])
		clear_object_collision(gObjectLists[OBJ_LIST_SURFACE])
		clear_object_collision(gObjectLists[OBJ_LIST_DESTRUCTIVE])
		check_player_object_collision()
		check_pushable_object_collision()
		check_destructive_object_collision()
	end

	return ObjectCollisions