local Cone = game:GetService("ReplicatedStorage").Assets:WaitForChild("Cone")

return function()
    local cone = Cone:Clone()
    
    cone.Parent = workspace

    return cone
end