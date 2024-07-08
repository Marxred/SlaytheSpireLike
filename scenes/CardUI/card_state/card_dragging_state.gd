extends CardState

func enter()->void:
	super()
	var ui_layer:= get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"


func on_gui_input(event: InputEvent)->void:
	var mouse_motion: bool = event is InputEventMouseMotion
	var cancel: bool = event.is_action_pressed("right_mouse")
	var confirm: bool = event.is_action_pressed("left_mouse")
	
	super(event)
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position()\
									- card_ui.pivot_offset
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
