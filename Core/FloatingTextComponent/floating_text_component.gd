class_name FloatingTextComponent
extends Node2D

enum TextType {
	HEALING,
	DAMAGE,
	ACTION_POINTS,
	MOVEMENT_POINTS,
}

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta : float) -> void:
	pass


# Public

# Generates floating text
func generate_floating_text(text : String, type : TextType) -> void:
	pass
	#var floating_text := floating_text_scene.instantiate()
	#floating_text.amount = amount
	#floating_text.text_type = FloatingText.TextType.HEALING
	#add_child(floating_text)
