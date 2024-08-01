class_name Battle
extends Node2D

@export var char_stats: CharacterStats
@export var background: AudioStream

@onready var battle_ui: BattleUI = $BattleUI
@onready var player: Player = $Player
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var battle_over_panel: Panel = $BattleOverLayer/BattleOverPanel

func _ready() -> void:
	var new_stats: CharacterStats = char_stats.new_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	Events.enemy_trun_ended.connect(_on_enemy_trun_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)

func start_battle(_char_stats: CharacterStats)->void:
	player.update_player()
	print("battle started!")
	#enemy_handler.reset_enemy_actions()
	Music.play(background, true)
	player_handler.start_battle(_char_stats)


func _on_enemy_trun_ended()->void:
	player_handler.start_turn()
	#enemy_handler.reset_enemy_actions()


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() != 0:
		return
	Events.battle_over_requested.emit("Victory!", BattleOverPanel.TYPE.WIN)
	print("Victory!")

func _on_player_died()->void:
	Events.battle_over_requested.emit("Game Over!", BattleOverPanel.TYPE.LOSE)
	print("Game Over!")
