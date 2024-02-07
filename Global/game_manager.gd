extends Node

signal current_map_setted
signal current_player_setted

var current_map : Map = null
var current_player : PlayerX = null

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body.


# Public

# Gets the current map
func get_current_map() -> Map:
	return current_map

# Sets the current map
func set_current_map(map : Map) -> void:
	current_map = map
	current_map_setted.emit()

# Gets the current player
func get_current_player() -> PlayerX:
	return current_player
	
# Sets the current player
func set_current_player(player : PlayerX) -> void:
	current_player = player
	current_player_setted.emit()
