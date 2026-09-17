extends State
class_name PlayerMoveAnticipation

@onready var animation_player: AnimationPlayer

func init() -> void:
	super.init()
	animation_player = player.get_child(2)

func enter() -> void:
	super.enter()
	animation_player.play("move_anticipation")

func process_input(event: InputEvent) -> void:
	if not animation_player.is_playing():
		transition_to.emit(PlayerMoving.new())
