local Helpers = require(script.Parent.Parent.Helpers)

local Shadow = require(game:GetService('ReplicatedStorage'):WaitForChild('Assets'):WaitForChild('Shadow'))

local class = {
	Name = false,
	Model = false,
	colors = {
		yellow = Color3.new(1, 1, 0),
		blue = Color3.fromRGB(120, 120, 255),
		red = Color3.new(1, 0, 0),
	}
}
class.__index = class

local custom = {}
custom.__index = custom

function class:New(ModelClass, MODEL)
	-- local newModel = Helpers.copy(self.Model)

	local newModel = Helpers.copy(MODEL) :: Model
	ModelClass.shadow = Shadow.new(5.7)

	return newModel, custom
end

function custom:Update()
	local shadow = self.shadow

	local wasHidden = self.shadowHidden
	local isHidden = self._lastHidden ~= nil
	if wasHidden ~= isHidden then
		self.shadowHidden = isHidden
		if shadow then
			shadow:setVisible(isHidden)
		end
	end
	--
	if not isHidden then

		-- update shadow
		local renderedCF = self.renderedCF or self.goalCF :: CFrame
		local pos = renderedCF.Position

		self.shadow:update(
			Vector3.new(pos.X, pos.Y + 2.793, pos.Z)
		)
	end
end

function custom:Destroy()
	if self.shadow then
		self.shadow:destroy()
	end
	self.shadow = nil
end

return class