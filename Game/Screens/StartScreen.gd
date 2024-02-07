extends Control

@export var battle_scene : PackedScene = preload("res://Game/Battle/Battle.tscn")

# Called when an input occurs.
func _input(event):
	if event is InputEventKey:
		get_tree().change_scene_to_packed(battle_scene)
