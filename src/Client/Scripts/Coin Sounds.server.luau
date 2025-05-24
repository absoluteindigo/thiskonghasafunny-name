local Package = require(script.Parent.Parent.Package)
local Tick = require(script.Parent.Parent.Tick)

local Sounds = Package.Sounds
local Util = Package.Util
local ObjectListProcessor = Package.Game.Object.ObjectListProcessor

local LastNumCoins = ObjectListProcessor.gMarioObject and ObjectListProcessor.gMarioObject.NumCoins or 0

local ACT_FLAG_SWIMMING, ACT_FLAG_METAL_WATER = Package.Enums.ActionFlags.SWIMMING, Package.Enums.ActionFlags.METAL_WATER

Tick.AddTickLoop(function()
	local gMarioObject = ObjectListProcessor.gMarioObject
	local NumCoins = gMarioObject.NumCoins
	if LastNumCoins ~= NumCoins then
		if  bit32.band(Util.GlobalTimer, 1) ~= 0 then
			if NumCoins > LastNumCoins then
				LastNumCoins += 1
			else
				LastNumCoins = NumCoins
				return
			end
			local action = gMarioObject.Action()
			
			local coinSound
			
			if bit32.band(action, ACT_FLAG_SWIMMING) ~= 0 or
				bit32.band(action, ACT_FLAG_METAL_WATER) ~= 0 then
				coinSound = Sounds.GENERAL_COIN_WATER
			else
				coinSound = Sounds.GENERAL_COIN
			end
			
			if coinSound then
				coinSound:Play()
			end
		end	
	end
end)