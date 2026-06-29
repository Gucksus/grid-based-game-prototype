extends TileMapLayer 

func hightlight_tile(pos: Vector2i):
	set_cell(pos, 0, Vector2i(0, 0))
