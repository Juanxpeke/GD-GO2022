extends TileMap
class_name AStarTileMap

# Wrapper class for TileMap class. It adds new basic functionalities using
# different methods and a AStar inner object, allowing the user to draw paths 
# or areas in it.

const DIRECTIONS := [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

enum Tiles {GROU0ND_TILE, 
			MOVEMENT_TILE, 
			SPELL_RANGE_TILE,
			SPELL_RANGE_BLOCKED_TILE, 
			SPELL_AREA_TILE}

var astar := AStar2D.new()
var obstacles := []
var units := []

onready var movement_board : TileMap = $MovementBoard
onready var spells_range_board : TileMap = $SpellsRangeBoard
onready var spells_area_board : TileMap = $SpellsAreaBoard

# Called when the node is added to the scene tree.
func _ready() -> void:
	refill_astar_points()
	set_obstacles_points_disabled(true)

# =================
# ===== ASTAR =====
# =================

# RefiLls the AStar graph with the tilemap cells origins and its cardinal conections.
func refill_astar_points() -> void:
	astar.clear()
	var cell_origins = get_used_cells_origins()
	for cell_origin in cell_origins:
		astar.add_point(get_cell_id(cell_origin), cell_origin)
	for cell_origin in cell_origins:
		connect_astar_point(cell_origin)

# Connects a point to its cardinal neighbors.
func connect_astar_point(point_position : Vector2) -> void:
	var point_id := get_cell_id(point_position)
	for direction in DIRECTIONS:
		var cardinal_point_id := get_cell_id(point_position + map_to_world(direction))
		if cardinal_point_id != point_id and astar.has_point(cardinal_point_id):
			astar.connect_points(point_id, cardinal_point_id, true)

# ===================
# ===== GETTERS =====
# ===================

# Notes: Origin right now is the top-left corner of the cell.

# Given a position in the board, it returns the origin position of the cell that
# covers that position.
func get_cell_origin(position : Vector2) -> Vector2:
	return global_position + map_to_world(world_to_map(to_local(position)))
	
# Returns an array with the origin positions of all the cells USED in the tilemap.
func get_used_cells_origins() -> Array:
	var cells_coordinates = get_used_cells()
	var cell_origins := []
	for cell_coordinate in cells_coordinates:
		var cell_origin := global_position + map_to_world(cell_coordinate)
		cell_origins.append(cell_origin)
	return cell_origins

# Returns an array with the origin positions of cells in a certain path.
func get_cells_path(start_origin : Vector2, end_origin : Vector2) -> Array:
	if not has_cell(start_origin) or not has_cell(end_origin): return []
	set_unit_points_disabled(true)
	var cells_path : Array = astar.get_point_path(get_cell_id(start_origin), get_cell_id(end_origin))
	set_unit_points_disabled(false)
	return cells_path
		
# Returns an array with the coordinates of cells in the discrete line from
# coordinates (x0, y0) to (x1, y1). Low part of modified Dofus' line algorithm.
func get_cells_line_low(x0 : int, y0 : int, x1 : int, y1 : int) -> Array:
	var cells_line = []
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var yi : int = 1
	
	if dy < 0:
		yi = -1
		dy = -dy
		
	var D : int = dy - dx
	var y : int = y0

	for x in range(x0, x1 + 1):
		cells_line.append(Vector2(x, y))
		if D > 0:
			cells_line.append(Vector2(x, y + yi))
			y = y + yi
			D = D + (2 * (dy - dx))
		elif D < 0:
			D = D + 2 * dy
		else:
			y = y + yi
			D = D + (2 * (dy - dx))
			
	return cells_line

# Returns an array with the coordinates of cells in the discrete line from
# coordinates (x0, y0) to (x1, y1). High part of modified Dofus' line algorithm.
func get_cells_line_high(x0 : int, y0 : int, x1 : int, y1 : int) -> Array:
	var cells_line = []
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var xi : int = 1
	
	if dx < 0:
		xi = -1
		dx = -dx

	var D : int = dx - dy
	var x : int = x0

	for y in range(y0, y1 + 1):
		cells_line.append(Vector2(x, y))
		if D > 0:
			cells_line.append(Vector2(x + xi, y))
			x = x + xi
			D = D + (2 * (dx - dy))
		elif D < 0:
			D = D + 2 * dx
		else:
			x = x + xi
			D = D + (2 * (dx - dy))
			
	return cells_line

# Returns an array with the coordinates of cells in the discrete line from 
# start_coord to end_coord, it uses a modified version of the Bresenham's line 
# algorithm divided in different cases, trying to replicate the Dofus' behaviour.
func get_cells_line(start_coord : Vector2, end_coord : Vector2) -> Array:
	var x0 : int = start_coord[0]
	var y0 : int = start_coord[1]
	var x1 : int = end_coord[0]
	var y1 : int = end_coord[1]
	
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
	
# Given a cell origin, returns a unique identifier. It uses improved Szudzik pair 
# algorithm to calculate the ID, and first transforms the origin to the equivalent
# coordinate, in order reduce the IDs values.
func get_cell_id(cell_origin : Vector2) -> int:
	var cell_coordinate = get_cell_coord(cell_origin)
	var x : int = cell_coordinate.x
	var y : int = cell_coordinate.y
	
	var a := x * 2 if x >= 0 else (x * -2) - 1
	var b := y * 2 if y >= 0 else (y * -2) - 1
	var c = (a * a) + a + b if a >= b else (b * b) + a
	
	if a >= 0 and b < 0 or b >= 0 and a < 0:
		return -c - 1
	
	return c
		
# Given a cell origin, it returns the equivalent cartesian coordinate.
func get_cell_coord(cell_origin : Vector2) -> Vector2:
	return world_to_map(to_local(cell_origin))

# ================
# ===== MISC =====
# ================

# Returns true if the correspondent cell is used, false otherwise.
func has_cell(cell_origin : Vector2) -> bool:
	return astar.has_point(get_cell_id(cell_origin))

# ===================
# ===== DRAWING =====
# ===================

# Shows an area of possible movements. It should use an entity cache in case it is
# not the entity's turn.
func show_possible_movements() -> void:
	pass
	
# Shows the movement path following a cells array. It can also use a cache,
# because if the path is A, then, the path to some cell inside A should also
# be the optimum path.
func show_movement_path(cells_path : Array) -> void:
	for cell_origin in cells_path:
		var cell_coord := get_cell_coord(cell_origin)
		movement_board.set_cellv(cell_coord, Tiles.MOVEMENT_TILE)
	
# Shows the spell range cells given a spell and a certain origin. If the line between the origin and
# a certain spell range cell touches an obstacle or a unit, it is marked as blocked. For this, we
# use a modified version of the Bresenham's line algorithm.
func show_spell_range_cells(spell : Spell, origin : Vector2) -> void:
	var origin_coord := get_cell_coord(origin)
	var used_cells := get_used_cells()
	var spell_cells := spell.get_range_cells(origin_coord)
	
	for spell_cell_coord in spell_cells:
		
		if spell_cell_coord in used_cells:
			
			var spell_line_cells := get_cells_line(origin_coord, spell_cell_coord)
			var is_cell_blocked := false
			
			for obstacle in obstacles:
				if get_cell_coord(obstacle.global_position) in spell_line_cells:
					is_cell_blocked = true
					break
					
			for unit in units:
				var unit_coord := get_cell_coord(unit.global_position)
					
				if unit_coord in spell_line_cells and unit_coord != origin_coord and \
				unit_coord != spell_cell_coord:
					is_cell_blocked = true
					break
					
			if is_cell_blocked:
				spells_range_board.set_cellv(spell_cell_coord, Tiles.SPELL_RANGE_BLOCKED_TILE)
			else:
				spells_range_board.set_cellv(spell_cell_coord, Tiles.SPELL_RANGE_TILE)

# Shows the spell area cells given a spell and a certain origin.
func show_spell_area_cells(spell : Spell, origin : Vector2) -> void:
	var origin_coord := get_cell_coord(origin)
	
	if spells_range_board.get_cellv(origin_coord) != Tiles.SPELL_RANGE_TILE:
		return
	
	var used_cells := get_used_cells()
	var spell_area_cells := spell.get_area_cells(origin_coord)
	
	for spell_cell_coord in spell_area_cells:
		if spell_cell_coord in used_cells:
			spells_area_board.set_cellv(spell_cell_coord, Tiles.SPELL_AREA_TILE)
	
# Hide all the cells in the movement path.
func hide_movement_path() -> void:
	movement_board.clear()
	
# Hide all the spell range cells.
func hide_spell_range_cells() -> void:
	spells_range_board.clear()

# Hide all the spell are cells.
func hide_spell_area_cells() -> void:
	spells_area_board.clear()
	
# ===============================
# ===== UNITS AND OBSTACLES =====
# ===============================

# Adds an obstacle to the obstacle list.
func add_obstacle(obstacle: Object) -> void:
	obstacles.append(obstacle)
	if not obstacle.is_connected("tree_exiting", self, "remove_obstacle"):
		obstacle.connect("tree_exiting", self, "remove_obstacle", [obstacle])

# Removes an obstacle from the obstacle list.
func remove_obstacle(obstacle: Object) -> void:
	obstacles.erase(obstacle)

# Adds a unitto the unit list.
func add_unit(unit: Object) -> void:
	units.append(unit)
	if not unit.is_connected("tree_exiting", self, "remove_unit"):
		unit.connect("tree_exiting", self, "remove_unit", [unit])

# Removes a unit from the unit list.
func remove_unit(unit: Object) -> void:
	units.erase(unit)

# Marks the units positions as disabled or enabled in the AStar graph, based on the given boolean.
func set_unit_points_disabled(value: bool) -> void:
	for unit in units:
		astar.set_point_disabled(get_cell_id(unit.global_position), value)

# Marks the obstacles positions as disabled or enabled in the AStar graph, based on the given
# boolean.
func set_obstacles_points_disabled(value: bool) -> void:
	for obstacle in obstacles:
		astar.set_point_disabled(get_cell_id(obstacle.global_position), value)

# Returns true if a certain position has an obstacle, false otherwise.
func position_has_obstacle(obstacle_position: Vector2) -> bool:
	for obstacle in obstacles:
		if obstacle.global_position == obstacle_position: return true
	return false

# Returns true if a certain position has a unit, false otherwise.
func position_has_unit(unit_position: Vector2) -> bool:
	for unit in units:
		if unit.global_position == unit_position: return true
	return false

# ===========================
# ===== EXTRA UTILITIES =====
# ===========================

# Returns an array with the coordinates of cells in the discrete line from
# coordinates (x0, y0) to (x1, y1). Low part of Bresenham's line algorithm.
func get_cells_line_low_b(x0 : int, y0 : int, x1 : int, y1 : int) -> Array:
	var cells_line = []
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var yi : int = 1
	
	if dy < 0:
		yi = -1
		dy = -dy
		
	var D : int = (2 * dy) - dx
	var y : int = y0

	for x in range(x0, x1 + 1):
		cells_line.append(Vector2(x, y))
		if D > 0:
			y = y + yi
			D = D + (2 * (dy - dx))
		else:
			D = D + 2 * dy
			
	return cells_line

# Returns an array with the coordinates of cells in the discrete line from
# coordinates (x0, y0) to (x1, y1). High part of Bresenham's line algorithm.
func get_cells_line_high_b(x0 : int, y0 : int, x1 : int, y1 : int) -> Array:
	var cells_line = []
	var dx : int = x1 - x0
	var dy : int = y1 - y0
	var xi : int = 1
	
	if dx < 0:
		xi = -1
		dx = -dx

	var D : int = (2 * dx) - dy
	var x : int = x0

	for y in range(y0, y1 + 1):
		cells_line.append(Vector2(x, y))
		if D > 0:
			x = x + xi
			D = D + (2 * (dx - dy))
		else:
			D = D + 2 * dx
			
	return cells_line

# Returns an array with the coordinates of cells in the discrete line from 
# start_coord to end_coord, it uses the Bresenham's line algorithm divided
# in different cases.
func get_cells_line_b(start_coord : Vector2, end_coord : Vector2) -> Array:
	var x0 : int = start_coord[0]
	var y0 : int = start_coord[1]
	var x1 : int = end_coord[0]
	var y1 : int = end_coord[1]
	
	if abs(y1 - y0) < abs(x1 - x0):
		if x0 > x1:
			return get_cells_line_low_b(x1, y1, x0, y0)
		else:
			return get_cells_line_low_b(x0, y0, x1, y1)
	else:
		if y0 > y1:
			return get_cells_line_high_b(x1, y1, x0, y0)
		else:
			return get_cells_line_high_b(x0, y0, x1, y1)
