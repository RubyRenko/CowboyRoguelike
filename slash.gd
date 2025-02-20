extends State
 
func enter():
	super.enter()
 
func transition():
	if owner.direction.length() > 120:
		get_parent().change_state("Follow")
