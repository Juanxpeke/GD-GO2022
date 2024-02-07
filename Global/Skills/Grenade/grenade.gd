class_name Grenade
extends Skill

# Public

# Gets the range cells of the skill in a given range index
func get_index_range_cells(range_index : int) -> Array[Vector2i]:
	assert(range_index >= 0, "Error: Skill range index must be equal or greater than 0")
	
	if range_index == 0: return []
	
	var range_cells : Array[Vector2i] = [
		Vector2i(0, range_index),
		Vector2i(range_index, 0),
		Vector2i(0, -range_index),
		Vector2i(-range_index, 0),
	]
	
	for i in range(1, range_index):
		range_cells.append(Vector2i(i, range_index - i))
	for i in range(1, range_index):
		range_cells.append(Vector2i(range_index - i, -i))
	for i in range(1, range_index):
		range_cells.append(Vector2i(-i, i - range_index))
	for i in range(1, range_index):
		range_cells.append(Vector2i(i - range_index, i))
		
	return range_cells

# Gets the effect area cells of the skill in a given area index
func get_index_area_cells(area_index : int) -> Array[Vector2i]:
	assert(area_index >= 0, "Error: Skill area index must be equal or greater than 0")
	
	if area_index == 0: return [Vector2i(0, 0)]
	
	var area_cells : Array[Vector2i] = [
		Vector2i(0, area_index),
		Vector2i(area_index, 0),
		Vector2i(0, -area_index),
		Vector2i(-area_index, 0),
	]
	
	for i in range(1, area_index):
		area_cells.append(Vector2i(i, area_index - i))
	for i in range(1, area_index):
		area_cells.append(Vector2i(area_index - i, -i))
	for i in range(1, area_index):
		area_cells.append(Vector2i(-i, i - area_index))
	for i in range(1, area_index):
		area_cells.append(Vector2i(i - area_index, i))
		
	return area_cells

# Applies its effect to the given cell, the effect index is an indicator of the
# strength of the effect, being the biggest effect when its value is 0
func apply_effect(cell : Vector2i, effect_index : int = 0) -> void:
	var entity := GameManager.current_map.board.get_entity_at_cell(cell)
	if entity != null:
		entity.subtract_current_health_points(100 * (1 - 0.1 * effect_index)) 
