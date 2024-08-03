class_name Run
extends Node

@export var run_setup: RunStartup

const BATTLE_REWARD = preload("res://scenes/Map/battle_reward.tscn")
const CAMPFIRE = preload("res://scenes/Map/campfire.tscn")
const MAP = preload("res://scenes/Map/map.tscn")
const SHOP = preload("res://scenes/Map/shop.tscn")
const TREASURE_ROOM = preload("res://scenes/Map/treasure_room.tscn")
const BATTLE = preload("res://scenes/Battle/battle.tscn")

var current_view_child:PackedScene:set = set_current_view_child

func set_current_view_child(scene:PackedScene)->void:
	if current_view.get_child_count() > 0:
		for i in current_view.get_children():
			i.queue_free()
	current_view.add_child(scene.instantiate())


@onready var current_view: Node = $CurrentView

@onready var campfire: Button = $Debug/Campfire
@onready var shop: Button = $Debug/Shop
@onready var battle: Button = $Debug/Battle
@onready var battle_reward: Button = $Debug/BattleReward
@onready var treasure_room: Button = $Debug/TreasureRoom

var char_stats:CharacterStats

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
	setup_events_connections()
	print_debug("TODO: procedurally generate map")

func setup_events_connections()->void:
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(set_current_view_child.bind(MAP))
	Events.campfire_exited.connect(set_current_view_child.bind(MAP))
	Events.battle_reward_exited.connect(set_current_view_child.bind(MAP))
	Events.battle_won.connect(set_current_view_child.bind(BATTLE_REWARD))
	Events.treasure_room_exited.connect(set_current_view_child.bind(MAP))

func _on_map_exited()->void:
	print_debug("map exited")

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
	current_view_child = MAP
