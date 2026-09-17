extends State
class_name PlayerIdle

func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and MapManager.is_spinnable(player.grid_pos):
		transition_to.emit(PlayerRotating)
		MapManager.init_spin(player.grid_pos)
		return

	if player.next_grid_pos != Vector2i(-1, -1) and MapManager.is_walkable(player.next_grid_pos):
		player.move_to(player.next_grid_pos)
		transition_to.emit(PlayerMoveAnticipation)
