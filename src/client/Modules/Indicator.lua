return function()
    local Part = Instance.new("Part", workspace)

    Part.Anchored = true
    Part.CanCollide = false
    Part.Size = Vector3.one
    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.fromRGB(255, 0, 0)
    Part.Transparency = 0.5
    Part.CastShadow = false

    return Part
end