extends Control

var player : Player

onready var timer_label := $"%TimerLabel"
onready var action_points_label := $"%APLabel"
onready var movement_points_label := $"%MPLabel"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Sets the player that the UI is going to listen.
func set_player(player : Player) -> void:
	self.player = player
	player.connect("health_points_changed", self, "update_health_gauges")
	player.connect("action_points_changed", self, "update_action_points_label")
	player.connect("movement_points_changed", self, "update_movement_points_label")
	update_health_gauges()
	update_action_points_label()
	update_movement_points_label()
	update_spells_layout()

# Updates the timer label.
func update_timer_label(timer_value : int) -> void:
	timer_label.text = str(timer_value)

# Updates the health indicators.
func update_health_gauges() -> void:
	pass

# Updates the action points label.
func update_action_points_label() -> void:
	assert(player, "Player is not defined for the UI.")
	action_points_label.text = str(player.get_action_points())

# Updates the movement points label.
func update_movement_points_label() -> void:
	assert(player, "Player is not defined for the UI.")
	movement_points_label.text = str(player.get_movement_points())
	
# Updates the spells layout.
func update_spells_layout() -> void:
	assert(player, "Player is not defined for the UI.")
	pass


