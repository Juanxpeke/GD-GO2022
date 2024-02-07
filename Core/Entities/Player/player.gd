class_name PlayerX
extends EntityX

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.set_current_player(self)
