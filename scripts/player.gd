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
@onready var grid_map: TileMapLayer = $"../GridMap"
@onready var hight_light_map: TileMapLayer = $"../HightLightMap"

# The position of the player on the logic grid.
var grid_pos: Vector2i

func _ready() -> void:
	await get_parent().ready
	grid_pos = grid_map.local_to_map(position)
	if not AutoScanGrid.is_walkable(grid_pos):
		grid_pos = AutoScanGrid.first_walkable_tile()
	position = grid_map.map_to_local(grid_pos) - Vector2(8, 8)
	arrow.visible = false

func try_move_to(pos: Vector2i):
	if AutoScanGrid.is_walkable(pos):
		grid_pos = pos
		position = grid_map.map_to_local(grid_pos) - Vector2(8, 8)
		print(AutoScanGrid.state_grid[grid_pos])

func _unhandled_input(event: InputEvent) -> void:
	match current_state:
		States.MOVING:
			if event.is_action_pressed("interact") and AutoScanGrid.is_spinnable(grid_pos):
				current_state = States.CHOOSING_DIRECTION
				
				# Arrow position and angle set to a walkable tile before making it visible.
				for input in directional_inputs:
					if AutoScanGrid.is_walkable(grid_pos + directional_inputs[input]):
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
				AutoScanGrid.state_grid[grid_pos].being_chose = true
				AutoScanGrid.flood_fill(grid_pos + arrow.get_meta("directional_vector"))
				AutoScanGrid.state_grid[grid_pos].being_chose = false
				AutoScanGrid.update_choosing_tiles()
				current_state = States.CHOOSING_ROTATION
			
			for input in angle_inputs:
				if event.is_action_pressed(input) and AutoScanGrid.is_walkable(grid_pos + directional_inputs[input]):
					arrow.position = angle_inputs[input][1]
					arrow.rotation = angle_inputs[input][0]
					arrow.set_meta("directional_vector", directional_inputs[input])
					
		States.CHOOSING_ROTATION:
			if event.is_action_pressed("interact"):
				AutoScanGrid.spin_tile(grid_pos)
