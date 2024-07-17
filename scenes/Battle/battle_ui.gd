class_name BattleUI
extends CanvasLayer


@export var char_stats: CharacterStats: set = set_char_stats

@onready var hand: Hand = $Hand
@onready var mana_ui: ManaUI = $ManaUI
@onready var end_turn_button: Button = $EndTurnButton

func set_char_stats(v: CharacterStats)->void:
	char_stats = v
	mana_ui.char_stats = char_stats
	hand.char_stats = char_stats

func _ready() -> void:
	Events.card_hand_drawn.connect(_on_card_hand_drawn)
	end_turn_button.pressed.connect(_on_button_pressed)

func _on_card_hand_drawn()->void:
	end_turn_button.disabled = false

func _on_button_pressed()->void:
	end_turn_button.disabled = true
	hand.cards_played_this_turn = 0
	Events.player_turn_ended.emit()
