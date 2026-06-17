extends CharacterBody2D

var directional_inputs = {
	'up': Vector2i.UP,
	'down': Vector2i.DOWN,
	'left': Vector2i.LEFT,
	'right': Vector2i.RIGHT
}

@onready var tile_map: TileMapLayer = $"../TileMap"
var grid_pos: Vector2i

func _ready() -> void:
	await get_parent().ready
	grid_pos = tile_map.local_to_map(position) - AutoScanGrid.grid_offset
	print(grid_pos)
	if not AutoScanGrid.state_grid[grid_pos.y][grid_pos.x]["walkable"]:
		grid_pos = Vector2i(0, 0)  
	position = tile_map.map_to_local(grid_pos + AutoScanGrid.grid_offset) - Vector2(8, 8)

func try_move_to(pos: Vector2i):
	if AutoScanGrid.state_grid[pos.y][pos.x]["walkable"]:
		grid_pos = pos
		position = tile_map.map_to_local(grid_pos + AutoScanGrid.grid_offset) - Vector2(8, 8)

func _unhandled_input(event: InputEvent) -> void:
	for input in directional_inputs:
		if event.is_action_pressed(input):
			var new_pos: Vector2i = (grid_pos + directional_inputs[input]).clamp(Vector2i(0, 0), AutoScanGrid.grid_size)
			try_move_to(new_pos)
