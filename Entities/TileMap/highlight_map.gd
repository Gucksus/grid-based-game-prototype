extends CustomTileMap
class_name HighlightMap

func _ready() -> void:
	tile_set = preload("res://Entities/TileMap/Asset/TileSet/highlight_tile_set.tres")
	z_index = 4

func highlight_tile(pos: Vector2i) -> void:
	set_cell(pos, 0, Vector2i(0, 0), 0)
