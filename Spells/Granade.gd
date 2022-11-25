extends Spell
class_name Granade

# Constructor.
func _init():
	spell_range = 6
	spell_action_points = 5
	spell_cooldown = 1

# Gets the range cells of the spell in a given range index.
func get_index_range_cells(range_index : int) -> Array:
	assert(range_index >= 0, "Error: Spell range index must be equal or greater than 0.")
	if range_index == 0:
		return []
	else:
		var range_cells := [Vector2(0, range_index), Vector2(range_index, 0),
							Vector2(0, -range_index), Vector2(-range_index, 0)]
		for i in range(1, range_index):
			range_cells.append(Vector2(i, range_index - i))
		for i in range(1, range_index):
			range_cells.append(Vector2(range_index - i, -i))
		for i in range(1, range_index):
			range_cells.append(Vector2(-i, i - range_index))
		for i in range(1, range_index):
			range_cells.append(Vector2(i - range_index, i))
		return range_cells

# Gets the effect area cells of the spell.
func get_area_cells(origin_coord := Vector2(0, 0)) -> Array:
	var area_cells := []
	
	for j in range(1, 2):
		for i in j:
			area_cells.append(Vector2(i, j - i) + origin_coord)
		for i in j:
			area_cells.append(Vector2(j - i, -i) + origin_coord)
		for i in j:
			area_cells.append(Vector2(-i, i - j) + origin_coord)
		for i in j:
			area_cells.append(Vector2(i - j, i) + origin_coord)
			
	area_cells.append(Vector2(0, 0) + origin_coord)
	return area_cells
	
# Gets the related action.
func get_action() -> String:
	return "cast_fourth_spell"
	
# Applies its effect to the given entity
func apply_effect(entity) -> void:
	entity.take_damage(60)	
