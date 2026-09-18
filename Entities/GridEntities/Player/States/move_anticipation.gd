extends State
class_name PlayerMoveAnticipation

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var moving_direction = {
	Vector2i.UP: "move_up_anticipation",
	Vector2i.DOWN: "move_down_anticipation",
	Vector2i.RIGHT: "move_right_anticipation",
	Vector2i.LEFT: "move_left_anticipation"
}

func enter() -> void:
	super.enter()
	animation_player.play(moving_direction[player.last_move_direction])

func _process(delta: float) -> void:
	if not animation_player.is_playing():
		transition_to.emit(PlayerMoving)
