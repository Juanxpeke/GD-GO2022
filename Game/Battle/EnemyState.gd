extends BattleState
class_name EnemyState

# Inherited parent constructor.
func _init(battle, board).(battle, board):
	pass

# Called when being selected as the new state.
func enter() -> void:
	print("Entered enemy state.\n")
	battle.reset_player_points()
	yield(battle.get_tree().create_timer(2.0), "timeout")
	battle.to_player_start_state()
