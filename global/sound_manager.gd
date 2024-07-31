extends Node

func play(music: AudioStream, single: bool = false)->void:
	if not music:
		print("DB no music")
		return
	if single:
		stop()
		var player = get_child(0) as AudioStreamPlayer
		player.stream = music
		player.play()
		
	for player:AudioStreamPlayer in get_children():
		if not player.is_playing():
			player.stream = music
			player.play()
			return
		elif player.stream == music:
			player.play()
			return


func stop()->void:
	for player:AudioStreamPlayer in get_children():
		player.stop()
