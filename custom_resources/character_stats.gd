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

## 设置法力
func set_mana(v: int)->void:
	mana = v
	stats_changed.emit()
## 回复法力
func reset_mana()->void:
	mana = MAX_MANA
## 检查该卡牌是否可以打出
func can_play_card(card:Card)->bool:
	return mana >= card.cost


func take_damage(damage: int)->void:
	var initial_health: int = health
	super(damage)
	if initial_health > health:
		Events.player_hited.emit()


func new_instance()->CharacterStats:
	var instance: CharacterStats = self.duplicate()
	instance.health = MAX_HEALTH
	instance.block = init_block
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
