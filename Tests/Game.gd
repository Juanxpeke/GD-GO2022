extends Node2D

onready var board = $Board
onready var player = $Board/Player
onready var line = $Line

var last_cell_position : Vector2
var player_movement_points := 3

func _process(delta):
	var mouse_isometric_position = cart2iso(get_viewport().get_mouse_position())
	var cell_isometric_position = (mouse_isometric_position / board.cell_size.y).floor() * board.cell_size.y
	var cell_cartisian_position = iso2cart(cell_isometric_position)
	
	if cell_cartisian_position != last_cell_position and board.get_cells_distance(player.global_position, cell_cartisian_position) <= player_movement_points:
		last_cell_position = cell_cartisian_position
		
		var path_points = board.get_astar_path(player.global_position, cell_cartisian_position)
		line.points = path_points
		


# Called when an input occurs.
func _input(event):
	if event.is_action_pressed("mouse_left"):
		var event_cartesian_position = cart2iso(event.position)
		var target_cart_cell_position = (event_cartesian_position / board.cell_size.y).floor() * board.cell_size.y
		var target_cell_position = iso2cart(target_cart_cell_position)

		var path_points = board.get_astar_path(player.global_position, target_cell_position)
		line.points = path_points
		player.global_position = path_points[-1]
		
# Converts from isometric coordinates to cartesian coordinates.
func iso2cart(iso_position : Vector2) -> Vector2:
	return Vector2(iso_position.x - iso_position.y, (iso_position.x + iso_position.y) / 2)

# Converts from cartesian coordinates to isometric coordinates.
func cart2iso(cart_position : Vector2) -> Vector2:
	return Vector2(cart_position.x / 2 + cart_position.y, -cart_position.x / 2 + cart_position.y)


