local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local require = require(ReplicatedStorage.Require)

local Trove = require("Packages/Trove")
--local Cone = require("Client/Modules/Cone")
local Ball = require("Client/Modules/Ball")
local Indicator = require("Client/Modules/Indicator")

local rParams = RaycastParams.new()
rParams.FilterType = Enum.RaycastFilterType.Exclude

local Rotation = Vector3.new(0,1,-1).Unit
local r = .5
local max = 10

local VectorMatch = "(-?%d+%.?%d*)%s*,%s*(-?%d+%.?%d*)%s*,%s*(-?%d+%.?%d*)"
local NumberMatch = "%d+%.?%d*"

local Character = {}
Character.__index = Character

function Character.new(obj: Model)
    local self = setmetatable({}, Character)
    
    self._obj = obj
    self._trove = Trove.new()

    self.Part = self._trove:Construct(Indicator)
    --self.Cone = self._trove:Construct(Cone)
    self.Ball = self._trove:Construct(Ball)

    Mouse.TargetFilter = self.Part

    self.HumanoidRootPart = obj:WaitForChild("HumanoidRootPart")

	self._trove:Connect(RunService.Stepped, function(dt)
        local UnitRay = Mouse.UnitRay

        local Hit = self:ComputeHit(UnitRay.Origin, UnitRay.Direction * 1000)
        local Direction = self:ComputeDirection(Hit)

		local pos = self.HumanoidRootPart.CFrame:VectorToWorldSpace(Rotation * max/2)

        self.Part.CFrame = self.HumanoidRootPart.CFrame + Direction
		--self.Cone.CFrame = CFrame.new(self.HumanoidRootPart.Position + pos, self.HumanoidRootPart.Position + 2 * pos) * CFrame.fromEulerAnglesXYZ(math.pi / 2, 0, 0)
        self.Ball.Position = self.HumanoidRootPart.Position + pos * 2
    end)

    self._trove:Connect(obj:WaitForChild("Humanoid").Died, function()
        self:Destroy()
	end)
	
	self._trove:Connect(Player.Chatted, function(msg) 
        local vector = msg:find(VectorMatch)
		local number = tonumber(msg:match(NumberMatch))
		
		if vector then -- Say "number, number, number" in chat to set rotation
            local x, y, z = msg:match(VectorMatch)
            x, y, z = tonumber(x), tonumber(y), tonumber(z)

            if x and y and z then
                Rotation = Vector3.new(x, y, z).Unit
            end

        elseif number then
            if msg:find("^r") then -- Say "r number" in chat to set radius
                r = number
            elseif msg:find("^m") then -- Say "m number" in chat to set max
                max = number
            end
        end

        self:_updateIndicators()
	end)

    self:_updateIndicators()

    return self
end

function Character:ComputeDirection(Hit) -- Credits to Aidan Epperly for this function
    local u = self.HumanoidRootPart.CFrame:VectorToWorldSpace(Rotation).Unit
    local x = (Hit - self.HumanoidRootPart.Position)
    local t = math.min(x:Dot(u), max) -- Hardcap of 10

    local y = if t < 0 then Vector3.zero else x - t * u

    if y.Magnitude > t * r then
        return t * (u + r * y / y.Magnitude)
    else
        return x
    end
end

function Character:ComputeHit(Origin, Direction)
    rParams.FilterDescendantsInstances = {self._obj, self.Ball, self.Part} --  workspace.Cone,

    local result = workspace:Raycast(Origin, Direction, rParams)

    if result then
        return result.Position
    else
        return Origin + Direction
    end
end

function Character:_updateIndicators()
    local d = max * r * 2

    --self.Cone.Size = Vector3.new(d,max,d)
    self.Ball.Size = Vector3.new(d,d,d)
end

function Character:Destroy()
    self._trove:Destroy()

    Mouse.TargetFilter = nil

    self._obj = nil
end

return Character