class_name Hand
extends HBoxContainer
#手牌脚本
## 手牌处于拖拽状态时脱离父节点，取消手牌后回归。


@export var char_stats: CharacterStats
@onready var card_ui: PackedScene = preload("res://scenes/CardUI/card_ui.tscn")


func _ready() -> void:
#	Events.card_played.connect(on_card_played)
	pass


var cards_played_this_turn: int = 0
func on_card_played(_card: Card)->void:
	cards_played_this_turn += 1


func discard_card(card: CardUI)->void:
	card.queue_free()

func disabled_hand()->void:
	for card: CardUI in get_children():
		card.disabled = true


func add_card(card: Card)->void:
	var new_card:CardUI= card_ui.instantiate()
	new_card.parent = self
	new_card.card = card
	new_card.char_stats = self.char_stats
	new_card.reparent_requested.connect(_on_reparent_requested2)
	add_child(new_card)


func _on_reparent_requested1(child: CardUI)->void:
	child.disabled = true
	child.reparent(self)
	var new_index: int = clampi(
				child.original_index - cards_played_this_turn,
				0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)

func _on_reparent_requested2(child: CardUI)->void:
	child.disabled = true
	child.reparent(self)
	for child_index: CardUI in get_children():
		if child.original_index - child_index.original_index < 0:
			move_child.call_deferred(child, (child_index.get_index()))
			child.set_deferred("disabled", false)
			return
	move_child.call_deferred(child, self.get_child_count() - 1)
	child.set_deferred("disabled", false)
	return
