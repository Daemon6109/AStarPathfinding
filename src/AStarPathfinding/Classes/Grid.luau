local Node = require("./Node")
local Types = require("../Types")

type Grid = Types.Grid
type NeighboringNodes = Types.NeighboringNodes
type Node = Types.Node

--[=[
    A Grid represents a 2D grid of nodes. It contains information about the grid size and the nodes themselves.
    @class Grid
]=]
local Grid = {}
Grid.__index = Grid

type GridInternal = {
	width: number,
	height: number,
	grid: Node,
}

--[=[
    Props for creating a new Grid.

    @within Grid
    @interface GridProps
    .width number -- The width of the grid.
    .height number -- The height of the grid.
    .blockProbability number -- The probability of a node being non-walkable (0-1).
]=]
type GridProps = {
	width: number,
	height: number,
	blockProbability: number,
}

--[=[
    Create a new Grid with the given properties.

    @within Grid
    @param props GridProps -- The properties for the new Grid.
    @return Grid -- The new Grid instance.

    ```lua
    local grid = Grid.new({
        width = 10,
        height = 10,
        blockProbability = 0.3,
    })
    ```
]=]
function Grid.new(props: GridProps): Grid
	local self = setmetatable({}, Grid)
	self.width = props.width
	self.height = props.height
	self.grid = {}

	-- Initialize grid with nodes, randomly marking some as non-walkable
	for y = 1, self.height do
		self.grid[y] = {}
		for x = 1, self.width do
			local walkable = math.random() > props.blockProbability
			self.grid[y][x] = Node.new({ ["x"] = x, ["y"] = y, ["walkable"] = walkable })
		end
	end

	return (self :: any) :: Grid
end

--[=[
    Get the neighbors of a given node. This includes the nodes above, below, left, right, and diagonally adjacent to the node.

    @method getNeighbors
    @within Grid
    @param node Node -- The node to get neighbors for.
    @return NeighboringNodes -- A table of neighboring nodes.

    ```lua
    local neighbors = grid:getNeighbors(node)
    ```
]=]
function Grid.getNeighbors(self: GridInternal, node: Node): NeighboringNodes
	local neighbors = {}
	local directions = {
		{ 0, 1 }, -- Up
		{ 1, 0 }, -- Right
		{ 0, -1 }, -- Down
		{ -1, 0 }, -- Left
		{ 1, 1 }, -- Up-Right (Diagonal)
		{ 1, -1 }, -- Down-Right (Diagonal)
		{ -1, 1 }, -- Up-Left (Diagonal)
		{ -1, -1 }, -- Down-Left (Diagonal)
	}

	for _, dir in directions do
		local nx, ny = node.x + dir[1], node.y + dir[2]
		if nx >= 1 and nx <= self.width and ny >= 1 and ny <= self.height then
			local neighbor = self.grid[ny][nx]
			if neighbor.walkable then
				table.insert(neighbors, neighbor)
			end
		end
	end
	return neighbors
end

--[=[
    Get the node at the given coordinates in the grid.

    @method getNode
    @within Grid
    @param x number -- The x-coordinate of the node.
    @param y number -- The y-coordinate of the node.
    @return Node | nil -- The node at the given coordinates, or nil if it does not exist.

    ```lua
    local node = grid:getNode(1, 1)
    ```
]=]
function Grid.getNode(self: GridInternal, x: number, y: number): Node | nil
	return self.grid[y] and self.grid[y][x] or nil
end

--[=[
    Display the grid in the console. Walkable nodes are represented by a period (.) and non-walkable nodes are represented by a hash (#).

    @method display
    @within Grid

    ```lua
    grid:display()
    ```
]=]
function Grid.display(self: GridInternal)
	for y = 1, self.height do
		local row = ""
		for x = 1, self.width do
			if self.grid[y][x].walkable then
				row = row .. "."
			else
				row = row .. "#"
			end
		end
		print(row)
	end
end

return Grid
