extends CardState

func enter()->void:
	super()
	var ui_layer:= get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"


func on_input(event: InputEvent)->void:
	var single_targeted: bool = card_ui.card.is_single_targeted()
	var mouse_motion: bool = event is InputEventMouseMotion
	var cancel: bool = event.is_action_pressed("right_mouse")
	var confirm: bool = event.is_action_pressed("left_mouse") or event.is_action_released("left_mouse")
	
	super(event)
	
	if single_targeted and mouse_motion and card_ui.targets.size() > 0.0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position()\
									- card_ui.pivot_offset
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
