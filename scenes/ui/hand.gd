extends HBoxContainer


func _ready() -> void:
	for child in get_children():
		var card_ui: = child as CardUI
		card_ui.parent = self
		card_ui.reparent_requested.connect(_on_reparent_requested)

func _on_reparent_requested(child: CardUI)->void:
	child.reparent(self)

#手牌脚本
## 手牌处于拖拽状态时脱离父节点，取消手牌后回归。
