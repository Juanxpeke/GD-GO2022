extends BattleState
class_name PlayerStartState

# Inherited parent constructor.
func _init(battle, board).(battle, board):
	pass

# Called when being selected as the new state.
func enter() -> void:
	print("Entered player start state.\n")
	battle.turn_timer.start()
	battle.reset_enemy_points()
	battle.decrease_spells_cooldowns()
	battle.to_player_idle_state()
