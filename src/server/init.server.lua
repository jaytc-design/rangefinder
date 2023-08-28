local require = require(game:GetService("ReplicatedStorage").Require)

local Knit = require("Packages/Knit")

for _, service in pairs(require("Server/Services")) do
	require(service)
end

Knit.Start():catch(warn):andThen(function()
	for _, component in pairs(require("Server/Components")) do
		require(component)
	end
end)