local Types = require("../Types")

type Node = Types.Node

--[=[
    Get the heuristic (estimated cost) from a node to the end node. This is the Manhattan distance.

    @within AStarPathfinding
    @param node Node -- The node to calculate the heuristic for.
    @param endNode Node -- The end node to calculate the heuristic to.
    @return number -- The heuristic value.

    ```lua
    local heuristic = getHeuristic(node, endNode)
    ```
]=]
local function getHeuristic(node: Node, endNode: Node): number
	return math.abs(node.x - endNode.x) + math.abs(node.y - endNode.y)
end

return getHeuristic
