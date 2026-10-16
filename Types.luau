export type AStar = {
	grid: Grid,
	openList: Path,
	closedList: Path,
	findPath: (self: AStar, startX: number, startY: number, endX: number, endY: number) -> Path | nil,
}

export type Grid = {
	width: number,
	height: number,
	grid: Node,
	getNeighbors: (self: Grid, node: Node) -> Path,
	getNode: (self: Grid, x: number, y: number) -> Node | nil,
	display: (self: Grid, Path?) -> nil,
}

--[=[
	Path represents a table of neighboring nodes around a given node.

	@within Grid
	@type Path {Node}
]=]
export type Path = { Node }

export type Node = {
	x: number,
	y: number,
	walkable: boolean,
	gCost: number,
	hCost: number,
	parent: Node | nil,
	getFCost: (self: Node) -> number,
}

return {}
