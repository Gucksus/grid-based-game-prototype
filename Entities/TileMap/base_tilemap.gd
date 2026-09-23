class_name CustomTileMap
extends TileMapLayer

func get_grid_size() -> Vector2i:
	var rect = self.get_used_rect()
	return Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y)

func get_wall_cell() -> Cell:
	var new_cell := Cell.new(self)
	new_cell.source_id = 2
	new_cell.atlas_coords = Vector2i.ZERO
	new_cell.alternative_source_id = 0
	return new_cell
