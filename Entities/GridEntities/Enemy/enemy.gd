extends GridEntities

@onready var player: GridEntities = $"../Player"

func _ready() -> void:
	super._ready()
	player.moved.connect(take_turn)

func take_turn() -> void:
	var min_distance = INF
	var next_tile_pos: Vector2i
	for tile_pos in MapManager.neighboring_tiles(grid_pos):
		if not MapManager.is_walkable(tile_pos):
			continue
		var distance = MapManager.the_distance_between_2_tiles(tile_pos, player.grid_pos)
		if min_distance > distance:
			min_distance = distance
			next_tile_pos = tile_pos
	grid_pos = next_tile_pos
	set_position_from_grid_pos(grid_pos)
