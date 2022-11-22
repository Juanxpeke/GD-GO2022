extends BattleState

var spell : Spell
var last_cell : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_cell := board.get_cell_origin(get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_spell_area_cells()
		board.show_spell_area_cells(spell, target_cell)
				
# Called when an input occurs.
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		board.hide_spell_range_cells()
		board.hide_spell_area_cells()
		# spell_active = false
