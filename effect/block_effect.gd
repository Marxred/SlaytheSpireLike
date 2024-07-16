class_name BlockEffect
extends Effect

var amounts: int = 0

func execute(targets: Array[Node])->void:
	super(targets)
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.char_stats.block += amounts
