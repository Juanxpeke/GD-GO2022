extends AnimationState
class_name PlayerWalkingState

var walking_path := []

# Inherited parent constructor.
func _init(battle, board).(battle, board):
	pass

func set_walking_path(walking_path) -> void:
	self.walking_path = walking_path

# Called every frame.
func update(_delta : float) -> void:
	if walking_path.size() == 0:
		battle.to_void_state()
		return
	
	var closest_point : Vector2 = walking_path[0]
	battle.add_player_position((closest_point - battle.get_player_position()).normalized() * _delta * 300)
	
	if closest_point.distance_to(battle.get_player_position()) < 5:
		battle.set_player_position(closest_point)
		walking_path.remove(0)
