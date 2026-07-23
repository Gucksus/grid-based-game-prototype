class_name RotatingMap
extends CustomTileMap

func transfer_tile_from_grid(from_layer: TileMapLayer, from_coord: Vector2i):
	var source_id := from_layer.get_cell_source_id(from_coord)
	var atlas_coords := from_layer.get_cell_atlas_coords(from_coord)
	var alt := from_layer.get_cell_alternative_tile(from_coord)
	
	from_layer.erase_cell(from_coord)
	set_cell(from_coord, source_id, atlas_coords, alt)
