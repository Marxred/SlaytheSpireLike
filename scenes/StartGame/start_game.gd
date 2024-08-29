extends Control

const CHAR_SELECTOR = preload("res://scenes/StartGame/char_selector.tscn")


func _on_new_game_pressed() -> void:
	print_debug("start a new run")
	get_tree().change_scene_to_packed(CHAR_SELECTOR)


func _on_continue_pressed() -> void:
	print_debug("continue run")


func _on_quit_pressed() -> void:
	print_debug("quit game")
	get_tree().quit()
