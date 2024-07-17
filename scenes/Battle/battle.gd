class_name Battle
extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var player: Player = $Player

func _ready() -> void:
	var new_stats: CharacterStats = char_stats.new_instance()
	battle_ui.char_stats = new_stats
	player.char_stats = new_stats
	Events.player_turn_ended.connect(player_handler.discard_cards)
	Events.player_hand_discarded.connect(player_handler.start_turn)
	
	start_battle(new_stats)

func start_battle(char_stats: CharacterStats)->void:
	print("battle started!")
	player_handler.start_battle(char_stats)

