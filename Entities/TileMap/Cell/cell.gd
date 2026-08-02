class_name Cell

var walkable: bool
var being_chose: bool
var type: String
var source_id: int
var alternative_source_id: int
var atlas_coords: Vector2i 

func _init(tile_map: TileMapLayer, coords: Vector2i) -> void:
	source_id = tile_map.get_cell_source_id(coords)
	alternative_source_id = tile_map.get_cell_alternative_tile(coords)
	atlas_coords = tile_map.get_cell_atlas_coords(coords)
	var tile_data := tile_map.get_cell_tile_data(coords)
	if tile_data:
		walkable = tile_data.get_custom_data("walkable")
		type = tile_data.get_custom_data("type")
	else:
		walkable = false
		type = "null"

func _to_string() -> String:
	return "Tilemap = {Src_id: %d, Atlas coords: %s}" % [source_id, atlas_coords]
