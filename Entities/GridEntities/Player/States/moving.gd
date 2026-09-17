extends State
class_name PlayerMoving

@onready var sprite_2d: Sprite2D = $"../Sprite2D"

var tween: Tween
var duration := .3
var spam_delay := .2
var timer := 0

func play_moving_anim() -> void:
	if tween:
		tween.kill()
	sprite_2d.scale = Vector2(1.5, 0.5)
	tween = get_tree().create_tween()
	tween.tween_property(player, "position", player.grid_pos_to_position(player.grid_pos), .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(1, 1), .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(sprite_2d, "position", Vector2(0, 16), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func enter() -> void:
	init()
	play_moving_anim()

func _process(delta: float) -> void:
	timer += delta
	if not tween.is_running():
		transition_to.emit(PlayerIdle)
	elif player.next_grid_pos != Vector2i(-1, -1) and player.try_move_to(player.next_grid_pos) and timer >= spam_delay:
		play_moving_anim()
		timer = 0

func exit() -> void:
	super.exit()
	player.moved.emit()
