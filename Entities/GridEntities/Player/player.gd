extends GridEntities
class_name PlayerEnitity

signal moved()
signal turned()
signal died()

var directional_inputs = {
	'up': Vector2i.UP,
	'down': Vector2i.DOWN,
	'right': Vector2i.RIGHT,
	'left': Vector2i.LEFT
}

var next_grid_pos := Vector2i(-1, -1)
var current_state: State

func _ready() -> void:
	super._ready()
	state_transition_to(PlayerIdle)
	await get_parent().ready
	set_position_from_grid_pos(grid_pos)

func move_to(des: Vector2i) -> void:
	if MapManager.state_grid.has(grid_pos):
		MapManager.state_grid[grid_pos].occupant = null
	MapManager.state_grid[des].occupant = self
	grid_pos = des
	#moved.emit()

func die() -> void:
	died.emit()

func state_transition_to(new_state: GDScript):
	if current_state:
		current_state.exit()
	current_state = new_state.new()
	add_child(current_state)
	current_state.enter()

func _unhandled_input(event: InputEvent) -> void:
	next_grid_pos = Vector2i(-1, -1)
	for input in directional_inputs:
		if event.is_action_pressed(input):
			next_grid_pos = grid_pos + directional_inputs[input]
	current_state.process_input(event)

func _process(delta: float) -> void:
	print(current_state)
