extends EnemyAction

@export var damage: int = 5
@export var rounds: int = 2

func perform_action()->void:
	super()
	if not enemy or not target:
		return
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var start: Vector2 = enemy.global_position
	var end: Vector2 = target.global_position + Vector2.RIGHT* 32
	var damage_effect:= DamageEffect.new()
	damage_effect.amounts = damage
	damage_effect.sfx = sfx
	var target_array: Array[Node] = [target]
	
	tween.tween_property(enemy, "global_position", end, 0.2)
	
	for i in rounds:
		tween.tween_callback(damage_effect.execute.bind(target_array))
		tween.tween_interval(0.24)
	
	tween.tween_interval(0.16)
	tween.tween_property(enemy,"global_position", start, 0.16)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)

