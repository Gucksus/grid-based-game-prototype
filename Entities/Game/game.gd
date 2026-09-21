extends Node2D

@onready var main_map: CustomTileMap = $MainMap
@onready var player: PlayerEnitity = $Player
@onready var enemy: EnemyEntity = $Enemy
@onready var back_ground_color: ColorRect = $"../BackGroundColor"

func _ready() -> void:
	MapManager.init_grid(main_map)
	MapManager.build_from_tilemap()
	back_ground_color.show()

func _process(delta: float) -> void:
	if player.grid_pos == enemy.grid_pos:
		player.die()
