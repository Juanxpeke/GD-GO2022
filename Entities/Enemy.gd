extends Entity
class_name Enemy

var is_agressive := true

# Called when the node enters the scene tree for the first time.
func _ready():
	spells = [LaserBeam.new()]

# Makes the best action for the current turn.
func make_best_action(battle, board) -> void:
	var can_do_something := true
	var min_distance : float = INF
	
	while can_do_something: 
		var best_score : float = -INF
		var best_cell_position := global_position
		var best_spell := Spell.new()
		var can_cast_spell := false
		
		for cell_position in board.get_cells_floodfill(global_position, movement_points):
			var current_score : float = 0.0
			var current_cell_position = cell_position
			
			var distance_path = board.get_cells_path(cell_position, battle.get_player_position())
			var current_raw_distance = board.get_raw_distance(cell_position, battle.get_player_position())
			
			if is_agressive:
				current_score -= (distance_path.size() - 1 + current_raw_distance) / 2
			else:
				current_score += (distance_path.size() - 1 + current_raw_distance) / 2
			
			if current_score > best_score:
				best_score = current_score
				best_cell_position = cell_position
			
			if distance_path.size() - 1 < min_distance:
				min_distance = distance_path.size() - 1
			
			for spell in spells:
				if spell.spell_current_cooldown > 0:
					continue
					
				if spell.spell_action_points > action_points:
					continue
				
				var enemy_coord = board.get_cell_coord(global_position)
				var cells_sight_areas = board.get_cells_sight_areas(spell.get_range_cells(enemy_coord), global_position)
	
				if board.get_cell_coord(battle.get_player_position()) in cells_sight_areas[0]:
					can_cast_spell = true
					current_score += spell.spell_score_value
	
					if current_score > best_score:
						best_score = current_score
						best_spell = spell

		print("Best movement: " + str(board.get_cell_coord(best_cell_position)))
				
		make_movement(board.get_cells_path(global_position, best_cell_position))
		cast_spell(best_spell, battle.get_player())

		print("Min distance: " + str(min_distance) + ", movement_points: " + str(movement_points) + ",")
		print(" can_cast_spell: " + str(can_cast_spell))
		
		if is_agressive and (min_distance == 0 or movement_points == 0)	and \
		not can_cast_spell:
			can_do_something = false
		
		elif not is_agressive and movement_points == 0 and not can_cast_spell:
			can_do_something = false
