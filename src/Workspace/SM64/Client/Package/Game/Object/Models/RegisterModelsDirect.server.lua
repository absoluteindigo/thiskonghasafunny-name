-- register models into the models table
-- (this functionality is stored elsewhere to prevent issues with models showing up in workspae)
-- WORSKAPCE
-- WORKSPACE

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Models = require(script.Parent)

require(ReplicatedStorage.Assets.ModelRegister)(Models.Register)