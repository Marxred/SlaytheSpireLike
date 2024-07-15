class_name Hand
extends HBoxContainer
#手牌脚本
## 手牌处于拖拽状态时脱离父节点，取消手牌后回归。

var cards_played_this_turn: int = 0

func _ready() -> void:
	Events.card_played.connect(on_card_played)
	for child in get_children():
		var card_ui: = child as CardUI
		card_ui.parent = self
		card_ui.reparent_requested.connect(_on_reparent_requested)

func on_card_played(card: Card)->void:
	cards_played_this_turn += 1

func _on_reparent_requested(child: CardUI)->void:
	child.disabled = true
	child.reparent(self)
	var new_index: int = clampi(
				child.original_index - cards_played_this_turn,
				0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)
