--!strict

--[[function WrapFolder(folder)
	return setmetatable({}, {
		__index = function(self, key)
			local child = folder:WaitForChild(key)

			if child:IsA("ModuleScript") then
				local module = child
				rawset(self, key, module)
				return module
			else
				local wrapped = WrapFolder(child)
				rawset(self, key, wrapped)
				return wrapped
			end
		end
	})
end

local Folder = WrapFolder(script)]]

local Folder = script

local Enums = {
	Action = require(Folder.Action).Action,
	Buttons = require(Folder.Buttons),
	ActionFlags = require(Folder.Action).Flags,
	ActionGroups = require(Folder.Action).Groups,

	MarioCap = require(Folder.Mario).Cap,
	MarioEyes = require(Folder.Mario).Eyes,
	MarioFlags = require(Folder.Mario).Flags,
	MarioHands = require(Folder.Mario).Hands,
	MarioInput = require(Folder.Mario).Input,

	AirStep = require(Folder.Steps).Air,
	HangStep = require(Folder.Steps).Hang,
	WaterStep = require(Folder.Steps).Water,
	GroundStep = require(Folder.Steps).Ground,

	FloorType = require(Folder.FloorType),
	InputFlags = require(Folder.InputFlags),
	ModelFlags = require(Folder.ModelFlags),
	SurfaceClass = require(Folder.SurfaceClass),
	TerrainType = require(Folder.TerrainType),
	ParticleFlags = require(Folder.ParticleFlags),

	Object = require(Folder.Object),

	Interaction = require(Folder.Interaction),

	Camera = require(Folder.Camera),
	
	mario_geo_switch_case_ids = require(Folder.mario_geo_switch_case_ids),
}

local nameIndex: { [any]: { [number]: string } } = {}

function Enums.GetName(map, value): string
	if not nameIndex[map] then
		local index = {}

		for name, value in pairs(map) do
			index[value] = name
		end

		nameIndex[map] = index
	end

	return nameIndex[map][value]
end

return table.freeze(Enums)
