extends Node2D
class_name State

@onready var player: PlayerEnitity
@onready var state_factory: StateFactory

signal transition_to(new_state: State)

func init() -> void:
	state_factory = get_parent()
	player = state_factory.get_parent()
	transition_to.connect(state_factory._on_player_state_changed)

func enter() -> void:
	init()

func exit() -> void:
	queue_free()

func process(event: InputEvent) -> void:
	pass

func _to_string() -> String:
	return self.get_script().get_global_name()
