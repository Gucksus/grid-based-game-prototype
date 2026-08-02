extends Node2D

@onready var main_map: CustomTileMap = $MainMap

func _ready() -> void:
	MapManager.init_grid(main_map)
	MapManager.build_from_tilemap()
