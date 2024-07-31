class_name Card
extends Resource

enum Type{ATTACK, SKILL, POWER}
enum Target{SELF, SINGLE_ENEMY, ALL_ENEMY, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type 
@export var target: Target
@export var cost: int
@export var sfx: AudioStream

@export_category("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text:String:set = _set_tooltip_text
func _set_tooltip_text(v: String)->void:
	tooltip_text = v


func is_single_targeted()-> bool :
	return Target.SINGLE_ENEMY == target

func get_targets(targets: Array[Node])->Array[Node]:
	if not targets:
		return []
	
	var tree = targets[0].get_tree()
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMY:
			return tree.get_nodes_in_group("enemy")
		Target.EVERYONE:
			return (tree.get_nodes_in_group("player")
					+tree.get_nodes_in_group("enemy"))
		_:
			return []

func play(targets: Array[Node], char_stats: CharacterStats)->void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(get_targets(targets))

func apply_effects(_targets: Array[Node])->void:
	pass
