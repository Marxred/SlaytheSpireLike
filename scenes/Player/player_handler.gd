class_name PlayerHandler
extends Node


const HAND_DRAW_INTERVAL: float = 0.15
const HAND_DISCARD_INTERVAL: float = 0.1
var character: CharacterStats
@export var hand: Hand




func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func _on_card_played(card: Card)->void:
	character.discard.add_card(card)


func start_battle(_char_stats: CharacterStats)->void:
	character = _char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	start_turn()

func start_turn()->void:
	character.block = 0
	character.reset_mana()
	draw_cards(character.cards_per_turn)

func draw_cards(amounts: int)->void:
	var tween: Tween = create_tween()
	for i in range(amounts):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)

	tween.finished.connect(
		func():
			Events.card_hand_drawn.emit()
			)

func draw_card()->void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()

func end_turn()->void:
	hand.disabled_hand()
	discard_cards()

func discard_cards()->void:
	if hand.get_children().is_empty():
		Events.player_hand_discarded.emit()
		return
	var tween: Tween = create_tween()

	for card_ui:CardUI in hand.get_children():
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)

	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
			)

func reshuffle_deck_from_discard()->void:
	if not character.draw_pile.empty():
		return

	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())

	character.draw_pile.shuffle()

