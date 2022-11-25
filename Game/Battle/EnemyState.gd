extends BattleState
class_name EnemyState

# Inherited parent constructor.
func _init(battle, board).(battle, board):
	pass

# Called when being selected as the new state.
func enter() -> void:
	print("Entered enemy state.\n")
	battle.reset_player_points()
	
	battle.make_enemy_best_movement()
	
	battle.to_player_start_state()
