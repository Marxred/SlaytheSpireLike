extends Control



const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")

@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var card_preview_tool_tip: Control = $CardPreviewToolTip


func show_card_pile(_title: String, cardpile:CardPile)->void:
	title.text = _title
	if grid_container.get_child_count()>0:
		for child in grid_container.get_children():
			child.queue_free()
	for card in cardpile.cards:
		var visual_card:= CARD_MENU_UI.instantiate()
		grid_container.add_child(visual_card)
		visual_card.card = card
		visual_card.tooltip_requested.connect(card_preview_tool_tip._on_tooltip_requested)
	show()


func _debug()->void:
	const WARRIOR_STARTING_DECK = preload("res://characters/warrior/warrior_starting_deck.tres")
	show_card_pile("Original CardPile",WARRIOR_STARTING_DECK)


func _ready() -> void:
	#_debug()
	Events.card_pile_preview_requested.connect(show_card_pile)
	hide()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse"):
		hide()


func _on_back_button_pressed() -> void:
	hide()
