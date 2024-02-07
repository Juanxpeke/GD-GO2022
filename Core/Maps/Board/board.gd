class_name Board
extends TileMap

enum Layer {
	BASE_LAYER,
	MOVEMENT_LAYER,
	SKILL_RANGE_LAYER,
	SKILL_AREA_LAYER,
	OBSTACLE_LAYER,
}

const TILES = {
	'BASE': Vector2i(0, 0), 
	'MOVEMENT': Vector2i(1, 0), 
	'SKILL_RANGE': Vector2i(2, 1),
	'SKILL_RANGE_BLOCKED': Vector2i(2, 0), 
	'SKILL_AREA': Vector2i(1, 1),
}

const DIRECTIONS := [
	Vector2i.RIGHT - Vector2i(1, 0),
	Vector2i.UP - Vector2i(1, 0),
	Vector2i.LEFT - Vector2i(1, 0),
	Vector2i.DOWN - Vector2i(1, 0),
]

var astar : AStar2D = AStar2D.new()
var entities : Array[EntityX] = []

# Called when the node is added to the scene tree
func _ready() -> void:
	refill_astar_points()
	set_obstacle_points_disabled(true)

#region Base Cells Methods

# Given a cell center, returns a unique identifier. It uses improved Szudzik pair 
# algorithm to calculate the ID, and first transforms the center position to the
# correspondent cell, in order reduce the IDs values
func get_cell_id(cell_center : Vector2) -> int:
	var cell = get_cell(cell_center)
	var x : int = cell.x
	var y : int = cell.y
	
	var a := x * 2 if x >= 0 else (x * -2) - 1
	var b := y * 2 if y >= 0 else (y * -2) - 1
	var c = (a * a) + a + b if a >= b else (b * b) + a
	
	if a >= 0 and b < 0 or b >= 0 and a < 0:
		return -c - 1
	
	return c

# Given a position in the board, it returns the cell that covers that position
func get_cell(position : Vector2) -> Vector2i:
	return local_to_map(to_local(position))

# Given a cell in the board, it returns the center position of the cell
func get_cell_center(cell : Vector2i) -> Vector2:
	return global_position + map_to_local(cell)
	
# Given a position in the board, it returns the center position of the cell that
# covers that position
func get_cell_centerp(position : Vector2) -> Vector2:
	return get_cell_center(get_cell(position))

# Returns an array with the center positions of all the base cells in the tilemap
func get_base_cells_centers() -> Array[Vector2]:
	var cells = get_used_cells(Layers.BASE_LAYER)
	var cells_centers : Array[Vector2]
	cells_centers.assign(cells.map(func(cell): return get_cell_center(cell)))
	return cells_centers

# Returns the cell distance between two cell centers
func get_cell_distance(start_center : Vector2, end_center : Vector2) -> float:
	var start_cell := get_cell(start_center)
	var end_cell := get_cell(end_center)
	return abs(start_cell.x - end_cell.x) + abs(start_cell.y - end_cell.y)

#endregion

#region AStar

# Refills the AStar graph with the tilemap cells origins and its cardinal conections
func refill_astar_points() -> void:
	astar.clear()
	var cell_centers = get_base_cells_centers()
	for cell_center in cell_centers:
		astar.add_point(get_cell_id(cell_center), cell_center)
	for cell_center in cell_centers:
		connect_astar_point(cell_center)

# Connects a point to its cardinal neighbors
func connect_astar_point(point_position : Vector2) -> void:
	var point_id := get_cell_id(point_position)
	for direction in DIRECTIONS:
		var cardinal_point_id := get_cell_id(point_position + map_to_local(direction))
		if cardinal_point_id != point_id and astar.has_point(cardinal_point_id):
			astar.connect_points(point_id, cardinal_point_id, true)

# Marks the obstacles positions as disabled or enabled in the AStar graph
func set_obstacle_points_disabled(value: bool) -> void:
	for obstacle_cell in get_used_cells(Layers.OBSTACLE_LAYER):
		var obstacle_id = get_cell_id(get_cell_center(obstacle_cell))
		if astar.has_point(obstacle_id):
			astar.set_point_disabled(obstacle_id, value)

# Marks the entities positions as disabled or enabled in the AStar graph
func set_entity_points_disabled(value: bool) -> void:
	for entity in entities:
		astar.set_point_disabled(get_cell_id(entity.global_position), value)

# Returns true if the correspondent cell center is used in the AStar, false otherwise
func has_cell_center(cell_center : Vector2) -> bool:
	return astar.has_point(get_cell_id(cell_center))

# Returns an array with the centers positions of cells in a certain path
func get_cells_centers_path(start_center : Vector2, end_center : Vector2) -> Array: # Array[Vector2]
	if not has_cell_center(start_center) or not has_cell_center(end_center): return []
	set_entity_points_disabled(true)
	var cells_path : Array = astar.get_point_path(get_cell_id(start_center), get_cell_id(end_center))
	set_entity_points_disabled(false)
	return cells_path

#endregion

#region Rasterization

# Returns an array with the cells in the discrete line from cell (x0, y0) to 
# cell (x1, y1). Low part of modified Dofus' line algorithm
func get_cells_line_low(x0 : int, y0 : int, x1 : int, y1 : int) -> Array[Vector2i]:
	var cells_line : Array[Vector2i] = []
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var yi : int = 1
	
	if dy < 0:
		yi = -1
		dy = -dy
		
	var D : int = dy - dx
	var y : int = y0

	for x in range(x0, x1 + 1):
		cells_line.append(Vector2i(x, y))
		
		if D > 0:
			cells_line.append(Vector2i(x, y + yi))
			
			y = y + yi
			D = D + (2 * (dy - dx))
		elif D < 0:
			D = D + 2 * dy
		else:
			y = y + yi
			D = D + (2 * (dy - dx))
			
	return cells_line

# Returns an array with the cells in the discrete line from cell (x0, y0) to 
# cell (x1, y1). High part of modified Dofus' line algorithm
func get_cells_line_high(x0 : int, y0 : int, x1 : int, y1 : int) -> Array[Vector2i]:
	var cells_line : Array[Vector2i] = []
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var xi : int = 1
	
	if dx < 0:
		xi = -1
		dx = -dx

	var D : int = dx - dy
	var x : int = x0

	for y in range(y0, y1 + 1):
		cells_line.append(Vector2i(x, y))
		
		if D > 0:
			cells_line.append(Vector2i(x + xi, y))
			
			x = x + xi
			D = D + (2 * (dx - dy))
		elif D < 0:
			D = D + 2 * dx
		else:
			x = x + xi
			D = D + (2 * (dx - dy))
			
	return cells_line

# Returns an array with the cells in the discrete line from start_cell to end_cell,
# it uses a modified version of the Bresenham's line algorithm divided in different
# cases, trying to replicate Dofus' behaviour
func get_cells_line(start_cell : Vector2i, end_cell : Vector2i) -> Array[Vector2i]:
	var x0 : int = start_cell[0]
	var y0 : int = start_cell[1]
	var x1 : int = end_cell[0]
	var y1 : int = end_cell[1]
	
	if abs(y1 - y0) < abs(x1 - x0):
		if x0 > x1:
			return get_cells_line_low(x1, y1, x0, y0)
		else:
			return get_cells_line_low(x0, y0, x1, y1)
	else:
		if y0 > y1:
			return get_cells_line_high(x1, y1, x0, y0)
		else:
			return get_cells_line_high(x0, y0, x1, y1)

# Returns an array with two arrays. The arrays tells if their cells are reachable or not by a cell
# line, respectively. It uses a modified version of the Bresenham's line algorithm, divided in 
# different cases, trying to replicate Dofus' behaviour
func get_cells_sight_areas(cells : Array[Vector2i], origin : Vector2) -> Array:
	var origin_cell := get_cell(origin)
	var base_cells := get_used_cells(Layers.BASE_LAYER)
	var obstacle_cells := get_used_cells(Layers.OBSTACLE_LAYER)
	var free_cells := []
	var blocked_cells := []
	
	for cell in cells:
		if !(cell in base_cells): continue
		
		var cells_line := get_cells_line(origin_cell, cell)
		var is_cell_blocked := false

		for obstacle_cell in obstacle_cells:
			if obstacle_cell in cells_line:
				is_cell_blocked = true
				break

		for entity in entities:
			if is_cell_blocked: break
			
			var entity_cell := get_cell(entity.global_position)
			if  entity_cell in cells_line and entity_cell != origin_cell and entity_cell != cell:
				is_cell_blocked = true
				break
	
		if is_cell_blocked:
			blocked_cells.append(cell)
		else:
			free_cells.append(cell)
		
	return [free_cells, blocked_cells]

# Returns a filtered array with only the cells that are base cells
func get_filtered_base_cells(cells : Array[Vector2i]) -> Array[Vector2i]:
	var base_cells := get_used_cells(Layers.BASE_LAYER)
	var filtered_cells : Array[Vector2i] = []
	filtered_cells.assign(cells.filter(func(cell): return cell in base_cells))
	return filtered_cells

#endregion

#region Drawing

# Shows an area of possible movements
func show_possible_movements() -> void:
	pass
	
# Shows the movement path following a cells centers array
func show_movement_path(cells_centers_path : Array[Vector2]) -> void:
	for cell_center in cells_centers_path:
		var cell := get_cell(cell_center)
		set_cell(Layers.MOVEMENT_LAYER, cell, 0, TILES.MOVEMENT)
		
# Shows the skill range cells
func show_skill_range_cells(free_cells : Array[Vector2i], blocked_cells : Array[Vector2i]) -> void:
	for cell in free_cells:
		set_cell(Layers.SKILL_RANGE_LAYER, cell, 0, TILES.SKILL_RANGE)
	for cell in blocked_cells:
		set_cell(Layers.SKILL_RANGE_LAYER, cell, 0, TILES.SKILL_RANGE_BLOCKED)
	
# Shows the skill area cells
func show_skill_area_cells(cells : Array[Vector2i]) -> void:
	for cell in cells:
		set_cell(Layers.SKILL_AREA_LAYER, cell, 0, TILES.SKILL_AREA)
	
# Hide all the cells in the movement path
func hide_movement_path() -> void:
	clear_layer(Layers.MOVEMENT_LAYER)
	
# Hide all the skill range cells
func hide_skill_range_cells() -> void:
	clear_layer(Layers.SKILL_RANGE_LAYER)

# Hide all the skill area cells
func hide_skill_area_cells() -> void:
	clear_layer(Layers.SKILL_AREA_LAYER)

#endregion

#region Entities

# Adds a entity to the entity list
func add_entity(entity : EntityX) -> void:
	entities.append(entity)
	entity.tree_exiting.connect(func(): remove_entity(entity))

# Removes a entity from the entity list
func remove_entity(entity : EntityX) -> void:
	entities.erase(entity)

# Returns the entity located in the given cell. If there is no entity in the given
# cell, returns null
func get_entity_at_cell(cell : Vector2i) -> EntityX:
	for entity in entities:
		if get_cell(entity.global_position) == cell: return entity
	return null

#endregion
