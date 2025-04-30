-- this script is just an example i dont necessarily suggest putting scripts in parts like this
script.Parent.Transparency = 1
while not shared.LocalMario do
	task.wait(.5)
end
local Package = require(workspace.SM64.Client.Package)

local Object = Package.Game.Object

local BehaviorData = Object.BehaviorData
local Models = Object.Models
local BehaviorScripts = BehaviorData.BehaviorScripts

local Util = Package.Util

Object.Custom.SpawnObject(
	BehaviorScripts.bhvGoombaTripletSpawner, -- behavior script
	Models.NONE, -- model
	Util.ToSM64(script.Parent.Position), -- position (vec 3)
	nil, -- yaw (a number)
	nil -- properties (a dictionary)
)