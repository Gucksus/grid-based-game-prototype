extends TileMapLayer

func move_tile(from: Vector2i,to :Vector2i):
	var source_id = get_cell_source_id(from)
	var atlas_coords = get_cell_atlas_coords(from)
	
	erase_cell(from)
	set_cell(to, source_id, atlas_coords)
