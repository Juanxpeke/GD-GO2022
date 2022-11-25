extends AnimatedSprite
class_name Entity

signal entity_has_dead
signal health_points_changed
signal action_points_changed
signal movement_points_changed

var total_health_points := 100
var total_action_points := 7
var total_movement_points := 4

var health_points := total_health_points
var action_points := total_action_points
var movement_points := total_movement_points

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var spells = []

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

# Gets the player spell at the given index.
func get_spell(spell_index : int):
	return spells[spell_index]
	



