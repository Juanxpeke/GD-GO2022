extends Position2D
class_name FloatingText

enum TextType {DAMAGE, HEALING, AP, MP, MESSAGE, TIME_MESSAGE}

var text_type = TextType.DAMAGE

var amount := 0

var prefix := ""

var velocity := Vector2(0, 0)

onready var label := $Label
onready var tween := $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var final_scale = Vector2(1.5, 1.5)
	
	label.text = prefix + str(amount)
	
	match text_type:
		TextType.DAMAGE:
			label.set("custom_colors/font_color", Color("fa4646"))
		TextType.HEALING:
			label.set("custom_colors/font_color", Color("6ef87d"))
		TextType.AP:
			label.set("custom_colors/font_color", Color("7e51ed"))
		TextType.MP:
			label.set("custom_colors/font_color", Color("51ed8b"))
		TextType.TIME_MESSAGE:
			label.set("custom_colors/font_color", Color("ffffff"))
		TextType.MESSAGE:
			label.set("custom_colors/font_color", Color("ffffff"))
			label.text = prefix
			final_scale = Vector2(1.2, 1.2)
	
	velocity = Vector2(randi() % 40 - 20, -60)

	tween.connect("tween_all_completed", self, "on_tween_completed")
	
	tween.interpolate_property(self, "scale", scale, final_scale, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.interpolate_property(self, "modulate", modulate, Color.transparent, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

# Called on each frame.
func _process(delta):
	global_position += velocity * delta

# Called when the tween completes.
func on_tween_completed() -> void:
	self.queue_free()
