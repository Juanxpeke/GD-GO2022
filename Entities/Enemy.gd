extends Entity
class_name Enemy

var is_agressive := true

# Called when the node enters the scene tree for the first time.
func _ready():
	spells = [LaserBeam.new()]

# Makes the best action for the current turn.
func make_best_action(battle, board) -> void:
	if get_health_points() <= total_health_points / 3:
		is_agressive = false
	else:
		is_agressive = true
	
	print("-> Calculating best action with player position: " + str(board.get_cell_coord(battle.get_player_position())) + ", enemy position: " + str(board.get_cell_coord(global_position)) + "\n")

	var best_score : int = -INF
	var best_cell_position := global_position
	var best_spell := Spell.new()
	var can_cast_spell := false
	
	for cell_position in board.get_cells_floodfill(global_position, movement_points):
		var current_score : int = 0
		var current_cell_position = cell_position
		
		var distance_path = board.get_cells_path_ignoring_unit(cell_position, battle.get_player_position(), battle.get_player())
		
		if is_agressive:
			current_score -= distance_path.size() - 1
		else:
			current_score += distance_path.size() - 1 + board.get_raw_distance(cell_position, battle.get_player_position())
		
		if current_score > best_score:
			best_score = current_score
			best_cell_position = cell_position
		
		for spell in spells:
			if spell.spell_current_cooldown > 0:
				continue
				
			if spell.spell_action_points > action_points:
				continue
			
			var enemy_coord = board.get_cell_coord(cell_position)
			var cells_sight_areas = board.get_cells_sight_areas(spell.get_range_cells(enemy_coord), global_position)

			if board.get_cell_coord(battle.get_player_position()) in cells_sight_areas[0]:

				can_cast_spell = true
				current_score += spell.spell_score_value

				if current_score > best_score:
					best_score = current_score
					best_cell_position = cell_position
					best_spell = spell

	print("-> Best movement: " + str(board.get_cell_coord(best_cell_position)))
			
	make_movement(board.get_cells_path(global_position, best_cell_position))
	
	print("-> Best spell: " + str(best_spell))

	cast_spell(best_spell, [board.get_cell_coord(battle.get_player_position())], board)

	print("-> Movement points: " + str(movement_points) + ", can cast spell: " + str(can_cast_spell) + "\n")
