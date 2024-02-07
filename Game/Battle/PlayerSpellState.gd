extends BattleState
class_name PlayerSpellState

var spell : Spell
var last_cell : Vector2

var area_effect_cells := []
var normal_mouse_cursor_image = load("res://Assets/Cursors/normal_cursor.png")

# Inherited parent constructor.
func _init(battle, board):
	super(battle, board)
	pass
		
# Called when being selected as the new state.
func enter() -> void:
	print("@@@ Entered player spell state. @@@\n")
	battle.current_spell = spell
	var player_coord := board.get_cell_coord(battle.get_player_position())
	var cells_sight_areas := board.get_cells_sight_areas(spell.get_range_cells(player_coord), battle.get_player_position())
	board.show_spell_range_cells(cells_sight_areas[0], cells_sight_areas[1])
	Input.set_custom_mouse_cursor(spell.spell_cursor_image)

# Called when being removed as the current state.
func exit() -> void:
	print("@@@ Exited player spell state. @@@\n")
	battle.current_spell = null
	board.hide_spell_range_cells()
	board.hide_spell_area_cells()
	Input.set_custom_mouse_cursor(normal_mouse_cursor_image)

# Called every frame.
func update() -> void:
	if battle.total_sum == 0.0:
		print("-> Timer stopped!\n")
		battle.to_enemy_state()
		return
	
	var target_cell := board.get_cell_origin(battle.get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_spell_area_cells()
		board.show_spell_area_cells(spell, target_cell)
		area_effect_cells = board.spells_area_board.get_used_cells(0)
				
# Called when an input occurs.
func handle_input(event) -> void:
	
	if event.is_action_pressed("mouse_left"):
		var target_cell = board.get_cell_coord(board.get_cell_origin(battle.get_viewport().get_mouse_position()))
		if target_cell in board.get_used_cells(0):
			battle.try_to_cast_spell(board.spells_area_board.get_used_cells(0), spell)
			battle.to_player_idle_state()

# Sets the related spell.
func set_spell(spell : Spell) -> void:
	self.spell = spell

