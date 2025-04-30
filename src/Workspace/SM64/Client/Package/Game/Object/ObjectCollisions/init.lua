-- https://github.com/sm64js/sm64js/blob/vanilla/src/game/ObjectCollisions.js
-- with a modern twist honestly

local ObjectCollisions = {}

local ObjectListProcessor = require(script.Parent.ObjectListProcessor)
local Types = require(script.Parent.Parent.Parent.Types)
local Enums = require(script.Parent.Parent.Parent.Enums)
local Interaction = require(script.Parent.Parent.Interaction)
local ObjectConstants = require(script.Parent.ObjectConstants)
local BehaviorData = require(script.Parent.BehaviorData)

type Object = Types.ObjectState

local INT_SUBTYPE_DELAY_INVINCIBILITY = Enums.Interaction.Subtype.DELAY_INVINCIBILITY
local ACTIVE_FLAG_UNK9 = Enums.Object.ActiveFlag.UNK9

-- STUFF!!! for my CUSTOM LIST property (yeah)
local OBJ_LIST_PLAYER = BehaviorData.OBJ_LIST_PLAYER
local OBJ_LIST_UNUSED_1 = BehaviorData.OBJ_LIST_UNUSED_1
local OBJ_LIST_DESTRUCTIVE = BehaviorData.OBJ_LIST_DESTRUCTIVE
local OBJ_LIST_UNUSED_3 = BehaviorData.OBJ_LIST_UNUSED_3
local OBJ_LIST_GENACTOR = BehaviorData.OBJ_LIST_GENACTOR
local OBJ_LIST_PUSHABLE = BehaviorData.OBJ_LIST_PUSHABLE
local OBJ_LIST_LEVEL = BehaviorData.OBJ_LIST_LEVEL
local OBJ_LIST_UNUSED_7 = BehaviorData.OBJ_LIST_UNUSED_7
local OBJ_LIST_DEFAULT = BehaviorData.OBJ_LIST_DEFAULT
local OBJ_LIST_SURFACE = BehaviorData.OBJ_LIST_SURFACE
local OBJ_LIST_POLELIKE = BehaviorData.OBJ_LIST_POLELIKE
local OBJ_LIST_SPAWNER = BehaviorData.OBJ_LIST_SPAWNER
local OBJ_LIST_UNIMPORTANT = BehaviorData.OBJ_LIST_UNIMPORTANT
local NUM_OBJ_LISTS = BehaviorData.NUM_OBJ_LISTS

local listCategories = {}
for k, v in pairs({
	OBJ_LIST_PLAYER,
	OBJ_LIST_UNUSED_1,
	OBJ_LIST_DESTRUCTIVE,
	OBJ_LIST_UNUSED_3,
	OBJ_LIST_GENACTOR,
	OBJ_LIST_PUSHABLE,
	OBJ_LIST_LEVEL,
	OBJ_LIST_UNUSED_7,
	OBJ_LIST_DEFAULT,
	OBJ_LIST_SURFACE,
	OBJ_LIST_POLELIKE,
	OBJ_LIST_SPAWNER,
	OBJ_LIST_UNIMPORTANT,
	NUM_OBJ_LISTS,
	}) do
	listCategories[v] = v
end


-- local objList = ObjectListProcessor.gObjectLists
local objList = ObjectListProcessor.objList

local function getObjectsInList(list)
	local newList = {}
	for k, obj in pairs(objList) do
		if obj.LIST == list then
			table.insert(newList, obj)
		end
	end
	return newList
end
ObjectCollisions.getObjectsInList = getObjectsInList

local global = nil

local function categorizeObjectList()
	if global then return global end
	local categorized = {}
	for v in pairs(listCategories) do
		categorized[v] = {}
	end
	for k, obj in pairs(objList) do
		if obj.LIST and listCategories[obj.LIST] then
			table.insert(categorized[obj.LIST], obj)
		end
	end
	-- print(#objList)
	global = categorized
	return categorized
end
ObjectCollisions.categorizeObjectList = categorizeObjectList

local function clear_object_collision(listHead)
	for k, obj: Object in pairs(listHead) do
		obj.CollidedObjs = {}
		obj.NumCollidedObjs = 0 -- possibly not necessary
		obj.CollidedObjInteractTypes:Clear()
		--obj.CollidedObjInteractTypes = 0
		if (obj.IntangibleTimer > 0) then
			obj.IntangibleTimer -= 1
		end
	end
end

local function detect_object_hitbox_overlap(a: Object, b: Object)
	-- or 0 for both of these is custom code
	local sp3C = a.Position.Y - (a.HitboxDownOffset or 0)
	local sp38 = b.Position.Y - (b.HitboxDownOffset or 0)
	local dx = a.Position.X - b.Position.X
	local dz = a.Position.Z - b.Position.Z
	local collisionRadius = a.HitboxRadius + b.HitboxRadius
	local distance = math.sqrt(dx * dx + dz * dz)

	if collisionRadius > distance then
		local sp20 = a.HitboxHeight + sp3C
		local sp1C = b.HitboxHeight + sp38

		if (sp3C > sp1C) then return false end
		if (sp20 < sp38) then return false end
		if (a.NumCollidedObjs >= 4) then return false end
		if (b.NumCollidedObjs >= 4) then return false end

		table.insert(a.CollidedObjs, b)
		table.insert(b.CollidedObjs, a)
		-- a.CollidedObjs.push(b)
		--  b.CollidedObjs.push(a)

		a.NumCollidedObjs += 1 --possibly unnecessary
		b.NumCollidedObjs += 1 --possibly unnecessary
		
		a.CollidedObjInteractTypes:Add(b.InteractType or 0)
		b.CollidedObjInteractTypes:Add(a.InteractType or 0) -- DUDE WEN I ADDED 0 I i just dont know dude
		
		-- a.CollidedObjInteractTypes |= b.InteractType
		-- b.CollidedObjInteractTypes |= a.InteractType

		return true
	end
end

local hbtodo = true

local function detect_object_hurtbox_overlap(a: Object| Types.MarioState, b: Object)
	-- or 0 for both of these is custom code
	if hbtodo and (
		(not a.HitboxDownOffset) or
		(not b.HitboxDownOffset) or
			(not a.HurtboxRadius)) then
		hbtodo = false
		warn('TODO: not everything has a hurtbox', a.HitboxDownOffset, b.HitboxDownOffset, a.HurtboxRadius)
	end
	--warn('--')
	--print(a.HitboxDownOffset)
	--print(b.HitboxDownOffset)
	--print(a.HurtboxRadius)
	local sp3C = a.Position.Y - (a.HitboxDownOffset or 0)
	local sp38 = b.Position.Y - (b.HitboxDownOffset or 0)
	local dx = a.Position.X - b.Position.X
	local dz = a.Position.Z - b.Position.Z
	local collisionRadius = (a.HurtboxRadius or a.HitboxRadius) + b.HurtboxRadius
	local distance = math.sqrt(dx * dx + dz * dz)

	if (a == ObjectListProcessor.gMarioObject) then
		b.InteractionSubtype:Add(INT_SUBTYPE_DELAY_INVINCIBILITY)
	end

	if (collisionRadius > distance) then
		local sp20 = a.HitboxHeight + sp3C
		local sp1C = b.HurtboxHeight + sp38

		if (sp3C > sp1C) then return false end
		if (sp20 < sp38) then return false end

		if (a == ObjectListProcessor.gMarioObject) then
			b.InteractionSubtype:Remove(INT_SUBTYPE_DELAY_INVINCIBILITY)
		end

		return true
	end
end

warn('TODO: remove custom code in check_collision_in_list')
-- this is mostly custom code
local function check_collision_in_list(aObj, listHead)-- , bObj)
	if aObj.IntangibleTimer == 0 then
		-- local bObj = bObj or next(listHead)
		for k, bObj in pairs(listHead) do
			if bObj == aObj then continue end
			if (bObj.IntangibleTimer == 0) then
				if (detect_object_hitbox_overlap(aObj, bObj) and bObj.HurtboxRadius ~= 0.0) then
					detect_object_hurtbox_overlap(aObj, bObj)
					
					--[[ CUSTOM
					local interactType = bObj.InteractType
					local func = interactType and Interaction.InteractionHandlers[interactType]
					for _, handler in ipairs(Interaction.InteractionHandlers) do
						if handler[1] == interactType then
							func = handler[2]
						end
					end

					if func and type(aObj.Action) ~= 'number' then
						func(aObj, bObj)
					end]]
				end
			end
		end
	end
	--[[if false then
        bObj = bObj or listHead.next
        while (bObj ~= listHead) {
            if (bObj.IntangibleTimer == 0) then
                if (detect_object_hitbox_overlap(aObj, bObj) and bObj.HurtboxRadius ~= 0.0) then
                    detect_object_hurtbox_overlap(aObj, bObj)
                end
            end
            bObj = bObj.next
        end]]
end

-- this is kinda custom code
local function check_player_object_collision()
	local LISTS = categorizeObjectList() -- objList

	local gObjectLists = objList
	local marioObj = LISTS[OBJ_LIST_PLAYER][1] -- next(LISTS[OBJ_LIST_PLAYER])
	
	check_collision_in_list(marioObj, LISTS[OBJ_LIST_POLELIKE])
	check_collision_in_list(marioObj, LISTS[OBJ_LIST_LEVEL])
	check_collision_in_list(marioObj, LISTS[OBJ_LIST_GENACTOR])
	check_collision_in_list(marioObj, LISTS[OBJ_LIST_PUSHABLE])
	check_collision_in_list(marioObj, LISTS[OBJ_LIST_SURFACE])
	check_collision_in_list(marioObj, LISTS[OBJ_LIST_DESTRUCTIVE])

    --[[local gObjectLists = objList
    local marioObj = gObjectLists[OBJ_LIST_PLAYER].next

    check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_POLELIKE])
    check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_LEVEL])
    check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_GENACTOR])
    check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_PUSHABLE])
    check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_SURFACE])
    check_collision_in_list(marioObj, gObjectLists[OBJ_LIST_DESTRUCTIVE])]]
end

-- ddjkhsadasdasdhjk
local function check_destructive_object_collision()
	local gObjectLists = categorizeObjectList() -- objList
	local listHead = gObjectLists[OBJ_LIST_DESTRUCTIVE]
	-- local obj = listHead.next

	for k, obj in pairs(listHead) do
		if obj.DistanceToMario < 2000 and not (obj.ActiveFlags:Has(ACTIVE_FLAG_UNK9)) then
			check_collision_in_list(obj, listHead)-- , obj.next)
			check_collision_in_list(obj, gObjectLists[OBJ_LIST_GENACTOR])
			check_collision_in_list(obj, gObjectLists[OBJ_LIST_PUSHABLE])
			check_collision_in_list(obj, gObjectLists[OBJ_LIST_SURFACE])
		end
		obj = obj.next
	end
end

local function check_pushable_object_collision()
	local gObjectLists = categorizeObjectList() -- objList
	local listHead = gObjectLists[OBJ_LIST_PUSHABLE]
	--local obj = listHead.next

	for k, obj in pairs(listHead) do

		check_collision_in_list(obj, listHead)-- , obj.next)
	end
    --[[while (obj ~= listHead) do
        check_collision_in_list(obj, listHead)-- , obj.next)
        obj = obj.next
   end]]
end

function ObjectCollisions.detect_object_collisions()
	global = nil -- custom

	local gObjectLists = categorizeObjectList() -- objList
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

	global = nil -- custom
end

return ObjectCollisions