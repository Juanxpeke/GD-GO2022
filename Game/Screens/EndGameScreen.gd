extends Control

var battle_scene := load("res://Game/Screens/StartScreen.tscn")

onready var try_again_button := $TryAgainButton


# Called when the node enters the scene tree for the first time.
func _ready():
	try_again_button.connect("mouse_entered", self, "zoom_button")
	try_again_button.connect("mouse_exited", self, "unzoom_button")
	try_again_button.connect("pressed", self, "to_battle_scene")

func zoom_button():
	try_again_button.rect_scale = Vector2(1.2, 1.2)

func unzoom_button():
	try_again_button.rect_scale = Vector2(1.0, 1.0)

func to_battle_scene():
	get_tree().change_scene_to(battle_scene)
