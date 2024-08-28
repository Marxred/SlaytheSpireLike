class_name MAP
extends Node2D


@onready var camera_2d: Camera2D = $Camera2D
var camera_edge_y:= 0.0
const CAMERA_SPEED:= 8.0
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_move_up"):
		camera_2d.position.y -= CAMERA_SPEED
		camera_2d.position.y = clampf(camera_2d.position.y, camera_edge_y, -80)
	elif event.is_action_pressed("camera_move_dwon"):
		camera_2d.position.y += CAMERA_SPEED
		camera_2d.position.y = clampf(camera_2d.position.y, camera_edge_y, -80)

	if event is InputEventKey:
		if event.keycode == KEY_1:
			camera_2d.zoom += Vector2(0.1,0.1)
		elif event.keycode == KEY_2:
			camera_2d.zoom -= Vector2(0.1,0.1)


@onready var map_generator: MapGenerator = $MapGenerator

var current_rooms:Array[RoomUI]=[]
#func _ready() -> void:
	#create_new_map()

func create_new_map()->void:
	var _map_data = map_generator.show_detail()
	initial_map_ui_data()
	draw_map2(map_ui_data)
	camera_edge_y= map_ui_data[0][0].position.y - 20.0
	var temp_room_ui:RoomUI=RoomUI.new()
	temp_room_ui.next_room_ui = map_ui_data[map_generator.FLOORS-1]
	unlock_rooms(temp_room_ui)


@onready var lines: Node2D = $Lines
@onready var visuals: Node2D = $Visuals
const CONNECT_ROOM_LINE = preload("res://scenes/Map/connect_room_line.tscn")
const ROOM_UI = preload("res://scenes/Map/room_ui.tscn")


func draw_map(map_data:Array[Array])->void:
	printerr("draw_map")
	#var map_data:Array[Array]=map_generator.map_data
	for i:Array[Room] in map_data:
		for j:Room in i:
			if j.type != Room.TYPE.UNSIGNED:
				var room:RoomUI=ROOM_UI.instantiate()
				room.room = j
				room.position = j.position
				visuals.add_child(room)
			if j.next_rooms.size()>0:
				for k in j.next_rooms:
					lines.add_child(connect_rooms(j.position, k.position))

func draw_map2(_map_ui_data:Array[Array])->void:
	printerr("draw_map")
	for i:Array[RoomUI] in _map_ui_data:
		for j:RoomUI in i:
			visuals.add_child(j)
			if j.next_room_ui.size()>0:
				for k in j.next_room_ui:
					lines.add_child(connect_rooms(j.position, k.position))

func connect_rooms(start:Vector2, end:Vector2)->Node:
	var _lines:Line2D=CONNECT_ROOM_LINE.instantiate()
	_lines.points[0] = start
	_lines.points[1] = end
	return _lines
#class test extends Node:
	#var i:int=0
	#var f:float=0.0
	#var test:set=set_test
	#func set_test(v)->void:
		#pass


func unlock_rooms(enter_room:RoomUI)->void:
	var next_rooms:Array[RoomUI]=enter_room.next_room_ui
	#Events.map_exited.emit(enter_room)
	lock_rooms(current_rooms)
	current_rooms.clear()
	current_rooms = next_rooms
	for room_ui:RoomUI in next_rooms:
		room_ui.state = RoomUI.STATE.ENTERABLE
		if room_ui.room_entered.is_connected(on_room_entered):
			var test:=room_ui.room_entered.is_connected(on_room_entered)
			printerr(test)
		else:room_ui.room_entered.connect(on_room_entered)

func on_room_entered(room_ui:RoomUI)->void:
	Events.map_exited.emit(room_ui)
	unlock_rooms(room_ui)


func unlock_rooms2(next_rooms:Array[RoomUI])->void:
	Events.map_exited.emit()
	lock_rooms(current_rooms)
	current_rooms.clear()
	current_rooms = next_rooms
	for room_ui:RoomUI in next_rooms:
		room_ui.state = RoomUI.STATE.ENTERABLE
		if room_ui.room_entered.is_connected(unlock_rooms):
			var test:=room_ui.room_entered.is_connected(unlock_rooms)
			printerr(test)
		else:room_ui.room_entered.connect(unlock_rooms)


func lock_rooms(_current_rooms:Array[RoomUI])->void:
	for room_ui:RoomUI in _current_rooms:
		if room_ui.state == RoomUI.STATE.ENTERED:
			continue
		else:room_ui.state = RoomUI.STATE.UNENTERABLE


var map_ui_data:Array[Array]
#var map_ui_data:Array[Array[RoomUI]]
#初始化类型和位置
func initial_map_ui_data()->void:
	for _floor in map_generator.FLOORS:
		var floor_rooms:Array[RoomUI]=[]
		for width in map_generator.WIDTHS:
			var room:Room=map_generator.map_data[map_generator.FLOORS -_floor-1][width]
			if room.type != Room.TYPE.UNSIGNED:
				var room_ui:RoomUI=ROOM_UI.instantiate()
				room_ui.room = room
				for n_room in room_ui.room.next_rooms:
					if _floor == 0:
						break
					for n_room_ui:RoomUI in map_ui_data[_floor -1]:
						if n_room_ui.room.position == n_room.position:
							if not room_ui.next_room_ui.has(n_room_ui):
								room_ui.next_room_ui.append(n_room_ui)
							break
				floor_rooms.append(room_ui)
		map_ui_data.append(floor_rooms)

func show_map()->void:
	show()
	camera_2d.enabled = true

func hide_map()->void:
	hide()
	camera_2d.enabled = false
