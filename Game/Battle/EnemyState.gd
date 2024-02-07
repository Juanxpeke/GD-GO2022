extends BattleState
class_name EnemyState

var best_action_calculated := false

# Inherited parent constructor.
func _init(battle, board):
	super(battle, board)
	pass
	
func update() -> void:
	if battle.enemy.in_animation or not best_action_calculated:
		return
		
	best_action_calculated = false
		
	battle.to_player_start_state()

# Called when being selected as the new state.
func enter() -> void:
	print("@@@ Entered enemy state. @@@\n")
	
	battle.reset_player_points()
	
	battle.make_enemy_best_action()
	
	best_action_calculated = true

# Called when the state is over.
func exit() -> void:
	print("@@@ Exited enemy state. @@@\n")
