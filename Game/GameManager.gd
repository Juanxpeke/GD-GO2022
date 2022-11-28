extends Node

# Plays an audio stream
static func play(audio : AudioStream) -> void:
	var audio_player := AudioStreamPlayer.new()
	GameManager.add_child(audio_player)
	audio_player.bus = "SFX"
	audio_player.stream = audio
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()
