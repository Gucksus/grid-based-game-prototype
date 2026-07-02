extends Node

var state_grid = []
@onready var hight_light_map: TileMapLayer
var tile_map: TileMapLayer
var rect: Rect2i
# Store the grid size + 1 because it also count (0,0)
var grid_size: Vector2i

# Initialize the grid from the game script.
func init_grid(tile_map: TileMapLayer, hight_light_map: TileMapLayer) -> void:
	self.tile_map = tile_map
	self.hight_light_map = hight_light_map
	rect = tile_map.get_used_rect()
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
			var cell_data = tile_map.get_cell_tile_data(Vector2i(x, y))
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
