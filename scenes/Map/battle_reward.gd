class_name BattleReward
extends Control


const REWARD_BUTTON = preload("res://scenes/ui/reward_button.tscn")
const GOLD_ICON = preload("res://art/gold.png")
const GOLD_TEXT = "{amounts} gold"

const CARD_ICON = preload("res://art/rarity.png")
const CARD_TEXT = "Add New Card"

@export var run_stats:RunStats
@export var char_stats:CharacterStats



@onready var rewards: VBoxContainer = $VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/Rewards

var card_reward_total_weight:=0.0
var card_rarity_weight:={
	Card.Rarity.COMMON:0.0,
	Card.Rarity.UNCOMMON:0.0,
	Card.Rarity.RARE:0.0,
}

func _ready() -> void:
	for node in rewards.get_children():
		node.queue_free()



func add_gold_rewards(amounts: int)->void:
	var gold_reward:RewardButton = REWARD_BUTTON.instantiate()
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT.format({"amounts": amounts})
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amounts))
	rewards.add_child.call_deferred(gold_reward)


func _on_gold_reward_taken(amounts: int)->void:
	if not run_stats:
		return
	run_stats.gold += amounts


func add_card_rewards()->void:
	var card_reward:RewardButton = REWARD_BUTTON.instantiate()
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)

const CARD_REWARDS = preload("res://scenes/ui/card_rewards.tscn")

func _show_card_rewards()->void:
#将card_rewards场景连接到此场景。实现随机抽牌，加入角色牌堆
	if not run_stats or not char_stats:
		return

	var card_rewards:CardRewards=CARD_REWARDS.instantiate()
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)

	var card_reward_array:Array[Card]=[]
	var available_cards:Array[Card]=char_stats.draftable_cards.cards.duplicate(true)

	for i in run_stats.card_rewards:
		_setup_card_chances()
		var roll:=randf_range(0.0, card_reward_total_weight)

		for rarity:Card.Rarity in card_rarity_weight:
			if card_rarity_weight[rarity]>roll:
				_modify_weight(rarity)
				var picked_card:= get_random_available_card(available_cards, rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break

	card_rewards.rewards = card_reward_array
	card_rewards.show_rewards()

func _setup_card_chances()->void:
	card_reward_total_weight = run_stats.common_weight + run_stats.uncommon_weight + run_stats.rare_weight
	card_rarity_weight[Card.Rarity.COMMON] = card_reward_total_weight - run_stats.rare_weight - run_stats.uncommon_weight
	card_rarity_weight[Card.Rarity.UNCOMMON] = card_reward_total_weight - run_stats.rare_weight
	card_rarity_weight[Card.Rarity.RARE] = card_reward_total_weight

func _modify_weight(rarity_rolled:Card.Rarity)->void:
	if rarity_rolled == Card.Rarity.RARE:
		run_stats.rare_weight = RunStats.BASE_RARE_WEIGHT
	else:
		run_stats.rare_weight = clampf(run_stats.rare_weight + 0.3, run_stats.BASE_RARE_WEIGHT, 5.0)

func get_random_available_card(available_cards:Array[Card], with_rarity:Card.Rarity)->Card:
	var all_possible_cards:= available_cards.filter(
		func(card:Card)->bool:
			return card.rarity == with_rarity
			)
	return all_possible_cards.pick_random()

func _on_card_reward_taken(card:Card)->void:
	if not char_stats or not card:
		return

	char_stats.deck.add_card(card)


func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()
