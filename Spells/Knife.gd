extends Spell
class_name Knife

# Constructor.
func _init():
	spell_range = 1
	spell_action_points = 2	
	
# Gets the related action.
func get_action() -> String:
	return "cast_first_spell"

# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(25)
	
# Returns the string version of the spell.
func _to_string() -> String:
	return "Knife"
