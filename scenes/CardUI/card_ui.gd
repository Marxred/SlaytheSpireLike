class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)


const BASE_STYLE = preload("res://scenes/CardUI/card_base_stylebox.tres")
const DARGGING_STYLE = preload("res://scenes/CardUI/card_dragging_stylebox.tres")
const HOVER_STYLE = preload("res://scenes/CardUI/card_hover_stylebox.tres")
var parent:Control
var tween: Tween
var disabled: bool= false
var playable:bool= true: set = set_playable
func set_playable(v: bool)->void:
	playable = v
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		#icon.modulate = Color(1,1,1,0.5)
		icon.modulate.a = 0.5
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1,1,1,1)
		icon.modulate.a = 1


@export var char_stats: CharacterStats: set = set_char_stats
func set_char_stats(v: CharacterStats)->void:
	char_stats = v
	char_stats.stats_changed.connect(self.on_char_stats_changed)

func on_char_stats_changed()->void:
	self.playable = char_stats.can_play_card(card)


@export var card: Card: set= set_card
func set_card(v:Card)->void:
	if not is_node_ready():
		await self.ready
	card = v
	cost.text = str(card.cost)
	icon.texture = card.icon


@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []
@onready var panel: Panel = $Panel
@onready var icon: TextureRect = $Icon
@onready var cost: Label = $Cost
@onready var original_index:int = self.get_index()

func _ready()->void:
	card_state_machine.init(self)
	Events.card_drag_started.connect(on_card_drag_or_aiming_started)
	Events.card_aim_started.connect(on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(on_card_drag_or_aiming_ended)
	Events.card_aim_ended.connect(on_card_drag_or_aiming_ended)

func on_card_drag_or_aiming_started(used_card: CardUI)->void:
	if used_card == self:
		return
	disabled = true

func on_card_drag_or_aiming_ended(_used_card: CardUI)->void:
	disabled = false
	self.playable = char_stats.can_play_card(card)


func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered()->void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited()->void:
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)


func animate_to_position(new_position: Vector2, duration: float)->void:
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self,"global_position", new_position, duration)
	await tween.finished


func play()->void:
	if not card:
		return
	card.play(targets,char_stats)
	queue_free()
