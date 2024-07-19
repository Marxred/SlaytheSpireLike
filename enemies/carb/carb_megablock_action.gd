extends EnemyAction

@export var block: int = 15
@export var hp_threshold: int = 6

var already_used: bool = false

func is_performable()->bool:
	if not enemy or already_used:
		return false
	
	var is_low:= enemy.stats.health < hp_threshold
	already_used = is_low
	
	return is_low

func perform_action()->void:
	super()
	if not enemy or not target:
		return
	
	var block_effect:= BlockEffect.new()
	block_effect.amounts = block
	block_effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
