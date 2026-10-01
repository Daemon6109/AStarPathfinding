# AStarPathfinding

A deterministic, shared-realm A* pathfinding library for Roblox and Luau.
It provides a grid, nodes, Manhattan-distance heuristic, and an A* solver with
eight-directional movement.

## Install

```toml
# wally.toml
[dependencies]
AStarPathfinding = "daemon6109/astar-pathfinding@1.1.1"
```

Then run:

```sh
wally install
```

## Use

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local AStarPathfinding = require(Packages:WaitForChild("AStarPathfinding"))

local grid = AStarPathfinding.Grid({
	width = 16,
	height = 16,
	blockProbability = 0,
})

-- Mark terrain as blocked when needed.
grid:getNode(8, 8).walkable = false

local solver = AStarPathfinding.AStar({ grid = grid })
local path = solver:findPath(1, 1, 16, 16)

if path then
	for _, node in path do
		print(node.x, node.y)
	end
end
```

Coordinates are one-indexed. `findPath` returns `nil` when either endpoint is
blocked/out of bounds or no route exists.

## Development

```sh
bash scripts/test.sh
```

## Publishing

The package archive is intentionally limited to the runtime module, this
README, and the MIT license. Before publishing a new version:

```sh
wally manifest-to-json
wally package --list
wally publish
```

Versions are immutable in the public Wally registry. Update both
`wally.toml` and `src/AStarPathfinding/init.luau` to the same next semantic
version before publishing.

## License

[MIT](LICENSE)
