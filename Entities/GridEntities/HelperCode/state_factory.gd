extends Node2D
class_name StateFactory

@onready var player: PlayerEnitity = $".."

var current_state: State
var states := {
	"idle": PlayerIdle,
	"move_anticipation": PlayerMoveAnticipation,
	"moving": PlayerMoving,
	"rotating": PlayerRotating
}

func _on_player_state_changed(new_state: State) -> void:
	current_state.exit()
	current_state = new_state
	add_child(current_state)
	current_state.enter()
	print(1)

func process(event: InputEvent) -> void:
	current_state.process(event)
	print(current_state)

func _on_player_ready() -> void:
	current_state = PlayerIdle.new()
	add_child(current_state)
	current_state.init()
