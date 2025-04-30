local Helpers = require(script.Parent)
local ObjectListProcessor = require(script.Parent.Parent.ObjectListProcessor)

local TIME_STOP_ENABLED = ObjectListProcessor.TIME_STOP_ENABLED

for k, f in pairs({
	Cenable_time_stop = function()
		ObjectListProcessor.gTimeStopState = bit32.bor(ObjectListProcessor.gTimeStopState, TIME_STOP_ENABLED)
	end,
	Cdisable_time_stop = function()
		ObjectListProcessor.gTimeStopState = bit32.band(ObjectListProcessor.gTimeStopState, bit32.bnot(TIME_STOP_ENABLED))
	end,
	Cset_time_stop_flags = function(flags)
		ObjectListProcessor.gTimeStopState = bit32.bor(ObjectListProcessor.gTimeStopState, flags)
	end,
	Cclear_time_stop_flags = function(flags)
		ObjectListProcessor.gTimeStopState = bit32.band(ObjectListProcessor.gTimeStopState, bit32.bnot(flags))
	end,
	}) do
	rawset(Helpers, k, f)
end