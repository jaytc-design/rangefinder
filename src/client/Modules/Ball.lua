return function()
    local ball = Instance.new("Part", workspace)
    
    ball.CanCollide = false
    ball.Transparency = .8
    ball.Material = Enum.Material.Neon
    ball.Anchored = true
    ball.Shape = Enum.PartType.Ball
    ball.CastShadow = false

    return ball
end