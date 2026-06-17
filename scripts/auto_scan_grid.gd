extends Node

var state_grid = []
var grid_offset: Vector2i
var grid_size: Vector2i

# Called when the node enters the scene tree for the first time.
func build_from_tilemap(tile_map: TileMapLayer):
	var rect = tile_map.get_used_rect()
	grid_offset = rect.position
	grid_size = rect.size - Vector2i(1, 1)
	for y in rect.size.y:
		var row = []
		for x in rect.size.x:
			var cell_data = tile_map.get_cell_tile_data(Vector2i(x + rect.position.x, y + rect.position.y))
			row.append({
				"walkable": cell_data.get_custom_data("walkable") if cell_data else false,
				"occupant": null
			})
		state_grid.append(row)
