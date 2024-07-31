class_name BlockEffect
extends Effect

func execute(targets: Array[Node])->void:
	super(targets)
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.block += self.amounts
			Sfx.play(self.sfx)
