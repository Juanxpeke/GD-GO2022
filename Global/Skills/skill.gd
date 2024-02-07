class_name Skill
extends Resource

@export var name : String = 'Skill'
@export var action_points : int = 0
@export var range : int = 0
@export var area : int = 0
@export var cooldown : int = 0
@export var icon : Texture2D
@export var sound : AudioStream
@export var animation_action : String = ''

var current_map_cooldowns : Dictionary = {}

# Private

# Returns the string version of the skill
func _to_string() -> String:
	return "Skill"

# Public

# Gets the range cells of the skill in a given range index
func get_index_range_cells(range_index : int) -> Array[Vector2i]:
	assert(range_index >= 0, "Error: Skill range index must be equal or greater than 0")
	return []

# Gets all the range cells of the skill
func get_range_cells(origin_cell := Vector2i(0, 0)) -> Array[Vector2i]:
	var range_cells : Array[Vector2i] = []
	for range_index in range + 1:
		for cell in get_index_range_cells(range_index):
			range_cells.append(cell + origin_cell)
	return range_cells

# Gets the effect area cells of the skill in a given area index
func get_index_area_cells(area_index : int) -> Array[Vector2i]:
	assert(area_index >= 0, "Error: Skill area index must be equal or greater than 0")
	return []

# Gets the effect area cells of the skill
func get_area_cells(origin_cell := Vector2i(0, 0)) -> Array[Vector2i]:
	var area_cells : Array[Vector2i] = []
	for area_index in area + 1:
		for cell in get_index_area_cells(area_index):
			area_cells.append(cell + origin_cell)
	return area_cells

# Applies its effect to the given cell, the effect index is an indicator of the
# strength of the effect, being the biggest effect when its value is 0
func apply_effect(cell : Vector2i, effect_index : int = 0) -> void:
	pass

# Applies its effect to the area cells using the area index as the effect index
func apply_area_effect(origin_cell := Vector2i(0, 0)) -> void:
	for area_index in area + 1:
		for cell in get_index_area_cells(area_index):
			apply_effect(cell + origin_cell, area_index)
