extends Node2D

onready var board = $Board
onready var player = $Player
onready var line = $Line


func _input(event):
	if event.is_action_pressed("mouse_left"):
		var event_cartesian_position = cart2iso(event.position)
		var target_cart_cell_position = (event_cartesian_position / board.cell_size.y).floor() * board.cell_size.y
		var target_cell_position = iso2cart(target_cart_cell_position)

		var path_points = board.get_astar_path(player.global_position, target_cell_position)
		print("Path points :" + str(path_points) + "\n")
		line.position = Vector2(0, board.cell_size.y / 2) # Use offset to move line to center of tiles
		line.points = path_points
	
	if event.is_action_pressed("mouse_right"):
		line.points = []
		
# Converts from isometric coordinates to cartesian coordinates.
func iso2cart(iso_position):
	return Vector2(iso_position.x - iso_position.y, (iso_position.x + iso_position.y) / 2)

# Converts from cartesian coordinates to isometric coordinates.
func cart2iso(cart_position):
	return Vector2(cart_position.x / 2 + cart_position.y, -cart_position.x / 2 + cart_position.y)


