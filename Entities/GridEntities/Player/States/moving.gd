extends State
class_name PlayerMoving

@onready var sprite_2d: Sprite2D = $"../Sprite2D"

var tween: Tween
var duration := .3
var spam_delay := .1
var timer := 0.0

func reset_sprite_pos_and_offset() -> void:
	if player.last_move_direction == Vector2i.UP or player.last_move_direction == Vector2i.DOWN:
		sprite_2d.position = Vector2(0, 16)
		sprite_2d.offset = Vector2(0, 0)
	elif player.last_move_direction == Vector2i.RIGHT:
		sprite_2d.position = Vector2(-8, 24)
		sprite_2d.offset = Vector2(8, -8)
	elif player.last_move_direction == Vector2i.LEFT:
		sprite_2d.position = Vector2(8, 24)
		sprite_2d.offset = Vector2(-8, -8)

func play_moving_anim() -> void:
	if tween:
		tween.stop()
		tween.kill()
	sprite_2d.scale = Vector2(1.5, 0.5)
	reset_sprite_pos_and_offset()
	tween = get_tree().create_tween()
	tween.tween_property(player, "position", player.grid_pos_to_position(player.grid_pos), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(sprite_2d, "scale", Vector2(1, 1), duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func enter() -> void:
	super.enter()
	play_moving_anim()

func _process(delta: float) -> void:
	timer += delta
	if not tween.is_running():
		transition_to.emit(PlayerIdle)

func process_input(event: InputEvent) -> void:
	if player.next_grid_pos != Vector2i(-1, -1) and MapManager.is_walkable(player.next_grid_pos) and timer >= spam_delay:
		player.move_to(player.next_grid_pos)
		play_moving_anim()
		timer = 0

func exit() -> void:
	super.exit()
