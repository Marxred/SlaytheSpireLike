class_name Card
extends Resource

enum Type{ATTACK, SKILL, POWER}
enum Target{SELF, SINGLE_ENEMY, ALL_ENEMY, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type 
@export var target: Target
@export var cost: int

func is_single_targeted()-> bool :
	return Target.SINGLE_ENEMY == target
