extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

func _ready() -> void:
	Events.player_hited.connect(_on_player_hited)
	timer.timeout.connect(_on_timer_timeout)
	hide()

func _on_player_hited()->void:
	show()
	timer.start()

func _on_timer_timeout()->void:
	hide()
