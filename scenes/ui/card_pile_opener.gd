class_name CardPileOpener
extends Control

@export var title: String= "DEBUG"
@onready var amount: Label = $amount

@export var cardpile: CardPile:set = set_cardpile
func set_cardpile(v:CardPile)->void:
	if not is_node_ready():
		await ready
	cardpile = v
	amount.text = str(cardpile.cards.size())
	if not cardpile.card_pile_size_changed.is_connected(_on_card_pile_size_changed):
		cardpile.card_pile_size_changed.connect(_on_card_pile_size_changed)

func _on_card_pile_size_changed(card_amount: int)->void:
	amount.text = str(card_amount)


func _on_pressed() -> void:
	print_debug("card_pile_preview_requested")
	Events.card_pile_preview_requested.emit(title, cardpile)
