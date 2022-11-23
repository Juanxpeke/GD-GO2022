extends Node
class_name Battle

var battle_state : BattleState
var animation_state : AnimationState

onready var board := $Board
onready var player := $Player
onready var player_idle_state := PlayerTurnIdleState.new(self, board)
onready var player_spell_state := PlayerTurnSpellState.new(self, board)
onready var void_state := PlayerVoidState.new(self, board)
onready var walking_state := PlayerWalkingState.new(self, board)


# Called when the node enters the scene tree for the first time.
func _ready():
	battle_state = player_idle_state
	animation_state = void_state
	player.add_movement_points(4)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	battle_state.update()
	animation_state.update(delta)

# Called when an input occurs.
func _input(event):
	battle_state.handle_input(event)

# =====================
# ==== TRANSITIONS ====
# =====================

# Changes the state to the idle state.
func to_idle_state() -> void:
	battle_state.exit()
	battle_state = player_idle_state
	battle_state.enter()

# Changes the state to the correspondent spell state.
func to_spell_state(spell) -> void:
	battle_state.exit()
	player_spell_state.set_spell(spell)
	battle_state = player_spell_state
	battle_state.enter()

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

# =================
# ==== PLAYERS ====
# =================

# Gets the player position.
func get_player_position() -> Vector2:
	return player.global_position

func set_player_position(value):
	player.global_position = value

func add_player_position(value):
	player.global_position += value
	
# Gets the player movement points.
func get_player_movement_points() -> int:
	return player.get_movement_points()
	
func get_player_spell(spell_index : int) -> Spell:
	return player.get_spell(spell_index)
	
# Substract the player movement points to the given amount.
func substract_player_movement_points(amount : int) -> void:
	player.substract_movement_points(amount)
	
# Tries to cast a spell.
func try_to_cast_spell(area_cells, spell) -> void:
	if player.get_action_points() < spell.spell_action_points:
		#	show_spell_message()
		return
	
	spell.show_animation()
	# yield()
	
	for cell in area_cells:
		spell.apply_effect(cell)

