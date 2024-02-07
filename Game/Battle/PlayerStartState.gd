extends BattleState
class_name PlayerStartState

signal player_started

# Inherited parent constructor.
func _init(battle, board):
	super(battle, board)
	pass

# Called when being selected as the new state.
func enter() -> void:
	print("@@@ Entered player start state. @@@\n")
	emit_signal("player_started")
	battle.battle_turn += 1
	battle.delta_sum = 0.0
	battle.total_sum = battle.turn_time
	#battle.battle_ui.update_timer_label(int(round(battle.total_sum)))
	#battle.reset_enemy_points()
	#battle.decrease_spells_cooldowns()
	battle.to_player_idle_state()
	
