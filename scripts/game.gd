extends Node2D

@onready var grid_map: TileMapLayer = $GridMap
@onready var hight_light_map: TileMapLayer = $HightLightMap
@onready var rotating_map: TileMapLayer = $RotatingMap

func _ready() -> void:
	AutoScanGrid.init_grid(grid_map, hight_light_map, rotating_map)
	AutoScanGrid.build_from_tilemap()
