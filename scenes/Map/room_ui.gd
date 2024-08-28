class_name RoomUI
extends Node2D


signal room_entered(room_ui:RoomUI)
var next_room_ui:Array[RoomUI]

@onready var animation_player: AnimationPlayer = $Visuals/AnimationPlayer
@onready var room_icon: Sprite2D = $Visuals/Room_icon
@onready var area_2d: RoomUI = $"."


const ICONS:={
	Room.TYPE.UNSIGNED:[null, Vector2(0.0,0.0)],
	Room.TYPE.MONSTERS:[preload("res://art/tile_0103.png"), Vector2.ONE],
	Room.TYPE.TREASURE:[preload("res://art/tile_0089.png"), Vector2.ONE],
	Room.TYPE.CAMPFIRE:[preload("res://art/player_heart.png"), Vector2.ONE],
	Room.TYPE.SHOP:[preload("res://art/gold.png"), Vector2.ONE],
	Room.TYPE.BOSS:[preload("res://art/tile_0105.png"), Vector2(1.5, 1.5)],
	#Room.TYPE.TREASURE:[preload("res://art/tile_0089.png"), Vector2(0.75,0.75)],
	#Room.TYPE.CAMPFIRE:[preload("res://art/player_heart.png"), Vector2(0.75,0.75)],
	#Room.TYPE.SHOP:[preload("res://art/gold.png"), Vector2(0.75,0.75)],
}

@export var room:Room:set=set_room
func set_room(v:Room)->void:
	room = v
	if not is_node_ready():
		await ready
	position = room.position
	room_icon.texture = ICONS[room.type][0]
	room_icon.scale = ICONS[room.type][1]


enum STATE{UNENTERABLE, ENTERABLE, ENTERED}
var state:STATE=STATE.UNENTERABLE:set=set_state
func set_state(next_state:STATE)->void:
	match next_state:
		STATE.UNENTERABLE:
			animation_player.play("RESET")
			area_2d.input_pickable = false
		STATE.ENTERABLE:
			animation_player.play("enterable")
			area_2d.input_pickable = true
			room.selected = true
			print(area_2d.input_pickable)
		STATE.ENTERED:
			animation_player.play("entered")
			area_2d.input_pickable = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print_debug("test")
	if event.is_action_pressed("left_mouse"):
		print(area_2d.monitoring)
		Events.enter_room.emit()
		room_entered.emit(self)
		state=STATE.ENTERED
