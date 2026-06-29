extends Node

var state_grid = []
var grid_offset: Vector2i
var grid_size: Vector2i
@onready var hight_light_map: TileMapLayer
var tile_map: TileMapLayer

func init_grid(tile_map: TileMapLayer, hight_light_map: TileMapLayer) -> void:
	self.tile_map = tile_map
	self.hight_light_map = hight_light_map

func logic_pos_to_map_pos(pos: Vector2i):
	return pos + grid_offset

func build_from_tilemap():
	var rect = tile_map.get_used_rect()
	grid_offset = rect.position
	grid_size = rect.size - Vector2i(1, 1)
	for y in rect.size.y:
		var row = []
		for x in rect.size.x:
			var cell_data = tile_map.get_cell_tile_data(Vector2i(x + rect.position.x, y + rect.position.y))
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
		hight_light_map.hightlight_tile(logic_pos_to_map_pos(src))
		flood_fill(src - Vector2i(0,1))
		flood_fill(src - Vector2i(1,0))
		flood_fill(src + Vector2i(0,1))
		flood_fill(src + Vector2i(1,0))
