/** A node's coordinates use the library's one-based grid convention. */
export interface Node {
 x: number; y: number; walkable: boolean;
 gCost: number; hCost: number; parent: Node | undefined;
 getFCost(): number;
}
export type Path = Node[];
export interface Grid {
 width: number; height: number;
 /** Rows are keyed by one-based y, then one-based x. */
 grid: Map<number, Map<number, Node>>;
 getNode(x: number, y: number): Node | undefined;
 getNeighbors(node: Node): Path;
 display(path?: Path): void;
}
export interface AStar {
 grid: Grid; openList: Path; closedList: Path;
 findPath(startX: number, startY: number, endX: number, endY: number): Path | undefined;
}
export interface NodeProps { x: number; y: number; walkable: boolean }
export interface GridProps { width: number; height: number; blockProbability: number }
export interface AStarProps { grid: Grid }
export declare const version: { major: number; minor: number; patch: number };
export declare function Node(props: NodeProps): Node;
export declare function Grid(props: GridProps): Grid;
export declare function AStar(props: AStarProps): AStar;
export declare function containsNode(list: Path, node: Node): boolean;
export declare function getHeuristic(node: Node, endNode: Node): number;
