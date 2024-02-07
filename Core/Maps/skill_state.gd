class_name SkillState
extends MapState

var skill : Skill

var last_cell : Vector2i = Vector2i(-1, -1)
var range_free_cells : Array[Vector2i] = []
var range_blocked_cells : Array[Vector2i] = []
var area_effect_cells : Array[Vector2i] = []

# Constructor
func _init(skill : Skill) -> void:
	self.skill = skill

# Called when being selected as the new state
func enter() -> void:
	print("@@@ Entered player spell state. @@@\n")
	var player_cell := GameManager.current_map.board.get_cell(GameManager.current_player.global_position)
	var cells_sight_areas := GameManager.current_map.board.get_cells_sight_areas(skill.get_range_cells(player_cell), GameManager.current_player.global_position)
	range_free_cells.assign(cells_sight_areas[0])
	range_blocked_cells.assign(cells_sight_areas[1])
	GameManager.current_map.board.show_skill_range_cells(range_free_cells, range_blocked_cells)

# Called when being removed as the current state
func exit() -> void:
	print("@@@ Exited player spell state. @@@\n")
	GameManager.current_map.board.hide_skill_range_cells()
	GameManager.current_map.board.hide_skill_area_cells()

# Called in the '_process()' callback
func update() -> void:
	var target_cell := GameManager.current_map.board.get_cell(GameManager.get_viewport().get_mouse_position())

	if target_cell == last_cell: return
	
	last_cell = target_cell
	
	if target_cell in range_free_cells:
		area_effect_cells = GameManager.current_map.board.get_filtered_base_cells(skill.get_area_cells(target_cell))
		GameManager.current_map.board.hide_skill_area_cells()
		GameManager.current_map.board.show_skill_area_cells(area_effect_cells)
	else:
		GameManager.current_map.board.hide_skill_area_cells() 

# Called in the '_input()' callback
func handle_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if last_cell in range_free_cells:
			GameManager.current_player.cast_skill(skill, last_cell)
		GameManager.current_map.to_idle_state()
