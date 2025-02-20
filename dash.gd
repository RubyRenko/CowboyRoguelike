extends State

func enter():
	super.enter()
	owner.set_physics_process(true)
	owner.target = owner.player.position
	owner.speed = 400
	print(owner.target)
 
func exit():
	super.exit()
	owner.set_physics_process(false)
	owner.speed = 200
	await get_tree().create_timer(1).timeout

func transition():
	var distance = owner.direction.length()
	if owner.target - Vector2(3, 3) < owner.position && owner.position < owner.target + Vector2(3,3):
		get_parent().change_state("Idle")
