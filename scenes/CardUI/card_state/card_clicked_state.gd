extends CardState

func enter()->void:
	super()
	
	card_ui.color.color = Color.ORANGE
	card_ui.state.text = "CLICKED"
	card_ui.drop_point_detector.monitoring = true

func on_gui_input(event: InputEvent)->void:
	super(event)
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
