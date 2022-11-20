extends AnimatedSprite
class_name Spell

export var spell_name : String = 'Spell'
export var spell_action_points : int = 0
export var spell_range : int = 0
export var spell_icon_image : StreamTexture
export var spell_sound : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Gets the range cells of the spell in a given range index.
func get_range_cells(range_index : int) -> Array:
	assert(range_index >= 0, "Error: Spell range index must be equal or greater than 0.")
	if range_index == 0:
		return []
	else:
		return [Vector2(0,  range_index),
				Vector2( range_index, 0),
				Vector2(-range_index, 0),
				Vector2(0, -range_index)]
