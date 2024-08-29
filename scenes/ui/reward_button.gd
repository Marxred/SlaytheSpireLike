class_name RewardButton
extends Button

@export var reward_icon:Texture:set= set_reward_icon
@export var reward_text:String:set=set_reward_text

@onready var custom_icon: TextureRect = $MarginContainer/HBoxContainer/CustomIcon
@onready var custom_text: Label = $MarginContainer/HBoxContainer/CustomText

func set_reward_icon(v:Texture)->void:
	reward_icon = v
	if not is_node_ready():
		await ready

	custom_icon.texture = reward_icon

func set_reward_text(v:String)->void:
	reward_text = v
	if not is_node_ready():
		await ready

	custom_text.text = reward_text



func _on_pressed() -> void:
	queue_free()

