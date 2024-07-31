class_name BattleOverPanel
extends Panel

enum TYPE{WIN,LOSE}

@onready var label: Label = $VBoxContainer/Label
@onready var resume: Button = $VBoxContainer/Resume
@onready var quit: Button = $VBoxContainer/Quit

func _ready() -> void:
	hide()
	resume.pressed.connect(get_tree().reload_current_scene)
	quit.pressed.connect(get_tree().quit)
	Events.battle_over_requested.connect(show_panel)

func show_panel(text:String, type:TYPE)->void:
	get_tree().paused = true
	label.text = text
	resume.visible = type == TYPE.LOSE
	quit.visible = type == TYPE.WIN
	show()

func hide_panel()->void:
	hide()
