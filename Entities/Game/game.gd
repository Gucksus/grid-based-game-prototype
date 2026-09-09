extends Node2D

@onready var main_map: CustomTileMap = $MainMap
@onready var player: PLayerEnitity = $Player
@onready var enemy: EnemyEntity = $Enemy

func _ready() -> void:
	MapManager.init_grid(main_map)
	MapManager.build_from_tilemap()

func _process(delta: float) -> void:
	if player.grid_pos == enemy.grid_pos:
		player.die()
