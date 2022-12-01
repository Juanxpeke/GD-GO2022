extends Spell
class_name Pistol

# Constructor.
func _init():
	spell_range = 8
	spell_action_points = 3
	spell_cooldown = 1
	spell_sound = load("res://Assets/Audio/SFX/pistol.wav")
	spell_cursor_image = load("res://Assets/Cursors/pistol_spell_cursor.png")
	
# Gets the related action.
func get_action() -> String:
	return "cast_second_spell"
	
# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(15)

# Returns the string version of the spell.
func _to_string() -> String:
	return "Pistol"
