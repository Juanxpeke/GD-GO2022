class_name MapState
extends Object

# Virtual function intended to be called when being selected as the new state
func enter() -> void:
	pass

# Virtual function intended to be called when being removed as the current state
func exit() -> void:
	pass
	
# Virtual function intended to be called in the '_process()' callback
func update() -> void:
	pass

# Virtual function intended to be called in the '_input()' callback
func handle_input(event) -> void:
	pass

