-- an entierly custom reimplementation of SurfaceLoad
-- https://github.com/sm64js/sm64js/blob/04c1a984117ebb8d0e7b0d5d2e3424367f69b92d/src/game/SurfaceLoad.js#L429

local ObjectClass = script.Parent

local ObjectHelpers = require(ObjectClass.ObjectHelpers)
local ObjectListProcessor = require(ObjectClass.ObjectListProcessor)
local ObjectConstants = require(ObjectClass.ObjectConstants)
local GraphNodeConstats = require(ObjectClass.GraphNodeConstats)

local GRAPH_RENDER_ACTIVE = GraphNodeConstats.GRAPH_RENDER_ACTIVE
local oDistanceToMario, oCollisionDistance, oDrawingDistance, ACTIVE_FLAG_IN_DIFFERENT_ROOM, O_POS_INDEX, O_FACE_ANGLE_INDEX = ObjectConstants.oDistanceToMario, ObjectConstants.oCollisionDistance, ObjectConstants.oDrawingDistance, ObjectConstants.ACTIVE_FLAG_IN_DIFFERENT_ROOM, ObjectConstants.O_POS_INDEX, ObjectConstants.O_FACE_ANGLE_INDEX
local dist_between_objects, obj_build_transform_from_pos_and_angle, obj_apply_scale_to_matrix = ObjectHelpers.dist_between_objects, ObjectHelpers.obj_build_transform_from_pos_and_angle, ObjectHelpers.obj_apply_scale_to_matrix
local TIME_STOP_ACTIVE = ObjectListProcessor.TIME_STOP_ACTIVE

local SurfaceLoad = {}

local function band(...)
	return bit32.band(...) ~= 0
end

function SurfaceLoad.load_object_collision_model(gCurrentObject)
	-- const vertexData = []
	-- local gCurrentObject = ObjectListProcessor.gCurrentObject
	local marioDist = gCurrentObject.DistanceToMario
	local tangibleDist = gCurrentObject.CollisionDistance

	-- On an object's first frame, the distance is set to 19000.0f.
	-- If the distance hasn't been updated, update it now.
	if marioDist == 19000.0 then
		marioDist = dist_between_objects(gCurrentObject, ObjectListProcessor.gMarioObject)
	end

	-- If the object collision is supposed to be loaded more than the
	-- drawing distance of 4000, extend the drawing range.
	if tangibleDist > 4000.0 then
		gCurrentObject.DrawingDistance = tangibleDist
	end
	
	if not band(ObjectListProcessor.gTimeStopState, TIME_STOP_ACTIVE) and
		marioDist < tangibleDist and
		not gCurrentObject.ActiveFlags:Has(ACTIVE_FLAG_IN_DIFFERENT_ROOM) then
		if gCurrentObject.OBJ_COL then
			gCurrentObject.OBJ_COL.Active = true
		end
		-- print('load collission')
		--[[local collisionData = {
			data = gCurrentObject.collisionData,
			dataIndex = 1
		}
		SurfaceLoad.transform_object_vertices(collisionData, vertexData)

		while collisionData.data[collisionData.dataIndex] ~= Surfaces.TERRAIN_LOAD_CONTINUE do
			SurfaceLoad.load_object_surfaces(collisionData, vertexData)
		end]]
	end


	if marioDist < gCurrentObject.DrawingDistance then
		gCurrentObject.GfxFlags:Add(GRAPH_RENDER_ACTIVE)
	else
		gCurrentObject.GfxFlags:Remove(GRAPH_RENDER_ACTIVE)
	end
end

return SurfaceLoad