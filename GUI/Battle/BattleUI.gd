extends Control

var player : Player
var enemy : Enemy

onready var health_points_label := $"%HPLabel"
onready var action_points_label := $"%APLabel"
onready var movement_points_label := $"%MPLabel"

onready var knife_spell_button := $"%KnifeSpellButton"
onready var pistol_spell_button := $"%PistolSpellButton"
onready var granade_spell_button := $"%GranadeSpellButton"
onready var medkit_spell_button := $"%MedkitSpellButton"

onready var timer_label := $"%TimerLabel"

onready var enemy_health_points_label := $"%EnemyHPLabel"
onready var enemy_action_points_label := $"%EnemyAPLabel"
onready var enemy_movement_points_label := $"%EnemyMPLabel"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Sets the player that the UI is going to listen.
func set_player(player : Player) -> void:
	self.player = player
	player.connect("health_points_changed", self, "update_health_gauges")
	player.connect("action_points_changed", self, "update_action_points_label")
	player.connect("movement_points_changed", self, "update_movement_points_label")

	knife_spell_button.connect("pressed", get_parent(), "to_player_spell_state", [player.get_spell(0)])
	pistol_spell_button.connect("pressed", get_parent(), "to_player_spell_state", [player.get_spell(1)])
	granade_spell_button.connect("pressed", get_parent(), "to_player_spell_state", [player.get_spell(2)])
	medkit_spell_button.connect("pressed", get_parent(), "to_player_spell_state", [player.get_spell(3)])
	
	update_health_gauges()
	update_action_points_label()
	update_movement_points_label()
	update_spells_layout()

# Sets the enemy that the UI is going to listen.
func set_enemy(enemy : Enemy) -> void:
	self.enemy = enemy
	
	enemy.connect("health_points_changed", self, "update_enemy_health_points_label")
	enemy.connect("action_points_changed", self, "update_enemy_action_points_label")
	enemy.connect("movement_points_changed", self, "update_enemy_movement_points_label")

	update_enemy_health_points_label()
	update_enemy_action_points_label()
	update_enemy_movement_points_label()

# Updates the timer label.
func update_timer_label(timer_value : int) -> void:
	timer_label.text = str(timer_value)

# Updates the health indicators.
func update_health_gauges() -> void:
	assert(player, "Player is not defined for the UI.")
	health_points_label.text = "HP: " + str(player.get_health_points())

# Updates the action points label.
func update_action_points_label() -> void:
	assert(player, "Player is not defined for the UI.")
	action_points_label.text = str(player.get_action_points())

# Updates the movement points label.
func update_movement_points_label() -> void:
	assert(player, "Player is not defined for the UI.")
	movement_points_label.text = str(player.get_movement_points())

# Updates the enemy health points label.
func update_enemy_health_points_label() -> void:
	assert(enemy, "Enemy is not defined for the UI.")
	enemy_health_points_label.text = str(enemy.get_health_points())

# Updates the action points label.
func update_enemy_action_points_label() -> void:
	assert(enemy, "Enemy is not defined for the UI.")
	enemy_action_points_label.text = str(enemy.get_action_points())

# Updates the movement points label.
func update_enemy_movement_points_label() -> void:
	assert(enemy, "Enemy is not defined for the UI.")
	enemy_movement_points_label.text = str(enemy.get_movement_points())

	# Updates the spells layout.
func update_spells_layout() -> void:
	assert(player, "Enemy is not defined for the UI.")
	pass


