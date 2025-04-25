extends State

func enter():
	super.enter()
	owner.set_physics_process(true)
	var target = owner.player.position
	if target.x > owner.position.x :
		target.x += 150
	else:
		target.x -= 150
	if target.y > owner.position.y:
		target.y += 150
	else:
		target.y -= 150
	owner.target = target
	owner.speed = 600
	#print(owner.target)
 
func exit():
	super.exit()
	owner.set_physics_process(false)
	owner.speed = 250
	await get_tree().create_timer(1).timeout

func transition():
	if owner.target - Vector2(5, 5) < owner.position && owner.position < owner.target + Vector2(5,5):
		get_parent().change_state("Idle")
