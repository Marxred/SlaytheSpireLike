class_name Run
extends Node

@export var run_setup: RunStartup
var stats: RunStats
var char_stats:CharacterStats


var current_view_child:PackedScene:set = set_current_view_child
func set_current_view_child(scene:PackedScene)->Node:
	if current_view.get_child_count() > 0:
		for i in current_view.get_children():
			i.queue_free()
	var new_scene:= scene.instantiate()
	current_view.add_child(new_scene)
	current_view_child = scene
	return new_scene

@onready var campfire: Button = $Debug/Campfire
@onready var shop: Button = $Debug/Shop
@onready var battle: Button = $Debug/Battle
@onready var battle_reward: Button = $Debug/BattleReward
@onready var treasure_room: Button = $Debug/TreasureRoom

@onready var current_view: Node = $CurrentView
@onready var card_pile_opener: CardPileOpener = $TopBar/BarItems/CardPileOpener

@onready var card_pile_preview: Control = $TopBar/CardPilePreview
@onready var gold_ui: GoldUI = $TopBar/BarItems/GoldUI

const BATTLE_REWARD = preload("res://scenes/Map/battle_reward.tscn")
const CAMPFIRE = preload("res://scenes/Map/campfire.tscn")
#const MAP = preload("res://scenes/Map/map.tscn")
@onready var map: MAP = $Map

const SHOP = preload("res://scenes/Map/shop.tscn")
const TREASURE_ROOM = preload("res://scenes/Map/treasure_room.tscn")
const BATTLE = preload("res://scenes/Battle/battle.tscn")

func _ready() -> void:
	if not run_setup:
		printerr("no run_setup")
		return
	match run_setup.type:
		RunStartup.ENTER_GAME.NEW_RUN:
			char_stats = run_setup.char_stat.new_instance()
			_start_run()
		RunStartup.ENTER_GAME.CONTINUED_RUN:
			print_debug("load previous Run")


func _start_run()->void:
	stats = RunStats.new()
	setup_events_connections()
	setup_top_bar()
	#print_debug("TODO: procedurally generate map")
	map.create_new_map()


func setup_events_connections()->void:
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.campfire_exited.connect(_show_map)
	Events.battle_reward_exited.connect(_show_map)

	Events.battle_won.connect(set_current_view_child.bind(BATTLE_REWARD))
	Events.battle_won.connect(_on_battle_won)

	Events.treasure_room_exited.connect(_show_map)

func setup_top_bar()->void:
	gold_ui.run_stats = stats
	card_pile_opener.cardpile = char_stats.deck

func _on_battle_won()->void:
	var reward_scene:= set_current_view_child(BATTLE_REWARD) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.char_stats = char_stats
	#临时代码
	reward_scene.add_gold_rewards(77)
	reward_scene.add_card_rewards()
	reward_scene.add_card_rewards()



func _on_map_exited(room_ui:RoomUI)->void:
	print_debug("map exited")
	print_debug("enter %s"% room_ui.room)
	match room_ui.room.type:
		Room.TYPE.MONSTERS:
			current_view_child = BATTLE
		Room.TYPE.SHOP:
			current_view_child = SHOP
		Room.TYPE.TREASURE:
			current_view_child = TREASURE_ROOM
		Room.TYPE.CAMPFIRE:
			current_view_child = CAMPFIRE
		Room.TYPE.BOSS:
			current_view_child = BATTLE
	_hide_map()

func _hide_map():
	map.hide_map()

func _on_campfire_pressed() -> void:
	current_view_child = CAMPFIRE

func _on_shop_pressed() -> void:
	current_view_child = SHOP


func _on_battle_pressed() -> void:
	current_view_child = BATTLE


func _on_battle_reward_pressed() -> void:
	current_view_child = BATTLE_REWARD


func _on_treasure_room_pressed() -> void:
	current_view_child = TREASURE_ROOM


func _on_map_pressed() -> void:
	#current_view_child = MAP
	_show_map()

func _show_map()->void:
	if current_view.get_child_count()>0:
		current_view.get_child(0).queue_free()
	map.show_map()
