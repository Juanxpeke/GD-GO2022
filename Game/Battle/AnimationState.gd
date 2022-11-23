extends Object
class_name AnimationState

var battle
var board : AStarTileMap

# Battle state constructor, it needs an AStarTileMap for doing board operations.
func _init(battle, board):
	self.battle = battle
	self.board = board

# Virtual function intended to be called when being selected as the new state.
func enter() -> void:
	pass

# Virtual function intended to be called when being removed as the current state.
func exit() -> void:
	pass
	
# Virtual function intended to be called in the '_process()' callback.
func update(_delta : float) -> void:
	pass

# Virtual function intended to be called in the '_input()' callback.
func handle_input(event : InputEvent) -> void:
	pass

