extends Entity
class_name Player

# Called when the node enters the scene tree for the first time.
func _ready():
	total_health_points = 350
	health_points = 350
	spells = [Knife.new(), Pistol.new(), SniperRifle.new(), Granade.new(), Medkit.new()]
