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
func get_index_range_cells(range_index : int) -> Array:
	assert(range_index >= 0, "Error: Spell range index must be equal or greater than 0.")
	if range_index == 0:
		return []
	else:
		return [Vector2(0,  range_index),
				Vector2( range_index, 0),
				Vector2(-range_index, 0),
				Vector2(0, -range_index)]

# Gets all the range cells of the spell.
func get_range_cells(origin_coord := Vector2(0, 0)) -> Array:
	var range_cells := []
	for range_index in spell_range + 1:
		for cell_coord in get_index_range_cells(range_index):
			range_cells.append(cell_coord + origin_coord)
	return range_cells

# Gets the effect area cells of the spell.
func get_area_cells(origin_coord := Vector2(0, 0)) -> Array:
	var area_cells := []
	area_cells.append(Vector2(0, 0) + origin_coord)
	return area_cells
	
	
	
	
