extends Node

var state_grid: Dictionary[Vector2i, Cell] = {}
var placeholder_state_grid: Dictionary[Vector2i, Cell] = {}
var rotating_state_grid: Dictionary[Vector2i, Cell] = {}
var choosing_tiles : Array[Vector2i] = []
var main_map: CustomTileMap
var highlight_map: TileMapLayer = TileMapLayer.new()

# Initialize the grid from the game script.
func init_grid(main_map: CustomTileMap) -> void:
	self.main_map = main_map
	highlight_map.tile_set = preload("uid://d3tjsc4lf3clc")
	highlight_map.z_index = main_map.z_index + 1
	
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

func is_being_chose(pos: Vector2i) -> bool:
	return false if not state_grid.has(pos) else state_grid[pos].being_chose

func flood_fill(src: Vector2i) -> void:
	if is_being_chose(src) or not is_walkable(src):
		return
	elif not is_being_chose(src) and is_walkable(src):
		state_grid[src].being_chose = true
		flood_fill(src - Vector2i(0,1))
		flood_fill(src - Vector2i(1,0))
		flood_fill(src + Vector2i(0,1))
		flood_fill(src + Vector2i(1,0))

func update_state_onto_main_map() -> void:
	main_map.clear()
	highlight_map.clear()
	for cell_pos in state_grid:
		main_map.set_cell(cell_pos, state_grid[cell_pos].source_id, state_grid[cell_pos].atlas_coords, state_grid[cell_pos].alternative_source_id)
	for cell_pos in rotating_state_grid:
		main_map.set_cell(cell_pos, rotating_state_grid[cell_pos].source_id, rotating_state_grid[cell_pos].atlas_coords, rotating_state_grid[cell_pos].alternative_source_id)
	for cell_pos in choosing_tiles:
		highlight_map.set_cell(cell_pos, 0, Vector2i(0, 0), 0)

func update_choosing_tiles() -> void:
	choosing_tiles.clear()
	for tile_pos in state_grid:
			if is_being_chose(tile_pos):
				choosing_tiles.append(tile_pos)

func move_chosen_tiles_to_rotating() -> void:
	for tile_pos in choosing_tiles:
		rotating_state_grid[tile_pos] = state_grid[tile_pos]
		state_grid.erase(tile_pos)

func transfer_to_placeholder(from: Vector2i, to: Vector2i) -> void:
	placeholder_state_grid[to] = rotating_state_grid[from]
	rotating_state_grid.erase(from)

func transfer_from_placeholder() -> void:
	for i in range(choosing_tiles.size()):
		rotating_state_grid[choosing_tiles[i]] = placeholder_state_grid[choosing_tiles[i]]

func initial_spinning() -> void:
	highlight_map.clear()
	main_map.get_parent().add_child(highlight_map)
	update_state_onto_main_map()

func spin_tile(pivot: Vector2i) -> void:
	placeholder_state_grid.clear()
	for i in range(choosing_tiles.size()):
		var src = choosing_tiles[i]
		var new_pos: Vector2i
		new_pos.x = roundi(pivot.x + (src.x - pivot.x) * cos(PI / 2) - (src.y - pivot.y) * sin(PI / 2))
		new_pos.y = roundi(pivot.y + (src.x - pivot.x) * sin(PI / 2) + (src.y - pivot.y) * cos(PI / 2))
		transfer_to_placeholder(src, new_pos)
		choosing_tiles[i] = new_pos
	transfer_from_placeholder()
	update_state_onto_main_map()

func confirm_spin() -> void:
	for pos in choosing_tiles:
		state_grid[pos] = rotating_state_grid[pos]
		state_grid[pos].being_chose = false
	main_map.get_parent().remove_child(highlight_map)
