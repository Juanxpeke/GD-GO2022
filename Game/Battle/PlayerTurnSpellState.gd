extends BattleState
class_name PlayerTurnSpellState

var spell : Spell
var last_cell : Vector2

var area_effect_cells := []

# Inherited parent constructor.
func _init(battle, board).(battle, board):
	pass
	
# Sets the related spell.
func set_spell(spell : Spell) -> void:
	self.spell = spell
	
# Called when being selected as the new state.
func enter() -> void:
	board.show_spell_range_cells(spell, battle.get_player_position())

# Called when being removed as the current state.
func exit() -> void:
	board.hide_spell_range_cells()
	board.hide_spell_area_cells()

# Called every frame.
func update() -> void:
	var target_cell := board.get_cell_origin(battle.get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_spell_area_cells()
		board.show_spell_area_cells(spell, target_cell)
		area_effect_cells = board.spells_area_board.get_used_cells()
				
# Called when an input occurs.
func handle_input(event) -> void:
	if event.is_action_pressed(spell.get_action()):
		battle.to_idle_state()
	
	elif event.is_action_pressed("mouse_left"):
		battle.try_to_cast_spell(board.spells_area_board, spell)
		battle.to_idle_state()
		
	elif event.is_action_pressed("cast_first_spell"):
		battle.to_spell_state(battle.get_player_spell(0))
		
	elif event.is_action_pressed("cast_second_spell"):
		battle.to_spell_state(battle.get_player_spell(1))
		
	elif event.is_action_pressed("cast_third_spell"):
		battle.to_spell_state(battle.get_player_spell(2))

	elif event.is_action_pressed("cast_fourth_spell"):
		battle.to_spell_state(battle.get_player_spell(3))
