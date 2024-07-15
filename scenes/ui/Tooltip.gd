class_name Tooltip
extends PanelContainer


var fade_time: float = 0.1
var buffer_time: float = 0.1
var is_visible: bool = false
var tween: Tween


@onready var tooltip_icon: TextureRect = $MarginContainer/V/TooltipIcon
@onready var tooltip_text_label: RichTextLabel = $MarginContainer/V/TooltipTextLabel

#加载入节点直接隐藏
func _ready() -> void:
	self.modulate = Color.TRANSPARENT
	hide()
	Events.card_tooltip_show.connect(show_tooltip)
	Events.card_tooltip_hide.connect(hide_tooltip)

#显示注释
func show_tooltip(icon: Texture, description: String)->void:
	tooltip_icon.texture = icon
	tooltip_text_label.text = description
	is_visible = true
	show_ani()
	print("DB show_tooltip")

func show_ani()->void:
	if tween:
		tween.kill()
	tween = (create_tween()
			.set_trans(Tween.TRANS_CUBIC)
			.set_ease(Tween.EASE_OUT_IN))
	tween.tween_callback(show)
	tween.tween_property(self, "modulate",Color.WHITE, fade_time)

#隐藏注释
func hide_tooltip()->void:
	is_visible = false
	get_tree().create_timer(buffer_time, false).timeout.connect(hide_ani)
	print("DB hide_tooltip")

func hide_ani()->void:
	
	if is_visible:
		return
	if tween:
		tween.kill()
	tween = (create_tween()
			.set_trans(Tween.TRANS_CUBIC)
			.set_ease(Tween.EASE_OUT_IN))
	tween.tween_property(self, "modulate",Color.TRANSPARENT, fade_time)
	tween.tween_callback(hide)
