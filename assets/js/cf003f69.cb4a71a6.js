"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[476],{559:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Create a new AStar instance with the given properties.\\n\\n\\n```lua\\nlocal astar = AStar.new({\\n    grid = grid,\\n})\\n```","params":[{"name":"props","desc":"The properties for the new AStar instance.","lua_type":"AStarProps"}],"returns":[{"desc":"The new AStar instance.","lua_type":"AStar"}],"function_type":"static","source":{"line":48,"path":"src/Classes/AStar.luau"}},{"name":"findPath","desc":"Find a path from the start coordinates to the end coordinates using the A* algorithm.\\n\\n\\n```lua\\nlocal path = astar:findPath(1, 1, 10, 10)\\n```","params":[{"name":"startX","desc":"The x-coordinate of the start node.","lua_type":"number"},{"name":"startY","desc":"The y-coordinate of the start node.","lua_type":"number"},{"name":"endX","desc":"The x-coordinate of the end node.","lua_type":"number"},{"name":"endY","desc":"The y-coordinate of the end node.","lua_type":"number"}],"returns":[{"desc":"A table of nodes representing the path, or nil if no path was found.","lua_type":"NeighboringNodes | nil"}],"function_type":"method","source":{"line":71,"path":"src/Classes/AStar.luau"}}],"properties":[],"types":[{"name":"AStarProps","desc":"Props for creating a new AStar instance.","fields":[{"name":"grid","lua_type":"Grid","desc":"The grid to perform pathfinding on."}],"source":{"line":31,"path":"src/Classes/AStar.luau"}}],"name":"AStar","desc":"AStar represents an A* pathfinding algorithm that operates on a grid of nodes.","source":{"line":15,"path":"src/Classes/AStar.luau"}}')}}]);