extends BattleState
class_name PlayerIdleState

var last_cell := Vector2(-1, -1)
var movement_path := []

# Inherited parent constructor.
func _init(battle, board).(battle, board):
	pass

# Called when being selected as the new state.
func enter() -> void:
	print("Entered player idle state.\n")

# Called when being removed as the current state.
func exit() -> void:
	print("Exited player idle state.\n")
	last_cell = Vector2(-1, -1)
	board.hide_movement_path()
	
# Called every frame.
func update() -> void:
	if battle.get_player().in_animation:
		return
	
	if battle.turn_timer.is_stopped():
		print("Timer stopped!")
		battle.to_enemy_state()
		return
	
	if battle.animation_state == battle.walking_state:
		return
		
	var target_cell := board.get_cell_origin(battle.get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_movement_path()
		
		var cells_path := board.get_cells_path(battle.get_player_position(), target_cell)

		if cells_path.size() > 0 and cells_path.size() - 1 <= battle.get_player_movement_points():
			movement_path = cells_path.slice(1, cells_path.size() - 1)
			board.show_movement_path(movement_path)
		else:
			movement_path = []

# Called when an input occurs.
func handle_input(event) -> void:
	if battle.get_player().in_animation:
		return
	
	if battle.animation_state == battle.walking_state:
		return
	
	if event.is_action_pressed("mouse_left"):
		board.hide_movement_path()
		battle.get_player().make_movement(movement_path)
		movement_path = []
		
	elif event.is_action_pressed("cast_first_spell"):
		battle.to_player_spell_state(battle.get_player_spell(0))
	
	elif event.is_action_pressed("cast_second_spell"):
		battle.to_player_spell_state(battle.get_player_spell(1))
		
	elif event.is_action_pressed("cast_third_spell"):
		battle.to_player_spell_state(battle.get_player_spell(2))

	elif event.is_action_pressed("cast_fourth_spell"):
		battle.to_player_spell_state(battle.get_player_spell(3))
		
	elif event.is_action_pressed("cast_fifth_spell"):
		battle.to_player_spell_state(battle.get_player_spell(4))
