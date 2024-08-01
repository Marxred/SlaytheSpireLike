## 子节点挂载EnemyAction，无需修改，仅修改子节点EnemyAction具体实现
class_name EnemyActionPicker
extends Node


@export var enemy: Enemy: set = _set_enemy
func _set_enemy(v: Enemy)->void:
	enemy = v
	for action:EnemyAction in get_children():
		action.enemy = enemy

@export var target: Node2D: set = _set_target
func _set_target(v: Node2D)->void:
	target = v
	for action: EnemyAction in get_children():
		action.target = target


@onready var total_weight: float = 0.0

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	setup_chances()


func get_action()->EnemyAction:
	var action: = get_first_conditional_action()
	if action:
		return action
	
	return get_chance_based_action()

func get_first_conditional_action()->EnemyAction:
	var action: EnemyAction
	for child:EnemyAction in get_children():
		if not child or child.type != EnemyAction.Type.CONDITIONAL:
			continue
		if child.is_performable():
			action = child
			return action
	return null

func get_chance_based_action()->EnemyAction:
	var action: EnemyAction
	var roll: float = randf_range(0.0, total_weight)
	for child:EnemyAction in get_children():
		if (not child 
			or child.type != EnemyAction.Type.CHANCE_BASED):
			continue
		if child.accumulated_weight >= roll:
			action = child
			return action
	return null

func setup_chances()->void:
	for child:EnemyAction in get_children():
		if (not child 
			or child.type != EnemyAction.Type.CHANCE_BASED):
			continue
		total_weight += child.chance_weight
		child.accumulated_weight = total_weight
