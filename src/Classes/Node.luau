local Types = require("../Types")

type Node = Types.Node

--[=[
    A Node represents a single tile in the grid. It contains information about its position, walkability, and cost for pathfinding.
    @class Node
]=]
local Node = {}
Node.__index = Node

type NodeInternal = {
	x: number,
	y: number,
	walkable: boolean,
	gCost: number,
	hCost: number,
	parent: Node | nil,
}

--[=[
    Props for creating a new Node.

    @within Node
    @interface NodeProps
    .x number -- The x-coordinate of the node.
    .y number -- The y-coordinate of the node.
    .walkable boolean -- Whether the node is walkable or not.
]=]
type NodeProps = {
	x: number,
	y: number,
	walkable: boolean,
}

--[=[
    Create a new Node with the given properties.

    @within Node
    @param props NodeProps -- The properties for the new Node.
    @return Node -- The new Node instance.

    ```lua
    local node = Node.new({
        x = 1,
        y = 1,
        walkable = true,
    })
    ```
]=]
function Node.new(props: NodeProps): Node
	local self = setmetatable({}, Node)
	self.x = props.x
	self.y = props.y
	self.walkable = props.walkable
	self.gCost = 0 -- Cost from start
	self.hCost = 0 -- Heuristic (estimated cost to end)
	self.parent = nil -- Parent node for pathfinding
	return (self :: any) :: Node
end

--[=[
    Get the F cost of the node (G cost + H cost).

    @method getFCost
    @within Node
    @return number

    ```lua
    local fCost = node:getFCost()
    ```
]=]
function Node.getFCost(self: NodeInternal): number
	return self.gCost + self.hCost
end

return Node
