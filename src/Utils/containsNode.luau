local Types = require("../Types")

type Node = Types.Node
type Path = Types.Path

--[=[
    Check if a list of nodes contains a specific node.

    @within AStarPathfinding
    @param list Path -- The list of nodes to check.
    @param node Node -- The node to check for.
    @return boolean -- Whether the list contains the node.

    ```lua
    local contains = containsNode(list, node)
    ```
]=]
local function containsNode(list: Path, node: Node): boolean
	for _, n in list do
		if n == node then
			return true
		end
	end
	return false
end

return containsNode
