extends Card

@export var amounts: int = 0

func apply_effects(targets)->void:
	super(targets)
	var block_effect:= BlockEffect.new()
	block_effect.amounts = amounts
	block_effect.execute(targets)
