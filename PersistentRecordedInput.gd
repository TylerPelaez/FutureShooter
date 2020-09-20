extends Node
# For reloading levels
var state = {}

func get_state():
	return state

func set_state(newState):
	state = newState
	
func clear_state():
	state = {}
