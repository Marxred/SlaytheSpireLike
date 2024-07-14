extends Node2D
## 卡牌目标选择器，使用Events全局脚本
## 在卡牌进入瞄准状态时发出信号调用_on_card_aim_started
## 在屏幕上绘制起点到终点的三次曲线
## 退出瞄准状态时调用_on_card_aim_ended

const ARC_POINTS: int = 8

@onready var area_2d: Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

var current_card: CardUI
var targeting: bool = false

##连接全局类的信号
func _ready()->void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)
## 进入瞄准状态实时更新曲线
func _process(_delta: float) -> void:
	if not targeting:
		return
	area_2d.position = get_local_mouse_position()
	card_arc.points = _get_points()
## 一共ARC_POINTS + 2 个点，相邻点之间x方向等距，y方向为 1 - （1-n%）^3
func _get_points()->PackedVector2Array:
	var points:Array=[]
	var start:Vector2 = current_card.global_position
	start.x += current_card.size.x /2
	#var target :Vector2 = get_local_mouse_position()## 使用local会使用相对坐标,返回相对于CardTargetSelector的坐标
	var target :Vector2 = get_global_mouse_position()## line2D节点在canvaslayer节点下，如果移动CardTargetSelector相对坐标就改变了。所以需要使用global_position
	var distance:Vector2 = target - start
	
	for i in range(ARC_POINTS):
		var t: float = (1.0/ ARC_POINTS) *i
		var x: float = start.x + (distance.x /ARC_POINTS) *i
		var y: float = start.y + ease_out_cubic(t) *distance.y
		points.append(Vector2(x, y))
	
	points.append(target)
	return points

func ease_out_cubic(number: float)-> float:
	return 1.0 - pow(1.0 - number, 3.0)

## 进入瞄准状态
func _on_card_aim_started(card:CardUI)->void:
	if not card.card.is_single_targeted():
		return
	
	targeting = true
	area_2d.monitorable = true
	area_2d.monitoring = true
	current_card = card
## 退出瞄准状态
func _on_card_aim_ended(card:CardUI)->void:
	targeting = false
	area_2d.monitorable = false
	area_2d.monitoring = false
	card_arc.clear_points()
	area_2d.position = Vector2.ZERO
	current_card = null

## 目标进入区域，添加目标
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	if not current_card.targets.has(area):
		current_card.targets.append(area)
## 目标退出区域，删除目标
func _on_area_2d_area_exited(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	if current_card.targets.has(area):
		current_card.targets.erase(area)
