local Helpers = {}

--
local ReferenceHelper = require(script.ReferenceHelper)
Helpers.ReferenceHelper = ReferenceHelper

--
function Helpers.copy(model)
	local newModel = model:Clone()
	newModel.Parent = workspace.SM64.Ignore
	return newModel
end

return Helpers