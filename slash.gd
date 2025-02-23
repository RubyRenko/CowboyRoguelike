extends State

func enter():
	super.enter()
	owner.player.hurt(1)
 
func transition():
	await get_tree().create_timer(1).timeout
	get_parent().change_state("Follow")
