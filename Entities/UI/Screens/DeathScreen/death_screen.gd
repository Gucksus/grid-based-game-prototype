extends Control

func _ready() -> void:
	hide()

func show_screen() -> void:
	show()

func game_reset() -> void:
	MapManager.reset()
	get_tree().reload_current_scene()

func game_exit() -> void:
	get_tree().quit()
