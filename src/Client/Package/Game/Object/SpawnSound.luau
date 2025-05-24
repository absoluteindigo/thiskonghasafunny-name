local Sounds = require(script.Parent.Parent.Parent.Sounds)

local Util = require(script.Parent.Parent.Parent.Util)
local GraphNodeConstats = require(script.Parent.GraphNodeConstats)
--local ObjectListProcessor = require(script.Parent.ObjectListProcessor)
--local ObjectHelpers = require(script.Parent.ObjectHelpers)
-- local BehaviorData = require(script.Parent.BehaviorData)

--[[import { ObjectListProcessorInstance as ObjectListProc } from "./ObjectListProcessor"
import { cur_obj_check_anim_frame, spawn_object } from "./ObjectHelpers"
import { oSoundEffectUnkF4 } from "../include/object_localants"
import { play_sound } from "../audio/external"
import { bhvSoundSpawner } from "./BehaviorData"
import { GRAPH_RENDER_ACTIVE } from "../engine/graph_node"]]

-- custom
local function clearTrash(trash: {Instance}?)
	if trash then
		for k, v in pairs(trash) do
			v:Destroy()
		end
	end
end

 -- custom
local function playSoundAt(sound: Sound, parent, object, trash: {Instance}?)
	if object and object.Audio then
		clearTrash(trash)
		object.Audio:Play(sound)
		return
	end
	if not sound then return clearTrash(trash) end
	if not sound.IsLoaded then return clearTrash(trash) end
	
	local newSound: Sound = sound:Clone()
	newSound.Parent = parent
	newSound:Play()

	newSound.Ended:Connect(function()
		newSound:Destroy()
		clearTrash(trash)
	end)
end

local function playSoundAtVector(sound, position: Vector3, object)
	local attachment = Instance.new('Attachment')
	attachment.Position = Util.ToRoblox(position)
	attachment.Parent = workspace:FindFirstChildOfClass('Terrain')

	--[[local part = Instance.new('Part')
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Size = Vector3.zero
	part.Position = Util.ToRoblox(position)
	part.Transparency = 1
	part.Parent = workspace.SM64.Ignore]]

	playSoundAt(sound, attachment, object, {attachment})
end

-- custom
local function play_sound(sound: Sound, object)
	if (not sound) then return end
	if type(sound) == 'string' then
		sound = Sounds[sound]
		if (not sound) then return end
	end

	if object then
		
		if type(object) == 'vector' then
			playSoundAtVector(sound, object, object)
		else
			local Model = object.Model
			Model = (Model and Model.Model) :: Instance
			if Model then
				local primary = Model:IsA('Model') and Model.PrimaryPart or Model:IsA('BasePart') and Model
				if primary then
					playSoundAt(sound, primary, object)
				else
					playSoundAtVector(sound, object.Position, object)
				end
			else
				playSoundAtVector(sound, object.Position, object)
			end
		end
		
	end
end

local SpawnSound = {}

SpawnSound.play_sound = play_sound

--[[
 * execute an object's current sound state with a provided array
 * of sound states. Used for the stepping sounds of various
 * objects. (King Bobomb, Bowser, King Whomp)
 ]]
--[[export local exec_anim_sound_state = (soundStates) => {
    local stateIdx = ObjectListProc.gCurrentObject.oSoundStateID

    switch (soundStates[stateIdx].playSound) {
        -- since we have an array of sound states corresponding to
        -- various behaviors, not all entries intend to play sounds. the
        -- boolean being 0 for unused entries skips these states.
        case 0:
            break
        case 1:
            local animFrame

            -- in the sound state information, -1 (0xFF) is for empty
            -- animFrame entries. These checks skips them.
            if ((animFrame = soundStates[stateIdx].animFrame1) >= 0) {
                if (cur_obj_check_anim_frame(animFrame)) {
                    cur_obj_play_sound_2(soundStates[stateIdx].soundMagic)
                }
            }

            if ((animFrame = soundStates[stateIdx].animFrame2) >= 0) {
                if (cur_obj_check_anim_frame(animFrame)) {
                    cur_obj_play_sound_2(soundStates[stateIdx].soundMagic)
                }
            }
            break
    }
}]]

--[[
 * Create a sound spawner for objects that need a sound play once.
 * (Breakable walls, King Bobomb exploding, etc)
 ]]
--[[export local create_sound_spawner = (soundMagic) => {
	local obj = spawn_object(ObjectListProc.gCurrentObject, 0, bhvSoundSpawner)

	obj.oSoundEffectUnkF4 = soundMagic
}]]
function SpawnSound.create_sound_spawner(o, soundMagic)

	--[[local obj = spawn_object(ObjectListProc.gCurrentObject, 0, bhvSoundSpawner)

	obj.oSoundEffectUnkF4 = soundMagic]]
	playSoundAtVector(soundMagic, o.Position)
end

--[[
 * The following 2 functions are relevant to the sound state function
 * above. While only cur_obj_play_sound_2 is used, they may have been intended as
 * separate left/right leg functions that went unused.
 ]]
--[[export local cur_obj_play_sound_1 = (soundMagic) => {
    if (ObjectListProc.gCurrentObject.gfx.flags & GRAPH_RENDER_ACTIVE) {
        play_sound(soundMagic, ObjectListProc.gCurrentObject.gfx.cameraToObject)
    }
}]]

function SpawnSound.cur_obj_play_sound_2(o, soundMagic)
	-- soundMagic is a roblox sonud instance

	if o.GfxFlags:Has(GraphNodeConstats.GRAPH_RENDER_ACTIVE) then
		play_sound(soundMagic, o)
	end
	--if o.gfx.flags & GRAPH_RENDER_ACTIVE then
	--play_sound(soundMagic, o.cameraToObject)
	--end
end

SpawnSound.cur_obj_play_sound_1 = SpawnSound.cur_obj_play_sound_2

--[[
 * These 2 functions below are complocalely unreferenced in all versions
 * of Super Mario 64. They are likely functions which facilitated
 * calculation of distance of an object to volume, since these are
 * common implementations of such a concept, and the fact they are
 * adjacent to other sound functions. The fact there are 2 functions
 * might show that the developers were testing several ranges, or certain
 * objects had different ranges, or had these for other unknown purposes.
 * Technically, these functions are only educated guesses. Trust these
 * interpretations at your own discretion.
 ]]
--[[export local calc_dist_to_volume_range_1 = (distance) => { -- range from 60-124
    local volume

    if (distance < 500.0) {
        volume = 127
    } else if (1500.0 < distance) {
        volume = 0
    } else {
        volume = (((distance - 500.0) / 1000.0) * 64.0) + 60.0
    }

    return volume
}

export local calc_dist_to_volume_range_2 = (distance) => { -- range from 79.2-143.2
    local volume

    if (distance < 1300.0) {
        volume = 127
    } else if (2300.0 < distance) {
        volume = 0
    } else {
        volume = (((distance - 1000.0) / 1000.0) * 64.0) + 60.0
    }

    return volume
}]]

return SpawnSound