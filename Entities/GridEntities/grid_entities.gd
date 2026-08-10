extends CharacterBody2D
class_name GridEntities

# The position of the player on the logic grid.
var grid_pos: Vector2i

func grid_pos_to_position(grid_pos: Vector2i) -> Vector2:
	return MapManager.map_to_local(grid_pos) - Vector2(8, 8)

func position_to_grid_pos(position: Vector2) -> Vector2i:
	return MapManager.local_to_map(position)

func set_position_from_grid_pos(grid_pos: Vector2i) -> void:
	position = grid_pos_to_position(grid_pos)

func _ready() -> void:
	await get_parent().ready
	grid_pos = position_to_grid_pos(position)
	if not MapManager.is_walkable(grid_pos):
		grid_pos = MapManager.first_walkable_tile()
	set_position_from_grid_pos(grid_pos)
