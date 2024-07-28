extends HBoxContainer


@onready var icon: TextureRect = $Icon
@onready var text: Label = $Text


func _update_intent(intent: Intent)->void:
	if not intent:
		hide()
		return
	icon.texture = intent.icon
	text.text = str(intent.number)
	show()
