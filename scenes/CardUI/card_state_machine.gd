class_name CardStateMachine
extends Node
## 集中管理卡片状态
## 进行切换状态 和 设备输入

@export var initial_state: CardState

var current_state: CardState
var states: Dictionary = {}

func init(card: CardUI)->void:
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card
	if initial_state:
		initial_state.enter()
		current_state = initial_state

##调用当前状态的输入
func on_input(event: InputEvent)->void:
	if current_state:
		current_state.on_input(event)
##调用状态gui输入
func on_gui_input(event: InputEvent)->void:
	if current_state:
		current_state.on_gui_input(event)
## 鼠标输入
func on_mouse_entered()->void:
	if current_state:
		current_state.on_mouse_entered()

func on_mouse_exited()->void:
	if current_state:
		current_state.on_mouse_exited()

## 状态切换，退出当前状态，进入新状态
func _on_transition_requested(from: CardState, to: CardState.State)->void:
	if from != current_state:
		return	
	var new_state: CardState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
