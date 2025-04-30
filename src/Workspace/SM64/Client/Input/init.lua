local InputHandler = {}

local Players = game:GetService('Players')
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Package = require(script.Parent.Package)

local FFlags = Package.FFlags
local Enums = Package.Enums
local Buttons = Enums.Buttons
local Types = require(script.Parent.Package.Types)
local player = Players.LocalPlayer

type InputType = Enum.UserInputType | Enum.KeyCode
type Controller = Types.Controller

local ControlModule: {
	GetMoveVector: (self: any) -> Vector3,
}

while not ControlModule do
	local inst = player:FindFirstChild("ControlModule", true) :: ModuleScript

	if inst then
		ControlModule = require(inst)
		break
	end

	task.wait(0.1)
end

-- NOTE: I had to replace the default BindAction via KeyCode and UserInputType
-- BindAction forces some mappings (such as R2 mapping to MouseButton1) which you
-- can't turn off otherwise.

local BUTTON_FEED = {}
local BUTTON_BINDS = require(script.Keybinds)
local BUTTON_ID = 'BTN_'

local COMMAND_WALK = false

local specialActions = {
	MarioDebug = function(state: Enum.UserInputState, input: InputObject)
		if not FFlags.DEBUG_TOGGLE then return end
		if state == Enum.UserInputState.Begin then
			FFlags.DEBUG = not FFlags.DEBUG
		end
	end,
	CommandWalk = function(state: Enum.UserInputState, input: InputObject)
		if state == Enum.UserInputState.Begin then
			COMMAND_WALK = true
		else
			COMMAND_WALK = false
		end
	end,
	--[[TASInputForceToggle = function(state: Enum.UserInputState, input: InputObject)
		if state == Enum.UserInputState.Begin then
			FFlags.RAPID_FIRE_INPUT = not FFlags.RAPID_FIRE_INPUT
			print(`<- TAS input override {FFlags.RAPID_FIRE_INPUT and "ON" or "OFF"} ->`)
		end
	end,]]
}

for n, button in pairs(Buttons) do
	specialActions[BUTTON_ID .. button] = function(state: Enum.UserInputState, input: InputObject)
		BUTTON_FEED[button] = input.UserInputState
	end
end

local function processAction(id: string | number, state: Enum.UserInputState, input: InputObject)
	local specialAction = specialActions[id]
	if specialAction then
		specialAction(state, input)
	else
		BUTTON_FEED[id] = state
	end
end

local ButtonA = Enum.KeyCode.ButtonA
local function processInput(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent and input.KeyCode ~= ButtonA then
		return
	end
	local ID = BUTTON_BINDS[input.KeyCode] or BUTTON_BINDS[input.UserInputType]
	-- print(input.KeyCode.Name)
	-- print(ID)
	if ID then
		processAction(ID, input.UserInputState, input)
	end
end

UserInputService.InputBegan:Connect(processInput)
UserInputService.InputChanged:Connect(processInput)
UserInputService.InputEnded:Connect(processInput)

local function bindInput(button: number, label: string?, ...: InputType)
	local id = BUTTON_ID .. button

	if UserInputService.TouchEnabled then
		ContextActionService:BindAction(id, processAction, label ~= nil)
		if label then
			ContextActionService:SetTitle(id, label)
		end
	end
end

function InputHandler.updateController(mario, humanoid: Humanoid?)
	local controller = mario.Controller :: Controller
	--[[if not humanoid then
		return
	end]]

	local moveDir = ControlModule:GetMoveVector()
	local pos = Vector2.new(moveDir.X, -moveDir.Z)
	local mag = 0

	if pos.Magnitude > 0 then
		if pos.Magnitude > 1 then
			pos = pos.Unit
		end

		if COMMAND_WALK then
			pos *= 0.475
		end

		mag = pos.Magnitude
	end

	controller.StickMag = mag * 64
	controller.StickX = pos.X * 64
	controller.StickY = pos.Y * 64

	controller.ButtonPressed:Clear()
	
	if humanoid then
		BUTTON_FEED[Buttons.A_BUTTON] = nil

		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		if humanoid.Jump then
			BUTTON_FEED[Buttons.A_BUTTON] = Enum.UserInputState.Begin
		elseif controller.ButtonDown:Has(Buttons.A_BUTTON) then
			BUTTON_FEED[Buttons.A_BUTTON] = Enum.UserInputState.End
		end
	end
	--[[if humanoid then
		BUTTON_FEED[Buttons.A_BUTTON] = nil

		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		if humanoid.Jump then
			BUTTON_FEED[Buttons.A_BUTTON] = Enum.UserInputState.Begin
		elseif controller.ButtonDown:Has(Buttons.A_BUTTON) then
			BUTTON_FEED[Buttons.A_BUTTON] = Enum.UserInputState.End
		end
	end]]

	local lastButtonValue = controller.ButtonDown()

	for button, state in pairs(BUTTON_FEED) do
		if state == Enum.UserInputState.Begin then
			controller.ButtonDown:Add(button)
		elseif state == Enum.UserInputState.End then
			controller.ButtonDown:Remove(button)
		end
	end

	table.clear(BUTTON_FEED)

	local buttonValue = controller.ButtonDown()
	controller.ButtonPressed:Set(buttonValue)
	controller.ButtonPressed:Band(bit32.bxor(buttonValue, lastButtonValue))

	if FFlags.RAPID_FIRE_INPUT then
		if not mario.Action:Has(Enums.ActionFlags.SWIMMING, Enums.ActionFlags.HANGING) then
			if controller.ButtonDown:Has(Buttons.A_BUTTON) and not controller.ButtonPressed:Has(Buttons.A_BUTTON) then
				controller.ButtonPressed:Add(Buttons.A_BUTTON)
			end
		end
	end
end

ContextActionService:BindAction("CommandWalk", processAction, false, Enum.KeyCode.LeftControl, Enum.KeyCode.Q)

if (not FFlags.DEBUG_OFF_INGAME) or RunService:IsStudio() then
	ContextActionService:BindAction("MarioDebug", processAction, false, Enum.KeyCode.P)
end

-- bindInput(Buttons.A_BUTTON,nil)
bindInput(Buttons.B_BUTTON, "B")
bindInput(Buttons.Z_TRIG, "Z")
-- JPAD buttons
--     ^
--  <     >
--     v
bindInput(Buttons.U_JPAD, nil)
bindInput(Buttons.L_JPAD, nil)
bindInput(Buttons.R_JPAD, nil)
bindInput(Buttons.D_JPAD, nil)

return InputHandler