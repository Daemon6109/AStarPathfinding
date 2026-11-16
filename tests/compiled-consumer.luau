local fs = require("@lune/fs")
local luau = require("@lune/luau")
local base = "tests/rbxts/node_modules/@rbxts/astar-pathfinding/rbxts/runtime/"
local root = { path = base .. "init.luau" }
root.Classes = { Parent = root }
root.Utils = { Parent = root }
root.Types = { Parent = root, path = base .. "Types.luau" }
for _, name in { "Node", "Grid", "AStar" } do
 root.Classes[name] = { Parent = root.Classes, path = base .. "Classes/" .. name .. ".luau" }
end
for _, name in { "containsNode", "getHeuristic" } do
 root.Utils[name] = { Parent = root.Utils, path = base .. "Utils/" .. name .. ".luau" }
end
local cache = {}
local loadModule
loadModule = function(module)
 if cache[module] then return cache[module] end
 local env = setmetatable({ script = module, require = loadModule }, { __index = getfenv() })
 local fn = luau.load(fs.readFile(module.path), { environment = env, debugName = module.path })
 local result = fn()
 cache[module] = result
 return result
end
local runtime = { import = function() return loadModule(root) end }
local service = {}
function service:WaitForChild() return self end
local gameMock = {}
function gameMock:GetService() return service end
local env = setmetatable({ script = {}, game = gameMock, require = function() return runtime end }, { __index = getfenv() })
local consumer = luau.load(fs.readFile("tests/rbxts/out/main.luau"), { environment = env, debugName = "compiled consumer" })
consumer()
print("compiled consumer and packaged Luau runtime: PASS (mock Roblox boundaries)")
