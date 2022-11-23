extends Spell
class_name LaserBeam

# Constructor.
func _init():
	spell_range = 6
	
# Gets the related action.
func get_action() -> String:
	return "cast_second_spell"
