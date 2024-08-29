class_name CardVisuals
extends Control


@export var card: Card:set = set_card
func set_card(v: Card)->void:
	if not v:
		return
	if not is_node_ready():
		await ready
	card = v
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = card.RARITY_COLOR.get(card.rarity)

@onready var panel: Panel = $Panel
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity
@onready var cost: Label = $Cost
