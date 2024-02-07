class_name HUD
extends CanvasLayer

@onready var action_points_label := %APLabel
@onready var movement_points_label := %MPLabel

@onready var knife_skill_button := %KnifeSkillButton
@onready var pistol_skill_button := %PistolSkillButton
@onready var grenade_skill_button := %GrenadeSkillButton
@onready var medkit_skill_button := %MedkitSkillButton

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.current_player_setted.connect(
		func():
			action_points_label.text = str(GameManager.current_player.current_action_points)
			movement_points_label.text = str(GameManager.current_player.current_movement_points)

			GameManager.current_player.action_points_changed.connect(self._on_player_action_points_changed)
			GameManager.current_player.movement_points_changed.connect(self._on_player_movement_points_changed)
	)

# Called when the current player action points change
func _on_player_action_points_changed() -> void:
	action_points_label.text = str(GameManager.current_player.current_action_points)

# Called when the current player movement points change
func _on_player_movement_points_changed() -> void:
	movement_points_label.text = str(GameManager.current_player.current_movement_points)

# Public

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass
