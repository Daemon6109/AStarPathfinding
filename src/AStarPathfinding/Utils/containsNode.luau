local Types = require("../Types")

type NeighboringNodes = Types.NeighboringNodes
type Node = Types.Node

--[=[
    Check if a list of nodes contains a specific node.

    @within AstarPathfinding
    @param list NeighboringNodes -- The list of nodes to check.
    @param node Node -- The node to check for.
    @return boolean -- Whether the list contains the node.

    ```lua
    local contains = containsNode(list, node)
    ```
]=]
local function containsNode(list: NeighboringNodes, node: Node): boolean
	for _, n in list do
		if n == node then
			return true
		end
	end
	return false
end

return containsNode
