extends Node2D

@onready var grid_map: TileMapLayer = $GridMap
@onready var hight_light_map: TileMapLayer = $HightLightMap

func _ready() -> void:
	AutoScanGrid.init_grid(grid_map, hight_light_map)
	AutoScanGrid.build_from_tilemap()
