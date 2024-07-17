class_name Player
extends Node2D

@export var char_stats: CharacterStats :set = set_character_stats
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI

func set_character_stats(v: CharacterStats)->void:
	char_stats = v
	
	if not char_stats.stats_changed.is_connected(update_stats):
		char_stats.stats_changed.connect(update_stats)
	
	update_player()


func update_player()->void:
	if not char_stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = char_stats.ART
	update_stats()

func update_stats()->void:
	stats_ui.update_stats(char_stats)

func take_damage(damage: int)->void:
	if char_stats.health <= 0:
		return
	char_stats.take_damage(damage)
	
	if char_stats.health <= 0:
		queue_free()
