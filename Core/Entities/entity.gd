class_name EntityX
extends Node2D
#region Signals
signal dead
signal health_points_changed
signal action_points_changed
signal movement_points_changed
signal skill_casted
#endregion Signals

static var MOVEMENT_SPEED := 200.0
static var MOVEMENT_SHORTCUT_THRESHOLD := 4.0

@export var health_points := 360
@export var action_points := 6
@export var movement_points := 3
@export var skills : Array[Skill] = []
@export var speed := 10

var current_health_points := health_points
var current_action_points := action_points
var current_movement_points := movement_points

var turn_accumulator := 0
#region Movement Variables
var movement_path : Array[Vector2]= []
#endregion Movement Variables
#region Nodes References
@onready var floating_text_component : FloatingTextComponent = %FloatingTextComponent
@onready var sprite : AnimatedSprite2D = %Sprite
@onready var audio : AudioStreamPlayer = %AudioStreamPlayer
#endregion Nodes References

# Private

# Called when the node enters the scene tree for the first time
func _ready():
	if GameManager.current_map != null:
		GameManager.current_map.board.add_unit(self)

# Called every frame
func _process(delta : float) -> void:
	if is_moving():
		var movement_point = movement_path[0]
		global_position += (movement_point - global_position).normalized() * delta * MOVEMENT_SPEED 
		
		if movement_point.distance_to(global_position) < MOVEMENT_SHORTCUT_THRESHOLD:
			global_position = movement_point
			movement_path.remove_at(0)

# Called when a turn starts
func _on_turn_started(turn_owner : EntityX):
	pass

# Public

#region Attributes

#region Health

# Gets the player current health points
func get_current_health_points() -> int:
	return current_health_points

# Sets the player current health points
func set_current_health_points(amount : int) -> void:
	current_health_points = clamp(amount, 0, health_points)
	health_points_changed.emit()
	
	if current_health_points <= 0:
		die()

# Adds a certain amount to the player current health points
func add_current_health_points(amount : int) -> void:
	floating_text_component.generate_floating_text(str(amount), FloatingTextComponent.TextType.HEALING)
	set_current_health_points(current_health_points + amount)
	
# Substracts a certain amount to the player current health points
func subtract_current_health_points(amount : int) -> void:
	floating_text_component.generate_floating_text(str(amount), FloatingTextComponent.TextType.DAMAGE)
	set_current_health_points(current_health_points - amount)

# Dies
func die() -> void:
	dead.emit()
	
#endregion

#region Action Points

# Gets the player current action points
func get_current_action_points() -> int:
	return current_action_points

# Sets the player current action points
func set_current_action_points(amount : int) -> void:
	current_action_points = clamp(amount, 0, 99999)
	action_points_changed.emit()

# Adds a certain amount to the player current action points
func add_current_action_points(amount : int) -> void:
	floating_text_component.generate_floating_text(str(amount), FloatingTextComponent.TextType.ACTION_POINTS)
	set_current_action_points(current_action_points + amount)
	
# Substracts a certain amount to the player current action points
func substract_current_action_points(amount : int) -> void:
	floating_text_component.generate_floating_text(str(amount), FloatingTextComponent.TextType.ACTION_POINTS)
	set_current_action_points(current_action_points - amount)

# Resets the player current action points to the total
func reset_current_action_points() -> void:
	set_current_action_points(action_points)

#endregion

#region Movement Points

# Gets the player current movement points
func get_current_movement_points() -> int:
	return current_movement_points

# Sets the player current movement points
func set_current_movement_points(amount : int) -> void:
	current_movement_points = clamp(amount, 0, 99999)
	movement_points_changed.emit()

# Adds a certain amount to the player current movement points
func add_current_movement_points(amount : int) -> void:
	floating_text_component.generate_floating_text(str(amount), FloatingTextComponent.TextType.MOVEMENT_POINTS)
	set_current_movement_points(current_movement_points + amount)
	
# Substracts a certain amount to the player current movement points
func substract_current_movement_points(amount : int) -> void:
	floating_text_component.generate_floating_text(str(amount), FloatingTextComponent.TextType.MOVEMENT_POINTS)
	set_current_movement_points(current_movement_points - amount)

# Resets the player current movement points to the total
func reset_current_movement_points() -> void:
	set_current_movement_points(movement_points)

#endregion

#region Skills

# Gets the array of skills
func get_skills() -> Array[Skill]:
	return skills

# Gets the player skill at the given index
func get_skill(skill_index : int):
	return skills[skill_index]

#endregion

#endregion

#region Behaviour

#region Movement

# Returns true if the entity is moving, false otherwise
func is_moving() -> bool:
	return !movement_path.is_empty()

# Makes a certain movement
func make_movement(movement_path : Array[Vector2]) -> void:
	substract_current_movement_points(movement_path.size())
	self.movement_path = movement_path

#endregion Movement
	
#region Skill Casting 

# Casts the given skill
func cast_skill(skill : Skill, target_cell : Vector2i) -> void:
	substract_current_action_points(skill.action_points)
	
	AudioManager.play_sound(skill.sound)
	
	skill.apply_area_effect(target_cell)
	
	skill_casted.emit()
	
	# var player_cell = GameManager.current_map.board.get_cell(global_position)
	# var x_diff = player_cell.x - target_cell.x
	# var y_diff = player_cell.y - target_cell.y

	#if x_diff < 0 and abs(x_diff) >= abs(y_diff):
	#	orientation_index = 0
	#elif y_diff < 0 and abs(y_diff) >= abs(x_diff):
	#	orientation_index = 1
	#elif x_diff > 0 and abs(x_diff) >= abs(y_diff):
	#	orientation_index = 2
	#elif y_diff > 0 and abs(y_diff) >= abs(x_diff):
	#	orientation_index = 3
	
	# if false: # sprite.frames.has_animation(str(skill).to_lower() + "_" + str(orientation_index)):
	#	print("-> In animation " + str(skill).to_lower() + "_" + str(orientation_index) +"\n")
	#	in_animation = true
	#	sprite.animation = str(skill).to_lower() + "_" + str(orientation_index)
	#	sprite.play()
	# else: 
	#	print("-> Animation " + str(skill).to_lower() + "_" + str(orientation_index) + " not found\n")
	#	return

	# await sprite.animation_finished

#endregion

#endregion
