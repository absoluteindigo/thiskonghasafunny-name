-- list of behaviors
local Behaviors = {}

-- to avoid cyclic module dependency issues, a script will register behaviors instead
function Behaviors.Register(behavior)
	for k, v in pairs(behavior) do
		Behaviors[k] = v
	end
end

return Behaviors