class_name MapGenerator
extends Node


const FLOORS:int = 15
#const FLOORS:int = 10
const WIDTHS:int = 7


#const FLOOR_DISTANCE:int=int(144 / FLOORS)
const WIDTH_DISTANCE:int=int(240 / WIDTHS)
const FLOOR_DISTANCE:int=50
#const WIDTH_DISTANCE:int=50S


const ROOM_OFFSET:int= 5


const MONSTER_ROOM_WEIGHT := 12.0
const EVENT_ROOM_WEIGHT := 5.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0

var room_total_weight:float= 0.0
var room_type_weight:={
	Room.TYPE.MONSTERS:0.0,
	Room.TYPE.CAMPFIRE:0.0,
	Room.TYPE.SHOP:0.0,
	Room.TYPE.BOSS:0.0,
	#Room.TYPE.RELIC:0.0,
	#Room.TYPE.TREASURE:0.0,
}

func _setup_random_room_weights() -> void:
	room_type_weight[Room.TYPE.MONSTERS] = MONSTER_ROOM_WEIGHT
	room_type_weight[Room.TYPE.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	room_type_weight[Room.TYPE.SHOP] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHOP_ROOM_WEIGHT
	for type:Room.TYPE in room_type_weight:
		room_total_weight += room_type_weight[type]


var map_data:Array[Array]=[]

#初始化类型和位置
func initial_map_data()->void:
	for _floor in FLOORS:
		var rooms:Array[Room]=[]
		for width in WIDTHS:
			var room:Room=Room.new()
			room.type=Room.TYPE.UNSIGNED
			var x_offset := randi_range(-ROOM_OFFSET, ROOM_OFFSET)
			var y_offset := randi_range(-ROOM_OFFSET, ROOM_OFFSET)
			room.position = Vector2(width*WIDTH_DISTANCE + x_offset + 20, -(_floor *FLOOR_DISTANCE + y_offset))
			#room.position.x = clampf(width*WIDTH_DISTANCE + x_offset, 10, 256)
			#room.position.y = -(_floor *FLOOR_DISTANCE + y_offset)

			rooms.append(room)
		map_data.append(rooms)


func generate_map()-> Array[Array]:
	initial_map_data()
	select_rooms_randomly()
	return map_data

func select_rooms_randomly()->void:
	_setup_random_room_weights()
	var entries:Array[int]=select_starting_points()
	print(entries)
	#根据根节点连接上层房间
	for i in entries:
		stretch_path(i)
	set_up_boss_room()


func select_starting_points()->Array[int]:
	#先随机选择根节点
	var room_counts:int= randi_range(2, 5)
	var unique_room:int= 0
	var starting_point:Array[int]=[]
	const PATHS :int= 5
	while unique_room < room_counts or starting_point.size() < PATHS:
		var rand_point:= randi_range(0, WIDTHS - 1)
		if not starting_point.has(rand_point):
			var room:Room= map_data[0][rand_point]
			room.type = assign_room_type_randomly(-1, null, null)
			unique_room+=1
		starting_point.append(rand_point)
	return starting_point


func stretch_path(entry:int)->void:
	var current_index: int =entry
	var current_room:Room= map_data[0][entry]
	for _floor in FLOORS-1:
		var next_index:int=clampi(randi_range(current_index -1,current_index +1), 0, WIDTHS -1)
		var next_room:Room=map_data[_floor +1][next_index]
		var counts:int=0
		while would_cross_other_path(next_index, _floor +1, next_room, current_room):
			counts+=1
			if counts>10:
				printerr("too many counts")
			next_index = clampi(randi_range(current_index -1,current_index +1), 0, WIDTHS -1)
			next_room = map_data[_floor +1][next_index]
		if _floor == FLOORS -2:
			next_index = WIDTHS/2
			next_room =map_data[_floor +1][next_index]

		current_room.next_rooms.append(next_room)
		#current_room.type = assign_room_type_randomly(_floor, current_room, next_room)
		next_room.type = assign_room_type_randomly(_floor, current_room, next_room)
		current_index = next_index
		current_room = next_room

func set_up_boss_room()->void:
	var boss_room: Room = map_data[FLOORS -1][WIDTHS /2]
	boss_room.type = Room.TYPE.BOSS

func would_cross_other_path(x_index:int, y_index:int, next_room:Room, current_room:Room)->bool:
	var path:Vector2= next_room.position - current_room.position
	var parent_room:Room=map_data[y_index -1][x_index]
	if parent_room.type == Room.TYPE.UNSIGNED:
		return false
	for i in parent_room.next_rooms:
		var next_path:Vector2= i.position - parent_room.position
		if sign(next_path.x) != sign(path.x):
			if parent_room == current_room:
				pass
				return false
			else:
				pass
				return true
	return false

#assign the the type of next room
func assign_room_type_randomly(current_floor:int, current_room:Room, _next_room:Room)->Room.TYPE:
	var next_floor = current_floor +1
	if next_floor == 0:
		return Room.TYPE.MONSTERS
	if next_floor == 8:
		return Room.TYPE.TREASURE
	elif next_floor == FLOORS -2:
		return Room.TYPE.CAMPFIRE


#四楼下无营火，无连续营火和连续商店，13层无营火
	var campfire_below_4:=true
	var consecutive_camfire:=true
	var consecutive_shop:=true
	var campfire_on_13:=true

	var type_candidate:Room.TYPE

	var counts:int= 0
	while campfire_below_4 or consecutive_camfire or consecutive_shop or campfire_on_13:
		counts+=1
		if counts >100:
			printerr(self.name ," counts >10")
		type_candidate = get_room_type()
		if next_floor <= 4 and type_candidate == Room.TYPE.CAMPFIRE:
			campfire_below_4 = true
		else:campfire_below_4 = false
		if current_room.type == Room.TYPE.CAMPFIRE and type_candidate == Room.TYPE.CAMPFIRE:
			consecutive_camfire =true
		else:consecutive_camfire = false
		if current_room.type == Room.TYPE.SHOP and type_candidate == Room.TYPE.SHOP:
			consecutive_shop = true
		else:consecutive_shop = false
		if next_floor == 12 and type_candidate == Room.TYPE.CAMPFIRE:
			campfire_on_13 = true
		else: campfire_on_13 = false
	return type_candidate

func get_room_type()->Room.TYPE:
	var roll:= randf_range(0.0, room_total_weight)
	for type:Room.TYPE in room_type_weight:
		if room_type_weight[type]> roll:
			return type
	return Room.TYPE.MONSTERS

func _randi_range_arr(from:int,to:int, lens:int)->Array[int]:
	var unique_nums:int= 0
	var nums:Array[int]=[]
	lens = clampi(lens, 0, to -from + 1)
	while unique_nums < lens:
		var rand_point:= randi_range(from, to)
		while nums.has(rand_point):
			rand_point = randi_range(from, to)
		nums.append(rand_point)
		unique_nums+=1
	return nums


func show_detail()-> Array[Array]:
	generate_map()
	#for _floor in FLOORS:
		#var output:=map_data[_floor].filter(
			#func(v:Room):
				#return v.type != Room.TYPE.UNSIGNED
				#)
		#print_debug("floor%s\t %s"% [_floor, output])
	return map_data
