extends Spell
class_name Pistol

# Constructor.
func _init():
	spell_range = 8
	spell_action_points = 3
	
# Gets the related action.
func get_action() -> String:
	return "cast_second_spell"
	
# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(15)
