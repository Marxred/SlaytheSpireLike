class_name Room
extends Resource


enum TYPE{UNSIGNED, MONSTERS, SHOP, RELIC, TREASURE, CAMPFIRE, BOSS}


@export var type:TYPE=TYPE.UNSIGNED
@export var position:Vector2
@export var icon:Texture
var next_rooms:Array[Room]
var selected:bool=false


func _to_string() -> String:
	var test:="{type} {position}".format({"type":TYPE.keys()[type][0],"position":position})
	#return String(TYPE.keys()[type][0]) + str(position)
	return test
