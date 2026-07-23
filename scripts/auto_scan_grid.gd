extends Node

var state_grid: Dictionary[Vector2i, StateCell] = {}
var choosing_tiles : Array[Vector2i] = []
var hight_light_map: HightlightMap
var rotating_map: RotatingMap
var grid_map: CustomGridMap

# Initialize the grid from the game script.
func init_grid(grid_map: TileMapLayer, hight_light_map: TileMapLayer, rotating_map: TileMapLayer) -> void:
	self.grid_map = grid_map
	self.hight_light_map = hight_light_map
	self.rotating_map = rotating_map

# Returns the first walkable tile.
func first_walkable_tile() -> Vector2i:
	for tile_pos in state_grid:
		if state_grid[tile_pos].walkable:
			return tile_pos
	return Vector2i.ZERO

# Builds the state grid from the given tile map at initialization.
func build_from_tilemap() -> void:
	var grid_size := grid_map.get_grid_size()
	for y in grid_size.y:
		for x in grid_size.x:
			var pos := Vector2i(x, y)
			if grid_map.get_cell_tile_data(pos):
				state_grid[pos] = StateCell.new(grid_map.get_cell_tile_data(pos))

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
		hight_light_map.hightlight_tile(src)
		flood_fill(src - Vector2i(0,1))
		flood_fill(src - Vector2i(1,0))
		flood_fill(src + Vector2i(0,1))
		flood_fill(src + Vector2i(1,0))

func update_choosing_tiles() -> void:
	choosing_tiles.clear()
	for tile_pos in state_grid:
			if is_being_chose(tile_pos):
				choosing_tiles.append(tile_pos)

func move_chosen_tiles_to_rotating_map() -> void:
	for tile_pos in choosing_tiles:
		rotating_map.transfer_tile_from_grid(grid_map, tile_pos)

func move_state(from: Vector2i,to :Vector2i) -> void:
	state_grid[to] = state_grid.get(from)
	state_grid.erase(from)

func move_tile(from: Vector2i,to :Vector2i) -> void:
	rotating_map.move_tile(from, to)
	hight_light_map.move_tile(from, to)
	move_state(from, to)

func spin_tile(pivot: Vector2i) -> void:
	for i in range(choosing_tiles.size()):
		var tar = choosing_tiles[i]
		var new_pos: Vector2i
		new_pos.x = roundi(pivot.x + (tar.x - pivot.x) * cos(PI / 2) - (tar.y - pivot.y) * sin(PI / 2))
		new_pos.y = roundi(pivot.y + (tar.x - pivot.x) * sin(PI / 2) + (tar.y - pivot.y) * cos(PI / 2))
		move_tile(tar, new_pos)
		choosing_tiles[i] = new_pos
