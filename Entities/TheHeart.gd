extends Node
class_name TheHeart

enum TheHeartStates {HAPPY,
					HAPPY_BEATEN, 
					SAD_BEATEN,
					DEPRESSED_BEATEN, 
					ALMOST_DEAD}
					
var current_state = TheHeartStates.HAPPY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
