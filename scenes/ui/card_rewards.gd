class_name CardRewards
extends ColorRect


signal card_reward_selected(card:Card)


var selected_card:Card
@export var rewards:Array[Card]:set=set_rewards
func set_rewards(v:Array[Card])->void:
	rewards = v


const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")
@onready var cards: HBoxContainer = $VBoxContainer/Cards
@onready var card_preview_tool_tip: Control = $CardPreviewToolTip
func _ready() -> void:
	hide()
	if not is_node_ready():
		await ready
	clear_rewards()


func clear_rewards()->void:
	selected_card = null
	if 0 == cards.get_child_count():
		printerr("no reward cards")
		return
	for card in cards.get_children():
		card.queue_free()

func show_rewards()->void:
	if 0 != cards.get_child_count():
		clear_rewards()
	for card in rewards:
		var card_menu_ui = CARD_MENU_UI.instantiate()
		card_menu_ui.tooltip_requested.connect(_on_tooltip_requested)
		card_menu_ui.card = card
		cards.add_child(card_menu_ui)
	show()


func _on_tooltip_requested(card:Card)->void:
	selected_card = card
	card_preview_tool_tip._on_tooltip_requested(card)


func _on_skip_button_pressed() -> void:
	printerr("skip card reward")
	card_reward_selected.emit(null)
	queue_free()


func _on_take_button_pressed() -> void:
	if null == selected_card:
		printerr("no selected card was taken")
	printerr("take {card}".format({"card": selected_card.id}))
	card_reward_selected.emit(selected_card)
	queue_free()
