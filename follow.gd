extends State
 
func enter():
	super.enter()
	owner.set_physics_process(true)
 
func exit():
	super.exit()
	owner.set_physics_process(false)
 
func transition():
	var distance = owner.direction.length()
	
	if distance < 30:
		get_parent().change_state("Slash")
