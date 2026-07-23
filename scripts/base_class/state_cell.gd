class_name StateCell

var walkable: bool
var being_chose: bool
var type: String

func _init(tile_data: TileData) -> void:
	if tile_data:
		walkable = tile_data.get_custom_data("walkable")
		type = tile_data.get_custom_data("type")
	else:
		walkable = false
		type = "null"

func _to_string() -> String:
	return "State = {Walkable: %s, Type: %s}" % [walkable, type]
