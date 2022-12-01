extends Node
class_name Battle

export var true_won_game_scene : PackedScene = preload("res://Game/Screens/TrueWonGameScreen.tscn")
export var bad_won_game_scene : PackedScene = preload("res://Game/Screens/BadWonGameScreen.tscn")
export var lost_game_scene : PackedScene = preload("res://Game/Screens/LostGameScreen.tscn")

var battle_state : BattleState
var animation_state : AnimationState

var turn_time : float = 2.0

var delta_sum : float = 0.0
var total_sum : float = turn_time

# Important nodes
onready var board : AStarTileMap = $Board
onready var player : Player = $"%Player"
onready var enemy : Enemy = $"%Enemy"
onready var battle_ui : Control = $BattleUI
# Battle states
onready var player_start_state := PlayerStartState.new(self, board)
onready var player_idle_state := PlayerIdleState.new(self, board)
onready var player_spell_state := PlayerSpellState.new(self, board)
onready var enemy_state := EnemyState.new(self, board)
# Animation states
onready var void_state := PlayerVoidState.new(self, board)
onready var walking_state := PlayerWalkingState.new(self, board)


var current_spell

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("entity_has_dead", self, "end_game_lost")
	enemy.connect("entity_has_dead", self, "end_game_won")
	
	board.add_unit(player)
	board.add_unit(enemy)
	
	battle_ui.set_player(player)
	battle_ui.set_enemy(enemy)
	
	battle_state = player_start_state
	battle_state.enter()
	animation_state = void_state
	
# More precise process.
func _physics_process(delta):
	if player.in_animation:
		return	
	delta_sum += delta
	total_sum -= delta
	if delta_sum >= 1.0:
		delta_sum = 0.0
		battle_ui.update_timer_label(int(round(total_sum)))
	if total_sum <= 0.0:
		total_sum = 0.0
	
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
	if player.in_animation:
		print("Tried spell state, but player in animation...\n")
		return
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
	
# Gets a certain player spell.
func get_player_spell(spell_index : int) -> Spell:
	return player.get_spell(spell_index)
	
# Resets the player action and movement points.
func reset_player_points() -> void:
	player.reset_action_points()
	player.reset_movement_points()
	
# ===============
# ==== ENEMY ====
# ===============

# Makes the enemy best action for the current turn.
func make_enemy_best_action() -> void:
	enemy.make_best_action(self, board)

# Resets the enemy action and movement points.
func reset_enemy_points() -> void:
	enemy.reset_action_points()
	enemy.reset_movement_points()

# ===============
# ==== LOGIC ====	
# ===============
	
# Decreases the player and enemy spells cooldowns by 1.
func decrease_spells_cooldowns() -> void:
	for spell in player.get_spells():
		spell.spell_current_cooldown = max(spell.spell_current_cooldown - 1, 0)
	for spell in enemy.get_spells():
		spell.spell_current_cooldown = max(spell.spell_current_cooldown - 1, 0)
	battle_ui.update_spells_layout()
	
# Tries to cast a spell.
func try_to_cast_spell(area_cells, spell) -> void:
	if player.get_action_points() < spell.spell_action_points:
		player.call_no_ap_message()
		return
	
	if spell.spell_current_cooldown > 0:
		print("-> Spell is in cooldown!\n")
		return
	
	player.cast_spell(spell, area_cells, board)
		
# Ends the game when the player wins.
func end_game_won() -> void:
	if battle_ui.current_state == battle_ui.TheHeartStates.HAPPY:
		get_tree().change_scene_to(true_won_game_scene)
	else:
		get_tree().change_scene_to(bad_won_game_scene)

# Ends the game when the player losses.
func end_game_lost() -> void:
	get_tree().change_scene_to(lost_game_scene)
