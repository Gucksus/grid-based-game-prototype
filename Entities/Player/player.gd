extends CharacterBody2D

var directional_inputs = {
	'up': Vector2i.UP,
	'down': Vector2i.DOWN,
	'right': Vector2i.RIGHT,
	'left': Vector2i.LEFT
}

var angle_inputs = {
	"up": [0, Vector2i(8, -8)],
	"down": [PI, Vector2i(8, 24)],
	"right": [PI / 2, Vector2i(24, 8)],
	"left": [PI * 3/2, Vector2i(-8, 8)]
}
var ini_rotate_point := Vector2i(8, 4)

enum States {MOVING, CHOOSING_DIRECTION, CHOOSING_ROTATION}
var current_state := States.MOVING

@onready var arrow: Sprite2D = $Arrow

# The position of the player on the logic grid.
var grid_pos: Vector2i

func _ready() -> void:
	await get_parent().ready
	grid_pos = MapManager.local_to_map(position)
	if not MapManager.is_walkable(grid_pos):
		grid_pos = MapManager.first_walkable_tile()
	position = MapManager.map_to_local(grid_pos) - Vector2(8, 8)
	arrow.visible = false

func try_move_to(pos: Vector2i):
	if MapManager.is_walkable(pos):
		grid_pos = pos
		position = MapManager.map_to_local(grid_pos) - Vector2(8, 8)
		print(MapManager.state_grid[grid_pos])

func _unhandled_input(event: InputEvent) -> void:
	match current_state:
		States.MOVING:
			if event.is_action_pressed("interact") and MapManager.is_spinnable(grid_pos):
				current_state = States.CHOOSING_DIRECTION
				
				# Arrow position and angle set to a walkable tile before making it visible.
				for input in directional_inputs:
					if MapManager.is_walkable(grid_pos + directional_inputs[input]):
						arrow.position = angle_inputs[input][1]
						arrow.rotation = angle_inputs[input][0]
						arrow.set_meta("directional_vector", directional_inputs[input])
						break
				
				arrow.visible = true
				return

			for input in directional_inputs:
				if event.is_action_pressed(input):
					var new_pos: Vector2i = grid_pos + directional_inputs[input]
					try_move_to(new_pos)

		States.CHOOSING_DIRECTION:
			if event.is_action_pressed("interact"):
				arrow.visible = false
				# Temporarily set the spinning tile to true so that flood fill works correctly.
				MapManager.state_grid[grid_pos].being_chose = true
				MapManager.flood_fill(grid_pos + arrow.get_meta("directional_vector"))
				MapManager.state_grid[grid_pos].being_chose = false
				MapManager.move_chosen_tiles_to_rotating()
				MapManager.initial_spinning()
				current_state = States.CHOOSING_ROTATION
				return
			
			for input in angle_inputs:
				if event.is_action_pressed(input) and MapManager.is_walkable(grid_pos + directional_inputs[input]):
					arrow.position = angle_inputs[input][1]
					arrow.rotation = angle_inputs[input][0]
					arrow.set_meta("directional_vector", directional_inputs[input])

		States.CHOOSING_ROTATION:
			if event.is_action_pressed("interact"):
				MapManager.spin_tile(grid_pos)
			if event.is_action_pressed("confirm"):
				MapManager.confirm_spin()
				current_state = States.MOVING
