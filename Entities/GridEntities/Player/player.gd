extends GridEntities
class_name PlayerEnitity

signal moved()
signal turned()
signal died()
@onready var state_factory: StateFactory = $StateFactory

var directional_inputs = {
	'up': Vector2i.UP,
	'down': Vector2i.DOWN,
	'right': Vector2i.RIGHT,
	'left': Vector2i.LEFT
}

enum States {MOVING, CHOOSING_ROTATION, DEAD, IDLE}
var current_state := States.MOVING
var next_grid_pos := Vector2i(-1, -1)

func teleport_to(des: Vector2i) -> void:
	if MapManager.state_grid.has(grid_pos):
		MapManager.state_grid[grid_pos].occupant = null
	MapManager.state_grid[des].occupant = self
	grid_pos = des

func try_move_to(pos: Vector2i) -> bool:
	if MapManager.is_walkable(pos):
		teleport_to(pos)
		moved.emit()
		return true
	return false

func die() -> void:
	died.emit()
	current_state = States.DEAD

func _unhandled_input(event: InputEvent) -> void:
	next_grid_pos = Vector2i(-1, -1)
	for input in directional_inputs:
		if event.is_action_pressed(input):
			next_grid_pos = grid_pos + directional_inputs[input]
	state_factory.process(event)
