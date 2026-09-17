extends Node2D
class_name State

@onready var player: PlayerEnitity

signal transition_to(new_state: GDScript)

func init() -> void:
	player = get_parent()
	transition_to.connect(player.state_transition_to)

func enter() -> void:
	init()

func exit() -> void:
	queue_free()

func process_input(event: InputEvent) -> void:
	pass

func _to_string() -> String:
	return self.get_script().get_global_name()
