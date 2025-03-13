--------------------------------------------------------------------------------
-- AStarPathfinding.spec
-- Unit tests for the A* pathfinding module
-- @Daemon6109 (Matthew Radulovich)
--------------------------------------------------------------------------------

local AStarPathfinding = require("@Project/AStarPathfinding")
local JestGlobals = require("@DevPackages/JestGlobals")

local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it

local Node = AStarPathfinding.Node
local Grid = AStarPathfinding.Grid
local AStar = AStarPathfinding.AStar

local containsNode = AStarPathfinding.containsNode
local getHeuristic = AStarPathfinding.getHeuristic

-- Node Class Tests
describe("Node", function()
	it("creates a node with correct properties", function()
		local node = Node({ x = 5, y = 10, walkable = true })
		expect(node.x).toBe(5)
		expect(node.y).toBe(10)
		expect(node.walkable).toBe(true)
		expect(node.gCost).toBe(0)
		expect(node.hCost).toBe(0)
		expect(node.parent).toBe(nil)
	end)

	it("calculates fCost correctly as gCost + hCost", function()
		local node = Node({ x = 1, y = 1, walkable = true })
		node.gCost = 10
		node.hCost = 20
		expect(node:getFCost()).toBe(30)
	end)
end)

-- Grid Class Tests
describe("Grid", function()
	it("creates a grid with correct dimensions and node properties", function()
		local grid = Grid({ width = 5, height = 5, blockProbability = 0.3 })
		expect(grid.width).toBe(5)
		expect(grid.height).toBe(5)

		for y = 1, grid.height do
			expect(#grid.grid[y]).toBe(5) -- Number of columns in each row
			for x = 1, grid.width do
				local node = grid.grid[y][x]
				expect(node.x).toBe(x)
				expect(node.y).toBe(y)
				expect(type(node.walkable)).toBe("boolean")
			end
		end
	end)

	it("returns correct neighbors for a node", function()
		local grid = Grid({ width = 3, height = 3, blockProbability = 0 })
		-- Make all nodes walkable for a controlled test
		for y = 1, 3 do
			for x = 1, 3 do
				grid.grid[y][x].walkable = true
			end
		end

		local centerNode = grid:getNode(2, 2)
		assert(centerNode, "centerNode is nil")
		local neighbors = grid:getNeighbors(centerNode)
		expect(#neighbors).toBe(8) -- Center node should have 8 neighbors

		-- Expected neighbor coordinates
		local expectedCoords = {
			{ 1, 1 },
			{ 2, 1 },
			{ 3, 1 },
			{ 1, 2 },
			{ 3, 2 },
			{ 1, 3 },
			{ 2, 3 },
			{ 3, 3 },
		}
		for _, coord in expectedCoords do
			local found = false
			for _, neighbor in neighbors do
				if neighbor.x == coord[1] and neighbor.y == coord[2] then
					found = true
					break
				end
			end
			expect(found).toBe(true)
		end

		-- Test with some non-walkable nodes
		grid.grid[1][1].walkable = false -- Top-left
		grid.grid[2][1].walkable = false -- Top-center
		grid.grid[3][1].walkable = false -- Top-right
		neighbors = grid:getNeighbors(centerNode)
		expect(#neighbors).toBe(5) -- Only bottom and side neighbors remain
	end)

	it("retrieves the correct node at given coordinates", function()
		local grid = Grid({ width = 5, height = 5, blockProbability = 0 })
		local node = grid:getNode(3, 4)
		assert(node, "node is nil")
		expect(node.x).toBe(3)
		expect(node.y).toBe(4)

		-- Test out-of-bounds coordinates
		expect(grid:getNode(0, 1)).toBe(nil)
		expect(grid:getNode(1, 0)).toBe(nil)
		expect(grid:getNode(6, 5)).toBe(nil)
		expect(grid:getNode(5, 6)).toBe(nil)
	end)

	it("displays the grid without errors", function()
		local grid = Grid({ width = 3, height = 3, blockProbability = 0 })
		-- Simply call Display and ensure no errors occur
		grid:display()
	end)
end)

-- AStar Class Tests
describe("AStar", function()
	it("finds a path when one exists", function()
		local grid = Grid({ width = 5, height = 5, blockProbability = 0 })
		-- Make all nodes walkable
		for y = 1, 5 do
			for x = 1, 5 do
				grid.grid[y][x].walkable = true
			end
		end

		local astar = AStar({ grid = grid })
		local path = astar:findPath(1, 1, 5, 5)
		assert(path, "path is nil")
		local isGreatThan0 = #path > 0
		expect(isGreatThan0).toBe(true)
		expect(path[1].x).toBe(1)
		expect(path[1].y).toBe(1)
		expect(path[#path].x).toBe(5)
		expect(path[#path].y).toBe(5)

		-- Check that each step is adjacent (including diagonals)
		for i = 1, #path - 1 do
			local dx = math.abs(path[i].x - path[i + 1].x)
			local dy = math.abs(path[i].y - path[i + 1].y)
			expect(dx <= 1 and dy <= 1).toBe(true)
		end
	end)

	it("finds a path around obstacles", function()
		local grid = Grid({ width = 5, height = 5, blockProbability = 0 })
		-- Make all nodes walkable initially
		for y = 1, 5 do
			for x = 1, 5 do
				grid.grid[y][x].walkable = true
			end
		end
		-- Create a vertical wall at x=3 from y=1 to y=4
		grid.grid[1][3].walkable = false
		grid.grid[2][3].walkable = false
		grid.grid[3][3].walkable = false
		grid.grid[4][3].walkable = false

		local astar = AStar({ grid = grid })
		local path = astar:findPath(1, 3, 5, 3)
		assert(path, "path is nil")
		expect(path[1].x).toBe(1)
		expect(path[1].y).toBe(3)
		expect(path[#path].x).toBe(5)
		expect(path[#path].y).toBe(3)

		-- Ensure path avoids non-walkable nodes
		for _, node in path do
			expect(node.walkable).toBe(true)
		end
	end)

	it("returns nil when no path exists", function()
		local grid = Grid({ width = 5, height = 5, blockProbability = 0 })
		-- Make all nodes walkable initially
		for y = 1, 5 do
			for x = 1, 5 do
				grid.grid[y][x].walkable = true
			end
		end
		-- Create a vertical wall at x=3 splitting the grid
		for y = 1, 5 do
			grid.grid[y][3].walkable = false
		end

		local astar = AStar({ grid = grid })
		local path = astar:findPath(1, 1, 5, 1)
		expect(path).toBe(nil)
	end)

	it("returns a single-node path when start and end are the same", function()
		local grid = Grid({ width = 1, height = 1, blockProbability = 0 })
		grid.grid[1][1].walkable = true

		local astar = AStar({ grid = grid })
		local path = astar:findPath(1, 1, 1, 1)
		assert(path, "path is nil")
		expect(#path).toBe(1)
		expect(path[1].x).toBe(1)
		expect(path[1].y).toBe(1)
	end)

	it("correctly checks if a list contains a node", function()
		local grid = Grid({ width = 1, height = 1, blockProbability = 0 })
		local astar = AStar({ grid = grid })
		local node1 = grid:getNode(1, 1)
		assert(node1, "node1 is nil")
		local node2 = Node({ x = 2, y = 2, walkable = true })
		local list = { node1 }

		expect(containsNode(list, node1)).toBe(true)
		expect(containsNode(list, node2)).toBe(false)
	end)

	it("calculates the heuristic correctly using Manhattan distance", function()
		local grid = Grid({ width = 5, height = 5, blockProbability = 0 })
		local astar = AStar({ grid = grid })
		local node1 = grid:getNode(1, 1)
		assert(node1, "node1 is nil")
		local node2 = grid:getNode(3, 4)
		assert(node2, "node2 is nil")

		local heuristic = getHeuristic(node1, node2)
		expect(heuristic).toBe(math.abs(1 - 3) + math.abs(1 - 4)) -- 2 + 3 = 5
	end)
end)
