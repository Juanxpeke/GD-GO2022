extends Spell

# Gets the range cells of the spell in a given range index.
func get_range_cells(range_index : int) -> Array:
	assert(range_index >= 0, "Error: Spell range index must be equal or greater than 0.")
	if range_index == 0:
		return []
	else:
		var range_cells := []
		for i in range_index + 1:
			range_cells.append(Vector2(i, range_index - i))
		for i in range_index + 1:
			range_cells.append(Vector2(range_index - i, -i))
		for i in range_index + 1:
			range_cells.append(Vector2(-i, i - range_index))
		for i in range_index + 1:
			range_cells.append(Vector2(i - range_index, i))
		return range_cells
