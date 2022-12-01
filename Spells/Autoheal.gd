extends Spell
class_name Autoheal

# Constructor.
func _init():
	spell_range = 0
	spell_action_points = 4
	spell_score_value = 3
	spell_cooldown = 3
	spell_sound = load("res://Assets/Audio/SFX/autoheal.wav")

# Gets the range cells of the spell in a given range index.
func get_index_range_cells(range_index : int) -> Array:
	assert(range_index >= 0, "Error: Spell range index must be equal or greater than 0.")
	return [Vector2(0, 0)]

# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.heal(70)
	
# Returns the string version of the spell.
func _to_string() -> String:
	return "Autoheal"
