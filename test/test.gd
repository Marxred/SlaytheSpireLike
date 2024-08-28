extends Node2D


var map_data:Array[MapGenerator]
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_0:
			var temp = MapGenerator.new()
			map_data.append(temp)
		if event.keycode == KEY_1:
			if map_data.is_empty():
				return
			else:for test in map_data:
					print_debug("map_data")
					test.show_detail()
