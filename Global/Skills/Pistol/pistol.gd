class_name PistolX
extends Skill

# Public

# Gets the range cells of the skill in a given range index
func get_index_range_cells(range_index : int) -> Array[Vector2i]:
	assert(range_index >= 0, "Error: Skill range index must be equal or greater than 0")
	
	if range_index == 0: return []
	
	return [
		Vector2i(range_index, 0),
		Vector2i(0, range_index),
		Vector2i(-range_index, 0),
		Vector2i(0, -range_index),
	]

# Gets the effect area cells of the skill in a given area index
func get_index_area_cells(area_index : int) -> Array[Vector2i]:
	assert(area_index >= 0, "Error: Skill area index must be equal or greater than 0")
	return [Vector2i(0, 0)]

# Applies its effect to the given cell, the effect index is an indicator of the
# strength of the effect, being the biggest effect when its value is 0
func apply_effect(cell : Vector2i, effect_index : int = 0) -> void:
	var entity := GameManager.current_map.board.get_entity_at_cell(cell)
	if entity != null:
		entity.subtract_current_health_points(20)
