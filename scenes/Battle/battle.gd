class_name Battle
extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: CanvasLayer = $BattleUI

func _ready() -> void:
	var new_stats: CharacterStats = char_stats.new_instance()
	battle_ui.char_stats = char_stats

func start_battle()->void:
	print("battle started!")
