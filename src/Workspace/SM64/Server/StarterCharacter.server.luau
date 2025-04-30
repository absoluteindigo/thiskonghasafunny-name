local Players = game:GetService('Players')

local function CreateCharacter(Player: Player)
	local Character = Instance.new('Model', workspace.SM64.Ignore)
	Character.Name = Player.Name

	Player.Character = Character
	Instance.new('Humanoid', Player.Character)
end

Players.CharacterAutoLoads = false

Players.PlayerAdded:Connect(CreateCharacter)

Players.PlayerRemoving:Connect(function(player: Player)
	return player.Character and player.Character:Destroy()
end)