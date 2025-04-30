-- based off of https://github.com/sm64js/sm64js/blob/04c1a984117ebb8d0e7b0d5d2e3424367f69b92d/src/include/model_ids.js#L453
-- but mostly custom (hooray for modern game engines!)
local PLACEHOLDER_MODEL = game:GetService('ReplicatedStorage').Assets.PLACEHOLDER

local Models = {
	NONE = false,
}

local Placeholders = {}

local function newPlaceholder(key)
	if Placeholders[key] then return Placeholders[key] end
	
	local class = {
		Name = key,
		Model = PLACEHOLDER_MODEL,
	}
	class.__index = class
	
	Placeholders[key] = class
	
	function class:New(Model)
		Model.MODELKEY = key
		
		local newModel = self.Model:Clone()
		newModel.Parent = workspace.SM64.Ignore
		
		return newModel, class
	end
	
	function class:Update()
		local realModel = rawget(Models, self.MODELKEY)
		if realModel then
			self.Link.Model:SetModel(realModel)
		end
	end
	
	function class:Destroy()
		self.MODELKEY = nil
	end
end

function Models:__index(key)
	if rawget(Models, key) then
		print('cool')
		return rawget(Models, key)
	end
	warn(`Models.{key} does not exist!`)
	return newPlaceholder(key)-- rawget(Models, 'PLACEHOLDER')
end

function Models.Register(inst: Instance, key)
	Placeholders[key] = nil
	if inst:IsA('ModuleScript') then
		local model = require(inst)
		key = key or model.Name or inst.Name
		Models[key] = model
		-- print('registered advanced model', key)
	else
		if Models[inst.Name] then
			warn('Multiple models with the name ', inst.Name)
			return
		end
		--
		local model = {}
		
		model.Name = inst.Name
		model.Model = inst
		
		--[[function model:New()
			local newModel = self.Model:Clone()
			newModel.Parent = workspace.SM64.Ignore
			return newModel
		end]]
		
		key = key or model.Name
		Models[key] = model
		print('registered basic model', key)
	end
end

setmetatable(Models, Models)

local registerModels = script:FindFirstChildOfClass('Script')
if registerModels then
	registerModels.Enabled = true
end

return Models