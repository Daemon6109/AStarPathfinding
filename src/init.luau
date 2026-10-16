--------------------------------------------------------------------------------
-- AStarPathfinding
-- A* Algorithm with Node System
-- @Daemon6109 (Matthew Radulovich)
--------------------------------------------------------------------------------

local version = { major = 1, minor = 1, patch = 8 }

local Types = require("@self/Types")

-- Types
export type Grid = Types.Grid
export type AStar = Types.AStar
export type Path = Types.Path
export type Node = Types.Node

--[=[
	@class AStarPathfinding
]=]
return {
	version = version,

	-- Classes
	Node = require("@self/Classes/Node").new,
	Grid = require("@self/Classes/Grid").new,
	AStar = require("@self/Classes/AStar").new,

	-- Utils
	containsNode = require("@self/Utils/containsNode"),
	getHeuristic = require("@self/Utils/getHeuristic"),
}
