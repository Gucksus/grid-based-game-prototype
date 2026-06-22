extends CharacterBody2D

var directional_inputs = {
	'up': Vector2i.UP,
	'down': Vector2i.DOWN,
	'left': Vector2i.LEFT,
	'right': Vector2i.RIGHT
}

enum States {MOVING, ROTATING_LOCKED}
var current_state:= States.MOVING 

@onready var tile_map: TileMapLayer = $"../TileMap"
# The position of the player on the logic grid.
var grid_pos: Vector2i

func _ready() -> void:
	await get_parent().ready
	grid_pos = tile_map.local_to_map(position) - AutoScanGrid.grid_offset
	if not AutoScanGrid.is_walkable(grid_pos):
		grid_pos = Vector2i(0, 0)  
	position = tile_map.map_to_local(grid_pos + AutoScanGrid.grid_offset) - Vector2(8, 8)

func try_move_to(pos: Vector2i):
	if AutoScanGrid.is_walkable(pos):
		grid_pos = pos
		position = tile_map.map_to_local(grid_pos + AutoScanGrid.grid_offset) - Vector2(8, 8)

func _unhandled_input(event: InputEvent) -> void:
	match current_state:
		States.MOVING:
			if event.is_action_pressed("interact") and AutoScanGrid.is_spinnable(grid_pos):
				current_state = States.ROTATING_LOCKED
				return

			for input in directional_inputs:
				if event.is_action_pressed(input):
					var new_pos: Vector2i = (grid_pos + directional_inputs[input]).clamp(Vector2i(0, 0), AutoScanGrid.grid_size)
					try_move_to(new_pos)
					
		States.ROTATING_LOCKED:
			return
