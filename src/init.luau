--!strict
-- Deterministic, self-contained grid A* implementation.
-- Keep the runtime in this one module: Wally/Rojo consumers can require the
-- package entry point without relying on package-child synchronization.

local version = { major = 1, minor = 1, patch = 7 }

export type Node = {
	x: number,
	y: number,
	walkable: boolean,
	gCost: number,
	hCost: number,
	parent: Node?,
	getFCost: (self: Node) -> number,
}

export type Path = { Node }

export type Grid = {
	width: number,
	height: number,
	grid: { { Node } },
	getNeighbors: (self: Grid, node: Node) -> Path,
	getNode: (self: Grid, x: number, y: number) -> Node?,
	display: (self: Grid, path: Path?) -> (),
}

export type AStar = {
	grid: Grid,
	openList: Path,
	closedList: Path,
	findPath: (self: AStar, startX: number, startY: number, endX: number, endY: number) -> Path?,
}

type NodeProps = { x: number, y: number, walkable: boolean }
type GridProps = { width: number, height: number, blockProbability: number }
type AStarProps = { grid: Grid }

local Node = {}
Node.__index = Node

function Node.new(props: NodeProps): Node
	return setmetatable({
		x = props.x,
		y = props.y,
		walkable = props.walkable,
		gCost = 0,
		hCost = 0,
		parent = nil,
	}, Node) :: any
end

function Node.getFCost(self: Node): number
	return self.gCost + self.hCost
end

local function containsNode(list: Path, node: Node): boolean
	for _, candidate in list do
		if candidate == node then
			return true
		end
	end
	return false
end

local function getHeuristic(node: Node, endNode: Node): number
	return math.abs(node.x - endNode.x) + math.abs(node.y - endNode.y)
end

local Grid = {}
Grid.__index = Grid

function Grid.new(props: GridProps): Grid
	assert(props.width > 0 and props.height > 0, "Grid dimensions must be positive")
	assert(props.blockProbability >= 0 and props.blockProbability <= 1, "blockProbability must be between 0 and 1")

	local grid = {} :: { { Node } }
	for y = 1, props.height do
		grid[y] = {}
		for x = 1, props.width do
			grid[y][x] = Node.new({ x = x, y = y, walkable = math.random() > props.blockProbability })
		end
	end

	return setmetatable({ width = props.width, height = props.height, grid = grid }, Grid) :: any
end

function Grid.getNode(self: Grid, x: number, y: number): Node?
	return self.grid[y] and self.grid[y][x] or nil
end

function Grid.getNeighbors(self: Grid, node: Node): Path
	local neighbors = {} :: Path
	for _, direction in {
		{ 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, 0 },
		{ 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 },
	} do
		local neighbor = self:getNode(node.x + direction[1], node.y + direction[2])
		if neighbor and neighbor.walkable then
			table.insert(neighbors, neighbor)
		end
	end
	return neighbors
end

function Grid.display(self: Grid, path: Path?)
	for y = 1, self.height do
		local row = ""
		for x = 1, self.width do
			local node = self:getNode(x, y)
			row ..= if path and node and containsNode(path, node) then "*" elseif node and node.walkable then "." else "#"
		end
		print(row)
	end
end

local AStar = {}
AStar.__index = AStar

function AStar.new(props: AStarProps): AStar
	return setmetatable({ grid = props.grid, openList = {}, closedList = {} }, AStar) :: any
end

function AStar.findPath(self: AStar, startX: number, startY: number, endX: number, endY: number): Path?
	local startNode = self.grid:getNode(startX, startY)
	local endNode = self.grid:getNode(endX, endY)
	if not startNode or not endNode or not startNode.walkable or not endNode.walkable then
		return nil
	end

	self.openList = { startNode }
	self.closedList = {}
	startNode.gCost = 0
	startNode.hCost = getHeuristic(startNode, endNode)
	startNode.parent = nil

	while #self.openList > 0 do
		local lowestIndex = 1
		for index = 2, #self.openList do
			local candidate = self.openList[index]
			local current = self.openList[lowestIndex]
			if candidate:getFCost() < current:getFCost()
				or (candidate:getFCost() == current:getFCost() and candidate.hCost < current.hCost) then
				lowestIndex = index
			end
		end

		local current = table.remove(self.openList, lowestIndex) :: Node
		table.insert(self.closedList, current)
		if current == endNode then
			local path = {} :: Path
			while current do
				table.insert(path, 1, current)
				current = current.parent :: any
			end
			return path
		end

		for _, neighbor in self.grid:getNeighbors(current) do
			if not containsNode(self.closedList, neighbor) then
				local tentativeGCost = current.gCost + 1
				if not containsNode(self.openList, neighbor) or tentativeGCost < neighbor.gCost then
					neighbor.gCost = tentativeGCost
					neighbor.hCost = getHeuristic(neighbor, endNode)
					neighbor.parent = current
					if not containsNode(self.openList, neighbor) then
						table.insert(self.openList, neighbor)
					end
				end
			end
		end
	end

	return nil
end

return {
	version = version,
	Node = Node,
	Grid = Grid,
	AStar = AStar,
	containsNode = containsNode,
	getHeuristic = getHeuristic,
}
