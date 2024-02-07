class_name IdleState
extends MapState

var last_cell_center : Vector2 = Vector2(-1, -1)
var movement_path : Array[Vector2] = []

# Called when being selected as the new state
func enter() -> void:
	print("@@@ Entered idle state. @@@\n")

# Called when being removed as the current state
func exit() -> void:
	print("@@@ Exited idle state. @@@\n")
	last_cell_center = Vector2(-1, -1)
	GameManager.current_map.board.hide_movement_path()
	
# Called in the '_process()' callback
func update() -> void:
	
	var target_cell_center = GameManager.current_map.board.get_cell_centerp(GameManager.get_viewport().get_mouse_position())

	if target_cell_center != last_cell_center: 
		last_cell_center = target_cell_center
		GameManager.current_map.board.hide_movement_path()
		
		var points_path = GameManager.current_map.board.get_cells_centers_path(GameManager.current_player.global_position, target_cell_center)

		if points_path.size() > 0 and points_path.size() - 1 <= GameManager.current_player.current_movement_points:
			movement_path.assign(points_path.slice(1, points_path.size()))
			GameManager.current_map.board.show_movement_path(movement_path)
		else:
			movement_path = []

# Called in the '_input()' callback
func handle_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		GameManager.current_map.board.hide_movement_path()
		GameManager.current_player.make_movement(movement_path)
		movement_path = []
