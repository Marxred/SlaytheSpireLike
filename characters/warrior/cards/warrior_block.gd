extends Card

@export var amounts: int = 0 :set =  _set_amounts

func _set_amounts(v: int):
	amounts = v

func _set_tooltip_text(v: String)->void:
	super(v)
	tooltip_text = tooltip_text.format({"amounts": amounts})


func apply_effects(targets)->void:
	super(targets)
	var block_effect:= BlockEffect.new()
	block_effect.amounts = amounts
	block_effect.sfx = self.sfx
	block_effect.execute(targets)
