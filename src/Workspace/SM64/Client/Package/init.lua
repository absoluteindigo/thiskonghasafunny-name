local Types = require(script.Types)
local Mario = require(script.Mario)

local Package = {
	Core = script.Parent.Parent,
	FFlags = require(script.FFlags),
	Shared = require(script.Parent.Parent.Shared),
	Enums = require(script.Enums),
	Mario = Mario,
	Types = Types,
	Util = require(script.Util),
	Animations = require(script.Animations),
	Sounds = require(script.Sounds),

	Game = {
		Object = require(script.Game.Object),
		Interaction = require(script.Game.Interaction),
		PlatformDisplacement = require(script.Game.PlatformDisplacement),
	},
	
	Custom = {
		Model = require(script.Custom.Model)
	},
}

export type Mario = Mario.Class
export type MarioAction = Mario.MarioAction

export type BodyState = Types.BodyState
export type Controller = Types.Controller
export type MarioState = Types.MarioState

export type Flags = Types.Flags
export type ObjectState = Types.ObjectState
export type ObjectHitboxState = Types.ObjectHitboxState
-- export type PlayerCameraState = Types.PlayerCameraState
export type LakituState = Types.LakituState
-- export type CameraTransition = Types.CameraTransition
-- export type CameraTrackPath = Types.CameraTrackPath
export type CameraState = Types.CameraState

return Package