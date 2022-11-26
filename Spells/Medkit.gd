extends Spell
class_name Medkit

# Constructor.
func _init():
	spell_range = 0
	spell_action_points = 4
	spell_cooldown = 4

# Gets the range cells of the spell in a given range index.
func get_index_range_cells(range_index : int) -> Array:
	assert(range_index >= 0, "Error: Spell range index must be equal or greater than 0.")
	return [Vector2(0, 0)]
	
# Gets the related action.
func get_action() -> String:
	return "cast_fifth_spell"

# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.heal(20)
	
# Returns the string version of the spell.
func _to_string() -> String:
	return "Medkit"
