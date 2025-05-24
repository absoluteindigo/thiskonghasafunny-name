-- local Models = {}

local ModelFolder = script.Models
--[[Models.GOOMBA = ModelFolder.GOOMBA
Models.YELLOW_COIN = ModelFolder.YELLOW_COIN
Models.YELLOW_COIN_NO_SHADOW = ModelFolder.YELLOW_COIN_NO_SHADOW]]

return function(Register)
	local _reg = Register
	function Register(...)
		task.spawn(_reg, ...)
	end
	
	for _, model in pairs(ModelFolder:GetChildren()) do
		Register(model, model.Name)
	end
	ModelFolder.ChildAdded:Connect(function(model)
		Register(model, model.Name)
	end)
	Register(script.Parent.PLACEHOLDER, 'PLACEHOLDER')
end