extends Object
class_name Spell

signal animation_ended

var spell_name : String = 'Spell'
var spell_action_points : int = 0
var spell_range : int = 0
var spell_icon_image : StreamTexture
var spell_sound : AudioStream

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
	
# Gets the related action.
func get_action() -> String:
	return ""

func apply_effect(cell) -> void:
	print("Pium! Die " + str(cell))
	
func show_animation() -> void:
	emit_signal("animation_ended")
