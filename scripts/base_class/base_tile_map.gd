class_name CustomTileMap
extends TileMapLayer

#func get_

func move_tile(from: Vector2i,to :Vector2i):
	var source_id := get_cell_source_id(from)
	var atlas_coords := get_cell_atlas_coords(from)
	var alt := get_cell_alternative_tile(from)
	
	erase_cell(from)
	set_cell(to, source_id, atlas_coords, alt)

func get_grid_size() -> Vector2i:
	var rect = self.get_used_rect()
	return Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
