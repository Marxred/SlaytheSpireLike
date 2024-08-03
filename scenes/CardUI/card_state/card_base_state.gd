extends CardState

## 基本状态，手牌状态。进入该状态就回归手牌
func enter()->void:
	super()
	if not card_ui.is_node_ready():
		await card_ui.ready

	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLE)
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO

## 进入卡牌区域，单击鼠标左键进入CLICKED状态
func on_gui_input(event: InputEvent)->void:
	super(event)
	if not card_ui.playable or card_ui.disabled:
		return
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position()\
								- card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered()->void:
	super()
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLE)
	Events.card_tooltip_show.emit(card_ui.card.icon, card_ui.card.tooltip_text)

func on_mouse_exited()->void:
	super()
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLE)
	Events.card_tooltip_hide.emit()
