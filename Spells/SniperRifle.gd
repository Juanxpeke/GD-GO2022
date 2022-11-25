extends Spell
class_name SniperRifle

# Constructor.
func _init():
	spell_range = 12
	spell_action_points = 4
	
# Gets the related action.
func get_action() -> String:
	return "cast_third_spell"

# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(90)
