extends BattleState
class_name PlayerIdleState

var last_cell := Vector2(-1, -1)
var movement_path := []

# Inherited parent constructor.
func _init(battle, board):
	super(battle, board)

# Called when being selected as the new state.
func enter() -> void:
	print("@@@ Entered player idle state. @@@\n")

# Called when being removed as the current state.
func exit() -> void:
	print("@@@ Exited player idle state. @@@\n")
	last_cell = Vector2(-1, -1)
	board.hide_movement_path()
	
# Called every frame.
func update() -> void:
	if battle.get_player().in_animation:
		return
	
	if battle.total_sum == 0.0:
		pass
		#battle.to_enemy_state()
		#return
	
	#if battle.animation_state == battle.walking_state:
	#	return
	
	var target_cell := board.get_cell_origin(battle.get_viewport().get_mouse_position())
	
	# print("Target cell: ", target_cell)

	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_movement_path()
		
		var cells_path := board.get_cells_path(battle.get_player_position(), target_cell)
		
		if cells_path.size() > 0: print('Cells path: ', cells_path)

		if cells_path.size() > 0 and cells_path.size() - 1 <= battle.get_player_movement_points():
			movement_path = cells_path.slice(1, cells_path.size())
			board.show_movement_path(movement_path)
		else:
			movement_path = []

# Called when an input occurs.
func handle_input(event) -> void:
	if battle.get_player().in_animation:
		return
	
	#if battle.animation_state == battle.walking_state:
	#	return
	
	if event.is_action_pressed("mouse_left"):
		board.hide_movement_path()
		battle.get_player().make_movement(movement_path)
		movement_path = []
