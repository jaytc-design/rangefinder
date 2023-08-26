local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Loader = require(ReplicatedStorage.Packages.loader)

Loader.LoadDescendants(ServerScriptService.Server, function(moduleScript)
	return moduleScript.Name:match("Service$") ~= nil
end)