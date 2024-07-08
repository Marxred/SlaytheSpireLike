extends Node2D

var mouse: =get_global_mouse_position()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse == get_global_mouse_position():
		mouse = get_global_mouse_position()
		return
	print(get_global_mouse_position())
	mouse = get_global_mouse_position()
	
