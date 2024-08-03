class_name BattleOverPanel
extends Panel

enum TYPE{WIN,LOSE}

@onready var label: Label = $VBoxContainer/Label
@onready var resume: Button = $VBoxContainer/Resume
@onready var quit: Button = $VBoxContainer/Quit

func _ready() -> void:
	hide()
	resume.pressed.connect(func():
							hide()
							get_tree().reload_current_scene()
							)
	quit.pressed.connect(func():
						hide()
						Events.battle_won.emit()
						)
	Events.battle_over_requested.connect(show_panel)
	visibility_changed.connect(change_visibility)

func change_visibility()->void:
	get_tree().paused = visible

func show_panel(text:String, type:TYPE)->void:
	label.text = text
	resume.visible = type == TYPE.LOSE
	quit.visible = type == TYPE.WIN
	show()
