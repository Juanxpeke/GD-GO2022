extends Entity




const SPEED = 40000
var motion = Vector2()



func _ready():
	pass


func _physics_process(delta):
	# Everything works like you're used to in a top-down game
	var direction = Vector2()

	if Input.is_action_pressed("move_up"):
		direction += Vector2(0, -1)
	elif Input.is_action_pressed("move_down"):
		direction += Vector2(0, 1)
		
	if Input.is_action_pressed("move_left"):
		direction += Vector2(-1, 0)
	elif Input.is_action_pressed("move_right"):
		direction += Vector2(1, 0)

	motion = direction.normalized() * SPEED * delta
	# Isometric movement is movement like you're used to, converted to the isometric system
	# motion = cartesian_to_isometric(motion)
	# move_and_slide(motion)
