extends CardState

## 基本状态，手牌状态。进入该状态就回归手牌
func enter()->void:
	super()
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	card_ui.reparent_requested.emit(card_ui)
	card_ui.color.color = Color.WEB_GREEN
	card_ui.state.text = "BASE" + card_ui.card.id
	card_ui.pivot_offset = Vector2.ZERO

## 进入卡牌区域，单击鼠标左键进入CLICKED状态
func on_gui_input(event: InputEvent)->void:
	super(event)
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position()\
								- card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
