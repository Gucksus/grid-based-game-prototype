extends Node

var state_grid: Dictionary[Vector2i, Cell] = {}
var main_map: CustomTileMap
var highlight_map : HighlightMap
var NEXT_POS_SPIN: Dictionary[Vector2i, Vector2i] = {
	Vector2i(0, -1): Vector2i(1, 0),
	Vector2i(1, 0): Vector2i(0, 1),
	Vector2i(0, 1): Vector2i(-1 ,0),
	Vector2i(-1, 0): Vector2i(0, -1)
}
const INT_INF = 9223372036854775807


# Initialize the grid from the game script.
func init_grid(main_map: CustomTileMap) -> void:
	self.main_map = main_map
	highlight_map = HighlightMap.new()
	get_tree().current_scene.get_child(0).add_child(highlight_map)

func map_to_local(value: Vector2i) -> Vector2:
	return main_map.map_to_local(value)
	
func local_to_map(value: Vector2i) -> Vector2i:
	return main_map.local_to_map(value)

# Returns the first walkable tile.
func first_walkable_tile() -> Vector2i:
	for tile_pos in state_grid:
		if state_grid[tile_pos].walkable:
			return tile_pos
	return Vector2i.ZERO

# Builds the state grid from the given tile map at initialization.
func build_from_tilemap() -> void:
	var grid_size := main_map.get_grid_size()
	for y in grid_size.y:
		for x in grid_size.x:
			var pos := Vector2i(x, y)
			if main_map.get_cell_tile_data(pos):
				state_grid[pos] = Cell.new(main_map, pos)

func is_walkable(pos: Vector2i) -> bool:
	return false if not state_grid.has(pos) else state_grid[pos].walkable

func is_spinnable(pos: Vector2i) -> bool:
	return false if not state_grid.has(pos) else state_grid[pos].type == "spin_pivot"

func update_state_onto_main_map() -> void:
	main_map.clear()
	highlight_map.clear()
	print(state_grid.size())
	for cell_pos in state_grid:
		main_map.set_cell(cell_pos, state_grid[cell_pos].source_id, state_grid[cell_pos].atlas_coords, state_grid[cell_pos].alternative_source_id)
		if state_grid[cell_pos].is_being_chose:
			highlight_map.highlight_tile(cell_pos)

func init_spin(pivot_pos: Vector2i) -> void:
	for pos in neighboring_cell_position(pivot_pos):
		state_grid[pos].is_being_chose = true
	update_state_onto_main_map()

func move_cell(src: Vector2i, des: Vector2i):
	state_grid[des] = state_grid[src]
	state_grid.erase(src)
	if state_grid[des].occupant:
		state_grid[des].occupant.move_to(des)

func spin_tile(pivot: Vector2i) -> void:
	var neigboring_cell_position := neighboring_cell_position(pivot)
	var last_neighbor_placeholder := state_grid[neigboring_cell_position.back()]
	state_grid.erase(neigboring_cell_position.back())
	for i in range(neigboring_cell_position.size() - 2, -1, -1):
		move_cell(neigboring_cell_position[i], NEXT_POS_SPIN[neigboring_cell_position[i] - pivot] + pivot)
	#This part is basically like move_cell but without erasing the source tile.
	var des := NEXT_POS_SPIN[neigboring_cell_position.back() - pivot] + pivot
	state_grid[des] = last_neighbor_placeholder
	if state_grid[des].occupant:
		state_grid[des].occupant.move_to(des)
	update_state_onto_main_map()

func clear_spin(pivot_pos: Vector2i) -> void:
	for pos in neighboring_cell_position(pivot_pos):
		state_grid[pos].is_being_chose = false
	update_state_onto_main_map()

func neighboring_cell_position(src: Vector2i) -> Array[Vector2i]:
	var neighboring_cell_position: Array[Vector2i] = []
	var neighboring_cell_direction := [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]
	for direction in neighboring_cell_direction:
		if is_walkable(src + direction):
			neighboring_cell_position.push_back(src + direction)
	return neighboring_cell_position

func the_distance_between_2_tiles(src: Vector2i, des: Vector2i):
	var queue: Array = []
	var visited: Dictionary[Vector2i, bool] = {}
	var distance: Dictionary[Vector2i, int] = {}

	for tile_pos in state_grid:
		visited[tile_pos] = false
		distance[tile_pos] = 0
	visited[src] = true
	queue.push_back(src)

	while not queue.is_empty() and not visited[des]:
		var current_cell = queue.pop_front()
		var current_neighbor_cell = neighboring_cell_position(current_cell)
		for cell_pos in current_neighbor_cell:
			if visited[cell_pos]:
				continue
			visited[cell_pos] = true
			distance[cell_pos] = distance[current_cell] + 1
			queue.push_back(cell_pos)

	if visited[des]:
		return distance[des]
	else:
		return INT_INF

func reset() -> void:
	main_map = null
	highlight_map = null
	state_grid.clear()
