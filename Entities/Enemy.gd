extends Entity
class_name Enemy

var is_agressive := true

# Called when the node enters the scene tree for the first time.
func _ready():
	spells = [LaserBeam.new()]

# Makes the best movement.
func make_best_movement(battle, board) -> void:
	var best_score := 0
	var best_movement := []
	for cell_position in board.get_movement_positions():
		for spell in spells:
			if spell.spell_current_cooldown > 0:
				continue
			
			if not battle.get_player_position() in []:
				continue
				
			else:
				if false:
					pass
					
	make_movement(best_movement[0])
	cast_spell(best_movement[1])
	make_movement(best_movement[2])		
