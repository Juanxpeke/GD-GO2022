extends Entity
class_name Enemy

var is_agressive := true

# Called when the node enters the scene tree for the first time.
func _ready():
	spells = [LaserBeam.new()]

# Makes the best movement.
func make_best_movement(battle, board) -> void:
	while action_points > 0: 
		var best_score := 0
		var best_movement := []
		for cell_position in board.get_reachable_cells(movement_points, global_position):
			for spell in spells:
				if spell.spell_current_cooldown > 0:
					continue
				
				for spell_position in board.get_reachable_spell_cells(spell, cell_position):
					if not battle.get_player_position() == spell_position:
						continue
						
					else:
						pass
				
					
		make_movement(best_movement[0])
		cast_spell(best_movement[1], board.get_player())
		make_movement(best_movement[2])		
