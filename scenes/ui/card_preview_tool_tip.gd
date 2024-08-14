extends Control

@export var custom_modulate:Color=Color(0, 0, 0, 0.541):set=set_custom_modulate
func set_custom_modulate(v:Color)->void:
	if not is_node_ready():
		await ready
	custom_modulate = v
	color_rect.color = custom_modulate

@onready var card_menu_ui: CenterContainer = $VBoxContainer/CardMenuUI
@onready var Description: RichTextLabel = $VBoxContainer/Description
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	hide()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide()

func _on_tooltip_requested(card: Card)->void:
	if visible:
		return
	show_tooltip(card)


func show_tooltip(card:Card)->void:
	card_menu_ui.set_card(card)
	Description.text = card.tooltip_text
	show()
