extends Node

func shake(thing:Node2D, strength: float = 1.0, duration: float = 0.2)->void:
	if not thing:
		return
	
	var orig_pos: Vector2 = thing.position
	var shake_counts: int = 10
	var tween: Tween = create_tween()
	
	for i in shake_counts:
		var shake_offset:= Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		var target_pos:Vector2=orig_pos+ shake_offset* strength
		if i%2 == 0:
			target_pos = orig_pos
		tween.tween_property(thing,"position", target_pos, (duration/shake_counts))
		strength *= 0.75
	
	tween.finished.connect(
		func()->void:
			if thing:
				thing.position = orig_pos
	)
