extends Node

var state_grid = []
var choosing_tiles = []
@onready var hight_light_map: TileMapLayer
var grid_map: TileMapLayer
# Store the grid size + 1 because it also count (0,0)
var grid_size: Vector2i

# Initialize the grid from the game script.
func init_grid(grid_map: TileMapLayer, hight_light_map: TileMapLayer) -> void:
	self.grid_map = grid_map
	self.hight_light_map = hight_light_map
	var rect = grid_map.get_used_rect()
	grid_size = Vector2i(rect.size.x + rect.position.x, rect.size.y + rect.position.y)

# Returns the first walkable tile.
func first_walkable_tile() -> Vector2i:
	for y in grid_size.y:
		for x in grid_size.x:
			if is_walkable(Vector2i(x, y)):
				return Vector2i(x, y)
	return Vector2i(0, 0)

# Builds the state grid from the given tile map at initialization.
func build_from_tilemap():
	# + 1 so that the grid has an extra row and column to act as terminators.
	for y in grid_size.y + 1:
		var row = []
		for x in grid_size.x + 1:
			var cell_data = grid_map.get_cell_tile_data(Vector2i(x, y))
			row.append({
				"walkable": cell_data.get_custom_data("walkable") if cell_data else false,
				"spinnable": cell_data.get_custom_data("spinnable") if cell_data else false,
				"choosing": false,
				"occupant": null
			})
		state_grid.append(row)

func is_walkable(value: Vector2i) -> bool:
	return state_grid[value.y][value.x]["walkable"]

func is_spinnable(value: Vector2i) -> bool:
	return state_grid[value.y][value.x]["spinnable"]

func is_being_chose(value: Vector2i) -> bool:
	return state_grid[value.y][value.x]["choosing"]

func flood_fill(src: Vector2i):
	if is_being_chose(src) or not is_walkable(src):
		return
	elif not is_being_chose(src) and is_walkable(src):
		state_grid[src.y][src.x]["choosing"] = true
		hight_light_map.hightlight_tile(src)
		flood_fill(src - Vector2i(0,1))
		flood_fill(src - Vector2i(1,0))
		flood_fill(src + Vector2i(0,1))
		flood_fill(src + Vector2i(1,0))

func update_choosing_tiles():
	choosing_tiles.clear()
	for y in grid_size.y:
		for x in grid_size.x:
			if is_being_chose(Vector2i(x, y)):
				choosing_tiles.append(Vector2i(x, y))

func move_tile(from: Vector2i,to :Vector2i):
	grid_map.move_tile(from, to)
	hight_light_map.move_tile(from, to)

func spin_tile() -> void:
	var pivot = Vector2i(4, 6)
	
	for i in range(choosing_tiles.size()):
		var tar = choosing_tiles[i]
		var new_pos: Vector2i
		new_pos.x = pivot.x + (tar.x - pivot.x) * cos(PI / 2) - (tar.y - pivot.y) * sin(PI / 2)
		new_pos.y = pivot.y + (tar.x - pivot.x) * sin(PI / 2) + (tar.y - pivot.y) * cos(PI / 2)
		move_tile(tar, new_pos)
		choosing_tiles[i] = new_pos
