class_name ManaUI
extends Panel

@onready var mana_left: Label = $ManaLeft

@export var char_stats: CharacterStats : set = set_char_stats
func set_char_stats(v: CharacterStats)->void:
	char_stats = v
	if not char_stats.stats_changed.is_connected(on_stats_changed):
		char_stats.stats_changed.connect(on_stats_changed)
	if not is_node_ready():
		await ready
	
	on_stats_changed()

func on_stats_changed()->void:
	mana_left.text = str(char_stats.mana) + "/" + str(char_stats.MAX_MANA)
