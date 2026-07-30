class_name CustomTileMap
extends TileMapLayer

func move_tile(from: Vector2i,to :Vector2i):
	var source_id := get_cell_source_id(from)
	var atlas_coords := get_cell_atlas_coords(from)
	var alt := get_cell_alternative_tile(from)
	
	erase_cell(from)
	set_cell(to, source_id, atlas_coords, alt)

func get_grid_size() -> Vector2i:
	var rect = self.get_used_rect()
	return Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y)

func get_tile_from_grid(from_layer: TileMapLayer, from_coord: Vector2i, to_coord:= Vector2i(-1, -1)):
	var source_id := from_layer.get_cell_source_id(from_coord)
	var atlas_coords := from_layer.get_cell_atlas_coords(from_coord)
	var alt := from_layer.get_cell_alternative_tile(from_coord)
	
	from_layer.erase_cell(from_coord)
	set_cell(from_coord if to_coord == Vector2i(-1, -1) else to_coord, source_id, atlas_coords, alt)
