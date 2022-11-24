extends Node
class_name Battle

var battle_state : BattleState
var animation_state : AnimationState

# Important nodes
onready var board : AStarTileMap = $Board
onready var player : Player = $Player
onready var turn_timer : Timer = $TurnTimer
onready var battle_ui : Control = $BattleUI
# Battle states
onready var player_start_state := PlayerStartState.new(self, board)
onready var player_idle_state := PlayerTurnIdleState.new(self, board)
onready var player_spell_state := PlayerTurnSpellState.new(self, board)
onready var enemy_state := EnemyState.new(self, board)
# Animation states
onready var void_state := PlayerVoidState.new(self, board)
onready var walking_state := PlayerWalkingState.new(self, board)


# Called when the node enters the scene tree for the first time.
func _ready():
	battle_ui.set_player(player)
	
	battle_state = player_start_state
	battle_state.enter()
	animation_state = void_state
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	battle_state.update()
	animation_state.update(delta)

# Called when an input occurs.
func _input(event):
	battle_state.handle_input(event)

# ============================
# ==== BATTLE TRANSITIONS ====
# ============================

# Advances a turn.
func to_enemy_state() -> void:
	battle_state.exit()
	battle_state = enemy_state
	battle_state.enter()

# Changes the state to the player start state.
func to_player_start_state() -> void:
	battle_state.exit()
	battle_state = player_start_state
	battle_state.enter()

# Changes the state to the player idle state.
func to_player_idle_state() -> void:
	battle_state.exit()
	battle_state = player_idle_state
	battle_state.enter()

# Changes the state to the player spell state related to the given spell.
func to_player_spell_state(spell : Spell) -> void:
	battle_state.exit()
	player_spell_state.set_spell(spell)
	battle_state = player_spell_state
	battle_state.enter()

# ===============================
# ==== ANIMATION TRANSITIONS ====
# ===============================

# Changes the animation state to void.
func to_void_state() -> void:
	animation_state.exit()
	animation_state = void_state
	animation_state.enter()

# Changes the animation state to walking.
func to_walking_state(walking_path) -> void:
	animation_state.exit()
	animation_state = walking_state
	animation_state.set_walking_path(walking_path)
	animation_state.enter()

# ================
# ==== PLAYER ====
# ================

# Gets the player node.
func get_player() -> Player:
	return player

# Gets the player position.
func get_player_position() -> Vector2:
	return player.global_position

# Sets the player position.
func set_player_position(value : Vector2) -> void:
	player.global_position = value

# Adds a certain value to the player position.
func add_player_position(value : Vector2) -> void:
	player.global_position += value
	
# Gets the player movement points.
func get_player_movement_points() -> int:
	return player.get_movement_points()
	
# Substract the player movement points to the given amount.
func substract_player_movement_points(amount : int) -> void:
	player.substract_movement_points(amount)
	
# Resets the player action and movement points.
func reset_player_points() -> void:
	player.reset_action_points()
	player.reset_movement_points()
	
# ===============
# ==== LOGIC ====	
# ===============
	
func show_spell_message():
	print("Not enough AP!")
	
# Tries to cast a spell.
func try_to_cast_spell(area_cells, spell) -> void:
	if player.get_action_points() < spell.spell_action_points:
		show_spell_message()
		return
	
	player.substract_action_points(spell.spell_action_points)
	
	spell.show_animation()
	
	for cell in area_cells:
		spell.apply_effect(cell)

