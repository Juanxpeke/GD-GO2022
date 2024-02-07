extends Node

var audio_stream_player : AudioStreamPlayer = AudioStreamPlayer.new()

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	add_child(audio_stream_player)

# Public

# Plays the given sound
func play_sound(sound : AudioStream) -> void:
	audio_stream_player.stop()
	audio_stream_player.stream = sound
	audio_stream_player.play()
