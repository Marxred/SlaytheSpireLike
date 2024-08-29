class_name GoldUI
extends HBoxContainer


@onready var label: Label = $Label
func _ready() -> void:
	label.text = str(0)


@export var run_stats: RunStats: set=set_run_stats
func set_run_stats(v:RunStats)->void:
	run_stats = v
	if not run_stats.gold_changed.is_connected(_update_gold):
		run_stats.gold_changed.connect(_update_gold)
		_update_gold()

func _update_gold()->void:
	label.text = str(run_stats.gold)
