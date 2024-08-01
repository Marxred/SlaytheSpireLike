# meta-name: 卡牌模板
# meta-description: 卡牌模板
# meta-default: false
# meta-space-indent: 4

extends Card

@export var amounts: int = 0:set =  _set_amounts

func _set_amounts(v: int):
	amounts = v

func _set_tooltip_text(v: String)->void:
	super(v)
	tooltip_text = "deals " + str(amounts) + " damage"

func apply_effects(targets)->void:
	super(targets)
	var damage_effect:= DamageEffect.new()
	damage_effect.amounts = amounts
	damage_effect.sfx = sfx
	damage_effect.execute(targets)
