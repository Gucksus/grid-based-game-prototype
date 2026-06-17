extends Node2D

@onready var tile_map: TileMapLayer = $TileMap

func _ready() -> void:
	AutoScanGrid.build_from_tilemap(tile_map)
