class_name EnemyHandler
extends Node2D

func _ready() -> void:
	Events.enemy_action_completed.connect(_enemy_action_completed)

func reset_enemy_actions()->void:
	var enemy: Enemy
	for child:Enemy in get_children():
		enemy = child as Enemy
		enemy.current_action = null
		enemy.update_action()

func start_turn()->void:
	if get_child_count() == 0:
		return
	reset_enemy_actions()
	var first_enemy: Enemy = get_child(0) as Enemy
	first_enemy.do_turn()

func end_turn()->void:
	pass


func _enemy_action_completed(enemy: Enemy)->void:
	if enemy.get_index() == get_child_count() - 1:
		get_tree().create_timer(0.2, false).timeout.connect(
			func():
				Events.enemy_trun_ended.emit()
				)
		return
	
	var next_enemy: Enemy = get_child(enemy.get_index() + 1)
	next_enemy.do_turn()
