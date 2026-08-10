extends GridEntities

@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	super._ready()
	player.moved.connect(take_turn)

func take_turn(player_pos: Vector2i) -> void:
	var direction = Vector2i.ZERO
	if player_pos.x > grid_pos.x:
		direction.x = 1
	elif player_pos.x < grid_pos.x:
		direction.x = -1
	elif player_pos.y > grid_pos.y:
		direction.y = 1
	elif player_pos.y < grid_pos.y:
		direction.y = -1
	grid_pos += direction
	set_position_from_grid_pos(grid_pos)
