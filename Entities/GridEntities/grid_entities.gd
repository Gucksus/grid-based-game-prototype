extends CharacterBody2D
class_name GridEntities

# The position of the player on the logic grid.
var grid_pos: Vector2i
var position_offset := Vector2(0, -16)

func grid_pos_to_position(grid_pos: Vector2i) -> Vector2:
	return MapManager.map_to_local(grid_pos) + position_offset

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

func move_to(des: Vector2i) -> void:
	if MapManager.state_grid.has(grid_pos):
		MapManager.state_grid[grid_pos].occupant = null
	MapManager.state_grid[des].occupant = self
	grid_pos = des
	set_position_from_grid_pos(grid_pos)
