extends GridEntities

signal moved(new_pos: Vector2i)

var directional_inputs = {
	'up': Vector2i.UP,
	'down': Vector2i.DOWN,
	'right': Vector2i.RIGHT,
	'left': Vector2i.LEFT
}

enum States {MOVING, CHOOSING_ROTATION}
var current_state := States.MOVING

@onready var arrow: Sprite2D = $Arrow

func try_move_to(pos: Vector2i):
	if MapManager.is_walkable(pos):
		teleport_to(pos)
		moved.emit()

func _unhandled_input(event: InputEvent) -> void:
	match current_state:
		States.MOVING:
			if event.is_action_pressed("interact") and MapManager.is_spinnable(grid_pos):
				current_state = States.CHOOSING_ROTATION
				MapManager.init_spin(grid_pos)
				return

			for input in directional_inputs:
				if event.is_action_pressed(input):
					var new_pos: Vector2i = grid_pos + directional_inputs[input]
					try_move_to(new_pos)

		States.CHOOSING_ROTATION:
			if event.is_action_pressed("confirm"):
				current_state = States.MOVING
				MapManager.clear_spin(grid_pos)
				return
			if event.is_action_pressed("interact"):
				MapManager.spin_tile(grid_pos)
