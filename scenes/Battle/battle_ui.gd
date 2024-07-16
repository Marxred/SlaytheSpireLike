class_name BattleUI
extends CanvasLayer


@export var char_stats: CharacterStats: set = set_char_stats

@onready var mana_ui: ManaUI = $ManaUI

func set_char_stats(v: CharacterStats)->void:
	char_stats = v
	mana_ui.char_stats = char_stats
