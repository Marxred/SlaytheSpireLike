extends Control

const RUN = preload("res://scenes/Run/run.tscn")
const RUN_SETUP = preload("res://scenes/StartGame/run_setup.tres")

const SAVAGE = preload("res://characters/savage/savage.tres")
const WARRIOR = preload("res://characters/warrior/warrior.tres")
const WIZARD = preload("res://characters/wizard/wizard.tres")

@onready var portrait: TextureRect = $Portrait
@onready var title: Label = $VBoxContainer/Title
@onready var description: Label = $VBoxContainer/Description

var char_stats: CharacterStats :set = set_char_stats

func set_char_stats(picked_char: CharacterStats):
	print_debug(picked_char.character_name," selected")
	char_stats = picked_char
	portrait.texture = char_stats.portrait
	title.text = char_stats.character_name
	description.text = char_stats.description
	RUN_SETUP.char_stat = char_stats


func _ready() -> void:
	var warrior:= $HBoxContainer/Warrior as Button
	warrior.button_pressed = true
	set_char_stats(WARRIOR)
	RUN_SETUP.type = RunStartup.ENTER_GAME.NEW_RUN

func _on_warrior_pressed() -> void:
	set_char_stats(WARRIOR)


func _on_savage_pressed() -> void:
	set_char_stats(SAVAGE)


func _on_wizard_pressed() -> void:
	set_char_stats(WIZARD)


func _on_start_game_pressed() -> void:
	print_debug("start with ", char_stats.character_name)
	get_tree().change_scene_to_packed(RUN)
