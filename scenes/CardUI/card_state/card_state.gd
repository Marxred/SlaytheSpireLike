class_name CardState
extends Node
## 卡牌状态基类


signal transition_requested(from: CardState, to: State)

enum State{
	BASE, CLICKED, DRAGGING, AIMING, RELEASED
}

var card_ui: CardUI

@export var state: State


func enter()->void:
	pass


func exit()->void:
	pass


func on_input(_event: InputEvent)->void:
	pass


func on_gui_input(_event: InputEvent)->void:
	pass


func on_mouse_entered()->void:
	print("DB on_mouse_entered ", state)
	pass


func on_mouse_exited()->void:
	print("DB on_mouse_exited ", state)
	pass
