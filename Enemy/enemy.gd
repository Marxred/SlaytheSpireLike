class_name Enemy
extends Area2D
## 敌人类
## 

const ARROW_OFFSET: int = 5

@export var stats: EnemyStats: set = set_enemy_stats
func set_enemy_stats(v: EnemyStats)->void:
	stats = v.new_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_enemy()


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction: set = set_current_action

func set_current_action(v: EnemyAction)->void:
	if not v:
		print("DB current_action null!")
	current_action = v

func update_stats()->void:
	stats_ui.update_stats(stats)

func update_action()->void:
	if not enemy_action_picker:
		return
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	
	var new_conditional_action: EnemyAction = enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action

func update_enemy()->void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.ART
	setup_ai()
	update_stats()

func setup_ai()->void:
	if enemy_action_picker:
		enemy_action_picker.queue_free()
	
	var new_action_picker:EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self

func do_turn()->void:
	stats.block = 0
	if not current_action:
		return
	
	current_action.perform_action()

func take_damage(damage: int)->void:
	if stats.health <= 0:
		return
	stats.take_damage(damage)
	
	if stats.health <= 0:
		queue_free()


func _on_area_entered(_area: Area2D) -> void:
	arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()
