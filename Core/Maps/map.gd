class_name Map
extends Node

signal turn_started(turn_owner : EntityX)

const TURN_TIME : float = 2.0
const TURN_TRESHOLD : int = 100


var turn_owner : EntityX = null
var turn : int = 0

var delta_sum : float = 0.0
var total_sum : float = TURN_TIME

# Map states
var map_state : MapState = null

@onready var board : Board = %Board
@onready var entities : Node2D = %Entities

# Private

# Called when the node enters the scene tree for the first time
func _ready():
	for entity in entities.get_children():
		turn_started.connect(entity._on_turn_started)
		board.add_entity(entity)
		
	_update_turn_owner()
	
	GameManager.set_current_map(self)
	
	map_state = IdleState.new()
	
# More precise process
func _physics_process(delta):
	delta_sum += delta
	total_sum -= delta
	if delta_sum >= 1.0:
		delta_sum = 0.0
		#battle_ui.update_timer_label(int(round(total_sum)))
	if total_sum <= 0.0:
		total_sum = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	if map_state == null: return
	
	if Input.is_key_pressed(KEY_A) and map_state is IdleState:
		var xd = load("res://Global/Skills/Pistol/pistol.tres")
		var xdd = load("res://Global/Skills/Grenade/grenade.tres")
		to_skill_state(xdd)
	
	map_state.update()

# Called when an input occurs
func _input(event):
	if map_state == null: return
	
	map_state.handle_input(event)

# Updates the turn owner based on the following logic:
# 1 - Search for the entity TO with the biggest turn accumulator
# 2 - If TO turn accumulator is less than TURN_THRESHOLD, then update every turn accumulator
# 3 - Otherwise, it is TO turn, so resets its turn accumulator
func _update_turn_owner() -> void:
	turn_owner = entities.get_child(0)

	for entity in entities.get_children():
		if entity.turn_accumulator > turn_owner.turn_accumulator:
			turn_owner = entity
	
	while turn_owner.turn_accumulator < TURN_TRESHOLD:
		for entity in entities.get_children():
			entity.turn_accumulator += entity.speed
			if entity.turn_accumulator > turn_owner.turn_accumulator:
				turn_owner = entity
	
	turn_owner.turn_accumulator = 0

#region Turns Logic

# Returns true if the turn's owner is the given entity
func is_turn_owner(entity : EntityX) -> bool:
	return entity == turn_owner
	
# Ends the current turn
func end_turn() -> void:
	turn += 1
	_update_turn_owner()
	turn_started.emit(turn_owner)

#endregion

#region Map State Changes

# Changes the state to the player idle state
func to_idle_state() -> void:
	map_state.exit()
	map_state = IdleState.new()
	map_state.enter()

# Changes the state to the skill state with the given skill
func to_skill_state(skill : Skill) -> void:
	map_state.exit()
	map_state = SkillState.new(skill)
	map_state.enter()

#endregion
