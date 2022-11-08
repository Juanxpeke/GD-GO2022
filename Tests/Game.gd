extends Node2D

onready var board : AStarTileMap = $GameBoard
onready var player = $GameBoard/Player

var last_cell : Vector2
var player_movement_points := 6

var movement_path := []
var walking_path := []

var spell_active := false

class Spell:
	var action_points_cost : int
	var base_range : int

	func _init(action_points_cost : int, base_range : int):
		self.action_points_cost = action_points_cost
		self.base_range = base_range
	
	func get_cell_mapping(action_range : int) -> Array:
		assert(action_range >= 0, "Error: Spell range is ")
		if action_range == 0:
			return []
		else:
			return [Vector2(0, action_range), Vector2(action_range, 0), Vector2(-action_range, 0), Vector2(0, -action_range)]


func _process(delta):
	var target_cell := board.get_cell_origin(get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		board.hide_movement_path()
		
		var cells_path := board.get_cells_path(player.global_position, target_cell)
			
		if cells_path.size() > 0 and cells_path.size() - 1 <= player_movement_points and walking_path.size() == 0:
			movement_path = cells_path.slice(1, cells_path.size() - 1)
			board.show_movement_path(movement_path)
		else:
			movement_path = []
	
	if walking_path.size() > 0:
		walk(delta)

func walk(delta):
	var closest_point : Vector2 = walking_path[0]
	player.global_position += (closest_point - player.global_position).normalized() * delta * 300
	
	if closest_point.distance_to(player.global_position) < 5:
		player.global_position = closest_point
		walking_path.remove(0)

# Called when an input occurs.
func _input(event):
	if event.is_action_pressed("mouse_left") and walking_path.size() == 0:
		board.hide_movement_path()
		player_movement_points -= movement_path.size()
		walking_path = movement_path
		movement_path = []
		
	if event.is_action_pressed("ui_cancel"):
		if not spell_active:
			var spell = Spell.new(5, 5)
			board.show_spell_cells(spell, player.global_position)
			spell_active = true
		else:
			board.hide_spell_cells()
			spell_active = false
