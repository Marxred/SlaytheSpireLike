extends CenterContainer

#不是全局信号，只会在同一场景中使用
signal tooltip_requested(card: Card)

@onready var visuals: CardVisuals = $Visuals

@export var card: Card: set=set_card
func set_card(_card: Card)->void:
	if not _card:
		return
	if not is_node_ready():
		await ready
	card = _card
	visuals.card = card


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		print_debug("tooltip_requested")
		tooltip_requested.emit(card)


const CARD_BASE_STYLEBOX = preload("res://scenes/CardUI/card_base_stylebox.tres")
const CARD_HOVER_STYLEBOX = preload("res://scenes/CardUI/card_hover_stylebox.tres")

func _on_visuals_mouse_entered() -> void:
	visuals.panel.set("theme_override_styles/panel", CARD_HOVER_STYLEBOX)


func _on_visuals_mouse_exited() -> void:
	visuals.panel.set("theme_override_styles/panel", CARD_BASE_STYLEBOX)
