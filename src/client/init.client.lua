local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local Loader = require(ReplicatedStorage.Packages.loader)

Loader.LoadDescendants(StarterPlayerScripts.Client, function(moduleScript)
	return moduleScript.Name:match("Controller$") ~= nil
end)