extends Spell
class_name LaserBeam

# Constructor.
func _init():
	spell_range = 6
	spell_action_points = 2
	
# Gets the related action.
func get_action() -> String:
	return "cast_second_spell"
