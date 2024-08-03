extends CardState

var mouse_pressed_time: float = 0.1
var mini_time_pass: bool = false

## 进入DRAGGING状态时脱离手牌位置，重设canvaslayer为父节点
func enter()->void:
	super()
	Events.card_drag_started.emit(card_ui)
	#card_ui.panel.panel = card_ui.DARGGING_STYLE
	card_ui.panel.set("theme_override_styles/panel", card_ui.DARGGING_STYLE)
	var ui_layer:= get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	mini_time_pass = false
	(get_tree().create_timer(mouse_pressed_time, false)
					.timeout.connect(func(): mini_time_pass = true))

func exit()->void:
	super()
	Events.card_drag_ended.emit(card_ui)

## 在当前状态下卡牌始终跟随鼠标光标
## 有三种状态转换
## 1. 卡牌针对单个敌人，在指定区域可以进入瞄准状态
## 2. 其他种卡牌直接进入释放状态
## 3. 松开左键或按下右键回到BASE状态
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
		Events.card_tooltip_hide.emit()

	elif mini_time_pass and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
