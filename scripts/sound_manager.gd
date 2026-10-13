extends Node

# Plays a sound file once from code and cleans itself up automatically.
func play(stream: AudioStream, compound: bool = true) -> void:
	if not compound:
		var streams := get_children(false)
		for s in streams:
			if s.stream == stream:
				s.stop()
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "Master"
	player.volume_db = -6
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
