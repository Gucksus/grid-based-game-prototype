extends State
class_name PlayerMoveAnticipation

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func enter() -> void:
	super.enter()
	animation_player.play("move_anticipation")

func _process(delta: float) -> void:
	if not animation_player.is_playing():
		transition_to.emit(PlayerMoving)
