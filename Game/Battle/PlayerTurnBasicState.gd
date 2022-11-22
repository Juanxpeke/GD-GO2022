extends BattleState

var last_cell : Vector2
var movement_path := []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_cell := board.get_cell_origin(get_viewport().get_mouse_position())
	
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
func _input(event):
	if event.is_action_pressed("mouse_left"):
		board.hide_movement_path()
		battle.substract_player_movement_points(movement_path.size()) 
		# walking_path = movement_path
		movement_path = []
		
	if event.is_action_pressed("ui_cancel"):
		pass
		# board.show_spell_range_cells(spell, player.global_position)
		#spell_active = true
		

