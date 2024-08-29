extends EnemyAction

@export var block: int = 2


func perform_action()->void:
	super()
	if not enemy or not target:
		return

	var block_effect:= BlockEffect.new()
	block_effect.amounts = block
	block_effect.sfx = sfx
	block_effect.execute([enemy])

	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
