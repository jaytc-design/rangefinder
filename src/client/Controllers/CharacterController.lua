local ReplicatedStorage = game:GetService("ReplicatedStorage")

local require = require(ReplicatedStorage.Require)

local Player = game:GetService("Players").LocalPlayer

local Knit = require("Packages/Knit")
local Trove = require("Packages/Trove")

local Character = require("Client/Modules/Character")

local ArmController = Knit.CreateController { Name = "ArmController" }

function ArmController:GetUtilities()
    self._trove = Trove.new()
end

function ArmController:InitializeEvents()
    Player.CharacterAdded:Connect(function(char: Model)
        self._trove:Construct(Character, char)
    end)

    Player.CharacterRemoving:Connect(function()
        self._trove:Clean()
    end)
end

function ArmController:KnitStart()
    self:GetUtilities()
    self:InitializeEvents()
    
    if Player.Character then
        self.character =  self._trove:Construct(Character, Player.Character)
    end
end

function ArmController:KnitInit()
    
end

return ArmController