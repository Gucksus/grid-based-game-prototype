class_name CustomTileMap
extends TileMapLayer

func get_grid_size() -> Vector2i:
	var rect = self.get_used_rect()
	return Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
