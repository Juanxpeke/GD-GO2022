extends Node2D

onready var board : AStarTileMap = $GameBoard
onready var player = $GameBoard/Player

var last_cell : Vector2
var player_movement_points := 6
var walking_path := []

func _process(delta):
	var target_cell := board.get_cell_origin_by_pos(get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_path()	
		if board.has_cell_by_or(target_cell) and \
		board.get_cells_distance_by_or(player.global_position, target_cell) <= player_movement_points:
			board.show_path(player.global_position, target_cell)
	
	if walking_path.size() > 0:
		walk_to(walking_path, delta)

func walk_to(path : Array, delta):
	var closest_point : Vector2 = path[0]
	player.global_position += (closest_point - player.global_position).normalized() * delta * 300
	if closest_point.distance_to(player.global_position) < 5:
		player.global_position = closest_point
		path.remove(0)

# Called when an input occurs.
func _input(event):
	if event.is_action_pressed("mouse_left") and \
	board.has_cell_by_or(last_cell) and \
	board.get_cells_distance_by_or(player.global_position, last_cell) <= player_movement_points:
		walking_path = board.get_cells_path_by_or(player.global_position, last_cell)
		
