extends Card

@export var amounts: int = 0

func apply_effects(targets)->void:
	super(targets)
	var damage_effect:= DamageEffect.new()
	damage_effect.amounts = amounts
	damage_effect.execute(targets)
