extends CardState

func enter()->void:
	super()
	card_ui.drop_point_detector.monitoring = true

## 鼠标移动就切换到DRAGGING状态
func on_gui_input(event: InputEvent)->void:
	super(event)
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
