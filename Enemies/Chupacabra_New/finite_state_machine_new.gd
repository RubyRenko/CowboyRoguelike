extends Node2D
 
var current_state: State
var previous_state: State
 
func _ready():
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()
 
func change_state(state):
	previous_state.exit()
	current_state = find_child(state) as State
	current_state.enter()
	print("entering state: " + current_state.name)
	previous_state = current_state
