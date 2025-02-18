extends State
 
func enter():
	super.enter()
 
func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
