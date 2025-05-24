-- run loops on ticks or every frame

local TickClass = {}

local Tick = {}
Tick.__index = Tick
function Tick.new(array, callback)
	local self = setmetatable({
		array = array,
		callback = callback,
	}, Tick)
	
	table.insert(array, callback)
	
	return self
end
function Tick:Destroy()
	table.remove(self.array, table.find(self.array, self.callback))
	self = nil
end
--

local TickArray, UpdateArray = {}, {}
TickClass.TickArray, TickClass.UpdateArray = TickArray, UpdateArray

-- HELPERS
local function RunTable(array, ...)
	for k, callback in pairs(array) do
		callback(...)
	end	
end

-- MAIN
function TickClass.AddTickLoop(callback)
	return Tick.new(TickArray, callback)
end
function TickClass.AddUpdateLoop(callback: (dt: number, subframe: number)-> any?)
	return Tick.new(UpdateArray, callback)
end

function TickClass.Tick()
	RunTable(TickArray)
end

function TickClass.Update(dt: number, subframe: number)
	RunTable(UpdateArray, dt, subframe)
end

return TickClass