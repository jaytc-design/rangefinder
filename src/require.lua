local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local function loadModules(parent: Folder, noDescendants: boolean?)
    local Modules = {}

    for _, module in pairs(parent:GetChildren()) do
        if module == script then continue end

        --[[if module:IsA("ModuleScript") then
            Modules[module.Name:lower()] = module
        elseif module:IsA("Folder") then
            if not noDescendants then
                Modules[module.Name:lower()] = loadModules(module)
            end
        end]]

        if module:IsA("Folder") and not noDescendants then
            Modules[module.Name:lower()] = loadModules(module)
        else
            Modules[module.Name:lower()] = module
        end
    end

    return Modules
end

local Merged = {
    packages = loadModules(ReplicatedStorage.Packages, true),
    shared = loadModules(ReplicatedStorage.Shared)
}

if IS_SERVER then
    Merged.server = loadModules(ServerScriptService.Server)
elseif IS_CLIENT then
    Merged.client = loadModules(StarterPlayerScripts.Client)
end

return function(name: string | ModuleScript)
    if typeof(name) == "Instance" and name:IsA("ModuleScript") then
        return require(name)
    end
    assert(type(name) == "string", "Expected string or modulescript for argument #1, got " .. typeof(name))

    name = name:lower()

    local split do
        if name:find("%.") then
            split = name:split(".")
        elseif name:find("/") then
            split = name:split("/")
        else
            split = {name}
        end
    end

    local current = Merged

    for _, child in pairs(split) do
        current = assert(current[child], name .. " is not a valid module.")
    end

    return type(current) == "table" and current or require(current)
end