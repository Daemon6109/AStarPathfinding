# AStarPathfinding

A deterministic, shared-realm A* pathfinding library for Roblox and Luau.
It provides a grid, nodes, Manhattan-distance heuristic, and an A* solver with
eight-directional movement.

## Install

```toml
# wally.toml
[dependencies]
AStarPathfinding = "daemon6109/astar-pathfinding@1.1.6"
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
`wally.toml` and `src/init.luau` to the same next semantic
version before publishing.

## License

[MIT](LICENSE)

## roblox-ts (npm or Bun)

The repository includes an **unpublished** package named
`@rbxts/astar-pathfinding`. Do not assume it is available from the npm registry.
Install directly from the public GitHub repository, without npm scope access or a registry token:

```sh
npm install github:Daemon6109/AStarPathfinding
# or
bun add github:Daemon6109/AStarPathfinding
```

Pin a commit by appending `#<commit-sha>` to the GitHub specifier. For a local
checkout, `npm pack` also creates an installable `.tgz`. The package has no
install-time build scripts or runtime npm dependencies.

Use a standard roblox-ts Rojo project mapping `rbxts_include/node_modules/@rbxts`
to `node_modules/@rbxts`. For example, within `rbxts_include`:

```json
"node_modules": {
  "$className": "Folder",
  "@rbxts": { "$path": "node_modules/@rbxts" }
}
```

```ts
import { Grid, AStar } from "@rbxts/astar-pathfinding";

const grid = Grid({ width: 16, height: 16, blockProbability: 0 });
const obstacle = grid.getNode(8, 8);
if (obstacle !== undefined) obstacle.walkable = false;
const path = AStar({ grid }).findPath(1, 1, 16, 16);
if (path !== undefined) {
    for (const node of path) print(node.x, node.y);
}
```

Coordinates are **one-based**, including `getNode` and `findPath`; returned
paths are ordinary roblox-ts arrays, whose TypeScript indexes are zero-based.
Both endpoints must be walkable; an unreachable route returns `undefined`.
Movement includes diagonals (including through corners). The solver uses a
Manhattan heuristic and stops after 2,000 iterations, so it does not promise an
optimal or complete route on every grid. `blockProbability` is required and is
passed directly to the existing Luau implementation. For a `Vector2` position,
pass `position.X, position.Y` explicitly; no Vector2 overload is provided.

The runtime in `rbxts/runtime` is generated from the original Luau source with
Rojo and Darklua; regenerate it with `bash scripts/build-rbxts.sh` after source
changes and commit the result. It only rewrites module paths for Roblox; the
original Wally/Luau API is unchanged. To verify locally, run `npm install` and
`npx rbxtsc` in `tests/rbxts`, then from the repository root run
`lune run tests/compiled-consumer.luau`. This Lune test mocks Roblox module
boundaries; it is not a Studio test.
