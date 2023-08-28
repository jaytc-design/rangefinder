local require = require(game:GetService("ReplicatedStorage").Require)

local Knit = require("Packages/Knit")

for _, controller in pairs(require("Client/Controllers")) do
	require(controller)
end

Knit.Start({ServicePromises = false}):catch(warn):andThen(function()
	for _, component in pairs(require("Client/Components")) do
		require(component)
	end
end)