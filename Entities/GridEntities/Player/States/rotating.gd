extends State
class_name PlayerRotating

func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		MapManager.clear_spin(player.grid_pos)
		transition_to.emit(PlayerIdle)
		return
	if event.is_action_pressed("interact"):
		MapManager.spin_tile(player.grid_pos)
		player.turned.emit()
