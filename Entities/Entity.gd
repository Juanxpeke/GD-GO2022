extends Position2D
class_name Entity

signal entity_has_dead
signal health_points_changed
signal action_points_changed
signal movement_points_changed
signal walking_animation_ended

var total_health_points := 1000
var total_action_points := 6
var total_movement_points := 4

var health_points := total_health_points
var action_points := total_action_points
var movement_points := total_movement_points

var spells := []

var orientation_index := 0
var walking_path := []

var in_animation := false

onready var sprite : AnimatedSprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.connect("animation_finished", self, "when_anim_finished")

func when_anim_finished():
	print("Anim finished!")
	sprite.stop()
	sprite.animation = "idle_" + str(orientation_index)
	in_animation = false

# =======================
# ==== HEALTH POINTS ====
# =======================

# Sets the player current health points.
func set_health_points(amount : int) -> void:
	health_points = clamp(amount, 0, total_health_points)
	emit_signal("health_points_changed")
	if health_points == 0:
		emit_signal("entity_has_dead")

# Adds a certain amount to the current player health points.
func add_health_points(amount : int) -> void:
	set_health_points(health_points + amount)
	
# Substracts a certain amount to the current player health points.
func substract_health_points(amount : int) -> void:
	set_health_points(health_points - amount)

# Gets the player current health points.
func get_health_points() -> int:
	return health_points

# Takes damages.
func take_damage(amount : int) -> void:
	substract_health_points(amount)

# =======================
# ==== ACTION POINTS ====
# =======================

# Sets the player current action points.
func set_action_points(amount : int) -> void:
	action_points = clamp(amount, 0, 99999)
	emit_signal("action_points_changed")

# Adds a certain amount to the current player action points.
func add_action_points(amount : int) -> void:
	set_action_points(action_points + amount)
	
# Substracts a certain amount to the current player action points.
func substract_action_points(amount : int) -> void:
	set_action_points(action_points - amount)

# Resets the current player action points to the total.
func reset_action_points() -> void:
	set_action_points(total_action_points)

# Gets the player current action points.
func get_action_points() -> int:
	return action_points

# =========================
# ==== MOVEMENT POINTS ====
# =========================

# Sets the player current movement points.
func set_movement_points(amount : int) -> void:
	movement_points = clamp(amount, 0, 99999)
	emit_signal("movement_points_changed")

# Adds a certain amount to the current player movement points.
func add_movement_points(amount : int) -> void:
	set_movement_points(movement_points + amount)
	
# Substracts a certain amount to the current player movement points.
func substract_movement_points(amount : int) -> void:
	set_movement_points(movement_points - amount)

# Resets the current player movement points to the total.
func reset_movement_points() -> void:
	set_movement_points(total_movement_points)

# Gets the player current movement points.
func get_movement_points() -> int:
	return movement_points

# ================
# ==== SPELLS ====
# ================

# Gets the list of spells.
func get_spells() -> Array:
	return spells

# Gets the player spell at the given index.
func get_spell(spell_index : int):
	return spells[spell_index]
	
# ===================
# ==== BEHAVIOUR ====
# ===================

# Makes a certain movement.
func make_movement(walking_path : Array) -> void:
	substract_movement_points(walking_path.size())
	self.walking_path = walking_path
	if walking_path.size() > 0:
		in_animation = true
	
func cast_spell(spell, area_cells, board) -> void:
	if area_cells.size() == 0:
		return
	
	substract_action_points(spell.spell_action_points)
	spell.spell_current_cooldown = spell.spell_cooldown

	GameManager.play(spell.spell_sound)
	
	var player_cell = get_parent().get_parent().board.get_cell_coord(global_position)
	var target_cell = area_cells[0]
	
	if player_cell.x < target_cell.x:
		orientation_index = 0
	elif player_cell.y < target_cell.y:
		orientation_index = 1
	elif player_cell.x > target_cell.x:
		orientation_index = 2
	elif player_cell.y > target_cell.y:
		orientation_index = 3
	
	if sprite.frames.has_animation(str(spell).to_lower() + "_" + str(orientation_index)):
		in_animation = true
		sprite.animation = str(spell).to_lower() + "_" + str(orientation_index)
		sprite.play()


	for cell in area_cells:
		var affected_unit = board.get_unit_at_cell(cell)
		if affected_unit != null:
			spell.apply_effect(affected_unit)
	
	
# Called every frame.
func _process(delta : float) -> void:
	if walking_path.size() == 0:
		return
	
	var closest_point : Vector2 = walking_path[0]
	
	
	var player_cell = get_parent().get_parent().board.get_cell_coord(global_position)
	var closest_cell = get_parent().get_parent().board.get_cell_coord(closest_point)
	
	if player_cell.x < closest_cell.x:
		orientation_index = 0
	elif player_cell.y < closest_cell.y:
		orientation_index = 1
	elif player_cell.x > closest_cell.x:
		orientation_index = 2
	elif player_cell.y > closest_cell.y:
		orientation_index = 3
	
	global_position += (closest_point - global_position).normalized() * delta * 300
	
	# print("Player cell: " + str(player_cell) + ", closest cell: " + str(closest_cell))
	
	sprite.animation = "run_" + str(orientation_index)
	
	if closest_point.distance_to(global_position) < 5:
		global_position = closest_point
		walking_path.remove(0)
	
	if walking_path.size() == 0:
		sprite.animation = "idle_" + str(orientation_index)
		in_animation = false
		emit_signal("walking_animation_ended")
