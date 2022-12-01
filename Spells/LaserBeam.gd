extends Spell
class_name LaserBeam

# Constructor.
func _init():
	spell_range = 5
	spell_action_points = 4
	spell_score_value = 10
	spell_cooldown = 2
	spell_sound = load("res://Assets/Audio/SFX/laser.wav")
	
# Gets the related action.
func get_action() -> String:
	return "cast_third_spell"

# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(120)

# Returns the string version of the spell.
func _to_string() -> String:
	return "LaserBeam"
