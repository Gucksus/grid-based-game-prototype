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
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flash_light: PointLight2D = $FlashLight
var next_grid_pos := Vector2i(-1, -1)
var last_move_direction: Vector2i
var current_state: State

func grid_pos_to_position(grid_pos: Vector2i) -> Vector2:
	return super.grid_pos_to_position(grid_pos)

func _ready() -> void:
	super._ready()
	state_transition_to(PlayerIdle)

func move_to(des: Vector2i) -> void:
	if MapManager.state_grid.has(grid_pos):
		MapManager.state_grid[grid_pos].occupant = null
	MapManager.state_grid[des].occupant = self
	last_move_direction = des - grid_pos
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
	
	flash_light.rotation = (get_global_mouse_position() - position).angle()

func _process(delta: float) -> void:
	#print(current_state)
	pass
