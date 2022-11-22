extends Node
class_name BattleState

var battle : Battle
var board : AStarTileMap

# Battle state constructor, it needs a Battle object and an AStarTileMap.
func _init(battle : Battle, board : AStarTileMap):
	self.battle = battle
	self.board = board
