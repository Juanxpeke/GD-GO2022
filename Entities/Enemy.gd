extends Entity
class_name Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	spells = [Knife.new(), Pistol.new(), SniperRifle.new(), Granade.new(), Medkit.new()]
