--------------------------------------------------------------------------------
-- AStarPathfinding
-- A* Algorithm with Node System
-- @Daemon6109 (Matthew Radulovich)
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Types = require("./Types")

-- Types
export type Grid = Types.Grid
export type AStar = Types.AStar
export type NeighboringNodes = Types.NeighboringNodes
export type Node = Types.Node

--@class AstarPathfinding
return {
	version = version,

	-- Classes
	Node = require("./Classes/Node").new,
	Grid = require("./Classes/Grid").new,
	AStar = require("./Classes/AStar").new,

	-- Utils
	containsNode = require("./Utils/containsNode"),
	getHeuristic = require("./Utils/getHeuristic"),
}
