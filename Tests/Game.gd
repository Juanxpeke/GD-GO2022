extends Node2D

onready var board : AStarTileMap = $GameBoard
onready var player = $GameBoard/Player

export var spell_packed_scene : PackedScene

var last_cell : Vector2
var player_movement_points := 6

var movement_path := []
var walking_path := []

var spell_active := false

var spell : Spell 

func _ready():
	spell = spell_packed_scene.instance()

func _process(delta):
	var target_cell := board.get_cell_origin(get_viewport().get_mouse_position())
	
	if target_cell != last_cell: 
		last_cell = target_cell
		if not spell_active:
			board.hide_movement_path()
		else:
			board.hide_spell_area_cells()
		
		var cells_path := board.get_cells_path(player.global_position, target_cell)

		if cells_path.size() > 0 and cells_path.size() - 1 <= player_movement_points and \
		walking_path.size() == 0 and not spell_active:
			movement_path = cells_path.slice(1, cells_path.size() - 1)
			board.show_movement_path(movement_path)
		else:
			movement_path = []
			if spell_active:
				board.show_spell_area_cells(spell, target_cell)
	
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
			board.show_spell_range_cells(spell, player.global_position)
			spell_active = true
		else:
			board.hide_spell_range_cells()
			board.hide_spell_area_cells()
			spell_active = false

