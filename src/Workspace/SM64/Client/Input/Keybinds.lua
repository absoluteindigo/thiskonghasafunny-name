local Package = require(script.Parent.Parent.Package)

local Enums = Package.Enums
local Buttons = Enums.Buttons

local A_BUTTON = Buttons.A_BUTTON
local B_BUTTON = Buttons.B_BUTTON
local L_TRIG = Buttons.L_TRIG
local R_TRIG = Buttons.R_TRIG
local Z_TRIG = Buttons.Z_TRIG
local START_BUTTON = Buttons.START_BUTTON
local U_JPAD = Buttons.U_JPAD
local L_JPAD = Buttons.L_JPAD
local R_JPAD = Buttons.R_JPAD
local D_JPAD = Buttons.D_JPAD
local U_CBUTTONS = Buttons.U_CBUTTONS
local L_CBUTTONS = Buttons.L_CBUTTONS
local R_CBUTTONS = Buttons.R_CBUTTONS
local D_CBUTTONS = Buttons.D_CBUTTONS

local KeyCode = Enum.KeyCode
local UserInputType = Enum.UserInputType

local Keybinds = {
	[KeyCode.Space] = A_BUTTON,
	[KeyCode.ButtonA] = A_BUTTON,

	[UserInputType.MouseButton1] = B_BUTTON,
	[KeyCode.E] = B_BUTTON,
	[KeyCode.ButtonX] = B_BUTTON,
	[KeyCode.ButtonB] = B_BUTTON,

	[KeyCode.LeftShift] = Z_TRIG,
	[KeyCode.RightShift] = Z_TRIG,
	[KeyCode.ButtonL2] = Z_TRIG,
	-- [KeyCode.ButtonR2] = Z_TRIG,
	
	[KeyCode.Escape] = START_BUTTON,
	[KeyCode.Return] = START_BUTTON,
	[KeyCode.ButtonSelect] = START_BUTTON,
	
	[KeyCode.I] = U_JPAD,
	[KeyCode.K] = D_JPAD,
	[KeyCode.J] = L_JPAD,
	[KeyCode.L] = R_JPAD,

	[KeyCode.DPadUp] = U_JPAD,
	[KeyCode.DPadLeft] = L_JPAD,
	[KeyCode.DPadRight] = R_JPAD,
	[KeyCode.DPadDown] = D_JPAD,
}

return Keybinds