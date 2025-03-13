local Types = require("../Types")

type AStar = Types.AStar
type Grid = Types.Grid
type Node = Types.Node

local containsNode = require("../Utils/containsNode")
local getHeuristic = require("../Utils/getHeuristic")

--[=[
    AStar represents an A* pathfinding algorithm that operates on a grid of nodes.
    @class AStar
]=]
local AStar = {}
AStar.__index = AStar

type AStarInternal = {
	grid: Grid,
	openList: { Node },
	closedList: { Node },
}

--[=[
    Props for creating a new AStar instance.

    @within AStar
    @interface AStarProps
    .grid Grid -- The grid to perform pathfinding on.
]=]
type AStarProps = {
	grid: Grid,
}

--[=[
    Create a new AStar instance with the given properties.

    @within AStar
    @param props AStarProps -- The properties for the new AStar instance.
    @return AStar -- The new AStar instance.

    ```lua
    local astar = AStar.new({
        grid = grid,
    })
    ```
]=]
function AStar.new(props: AStarProps): AStar
	local self = setmetatable({}, AStar)
	self.grid = props.grid
	self.openList = {}
	self.closedList = {}
	return (self :: any) :: AStar
end

--[=[
    Find a path from the start coordinates to the end coordinates using the A* algorithm.

    @method findPath
    @within AStar
    @param startX number -- The x-coordinate of the start node.
    @param startY number -- The y-coordinate of the start node.
    @param endX number -- The x-coordinate of the end node.
    @param endY number -- The y-coordinate of the end node.
    @return {Node} | nil -- A table of nodes representing the path, or nil if no path was found.

    ```lua
    local path = astar:findPath(1, 1, 10, 10)
    ```
]=]
function AStar.findPath(self: AStarInternal, startX: number, startY: number, endX: number, endY: number): { Node } | nil
	local startNode = self.grid:getNode(startX, startY)
	local endNode = self.grid:getNode(endX, endY)

	if not startNode or not endNode or not startNode.walkable or not endNode.walkable then
		return nil -- No valid start or end node
	end

	table.insert(self.openList, startNode)

	while #self.openList > 0 do
		-- Get the node with the lowest fCost
		local currentNode = table.remove(self.openList, 1)
		if not currentNode then -- If there is no current node, (This is primarily for type solver)
			break
		end
		for _, node in self.openList do
			if
				node:getFCost() < currentNode:getFCost()
				or (node:getFCost() == currentNode:getFCost() and node.hCost < currentNode.hCost)
			then
				currentNode = node
			end
		end

		table.insert(self.closedList, currentNode)

		-- If we reached the end node, reconstruct the path
		if currentNode == endNode then
			local path = {}
			local current = currentNode
			while current do
				table.insert(path, 1, current)
				current = current.parent
			end
			return path
		end

		-- Process neighbors
		local neighbors = self.grid:getNeighbors(currentNode)
		for _, neighbor in neighbors do
			if not containsNode(self.closedList, neighbor) then
				local tentativeGCost = currentNode.gCost + 1
				if not containsNode(self.openList, neighbor) or tentativeGCost < neighbor.gCost then
					neighbor.gCost = tentativeGCost
					neighbor.hCost = getHeuristic(neighbor, endNode)
					neighbor.parent = currentNode

					if not containsNode(self.openList, neighbor) then
						table.insert(self.openList, neighbor)
					end
				end
			end
		end
	end

	return nil -- No path found
end

return AStar
