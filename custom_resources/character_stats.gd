class_name CharacterStats
extends Stats
## 角色状态类
## 扩展

@export var starting_deck: CardPile
@export var cards_per_turn: int
@export var MAX_MANA: int

var mana: int : set = set_mana
var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

func set_mana(v: int)->void:
	mana = v
	stats_changed.emit()
	
func reset_mana()->void:
	mana = MAX_MANA

func can_play_card(card:Card)->bool:
	return mana >= card.cost

func new_instance()->CharacterStats:
	var instance: CharacterStats = self.duplicate()
	instance.health = MAX_HEALTH
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
