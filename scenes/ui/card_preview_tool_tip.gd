extends Control


@onready var card_menu_ui: CenterContainer = $VBoxContainer/CardMenuUI
@onready var Description: RichTextLabel = $VBoxContainer/Description

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
