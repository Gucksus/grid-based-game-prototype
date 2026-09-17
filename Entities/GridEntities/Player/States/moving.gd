extends State
class_name PlayerMoving

var tween: Tween

func enter() -> void:
	init()
	if tween:
		tween.kill()
	player.scale = Vector2(1.5, 0.5)
	tween = get_tree().create_tween()
	tween.tween_property(player.get_child(1), "position", player.grid_pos_to_position(player.grid_pos), .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(player.get_child(1), "scale", Vector2(1, 1), .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func process_input(event: InputEvent) -> void:
	if tween.finished:
		transition_to.emit(PlayerIdle.new())
	elif player.next_grid_pos != Vector2i(-1, -1):
		enter()
