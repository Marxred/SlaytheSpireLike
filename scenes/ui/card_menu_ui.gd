extends CenterContainer

signal tooltip_requested(card: Card)


@export var card: Card: set=set_card
func set_card(_card: Card)->void:
	if not _card:
		return
	if not is_node_ready():
		await ready
	card = _card
	icon.texture = card.icon
	cost.text = str(card.cost)

@onready var panel: Panel = $Control/Panel
@onready var icon: TextureRect = $Control/Icon
@onready var cost: Label = $Control/Cost
const CARD_BASE_STYLEBOX = preload("res://scenes/CardUI/card_base_stylebox.tres")
const CARD_HOVER_STYLEBOX = preload("res://scenes/CardUI/card_hover_stylebox.tres")


func _on_control_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		print_debug("tooltip_requested")
		tooltip_requested.emit(card)


func _on_control_mouse_entered() -> void:
	panel.set("theme_override_styles/panel", CARD_HOVER_STYLEBOX)


func _on_control_mouse_exited() -> void:
	panel.set("theme_override_styles/panel", CARD_BASE_STYLEBOX)
