extends TileMap
class_name AStarTileMap

# Wrapper class for TileMap class. It adds new basic functionalities and also
# allows the user to draw shapes in it. The definitions adopted for using this 
# class are the following:
#
# 1) The tilemap has infinite cells, and a finite amount of cells that are used.
# 2) Each cell can be defined with an ID, a cartesian coordinate, a position
#	contained in the cell, or the origin position of the cell.
# 3) Methods will be defined following these concepts, for example, there could
#	be a method 'get_cell_id_by_cor', which returns 0 if  (0, 0) is given.

const DIRECTIONS := [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

const PAIRING_LIMIT = int(pow(2, 30))

onready var movement_board := $MovementBoard
onready var spells_board := $SpellsBoard

var astar := AStar2D.new()
var obstacles := []
var units := []

# Called when the node is added to the scene tree.
func _ready() -> void:
	refill_astar_points()

# =================
# ===== ASTAR =====
# =================

# Refiils the AStar graph with the tilemap cells origins and its cardinal conections.
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
func get_cells_path(start_origin: Vector2, end_origin: Vector2) -> Array:
	if not has_cell(start_origin) or not has_cell(end_origin): return []
	return astar.get_point_path(get_cell_id(start_origin), get_cell_id(end_origin)) as Array


# Returns true if the correspondent cell is used, false otherwise.
func has_cell(cell_origin : Vector2) -> bool:
	return astar.has_point(get_cell_id(cell_origin))

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

	
# Converts from isometric coordinates to cartesian coordinates.
func iso2cart(iso_position : Vector2) -> Vector2:
	return Vector2(iso_position.x - iso_position.y, (iso_position.x + iso_position.y) / 2)

# Converts from cartesian coordinates to isometric coordinates.
func cart2iso(cart_position : Vector2) -> Vector2:
	return Vector2(cart_position.x / 2 + cart_position.y, -cart_position.x / 2 + cart_position.y)


# ====================
# ===== GRAPHICS =====
# ====================

# Shows the possible movements of an entity on the board. It uses
# the entity cache in case it is not the entity's turn.
func show_possible_movements(entity : Entity) -> void:
	pass
	
# Shows the path from an entity to a given cell. It can also use a cache,
# because if the path is A, then, the path to some cell inside A should also
# be the optimum path.
func show_movement_path(cells_path : Array) -> void:
	for cell_origin in cells_path:
		var cell_coord = get_cell_coord(cell_origin)
		movement_board.set_cellv(cell_coord, 1)
	
func hide_movement_path() -> void:
	movement_board.clear()
	
# Highlights a cell.
func highlight_cell(cell, mode : int) -> void:
	pass












func set_path_length(point_path: Array, max_distance: int) -> Array:
	if max_distance < 0: return point_path
	point_path.resize(min(point_path.size(), max_distance))
	return point_path

func update() -> void:
	refill_astar_points()
	var unitNodes = get_tree().get_nodes_in_group("Units")
	for unitNode in unitNodes:
		add_unit(unitNode)
	var obstacleNodes = get_tree().get_nodes_in_group("Obstacles")
	for obstacleNode in obstacleNodes:
		add_obstacle(obstacleNode)
		




func stop_path_at_unit(potential_path_points: Array) -> Array:
	for i in range(1, potential_path_points.size()):
		var point : Vector2 = potential_path_points[i]
		if position_has_unit(point):
			potential_path_points.resize(i)
			break
	return potential_path_points


func get_floodfill_positions(start_position: Vector2, min_range: int, max_range: int, skip_obstacles := true, skip_units := true, return_center := false) -> Array:
	var floodfill_positions := []
	var checking_positions := [start_position]

	while not checking_positions.empty():
		var current_position : Vector2 = checking_positions.pop_back()
		if skip_obstacles and position_has_obstacle(current_position, start_position): continue
		if skip_units and position_has_unit(current_position, start_position): continue
		if current_position in floodfill_positions: continue

		var current_point := get_cell_id(current_position)
		if not astar.has_point(current_point): continue
		if astar.is_point_disabled(current_point): continue

		var distance := (current_position - start_position)
		var grid_distance := get_grid_distance(distance)
		if grid_distance > max_range: continue

		floodfill_positions.append(current_position)

		for direction in DIRECTIONS:
			var new_position := current_position + map_to_world(direction)
			if skip_obstacles and position_has_obstacle(new_position): continue
			if skip_units and position_has_unit(new_position): continue
			if new_position in floodfill_positions: continue

			var new_point := get_cell_id(new_position)
			if not astar.has_point(new_point): continue
			if astar.is_point_disabled(new_point): continue

			checking_positions.append(new_position)
	if not return_center:
		floodfill_positions.erase(start_position)

	var floodfill_positions_size := floodfill_positions.size()
	for i in floodfill_positions_size:
		var floodfill_position : Vector2 = floodfill_positions[floodfill_positions_size-i-1] # Loop through the positions backwards vvv
		var distance = (floodfill_position - start_position)
		var grid_distance := get_grid_distance(distance)
		if grid_distance < min_range:
			floodfill_positions.erase(floodfill_position) # Since we are modifying the array here

	return floodfill_positions




func path_directions(path) -> Array:
	# Convert a path into directional vectors whose sum would be path[length-1]
	var directions = []
	for p in range(1, path.size()):
		directions.append(path[p] - path[p - 1])
	return directions




func has_point(point_position: Vector2) -> bool:
	var point_id := get_cell_id(point_position)
	return astar.has_point(point_id)




func get_grid_distance(distance: Vector2) -> float:
	var vec := world_to_map(distance).abs().floor()
	return vec.x + vec.y



func set_obstacles_points_disabled(value: bool) -> void:
	#for obstacle in obstacles:
	#	astar.set_point_disabled(get_cell_id(obstacle.global_position.x, obstacle.global_position.y), value)
	pass

func set_unit_points_disabled(value: bool, exception_units: Array = []) -> void:
	for unit in units:
		if unit in exception_units or unit.owner in exception_units:
			continue
	#	astar.set_point_disabled(get_cell_id(unit.global_position.x, unit.global_position.y), value)



func add_obstacle(obstacle: Object) -> void:
	obstacles.append(obstacle)
	if not obstacle.is_connected("tree_exiting", self, "remove_obstacle"):
		obstacle.connect("tree_exiting", self, "remove_obstacle", [obstacle])

func remove_obstacle(obstacle: Object) -> void:
	obstacles.erase(obstacle)

func add_unit(unit: Object) -> void:
	units.append(unit)
	if not unit.is_connected("tree_exiting", self, "remove_unit"):
		unit.connect("tree_exiting", self, "remove_unit", [unit])

func remove_unit(unit: Object) -> void:
	units.erase(unit)

func position_has_obstacle(obstacle_position: Vector2, ignore_obstacle_position = null) -> bool:
	if obstacle_position == ignore_obstacle_position: return false
	for obstacle in obstacles:
		if obstacle.global_position == obstacle_position: return true
	return false

func position_has_unit(unit_position: Vector2, ignore_unit_position = null) -> bool:
	if unit_position == ignore_unit_position: return false
	for unit in units:
		if unit.global_position == unit_position: return true
	return false

func get_cells_path_avoiding_obstacles_and_units(start_position: Vector2, end_position: Vector2, exception_units := [], max_distance := -1) -> Array:
	set_obstacles_points_disabled(true)
	set_unit_points_disabled(true, exception_units)
	# var astar_path := astar.get_point_path(get_point(start_position), get_point(end_position))
	set_obstacles_points_disabled(false)
	set_unit_points_disabled(false)
	return []
	#return set_path_length(astar_path, max_distance)

func get_cells_path_avoiding_obstacles(start_position: Vector2, end_position: Vector2, max_distance := -1) -> Array:
	set_obstacles_points_disabled(true)
	# var potential_path_points := astar.get_point_path(get_point(start_position), get_point(end_position))
	set_obstacles_points_disabled(false)
	# var astar_path := stop_path_at_unit(potential_path_points)
	return []
	# return set_path_length(astar_path, max_distance)

