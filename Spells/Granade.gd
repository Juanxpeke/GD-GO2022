extends Spell
class_name Granade

# Constructor.
func _init():
	spell_range = 6
	spell_action_points = 5
	spell_cooldown = 2
	spell_sound = load("res://Assets/Audio/SFX/granade.wav")
	spell_cursor_image = load("res://Assets/Cursors/granade_spell_cursor.png")

# Gets the range cells of the spell in a given range index.
func get_index_range_cells(range_index : int) -> Array[Vector2i]:
	assert(range_index >= 0) #,"Error: Spell range index must be equal or greater than 0.")
	if range_index == 0:
		return []
	else:
		var range_cells := [Vector2i(0, range_index), Vector2i(range_index, 0),
							Vector2i(0, -range_index), Vector2i(-range_index, 0)]
		for i in range(1, range_index):
			range_cells.append(Vector2i(i, range_index - i))
		for i in range(1, range_index):
			range_cells.append(Vector2i(range_index - i, -i))
		for i in range(1, range_index):
			range_cells.append(Vector2i(-i, i - range_index))
		for i in range(1, range_index):
			range_cells.append(Vector2i(i - range_index, i))
		return range_cells

# Gets the effect area cells of the spell.
func get_area_cells(origin_coord := Vector2i(0, 0)) -> Array[Vector2i]:
	var area_cells : Array[Vector2i] = []
	
	for j in range(1, 2):
		for i in j:
			area_cells.append(Vector2i(i, j - i) + origin_coord)
		for i in j:
			area_cells.append(Vector2i(j - i, -i) + origin_coord)
		for i in j:
			area_cells.append(Vector2i(-i, i - j) + origin_coord)
		for i in j:
			area_cells.append(Vector2i(i - j, i) + origin_coord)
			
	area_cells.append(Vector2i(0, 0) + origin_coord)
	return area_cells
	
# Gets the related action.
func get_action() -> String:
	return "cast_third_spell"
	
# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(60)
	
# Returns the string version of the spell.
func _to_string() -> String:
	return "Granade"
