extends Control

var player : Player
var enemy : Enemy

var mouse_in_heart := false

var heart_ticks := 0

enum TheHeartStates {HAPPY,
					HAPPY_BEATEN, 
					SAD_BEATEN,
					ALMOST_DEAD}
					
var current_state = TheHeartStates.HAPPY

var heart_time = 0.0

var floating_text_scene := preload("res://Misc/FloatingText.tscn")
var heart_happy_image := load("res://Assets/GUI/TheHeart/heart_happy.png")
var heart_happy_gift_image := load("res://Assets/GUI/TheHeart/heart_happy_gift.png")
var heart_happy_beaten_image := load("res://Assets/GUI/TheHeart/heart_happy_beaten.png")
var heart_happy_beaten_gift_image := load("res://Assets/GUI/TheHeart/heart_happy_beaten_gift.png")
var heart_sad_beaten_image := load("res://Assets/GUI/TheHeart/heart_sad_beaten.png")
var heart_sad_beaten_gift_image := load("res://Assets/GUI/TheHeart/heart_sad_beaten_gift.png")
var heart_sad_beaten_middle_finger_image := load("res://Assets/GUI/TheHeart/heart_sad_beaten_middle_finger.png")
var heart_almost_dead_image := load("res://Assets/GUI/TheHeart/heart_almost_dead.png")

var pointer_cursor_image := load("res://Assets/Cursors/pointer_cursor.png")
var normal_cursor_image := load("res://Assets/Cursors/normal_cursor.png")

onready var health_points_label := $"%HPLabel"
onready var action_points_label := $"%APLabel"
onready var movement_points_label := $"%MPLabel"

onready var knife_spell_button := $"%KnifeSpellButton"
onready var pistol_spell_button := $"%PistolSpellButton"
onready var granade_spell_button := $"%GranadeSpellButton"
onready var medkit_spell_button := $"%MedkitSpellButton"

onready var timer_label := $"%TimerLabel"
onready var timer_center := $"%TimerCenter"

onready var heart_icon := $"%HeartIcon"
onready var heart_area := $"%HeartArea"
onready var heart_timer := $"%HeartTimer"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	heart_area.connect("mouse_entered", self, "on_mouse_entered_heart")
	heart_area.connect("mouse_exited", self, "on_mouse_exited_heart")

# Called when the mouse enters the heart.
func on_mouse_entered_heart() -> void:
	Input.set_custom_mouse_cursor(pointer_cursor_image)
	mouse_in_heart = true
	
# Called when the mouse exits the heart.
func on_mouse_exited_heart() -> void:
	Input.set_custom_mouse_cursor(normal_cursor_image)
	mouse_in_heart = false


# Sets the player that the UI is going to listen.
func set_player(player : Player) -> void:
	self.player = player
	player.connect("health_points_changed", self, "update_health_gauges")
	player.connect("action_points_changed", self, "update_action_points_label")
	player.connect("movement_points_changed", self, "update_movement_points_label")
	player.connect("spell_casted", self, "update_spells_layout")

	knife_spell_button.connect("pressed", self, "try_to_player_spell_state", [player.get_spell(0)])
	pistol_spell_button.connect("pressed", self, "try_to_player_spell_state", [player.get_spell(1)])
	granade_spell_button.connect("pressed", self, "try_to_player_spell_state", [player.get_spell(2)])
	medkit_spell_button.connect("pressed", self, "try_to_player_spell_state", [player.get_spell(3)])
	
	update_health_gauges()
	update_action_points_label()
	update_movement_points_label()
	update_spells_layout()
	
	get_parent().player_start_state.connect("player_started", self, "on_player_started")

# Tries to change to spell state.
func try_to_player_spell_state(spell_tried):
	if get_parent().battle_state is EnemyState:
		return
	if get_parent().current_spell == spell_tried:
		get_parent().to_player_idle_state()
		return
	get_parent().to_player_spell_state(spell_tried)
	

# Sets the enemy that the UI is going to listen.
func set_enemy(enemy : Enemy) -> void:
	self.enemy = enemy

# Updates the timer label.
func update_timer_label(timer_value : int) -> void:
	timer_label.text = str(timer_value)

# Updates the health indicators.
func update_health_gauges() -> void:
	assert(player, "Player is not defined for the UI.")
	health_points_label.text = str(player.get_health_points()) + " / " + str(player.total_health_points) 

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
	if player.get_spell(0).spell_current_cooldown > 0:
		knife_spell_button.disabled = true
	else:
		knife_spell_button.disabled = false
		
	if player.get_spell(1).spell_current_cooldown > 0:
		pistol_spell_button.disabled = true
	else:
		pistol_spell_button.disabled = false
		
	if player.get_spell(2).spell_current_cooldown > 0:
		granade_spell_button.disabled = true
	else:
		granade_spell_button.disabled = false
		
	if player.get_spell(3).spell_current_cooldown > 0:
		medkit_spell_button.disabled = true
	else:
		medkit_spell_button.disabled = false
	
func on_player_started():
	if get_parent().battle_turn <= 1:
		return
	
	heart_timer.start(0.3)
	yield(heart_timer, "timeout")
	#yield(get_tree().create_timer(0.4), "timeout")
		
	var rand_var = rand_range(0.0, 100.0)
	match current_state:
		TheHeartStates.HAPPY:
			if rand_var <= 5.0:
				heart_icon.texture = heart_happy_gift_image
				get_parent().player.add_action_points(1)
			elif rand_var <= 5.0:
				heart_icon.texture = heart_happy_gift_image
				get_parent().player.add_action_points(1)
			elif rand_var <= 30.0:
				heart_icon.texture = heart_happy_gift_image
				get_parent().player.heal(30)
		TheHeartStates.HAPPY_BEATEN:
			if rand_var <= 2.5:
				heart_icon.texture = heart_happy_beaten_gift_image
				get_parent().player.add_action_points(1)
			elif rand_var <= 2.5:
				heart_icon.texture = heart_happy_beaten_gift_image
				get_parent().player.add_action_points(1)
			elif rand_var <= 15.0:
				heart_icon.texture = heart_happy_beaten_gift_image
				get_parent().player.heal(30)
		TheHeartStates.SAD_BEATEN:
			if rand_var <= 10.0:
				heart_icon.texture = heart_sad_beaten_gift_image
				get_parent().player.heal(20)
			elif rand_var <= 60.0:
				heart_icon.texture = heart_sad_beaten_middle_finger_image

	heart_timer.start(0.6)
	yield(heart_timer, "timeout")
	#yield(get_tree().create_timer(0.4), "timeout")
	update_heart_layout()
	
# Called when an input occurs.	
func _input(event):
	if event.is_action_pressed("mouse_left") and mouse_in_heart:
		heart_ticks += 1
		
		if heart_ticks < 1:
			current_state = TheHeartStates.HAPPY
		elif heart_ticks < 7:
			current_state = TheHeartStates.HAPPY_BEATEN
		elif heart_ticks < 21:
			current_state = TheHeartStates.SAD_BEATEN
		else:
			current_state = TheHeartStates.ALMOST_DEAD
			
		update_heart_layout()
		
		if current_state == TheHeartStates.ALMOST_DEAD:
			return
		
		if get_parent().battle_state is EnemyState:
			return
			
		get_parent().total_sum = float(timer_label.text) + 2.0 
		update_timer_label(int(round(get_parent().total_sum)))
		
		var rand_var = rand_range(0.0, 100.0)
		if rand_var <= 50.0:
			get_parent().player.add_action_points(1)
		
		var floating_text := floating_text_scene.instance()
		floating_text.amount = 2
		floating_text.prefix = "+"
		floating_text.text_type = FloatingText.TextType.TIME_MESSAGE
		timer_center.add_child(floating_text)
		
# Updates the heart layout.
func update_heart_layout() -> void:
	if current_state == TheHeartStates.HAPPY:
		heart_icon.texture = heart_happy_image
	elif current_state == TheHeartStates.HAPPY_BEATEN:
		heart_icon.texture = heart_happy_beaten_image
	elif current_state == TheHeartStates.SAD_BEATEN:
		heart_icon.texture = heart_sad_beaten_image
	else:
		heart_icon.texture = heart_almost_dead_image


