class_name EnemyEntity
extends GridEntities

@onready var player: PLayerEnitity = $"../Player"

func _ready() -> void:
	super._ready()
	player.moved.connect(take_turn)
	player.turned.connect(take_turn)

func take_turn() -> void:
	var min_distance = MapManager.the_distance_between_2_tiles(grid_pos, player.grid_pos)
	var next_tile_pos := Vector2i(-1, -1)
	for tile_pos in MapManager.neighboring_cell_position(grid_pos):
		if not MapManager.is_walkable(tile_pos):
			continue
		var distance = MapManager.the_distance_between_2_tiles(tile_pos, player.grid_pos)
		if min_distance > distance:
			min_distance = distance
			next_tile_pos = tile_pos
	if next_tile_pos != Vector2i(-1, -1):
		teleport_to(next_tile_pos)
		return
	else:
		min_distance = grid_pos.distance_to(player.grid_pos)
		for tile_pos in MapManager.neighboring_cell_position(grid_pos):
			var distance = tile_pos.distance_to(player.grid_pos)
			if min_distance > distance:
				min_distance = distance
				next_tile_pos = tile_pos
		if next_tile_pos != Vector2i(-1, -1):
			teleport_to(next_tile_pos)
