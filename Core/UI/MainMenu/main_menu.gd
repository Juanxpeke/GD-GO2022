class_name MainMenu
extends Control

var game_scene := load("res://Core/Maps/map.tscn")

@onready var start_game_button := %StartGameButton

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	start_game_button.pressed.connect(_on_start_game_button_pressed)

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

# Public

