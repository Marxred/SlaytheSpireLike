extends CardState
## 卡牌瞄准状态

const MOUSE_Y_SNAPBACK_THRESHOULD : int = 138
const POSITION_DURATION: float = 0.2

## 
func enter()->void:
	super()
	card_ui.color.color = Color.WEB_PURPLE
	card_ui.state.text = "AIMING"
	card_ui.targets.clear()
	
	var offset: Vector2 = Vector2(card_ui.parent.size.x /2, 
								-card_ui.size.y /2)
	card_ui.drop_point_detector.monitoring = true
	Events.card_aim_started.emit(card_ui)
	#最好放在最后
	card_ui.animate_to_position(card_ui.parent.global_position + offset, POSITION_DURATION)
## 
func exit()->void:
	super()
	#若aiming状态存在时间小于POSITION_DURATION，则补间动画尚未结束就退出当前状态，卡牌无法归位。
	if card_ui.tween.is_running():
		card_ui.tween.kill()
	Events.card_aim_ended.emit(card_ui)


func on_input(event: InputEvent)->void:
	var mouse_motion: bool = event is InputEventMouseMotion
	var mouse_at_buttom: bool = (card_ui.get_global_mouse_position().y 
									> MOUSE_Y_SNAPBACK_THRESHOULD)
	
	if ((mouse_motion and mouse_at_buttom)
			or event.is_action("right_mouse")):
		transition_requested.emit(self, CardState.State.BASE)
	elif (event.is_action_pressed("left_mouse")
			or event.is_action_released("left_mouse")):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
